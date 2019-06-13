<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta http-equiv="X-UA-Compatible" content="ie=edge" />
    <title>backend</title>
    <link rel="stylesheet"  href="${pageContext.request.contextPath}/css/bootstrap.css" />
    <link rel="stylesheet"  href="${pageContext.request.contextPath}/css/index.css" />
    <script src="${pageContext.request.contextPath}/js/jquery.js"></script>
    <script src="${pageContext.request.contextPath}/js/bootstrap.js"></script>
    <script src="${pageContext.request.contextPath}/js/userSetting.js"></script>
    <script src="${pageContext.request.contextPath}/js/bootstrap-paginator.js"></script>
    <script>
        var time_flag = 1;
        $(function(){
            $(".user-setting li").click(function(){
                $(".user-setting li").removeClass("active");
                $(this).addClass("active");
                var panelId = "#"+$(this).attr("name");
                $("#userPanel > div").css({'display':'none'});
                $(panelId).css({'display':'block'});

            });
            //点击提交之后将选项数组返回
            $(".confirmUploadTestPaper").on("click",function () {
                var jsonQuestions=$(".question").serializeObject();
                //时间还没结束就交卷，看看有没有做完，没做完不能交
                console.log(jsonQuestions["Choice"]);
                // if(time_flag == 1 && jsonQuestions["Choice"].includes("null")){
                //     $('#QuestionNull').modal("show");
                //     return;
                // }
                if(time_flag == 1){
                    var questionNull = [];
                    var count = 0;
                    for(var i = 0;i< jsonQuestions["Choice"].length;i++){
                        if(jsonQuestions["Choice"][i] == "null"){
                            questionNull[count] = (i+1);
                            count++;
                        }
                    }
                    if(count > 0){
                        $('#questionUnDO').text("您以下题目尚未作答："+questionNull.join(','));
                        $('#QuestionNull').modal("show");
                        return;
                    }
                }
                // var jsonQuestions=$(".question").serializeArray();
                console.log(JSON.stringify(jsonQuestions));
                $.ajax({
                    type: "POST",
                    url: '${pageContext.request.contextPath}/question/TestPaper',
                    data: JSON.stringify(jsonQuestions),//必须
                    contentType: "application/json;charset=UTF-8",//必须
                    dataType: "json",//必须
                    success: function(jsonObject){
                        $("#testGrade").text("你本次的考试成绩为:     "+jsonObject.grade+"  分");
                        $(".testDetail").val(jsonObject.examineId);
                        if(jsonObject.grade >= 6){
                            $("#testFeedback").text("恭喜你通过本次考试！继续加油！");
                        }else{
                            $("#testFeedback").text("很遗憾你没能通过本次考试，继续努力吧！");
                        }
                        $("#ExamineResult").modal("show");
                    }
                })
            })
            //点击提交之后将选项数组返回
            $(".testDetail").on("click",function () {
                location.href='${pageContext.request.contextPath}/question/TestHistory';
            })
            //点击提交之后将选项数组返回
            $(".testContinue").on("click",function () {
                location.href='${pageContext.request.contextPath}/question/studentPin';
            })
            //将选项提取成数组
            $.fn.serializeObject = function() {
                var o = {};
                var a = this.serializeArray();
                $.each(a, function () {
                    if (o[this.name]) {
                        if (!o[this.name].push) {
                            o[this.name] = [o[this.name]];
                        }
                        o[this.name].push(this.value || '');
                    } else {
                        o[this.name] = this.value || '';
                    }
                });
                return o;
            }
        });
        $(function(){
            var now=new Date();
            //结束的时间：年，月，日，分，秒（月的索引是0~11）
            var year = now.getFullYear();
            var month = now.getMonth();
            var day = now.getDate();
            var hour = now.getHours();
            var min = now.getMinutes();
            var s = now.getSeconds();
            var end = new Date(year,month,day,hour,min+15,s);
            /*两个时间相减,得到的是毫秒ms,变成秒*/
            var result=Math.floor(end-now)/1000;

            var interval=setInterval(sub,1000); //定时器 调度对象
            /*封装减1秒的函数*/
            function sub(){
                if (result>1) {
                    time_flag = 1;
                    result = result - 1;
                    var second = Math.floor(result % 60);     // 计算秒 ，取余
                    var minite = Math.floor((result / 60) % 60); //计算分 ，换算有多少分，取余，余出多少秒
                    var hour = Math.floor((result / 3600) % 24); //计算小时，换算有多少小时，取余，24小时制除以24，余出多少小时
                    var day = Math.floor(result / (3600*24));  //计算天 ，换算有多少天

                    $("#remainTime").text("倒计时："+ minite + "分" + second + "秒");
                } else{
                    time_flag = 0;
                    $("#uploadTestPaper").click();
                    $(".confirmUploadTestPaper").click();
                }
            };
        });
    </script>
</head>

<body>
<div class="panel panel-default" id="userSet">
    <div class="panel-heading">
        <h3 class="panel-title">机动车考试题目</h3>
        <div id="remainTime" style="font-size:20px;font-weight:800;color: #c9302c;"></div>
    </div>
    <div class="panel-body">
        <div class="show-list text-center">
            <table class="table table-bordered table-hover" style='text-align: center;'>
                <tbody id="tb">
                <c:forEach items="${questions}" var="Question" varStatus="loop">
                    <tr>
                        <td><p style="font-size: 17px">${loop.count}.${Question.question_body}</p></td>
                    </tr>
                    <c:if test="${Question.question_form == 'C' }">
                        <tr>
                            <td>
                                <form action="" class="question" method="post">
                                    <input name="Choice" type="radio" value ="A">A.${Question.branch_a}<br>
                                    <input name="Choice" type="radio" value ="B">B.${Question.branch_b}<br>
                                    <input name="Choice" type="radio" value="C">C.${Question.branch_c}<br>
                                    <input name="Choice" type="radio" value="null" style="display: none " checked="checked">
                                </form>
                            </td>
                        </tr>
                    </c:if>
                    <c:if test="${Question.question_form == 'J' }">
                        <tr>
                            <td>
                                <form action="" class="question" method="post">
                                    <input name="Choice" type="radio" value ="A">对<br>
                                    <input name="Choice" type="radio" value ="B">错<br>
                                    <input name="Choice" type="radio" value="null" style="display: none " checked="checked">
                                </form>
                            </td>
                        </tr>
                    </c:if>
                </c:forEach>
                </tbody>
            </table>
            <ul id="pagination"></ul>
            <input type="button" value="提交考卷" class="btn btn-primary" id="uploadTestPaper">
        </div>
    </div>
</div>

<!-- 提交考试试卷 start -->
<div class="modal fade" tabindex="-1" id="confirmUpload">
    <!-- 窗口声明 -->
    <div class="modal-dialog modal-lg">
        <!-- 内容声明 -->
        <div class="modal-content">
            <!-- 头部、主体、脚注 -->
            <div class="modal-header">
                <button class="close" data-dismiss="modal">&times;</button>
            </div>
            <div class="modal-body">
                <h4 class="modal-title">你确认提交试卷吗？</h4>
            </div>
            <div class="modal-footer">
                <button class="btn btn-primary confirmUploadTestPaper">确定</button>
                <button class="btn btn-primary cancel" data-dismiss="modal">取消</button>
            </div>
        </div>
    </div>
</div>
<!-- 提交考试试卷 end -->

<!-- 题目没做 start -->
<div class="modal fade" tabindex="-1" id="QuestionNull">
    <!-- 窗口声明 -->
    <div class="modal-dialog modal-lg">
        <!-- 内容声明 -->
        <div class="modal-content">
            <!-- 头部、主体、脚注 -->
            <div class="modal-header">
                <button class="close" data-dismiss="modal">&times;</button>
            </div>
            <div class="modal-body">
                <h4 class="modal-title text-center">考试时间尚未结束，您还有题目未答，请检查后再交卷！</h4>
                <p id="questionUnDO" class="text-center" style="font-size: 20px"></p>
            </div>
            <div class="modal-footer">
                <button class="btn btn-primary " data-dismiss="modal">确定</button>
            </div>
        </div>
    </div>
</div>
<!-- 题目没做 end -->

<!-- 考试结果 start -->
<div class="modal fade" tabindex="-1" id="ExamineResult">
    <!-- 窗口声明 -->
    <div class="modal-dialog modal-lg">
        <!-- 内容声明 -->
        <div class="modal-content">
            <!-- 头部、主体、脚注 -->
            <div class="modal-header">
                <button class="close" data-dismiss="modal">&times;</button>
            </div>
            <div class="modal-body">
                <h4 class="modal-title text-center" style="font-size: 20px" id="testGrade">你本次的考试成绩为</h4>
                <p id="testFeedback" class="text-center" style="font-size: 20px"></p>
            </div>
            <div class="modal-footer">
                <button class="btn btn-primary testDetail" value="">查看详情</button>
                <button class="btn btn-primary testContinue">继续做题</button>
            </div>
        </div>
    </div>
</div>
<!-- 考试结果 end -->
</body>

</html>
