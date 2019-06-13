package com.cartest.frontweb.controller;

import cartest.common.constant.ResponseStatusConstant;
import cartest.common.util.ResponseResult;
import com.alibaba.fastjson.JSONObject;
import com.cartest.pojo.Examine;
import com.cartest.pojo.Question;
import com.cartest.pojo.Student;
import com.cartest.pojo.TestPaper;
import com.cartest.service.ExamineService;
import com.cartest.service.QuestionService;
import com.cartest.service.TestPaperService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


@Controller
@RequestMapping("/question")
public class QuestionController {

    @Autowired
    private QuestionService questionService;
    @Autowired
    private TestPaperService testPaperService;
    @Autowired
    private ExamineService examineService;

    @RequestMapping(value = "/studentPin",method = RequestMethod.GET)
    public String StudentPIN(){
        return "studentPin";
    }

    @RequestMapping(value = "/studentPin",method = RequestMethod.POST)
    @ResponseBody
    public ResponseResult getStudentPIN(HttpServletRequest request) {
        ResponseResult result = new ResponseResult();
        HttpSession session = request.getSession();
        if(session.getAttribute("student") == null){
            result.setMessage("考生尚未注册！");
            result.setStatus(ResponseStatusConstant.RESPONSE_STATUS_FAILURE);
            return result;
        }else{
            //获取当前时间转化为字符串
            SimpleDateFormat tempDate = new SimpleDateFormat("yyyyMMddHHmmss");
            String datetime = tempDate.format(new java.util.Date());
            //获取身份证后6位
            Student student = (Student) session.getAttribute("student");
            String studentPinLastSixByte = student.getStudent_pin().substring(11);
            //合成准考证号
            String examinePin= datetime+studentPinLastSixByte;
            session.setAttribute("examinePin",examinePin);
            //设置返回信息
            result.setStatus(ResponseStatusConstant.RESPONSE_STATUS_SUCCESS);
            result.setMessage("获取准考证号成功！");
            return result;
        }
    }

    @RequestMapping(value = "/TestPaper",method = RequestMethod.GET)
    public String findAll(Integer pageNum, Model model,HttpServletRequest request){
        //获取10道考试题目
        Map map = new HashMap();
        List<Question> questions = questionService.getTestPaper(map);
        //创建试卷
        TestPaper testPaper = new TestPaper();
        String question_id_seq = "";
        String key_seq = "";
            //将问题ID用“，”连接起来生成序列，答案同理
        for(int i=0;i<questions.size();i++){
            if(i<(questions.size()-1)){
                question_id_seq = question_id_seq+questions.get(i).getQuestion_id()+",";
                key_seq = key_seq+questions.get(i).getQuestion_key()+",";
            }else if(i == (questions.size()-1)){
                question_id_seq = question_id_seq+questions.get(i).getQuestion_id();
                key_seq = key_seq+questions.get(i).getQuestion_key();
            }
        }
        testPaper.setQuestion_id_seq(question_id_seq);
        testPaper.setKey_seq(key_seq);
        //将生成的试卷插入到考题表，将返回的PaperID存入Session中方便后面调用
        testPaperService.createTestPaper(testPaper);
        System.out.println("paper_id = " + testPaper.getPaper_id());
        HttpSession session = request.getSession();
        session.setAttribute("paperId",testPaper.getPaper_id());
        //将考题放入model中供前端调用
        model.addAttribute("questions",questions);

        return "doQuestion";
    }

    @RequestMapping(value = "/TestPaper" , method = RequestMethod.POST)
    @ResponseBody
    public JSONObject uploadTestPaper(@RequestBody Map<String,Object> jsonMap,HttpServletRequest request, Model model){
        //获取用户提交的答案，转化为List<String>
        List<String> choiceList = (List<String>) jsonMap.get("Choice");
        System.out.println(choiceList);
        //获取用户试卷的答案，比较，判分
        int paperId = (int)request.getSession().getAttribute("paperId");
        TestPaper testPaper = testPaperService.queryTestPaperById(paperId);
            //将答案字符串切片，生成答案字符数组
        String[] key_seq = testPaper.getKey_seq().split(",");
        List<String> key_seq_list = java.util.Arrays.asList(key_seq);
            //遍历判分
        int grade = 0;
        System.out.println("考生做的"+"  "+"正确答案");
        for(int i = 0;i < choiceList.size();i++){
            System.out.println(choiceList.get(i) +"\t"+key_seq_list.get(i));
            if(choiceList.get(i).equals(key_seq_list.get(i))){
                grade++;
            }
        }
        System.out.println("grade = " + grade);


        //将此次考试情况存入数据库
        Examine examine = new Examine();
            //从session中获取准考证号examinePin
        examine.setExamine_in((String)request.getSession().getAttribute("examinePin"));
            //从session中获取学生，身份证号后6位作为考试密码
        Student studentTemp = (Student)request.getSession().getAttribute("student");
        String examinePwd = studentTemp.getStudent_pin().substring(11);
        examine.setExamine_pwd(examinePwd);
            //学生的ID
        examine.setStudent_id(studentTemp.getStudent_id());
            //考试中学生的答题情况
        StringBuffer answerStringBuffer = new StringBuffer();
        for(int j = 0;j < choiceList.size(); j++ ){
            if(j < choiceList.size()-1){
                answerStringBuffer.append(choiceList.get(j));
                answerStringBuffer.append(",");
            }else if(j == choiceList.size() -1){
                answerStringBuffer.append(choiceList.get(j));
            }
        }
        String answerString = answerStringBuffer.toString();
        examine.setStudent_answer(answerString);
            //将得出的成绩放入
        examine.setScore(grade);
            //从session中取出paperId
        examine.setPaper_id((int)request.getSession().getAttribute("paperId"));
            //新建时间存入oracle
        examine.setExamine_date(new java.sql.Timestamp(new java.util.Date().getTime()));
            //存入考试状态，大于等于6分就标为"P"，表示pass，小于6分就表为"F"，表示Fail
        if(grade >= 6){
            examine.setStatus('P');
        }else{
            examine.setStatus('F');
        }
            //将本次考试情况存入数据库,删除数据库中的准考证号
        examineService.createExamine(examine);
        request.getSession().removeAttribute("examinePin");
        //将成绩和考试ID返回给界面，让界面可以选择是否查看详情
        System.out.println("examineId = " + examine.getExamine_id());
        int examineId = examine.getExamine_id();
        request.getSession().setAttribute("examineId",examineId);
        //设置返回结果
        JSONObject jsonObject = new JSONObject();  //创建Json对象
        jsonObject.put("grade", grade);         //设置Json对象的属性
        jsonObject.put("examineId", examineId);
        System.out.println(jsonObject.toString());  //调用toString方法将json对象转换成json字符串
        return jsonObject;
    }

    @RequestMapping(value = "/TestHistory" , method = RequestMethod.GET)
    public String getTestHistory(HttpServletRequest request,Model model){
        int examineId = (int)request.getSession().getAttribute("examineId");
        //获取考试信息,并给前端
        Examine examine = examineService.queryExamineById(examineId);
        model.addAttribute("examine",examine);
        //获取考试卷
        TestPaper testPaper = testPaperService.queryTestPaperById(examine.getPaper_id());
        //将考题号序列转化为question的list返回给前端
        String[] question_id_StringArr = testPaper.getQuestion_id_seq().split(",");
        List<String> question_id_Stringlist = java.util.Arrays.asList(question_id_StringArr);
        List<Question> questions = new ArrayList<>();
        for(String question_id : question_id_Stringlist){
            System.out.println("question_id = " + question_id);
            Question question = questionService.queryQuestionById(Integer.parseInt(question_id));
            System.out.println("question.getQuestion_id() = " + question.getQuestion_id());
            questions.add(question);
        }
        model.addAttribute("questions",questions);
        //将考生的选项list返回给前端
        String[] answer_StringArr = examine.getStudent_answer().split(",");
        List<String> answer_Stringlist = java.util.Arrays.asList(answer_StringArr);
        model.addAttribute("answer_Stringlist",answer_Stringlist);

        return "questionHistoryDetails";
    }
}
