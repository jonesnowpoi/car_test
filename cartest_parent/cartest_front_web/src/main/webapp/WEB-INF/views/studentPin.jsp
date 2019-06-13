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
        $(function(){
            $(".user-setting li").click(function(){
                $(".user-setting li").removeClass("active");
                $(this).addClass("active");
                var panelId = "#"+$(this).attr("name");
                $("#userPanel > div").css({'display':'none'});
                $(panelId).css({'display':'block'});

            });
            //点击提交之后将选项数组返回
            $("#getStudentPin").on("click",function () {
                $.ajax({
                    type: "POST",
                    url: '${pageContext.request.contextPath}/question/studentPin',
                    contentType: "application/json;charset=UTF-8",
                    dataType: "json",
                    success: function(result){
                        if(result.status == 2){
                            $("#studentNull").modal("show");
                        }else if (result.status == 1){
                            $("#getExaminePinSuccess").modal("show");
                        }
                    }

                })
            })
            $(".studentNullConfirm").on("click",function () {
                location.href='${pageContext.request.contextPath}/student';
            })
            $(".getExaminePinSuccessConfirm").on("click",function () {
                location.href='${pageContext.request.contextPath}/question/studentPin';
            })
            $("#examineStart").on("click",function () {
                location.href="${pageContext.request.contextPath}/question/TestPaper";
            })

        });
    </script>
</head>

<body>
<div class="panel panel-default" id="userSet">
    <div class="panel-heading">
        <h3 class="panel-title">准考证号获取</h3>
    </div>
    <div class="panel-body">
        <div class="show-list text-center">
            <table class="table table-bordered table-hover" style='text-align: center;'>
                <tbody id="tb">
                <tr>
                    <td><p style="font-weight: bold;font-size: 20px">准考证号<p></td>
                    <td>
                        <p style="font-weight: bold;font-size: 20px">
                            <c:if test="${sessionScope.examinePin == null}">
                                点击下方按钮获取准考证号
                            </c:if>
                        <p>
                        <p style="font-weight: bold;font-size: 20px">
                            <c:if test="${sessionScope.examinePin != null}">
                                ${sessionScope.examinePin}
                            </c:if>
                        <p>
                    </td>
                </tr>
            </table>
            <c:if test="${sessionScope.examinePin == null}">
                <input type="button" value="获取准考证号" class="btn btn-primary" id="getStudentPin">
            </c:if>
            <c:if test="${sessionScope.examinePin != null}">
                <input type="button" value="开始考试" class="btn btn-primary" id="examineStart">
            </c:if>
        </div>
    </div>
</div>

<!-- 提交考试试卷 start -->
<div class="modal fade" tabindex="-1" id="getExaminePinSuccess">
    <!-- 窗口声明 -->
    <div class="modal-dialog modal-lg">
        <!-- 内容声明 -->
        <div class="modal-content">
            <!-- 头部、主体、脚注 -->
            <div class="modal-header">
                <button class="close" data-dismiss="modal">&times;</button>
            </div>
            <div class="modal-body text-center">
                <h4 class="modal-title">获取准考证号成功</h4>
            </div>
            <div class="modal-footer">
                <button class="btn btn-primary getExaminePinSuccessConfirm">确定</button>
            </div>
        </div>
    </div>
</div>
<!-- 提交考试试卷 end -->

<!-- 修改商品类型 start -->
<div class="modal fade" tabindex="-1" id="studentNull">
    <!-- 窗口声明 -->
    <div class="modal-dialog modal-lg">
        <!-- 内容声明 -->
        <div class="modal-content">
            <!-- 头部、主体、脚注 -->
            <div class="modal-header">
                <button class="close" data-dismiss="modal">&times;</button>
            </div>
            <div class="modal-body text-center">
                <h4 class="modal-title">您尚未注册考生信息，请先注册考生信息！</h4>
            </div>
            <div class="modal-footer">
                <button class="btn btn-primary studentNullConfirm">确定</button>
            </div>
        </div>
    </div>
</div>
<!-- 修改商品类型 end -->
</body>

</html>
