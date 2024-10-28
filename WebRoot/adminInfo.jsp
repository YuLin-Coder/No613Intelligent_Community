<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%-- <%@ page import="com.jypc.dao.*" %>
<%@ page import="com.jypc.bean.*" %> --%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>登录信息</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<LINK href="css/admin.css" type="text/css" rel="stylesheet">
<link rel="stylesheet" href="css/style_control.css">
  </head>
  
  <body>
  	<TABLE cellSpacing=0 cellPadding=0 width="100%" align=center border=0>
  <TR height=28>
    <TD background=../images/title_bg1.jpg>
		&nbsp;&nbsp;
		<span style="font-weight:bold;">当前位置</span> >>  登录信息面板</TD>
  </TR>
  <TR>
    <TD bgColor=#b1ceef height=1></TD></TR>
  <TR height=20>
    <TD background=../images/shadow_bg.jpg></TD></TR></TABLE>
<TABLE cellSpacing=0 cellPadding=0 width="90%" align=center border=0>
  <TR height=100>
    <TD align="center" width=100>
    	<IMG height=100 src="images/admin_p.gif" width=90>
    </TD>
    <TD width=60>&nbsp;</TD>
    <TD>
      <TABLE height=100 cellSpacing=0 cellPadding=0 width="100%" border=0>
        
        <TR>
          <TD>您的身份：管理员</TD></TR>
        <TR>
          <TD style="FONT-WEIGHT: bold; FONT-SIZE: 16px">当前登录用户：${AdminMain.account}</TD></TR>
        <TR>
          <TD>欢迎进入“智能社区”后台管理中心！</TD></TR></TABLE></TD></TR>
  </TABLE>
<TABLE cellSpacing=0 cellPadding=0 width="95%" align=center border=0>

  <TR height=22>
    <TD 
    align=middle style="PADDING-LEFT: 20px; FONT-WEIGHT: bold; COLOR: #000"></TD>
  </TR>
  <TR bgColor=#ecf4fc height=12>
    <TD></TD></TR>
  <TR height=20>
    <TD></TD></TR></TABLE>
<TABLE cellSpacing=0 cellPadding=2 width="95%" align=left border=0>
  <TR>
    <TD align=right width="20%">登录帐号：</TD>
    <TD style="COLOR: #880000">${AdminMain.account}</TD></TR>
   <TR>
		    <TD align=right>用户姓名：</TD>
		    <TD style="COLOR: #880000">${AdminMain.userName}</TD></TR>
		  
		  <TR>
		    <TD align=right>身份证：</TD>
		    <TD style="COLOR: #880000">${AdminMain.identityCard}</TD></TR></TABLE>

  </body>
</html>
