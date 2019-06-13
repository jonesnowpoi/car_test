<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="C" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
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
        $(function(){
            $(".user-setting li").click(function(){
                $(".user-setting li").removeClass("active");
                $(this).addClass("active");
                var panelId = "#"+$(this).attr("name");
                $("#userPanel > div").css({'display':'none'});
                $(panelId).css({'display':'block'});

            });
            $("#continueTest").on("click",function () {
                location.href='${pageContext.request.contextPath}/question/studentPin';
            })
        });
    </script>
</head>

<body>
<div class="panel panel-default" id="userSet">
    <div class="panel-heading">
        <h3 class="panel-title">考题回顾</h3>
    </div>
    <div class="panel-body">
        <div class="show-list text-center">
            <table class="table table-bordered table-hover" style='text-align: center;'>
                <tbody id="tb">
                <tr>
                    <td>
                        <c:if test="${examine.score >= 6}">
                            <p style="font-size: 20px">你的成绩：&nbsp;&nbsp;&nbsp${examine.score}</p>
                            <p style="color: #5cb85c;font-size: 20px">考试通过！</p>
                        </c:if>
                        <c:if test="${examine.score < 6}">
                            <p style="font-size: 20px">你的成绩：&nbsp;&nbsp;&nbsp${examine.score}</p>
                            <p style="color: #c9302c;font-size: 20px">考试不通过！</p>
                        </c:if>
                    </td>
                    <td>
                        <p style="font-size: 20px">测试时间：&nbsp;&nbsp;&nbsp;<fmt:formatDate value="${examine.examine_date}" pattern="yyyy年MM月dd日 HH时mm分ss秒"/></p>
                    </td>
                </tr>
                <c:forEach items="${questions}" var="Question" varStatus="loop">
                    <tr>
                        <td colspan = 2>
                            <c:if test="${Question.question_key.equals(answer_Stringlist[loop.count-1].toString())}">
                                <p style="color: #5cb85c;font-size: 20px">你做对了！</p>
                            </c:if>
                            <c:if test="${Question.question_key !=  answer_Stringlist[loop.count-1].toString()}">
                                <p style="color: #c9302c;font-size: 20px">你做错了！</p>
                            </c:if>
                        </td>
                    </tr>
                    <tr>
                        <td colspan = 2><p style="font-size: 17px">${loop.count}.${Question.question_body}</p></td>
                    </tr>
                    <c:if test="${Question.question_form == 'C' }">
                        <tr>
                            <td colspan = 2>
                                <form action="" class="question" method="post">
                                    <input name="Choice" type="radio" value ="A">A.${Question.branch_a}<br>
                                    <input name="Choice" type="radio" value ="B">B.${Question.branch_b}<br>
                                    <input name="Choice" type="radio" value="C">C.${Question.branch_c}<br>
                                </form>
                            </td>
                        </tr>
                        <tr>
                            <td><p style="font-size: 20px">正确答案：   ${Question.question_key}</p></td>
                            <td><p style="font-size: 20px">你选择的：   ${answer_Stringlist[loop.count-1].toString()}</p></td>
                        </tr>
                    </c:if>
                    <c:if test="${Question.question_form == 'J' }">
                        <tr>
                            <td colspan = 2 >
                                <form action="" class="question" method="post">
                                    <input name="Choice" type="radio" value ="A">对<br>
                                    <input name="Choice" type="radio" value ="B">错<br>
                                </form>
                            </td>
                        </tr>
                        <tr>
                            <td><p style="font-size: 20px">正确答案：   ${Question.question_key}</p></td>
                            <td><p style="font-size: 20px">你选择的：   ${answer_Stringlist[loop.count-1].toString()}</p></td>
                        </tr>
                    </c:if>
                </c:forEach>
                </tbody>
            </table>
            <ul id="pagination"></ul>
            <input type="button" value="继续答题" class="btn btn-primary" id="continueTest">
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

<!-- 修改商品类型 start -->
<div class="modal fade" tabindex="-1" id="myProductType">
    <!-- 窗口声明 -->
    <div class="modal-dialog modal-lg">
        <!-- 内容声明 -->
        <div class="modal-content">
            <!-- 头部、主体、脚注 -->
            <div class="modal-header">
                <button class="close" data-dismiss="modal">&times;</button>
                <h4 class="modal-title">修改商品类型</h4>
            </div>
            <div class="modal-body text-center">
                <div class="row text-right">
                    <label for="proTypeNum" class="col-sm-4 control-label">编号：</label>
                    <div class="col-sm-4">
                        <input type="text" class="form-control" id="proTypeNum" readonly>
                    </div>
                </div>
                <br>
                <div class="row text-right">
                    <label for="proTypeName" class="col-sm-4 control-label">类型名称</label>
                    <div class="col-sm-4">
                        <input type="text" class="form-control" id="proTypeName">
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button class="btn btn-warning updateProType">修改</button>
                <button class="btn btn-primary cancel" data-dismiss="modal">取消</button>
            </div>
        </div>
    </div>
</div>
<!-- 修改商品类型 end -->
</body>

</html>
