<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" 
"http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib uri="/struts-tags" prefix="s"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>
<html>
<head>
<title>智能社区后台管理-登录</title>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />

<link href="css/style.css" rel="stylesheet" type="text/css" />

<script src="js/cloud.js" type="text/javascript"></script>
<script language="JavaScript" src="js/jquery.js"></script>
<script type="text/javascript" src="js/jquery-1.10.2.js"></script>
<script type="text/javascript" src="js/jquery-1.4.2.min.js"></script>

<script language="javascript">
	$(function() {
		$('.loginbox').css({
			'position' : 'absolute',
			'left' : ($(window).width() - 692) / 2
		});
		$(window).resize(function() {
			$('.loginbox').css({
				'position' : 'absolute',
				'left' : ($(window).width() - 692) / 2
			});
		});

	});
</script>
<script type="text/javascript">
	$(function() {
		$('#txtAccount').val("");
		$('#txtUserPwd').val("");
		$('#txtAccount').focus();
		//管理员登陆验证
		$('#loginbtn').click(function() {
			var user = $.trim($('#txtAccount').val());
			if (user == "") {
				alert("请输入用账号！");
				$('#txtAccount').focus();
				return false;
			}
			var userPwd = $.trim($('#txtUserPwd').val());
			if (userPwd == "") {
				alert("请输入密码！");
				$('#txtUserPwd').focus();
				return false;
			}
			return true;
		});
		/* //重置密码
		$('#rePwd').click(function() {
			if (confirm("确定将密码重置为:123456？")) {
				$('#formData').attr("action",
						"loginList/LoginUser!reSet");
				$('#formData').submit();
			} else {
			}
		}); */
	});
</script>
</head>
<body
	style="background-color:#1c77ac; background-image:url(images/light.png); background-repeat:no-repeat; background-position:center top; overflow:hidden;">

	<div id="mainBody">
		<div id="cloud1" class="cloud"></div>
		<div id="cloud2" class="cloud"></div>
	</div>

	<div class="logintop">
		<span>欢迎登录后台管理界面</span>
		<ul>
			<li><a href="#">回首页</a></li>
			<li><a href="#">帮助</a></li>
			<li><a href="#">关于</a></li>
		</ul>
	</div>

	<div class="loginbody">
		<span class="systemlogo"></span>
		<div class="loginbox">
			<form id="formData" method="post" action="loginList!LoginUser">
				<ul>
					<li><input name="account" id="txtAccount" type="text"
						class="loginuser" /></li>
					<li><input name="userPwd" id="txtUserPwd" type="password"
						class="loginpwd" /></li>
					<li><input id="loginbtn" name="loginbtn" type="submit"
						class="loginbtn" value="登录" />&nbsp;&nbsp;&nbsp;<!-- <label><input
						name="mark" type="checkbox" value="rememberP" checked="checked" />记住密码</label>&nbsp;&nbsp;&nbsp;<label><a
						id="rePwd">忘记密码？</a></label> --></li>
				</ul>
			</form>
		</div>
	</div>
	<div class="loginbm"></div>

</body>
<s:include value="inc/tips.jsp"></s:include>
</html>
