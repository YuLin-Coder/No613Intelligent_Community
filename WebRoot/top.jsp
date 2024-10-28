<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>无标题文档</title>
<link href="css/style.css" rel="stylesheet" type="text/css" />
<script language="JavaScript" src="js/jquery.js"></script>
<script type="text/javascript">
	$(function() {
		//顶部导航切换
		$(".nav li a").click(function() {
			$(".nav li a.selected").removeClass("selected");
			$(this).addClass("selected");
		});
	});
</script>


</head>

<body style="background:url(images/topbg.gif) repeat-x;">

	<div class="topleft">
		<a href="main.html" target="_parent"><img
			src="images/loginlogo2.png" title="系统首页" /></a>
	</div>

	<ul class="nav">
		<li><a href="admin/owenrList" target="rightFrame"><img
				src="images/icon01.png" title="" />
				<h2>物业管理</h2></a></li>
		<li><a href="admin/cardList" target="rightFrame"><img
				src="images/icon02.png" title="" />
				<h2>一卡通管理</h2></a></li>
		<li><a href="admin/costList" target="rightFrame"><img
				src="images/icon03.png" title="" />
				<h2>费用项目管理</h2></a></li>
		<li><a href="admin/reportList" target="rightFrame"><img
				src="images/icon04.png" title="" />
				<h2>报修管理</h2></a></li>
		<li><a href="admin/repairList" target="rightFrame"><img
				src="images/icon05.png" title="" />
				<h2>维修管理</h2></a></li>
		<li><a href="zhanShi.jsp" target="rightFrame"><img
				src="images/icon06.png" title="" />
				<h2>社区平面展示</h2></a></li>
	</ul>

	<div class="topright">
		<ul>
			<li><span><img src="images/help.png" title="帮助"
					class="helpimg" /></span><a href="#">帮助</a></li>
			<li><a href="#">关于</a></li>
			<li><a href="loginList!loginOut" target="_parent" id="loginOut" onclick="return confirm('确定退出？')">退出</a></li>
		</ul>

		<div class="user">
			<span>admin</span> <i>消息</i> <b>5</b>
		</div>

	</div>
</body>
</html>
