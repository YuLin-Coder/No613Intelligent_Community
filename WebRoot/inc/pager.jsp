<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib uri="/struts-tags" prefix="s"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<base href="<%=basePath%>">

<title>My JSP 'pager.jsp' starting page</title>

<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
<meta http-equiv="description" content="This is my page">

<link href="css/general.css" rel="stylesheet" type="text/css" />
<style type="text/css">
/* body {
	font-size: 12px;
	font-family: Verdana;
} */
a {
	color: #333;
	text-decoration: none;
}

ul {
	list-style: none;
}

#pagelist {
	margin: 15px auto;
	padding: 6px 0px;
	height: 20px;
	margin: 15px auto;
}

#pagelist ul li {
	float: left;
	border: 1px solid #CBCBCB;
	height: 25px;
	line-height: 25px;
	margin: 0px 2px;
	height: 25px;
}

#pagelist ul li,.pageinfo {
	display: block;
	padding: 0px 6px;
	/* background: #e6f2fe; */
}

.pageinfo {
	color: #555;
}

.current { /* background: #a9d2ff; */
	display: block;
	padding: 0px 6px;
	font-weight: bold;
}

.pager {
	width: 48px;
	text-align: center;
}

#btnGo:HOVER {
	background-color: #e5ecf0;
}
</style>
</head>

<body>
	<div id="pagelist">
		<ul>
			<li class="current">第</li>
			<li class="current">${pager.currrntPageNum }</li>
			<li class="current">页</li>
			<li class="current">/</li>
			<li class="current">共</li>
			<li class="current">${pager.allPage }</li>
			<li class="current">页</li>
			<li class="current">，</li>
			<s:if test="pager.isFirstPage()">
				<li><span class="pager">首页</span></li>
				<li><span class="pager">上一页</span></li>
			</s:if>
			<s:else>
				<li><a
					href="${ actionName}?pager.currrntPageNum=1&pager.pageSize=${pager.pageSize }"><span
						class="pager">首页</span></a></li>
				<li><a
					href="${ actionName}?pager.currrntPageNum=${pager.currrntPageNum-1 }&pager.pageSize=${pager.pageSize}"><span
						class="pager">上一页</span></a></li>
			</s:else>
			<s:if test="pager.isLastPage()">
				<li><span class="pager">下一页</span></li>
				<li><span class="pager">尾页</span></li>
			</s:if>
			<s:else>
				<li><a
					href="${ actionName}?pager.currrntPageNum=${pager.currrntPageNum+1 }&pager.pageSize=${pager.pageSize}"><span
						class="pager">下一页</span></a></li>
				<li><a class="pager"
					href="${ actionName}?pager.currrntPageNum=${pager.allPage }&pager.pageSize=${pager.pageSize}"><span
						class="pager">尾页</span></a></li>
			</s:else>
			<li class="current">,</li>
			<li class="current">第</li>
			<li class="current"><input id="currentPageNum"
				value="${pager.currrntPageNum }" type="text" size="1"
				name="pager.currrntPageNum" class="inputTextCenter"></li>
			<li class="current">页</li>
		</ul>
		<input type="submit" value="跳转" id="btnGo">
	</div>
</body>
</html>
