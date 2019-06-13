package com.cartest.frontweb.controller;

import cartest.common.constant.ResponseStatusConstant;
import cartest.common.util.ResponseResult;
import com.cartest.pojo.Student;
import com.cartest.service.StudentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Enumeration;


@Controller
@RequestMapping("/student")
public class StudentController {

    @Autowired
    private StudentService studentService;

    @RequestMapping(method = RequestMethod.GET)
    public String addStudent(){
        return "student";
    }

    @RequestMapping(method = RequestMethod.POST)
    @ResponseBody
    public ResponseResult addStudent(HttpServletRequest request, @RequestBody Student student) {
        System.out.println("student.toString() = " + student.toString());
        ResponseResult result = new ResponseResult();
        int studentInsertSuccess = studentService.createStudent(student);
        if(studentInsertSuccess>0){
            //插入成功，在返回的包中插入相应的信息
            result.setStatus(ResponseStatusConstant.RESPONSE_STATUS_SUCCESS);
            result.setMessage("学生注册成功！");
            //看下新创建的用户的ID
            System.out.println("student.getStudent_id() = " + student.getStudent_id());
            //将新创建的用户存入session中，方便等下调用
            HttpSession session = request.getSession();
            //清除原有session中的所有数据,除了用户的登录
            Enumeration em = request.getSession().getAttributeNames();
            while(em.hasMoreElements()){
                String sessionAttribute = em.nextElement().toString();
                System.out.println("sessionAttribute = " + sessionAttribute);
                if(sessionAttribute.equals("user")){
                    continue;
                }else{
                    request.getSession().removeAttribute(sessionAttribute);
                }
            }
            //将新的考生存入session中
            session.setAttribute("student",student);
        }else{
            result.setStatus(ResponseStatusConstant.RESPONSE_STATUS_FAILURE);
            result.setMessage("学生注册失败！");
        }
        return result;
    }
    @RequestMapping("/studentExit")
    @ResponseBody
    public ResponseResult studentExit(HttpServletRequest request){
        ResponseResult result = new ResponseResult();
        HttpSession session = request.getSession();
        //清除原有session中的所有数据,除了用户的登录
        Enumeration em = request.getSession().getAttributeNames();
        while(em.hasMoreElements()){
            String sessionAttribute = em.nextElement().toString();
            System.out.println("sessionAttribute = " + sessionAttribute);
            if(sessionAttribute.equals("user")){
                continue;
            }else{
                request.getSession().removeAttribute(sessionAttribute);
            }
        }
        //设置返回参数
        result.setStatus(ResponseStatusConstant.RESPONSE_STATUS_SUCCESS);
        result.setMessage("退出成功");

        return result;
    }
}
