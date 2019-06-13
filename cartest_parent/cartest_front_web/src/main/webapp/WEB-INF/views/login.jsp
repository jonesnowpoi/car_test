<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
  <head>
    <title>机动车考试答题系统</title>
    <meta charset="utf-8">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/mycss.css" />
	  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrapValidator.min.css" />
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/bootstrap.min.js"></script>
	  <script type="text/javascript" src="${pageContext.request.contextPath}/js/bootstrapValidator.min.js"></script>
	  <script>
		  //重新加载验证码
		  function reloadImage(){
			  $('#randCode').attr('src','${pageContext.request.contextPath}/code/image?'+new Date().getTime());
			  $('#code').val("");
		  }
		  //表单校验
		  $(function(){
			  $('#frmLogin').bootstrapValidator({
				  feedbackIcon : {
					  valid: 'glyphicon glyphicon-ok',
					  invalid: 'glyphicon glyphicon-romove',
					  validating: 'glyphicon glyphicon-refresh'
				  },
				  fields:{
					  loginName:{
						  validators:{
							  notEmpty:{
								  message:'帐号不能为空'
							  }
						  }
					  }, password:{
						  validators:{
							  notEmpty:{
								  message:'密码不能为空'
							  }
						  }
					  },
					  code:{
						  validators:{
							  notEmpty:{
								  message:'请输入验证码'
							  },
							  remote:{
								  url:'${pageContext.request.contextPath}/code/checkCode',
								  message:'验证码不正确'
							  }
						  }
					  }
				  }
			  })
		  })
		  $(function(){
			  $(".user-setting li").click(function(){
				  $(".user-setting li").removeClass("active");
				  $(this).addClass("active");
				  var panelId = "#"+$(this).attr("name");
				  $("#userPanel > div").css({'display':'none'});
				  $(panelId).css({'display':'block'});

			  });

			  $("#userLogin").on("click",function () {
				  userArr= {};
				  var loginName = $('#loginName').val();
				  if(loginName == ""){
				  	return;
				  }
				  userArr.loginname = loginName;
				  var password = $('#password').val();
				  if(password == ""	){
					  return;
				  }
				  userArr.password = password;
				  var code = $('#code').val();
				  if(code == ""	){
					  return;
				  }
				  var user = JSON.stringify(userArr);
				  console.log(user);
				  $.ajax({
					  type: "POST",
					  url: '${pageContext.request.contextPath}/user/login',
					  data: user,//必须
					  contentType: "application/json;charset=UTF-8",//必须
					  dataType: "json",//必须
					  success: function(result){
						  if(result.status == 3){
							$("#FailMessage").text(result.message);
							$("#loginFailure").modal("show");
							return;
						  }else if(result.status == 2){
							  $("#FailMessage").text(result.message);
							  $("#loginFailure").modal("show");
							  return;
						  }else{
							location.href = '${pageContext.request.contextPath}/index';
						  }
					  }
				  })
			  })
			  $(".loginConfirm").on("click",function () {
				  $("#loginFailure").modal("hide");
			  })

			  $("#registered").on("click",function () {
				  location.href = '${pageContext.request.contextPath}/user/userRegistered';
			  })
		  });
	  </script>
  </head>
  <body>
  	<!-- 使用自定义css样式 div-signin 完成元素居中-->
    <div class="container div-signin">
      <div class="panel panel-primary div-shadow">
      	<!-- h3标签加载自定义样式，完成文字居中和上下间距调整 -->
	    <div class="panel-heading">
	    	<h3>机动车考试答题系统 3.0</h3>
	    	<span>Car Test System</span>
	    </div>
	    <div class="panel-body">
	      <!-- login form start -->
	      <%--<form action="${pageContext.request.contextPath}/user/login" class="form-horizontal" method="post" id="frmLogin">--%>
		<form  class="form-horizontal"  id="frmLogin">
			  <div class="form-group">
		       <label class="col-sm-3 control-label">帐&nbsp;&nbsp;&nbsp;&nbsp;号：</label>
		       <div class="col-sm-9">
		         <input class="form-control" id="loginName" type="text" placeholder="请输入帐号" name="loginName">
		       </div>
		    </div>
		     <div class="form-group">
		       <label class="col-sm-3 control-label">密&nbsp;&nbsp;&nbsp;&nbsp;码：</label>
		       <div class="col-sm-9">
		         <input class="form-control" id="password" type="password" placeholder="请输入密码" name="password">
		       </div>
		    </div>
		     <div class="form-group">
		       <label class="col-sm-3 control-label">验证码：</label>
		       <div class="col-sm-4">
		         <input class="form-control" id="code" type="text" placeholder="验证码" name="code">
		       </div>
		       <div class="col-sm-2">
		       	  <!-- 验证码 -->
			      <img class="img-rounded" id="randCode" src="${pageContext.request.contextPath}/code/image" style="height: 32px; width: 70px;"/>
		       </div>
		       <div class="col-sm-2">
		         <button type="button" class="btn btn-link" onclick="reloadImage()">看不清</button>
		       </div>
		    </div>
		    <div class="form-group">
		       <div class="col-sm-3">
		       </div>
		       <div class="col-sm-9 padding-left-0">
		       	 <div class="col-sm-4">
			         <button id="userLogin" class="btn btn-primary btn-block">登&nbsp;&nbsp;陆</button>
		       	 </div>
		       	 <div class="col-sm-4">
			         <button id="registered" class="btn btn-primary btn-block">注&nbsp;&nbsp;册</button>
		       	 </div>
		       	 <%--<div class="col-sm-4">--%>
			         <%--<button type="button" class="btn btn-link btn-block">忘记密码？</button>--%>
		       	 <%--</div>--%>
		       </div>
		    </div>
	      </form>
	      <!-- login form end -->
	    </div>
	  </div>
    </div>
    <!-- 页尾 版权声明 -->
    <div class="container">
		<div class="col-sm-12 foot-css">
		        <p class="text-muted credit">
					@机动车考试答题系统
		        </p>
	    </div>
    </div>


	<!-- 登录错误信息 start -->
	<div class="modal fade" tabindex="-1" id="loginFailure">
		<!-- 窗口声明 -->
		<div class="modal-dialog modal-lg">
			<!-- 内容声明 -->
			<div class="modal-content">
				<!-- 头部、主体、脚注 -->
				<div class="modal-header">
					<button class="close" data-dismiss="modal">&times;</button>
				</div>
				<div class="modal-body">
					<h4 class="modal-title text-center" id="FailMessage">登录失败，请检查帐号或者密码输入是否有误！</h4>
				</div>
				<div class="modal-footer">
					<button class="btn btn-primary loginConfirm">确定</button>
				</div>
			</div>
		</div>
	</div>
	<!-- 登录错误信息 end -->
  </body>
</html>
