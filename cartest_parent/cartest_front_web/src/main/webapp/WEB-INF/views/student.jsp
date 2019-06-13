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
            $("#studentRegistered").on("click",function () {
                studentArr= {};
                //获取学生姓名
                var studentName = $('input[name=studentName]').val().replace(/(^\s*)|(\s*$)/g, "");
                studentArr.studentName = studentName;
                //获取学生身份证号，并校验
                var studentPin = $('input[name=studentPin]').val().replace(/(^\s*)|(\s*$)/g, "");
                var result1 = testid(studentPin);
                if(result1.status != 1){
                    console.log(result1.msg);
                    $("#FailMessage").text('注册失败：'+result1.msg);
                    console.log($("#FailMessage").text());
                    $("#studentRegisteredFailure").modal("show");
                    return;
                }
                studentArr.studentPin= studentPin;
                //获取学生电话并校验
                var studentPhone = $('input[name=studentPhone]').val().replace(/(^\s*)|(\s*$)/g, "");
                var result2 = checkPhone(studentPhone);
                if(result2 == false){
                    $("#FailMessage").text("注册失败："+"手机号码有误，请重填");
                    $("#studentRegisteredFailure").modal("show");
                    return;
                }
                studentArr.studentPhone= studentPhone;
                var student = JSON.stringify(studentArr);
                $.ajax({
                    type: "POST",
                    url: '${pageContext.request.contextPath}/student',
                    data: student,//必须
                    contentType: "application/json;charset=UTF-8",//必须
                    dataType: "json",//必须
                    success: function(result){
                        if(result.status == 1){
                            $("#studentRegisteredSuccess").modal("show");
                        }else{
                            $("#studentRegisteredFailure").modal("show");
                        }
                    }

                })

            });
            $(".studentRegisteredConfirm").on("click",function () {
                location.href='${pageContext.request.contextPath}/student';
            });
            $("#studentExit").on("click",function () {
                $.ajax({
                    type: "POST",
                    url: '${pageContext.request.contextPath}/student/studentExit',
                    contentType: "application/json;charset=UTF-8",//必须
                    dataType: "json",//必须
                    success: function(result){
                        if(result.status == 1) {
                            location.href='${pageContext.request.contextPath}/student';
                            // $("#studentRegisteredFailure").modal("show");
                        }
                    }
                })
            });
            $("#studentExitModalConfirm").on("click",function () {
                location.href='${pageContext.request.contextPath}/student';
            });
            $(".studentRegisteredFailConfirm").on("click",function () {
                $("#studentRegisteredFailure").modal("hide");
            });
        });
        //身份证校验
        function testid(id) {
            // 1 "验证通过!", 0 //校验不通过
            var format = /^(([1][1-5])|([2][1-3])|([3][1-7])|([4][1-6])|([5][0-4])|([6][1-5])|([7][1])|([8][1-2]))\d{4}(([1][9]\d{2})|([2]\d{3}))(([0][1-9])|([1][0-2]))(([0][1-9])|([1-2][0-9])|([3][0-1]))\d{3}[0-9xX]$/;
            //号码规则校验
            if(!format.test(id)){
                return {'status':0,'msg':'身份证号码不合规'};
            }
            //区位码校验
            //出生年月日校验   前正则限制起始年份为1900;
            var year = id.substr(6,4),//身份证年
                month = id.substr(10,2),//身份证月
                date = id.substr(12,2),//身份证日
                time = Date.parse(month+'-'+date+'-'+year),//身份证日期时间戳date
                now_time = Date.parse(new Date()),//当前时间戳
                dates = (new Date(year,month,0)).getDate();//身份证当月天数
            if(time>now_time||date>dates){
                return {'status':0,'msg':'出生日期不合规'}
            }
            //校验码判断
            var c = new Array(7,9,10,5,8,4,2,1,6,3,7,9,10,5,8,4,2);   //系数
            var b = new Array('1','0','X','9','8','7','6','5','4','3','2');  //校验码对照表
            var id_array = id.split("");
            var sum = 0;
            for(var k=0;k<17;k++){
                sum+=parseInt(id_array[k])*parseInt(c[k]);
            }
            if(id_array[17].toUpperCase() != b[sum%11].toUpperCase()){
                return {'status':0,'msg':'身份证校验码不合规'}
            }
            return {'status':1,'msg':'校验通过'}
        }
        //电话号码校验
        function checkPhone(phone){
            if(!(/^1[3|4|5|7|8]\d{9}$/.test(phone))){
                return false;
            }
            return true;
        }
    </script>

</head>

<body>
<div class="panel panel-default" id="userSet">
    <div class="panel-heading">
        <h3 class="panel-title">考生注册</h3>
    </div>
    <p class="text-center" style="font-size:20px;font-weight: bold;">当前考试学生：
        <c:if test="${sessionScope.student != null}">
            ${sessionScope.student.getStudent_name()}
            &nbsp;&nbsp;&nbsp;
            <a href="/question/studentPin">开始考试</a>
            <input type="button" value="考生退出" class="btn btn-primary" id="studentExit">
        </c:if>
        <c:if test="${sessionScope.student == null}">您尚未注册，请先注册！</c:if>
    </p>
    <div class="panel-body">
        <div class="show-list text-center">
            <table class="table table-bordered table-hover" style='text-align: center;'>
                <tbody id="tb">
                    <tr>
                        <td>考生姓名</td>
                        <td><input type="text" value="" name="studentName" style="width:300px;"></td>
                    </tr>
                    <tr>
                        <td>身份证号</td>
                        <td><input type="text" value="" name="studentPin" style="width:300px;"></td>
                    </tr>
                    <tr>
                        <td>联系电话</td>
                        <td><input type="text" value="" name="studentPhone" style="width:300px;"></td>
                    </tr>
                </tbody>
            </table>
            <input type="button" value="注册" class="btn btn-primary" id="studentRegistered">
        </div>
    </div>
</div>

<!-- 考生注册 start -->
<div class="modal fade" tabindex="-1" id="studentRegisteredSuccess">
    <!-- 窗口声明 -->
    <div class="modal-dialog modal-lg">
        <!-- 内容声明 -->
        <div class="modal-content">
            <!-- 头部、主体、脚注 -->
            <div class="modal-header">
                <button class="close" data-dismiss="modal">&times;</button>
            </div>
            <div class="modal-body text-center">
                <h4 class="modal-title">注册成功</h4>
            </div>
            <div class="modal-footer">
                <button class="btn btn-primary studentRegisteredConfirm">确定</button>
            </div>
        </div>
    </div>
</div>
<!-- 考生注册 end -->

<!-- 考生注册失败 start -->
<div class="modal fade" tabindex="-1" id="studentRegisteredFailure">
    <!-- 窗口声明 -->
    <div class="modal-dialog modal-lg">
        <!-- 内容声明 -->
        <div class="modal-content">
            <!-- 头部、主体、脚注 -->
            <div class="modal-header">
                <button class="close" data-dismiss="modal">&times;</button>
            </div>
            <div class="modal-body">
                <h4 class="modal-title" id="FailMessage">注册失败，请检查输入是否完整！</h4>
            </div>
            <div class="modal-footer">
                <button class="btn btn-primary studentRegisteredFailConfirm">确定</button>
            </div>
        </div>
    </div>
</div>
<!-- 考生注册失败 end -->
<!-- 考生退出 start -->
<div class="modal fade" tabindex="-1" id="studentExitModal">
    <!-- 窗口声明 -->
    <div class="modal-dialog modal-lg">
        <!-- 内容声明 -->
        <div class="modal-content">
            <!-- 头部、主体、脚注 -->
            <div class="modal-header">
                <button class="close" data-dismiss="modal">&times;</button>
            </div>
            <div class="modal-body text-center">
                <h4 class="modal-title">考生注销成功！</h4>
            </div>
            <div class="modal-footer">
                <button class="btn btn-primary " id="studentExitModalConfirm">确定</button>
            </div>
        </div>
    </div>
</div>
<!-- 考生退出 end -->
</body>

</html>
