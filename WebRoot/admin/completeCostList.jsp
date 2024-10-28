<%@page import="java.sql.ResultSet"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
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

<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="css/style.css" rel="stylesheet" type="text/css" />
<link href="css/general.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" href="css/jquery-ui.css" />	<!-- 模态框样式控制 -->

<script type="text/javascript" src="<%=request.getContextPath()%>/js/My97DatePicker/WdatePicker.js"></script> <!-- 日期控件 -->
<script type="text/javascript" src="js/jquery-1.4.2.min.js"></script>
<script type="text/javascript" src="js/jquery.watermark.min.js"></script>	<!-- 水印控件 -->
<script type="text/javascript" src="js/jquery-ui-1.8.12.custom.min.js"></script>	<!-- 模态框控件 -->
<script type="text/javascript" src="js/jquery.tipsy.js"></script>
<script type="text/javascript">
	$(document).ready(function() {
		$(".click").click(function() {
			$(".tip").fadeIn(200);
		});

		$(".tiptop a").click(function() {
			$(".tip").fadeOut(200);
		});

		$(".sure").click(function() {
			$(".tip").fadeOut(100);
		});

		$(".cancel").click(function() {
			$(".tip").fadeOut(100);
		});
	});

	$(function() {
		//全选
		$(".selectall:checkbox").click(
				function() {
					$(".ckbCompleteCost:checkbox").attr("checked",
							$(".selectall:checkbox").attr("checked"));
				});

		//补齐所选
		$('#delSelect').click(
				function() {
					if ($(":checkbox.ckbCompleteCost:checked").size() == 0) {
						alert("请选择所需补齐选项！");
						return false;
					}
					if (confirm("确定补齐所选？")) {
						$('#formData').attr("action","admin/completeCostList!addCompleteCosts");
						$('#formData').submit();
					} else {
					}
				});
		
		//按身份证号搜索
		$('#search').click(function(){
			var teg = /^\d{15}(\d\d[0-9xX])?$/;
			var idCard = $('#txtIdCard').val();
			if(idCard == ""){
				alert("请输入身份证号！");
				$('#txtIdCard').focus();
				return false;
			}
			if(!teg.test($('#txtIdCard').val())){
				alert("身份证号格式错误！");
				$('#txtIdCard').focus();
			}else{
				$.post(
				'admin/completeCostList!existsIdCard',//Ajax请求目标地址
				{
					'idCard' : $('#txtIdCard').val()
				},	function(response){
						if (Number(response) > 0) { //已存在的缴费信息  
							$('#formData').attr("action","admin/completeCostList!getCompleteCostIdcard");
							$('#formData').submit();
						}else{
							alert("该身份证住户不存在！");
							$('#txtIdCard').focus();
						}
					}
				);
			}
		});
		//添加水印
		$('#txtKeywords').watermark("- - -请输入筛选条件- - -");
		$('#txtIdCard').watermark("- -请输入需查询的身份证号- -");

		//条件筛选
		$('#txtKeywords').keyup(function() {
			$("table#paymentList tr.trZebra").each(function() {
				var txtKeywords = $('#txtKeywords').val();
				if ($(this).text().indexOf(txtKeywords) == -1) {
					$(this).hide();
				} else {
					$(this).show();
				}
			});
		});
	});

	//验证
	function check() {
		var txtPageSize = $('#txtPageSize').val();
		if (txtPageSize == "") {
			alert("设置条件不能为空！");
			$('#txtPageSize').focus();
			return false;
		}
		var teg = /^[0-9]*[1-9][0-9]*$/;
		if (!teg.test(txtPageSize)) {
			alert("设置条件格式不对,请输入正整数！");
			$('#txtPageSize').focus();
			$('#txtPageSize').val("");
			return false;
		}
		var currentPageNum = $('#currentPageNum').val();
		if (currentPageNum == "") {
			alert("跳转条件不能为空！");
			$('#currentPageNum').focus();
			return false;
		}
		if (!teg.test(currentPageNum)) {
			alert("跳转条件格式不对,请输入正整数！");
			$('#currentPageNum').val("");
			$('#currentPageNum').focus();
			return false;
		}
		return true;
	}
</script>
<style type="text/css">
#completeCostA{
	color: #3EAFE0;
}
#completeCostA:HOVER{
	text-decoration: underline;
}
.qianfei{
	color: red;
}
#txtIdCard{
	width: 160px;
	height: 33px;
}
#search {
	margin-left: -16px;
}
</style>
</head>
<body>
	<!-- 导航栏开始 -->
	<div class="place">
		<span>位置：</span>
		<ul class="placeul">
			<li><a href="index.jsp">首页</a></li>
			<li><a href="admin/paymentList">居民补款管理</a></li>
			<li>基本内容</li>
		</ul>
	</div>
	<!-- 导航栏结束 -->

	<!-- form表单开始 -->
	<form id="formData" action="admin/completeCostList" method="post"
		onsubmit="return check();">
		<div class="rightinfo">
			<!-- 工具栏开始 -->
			<div class="tools">
				<ul class="toolbar">
					<li id="delSelect"><span></span><a>补齐所勾选项</a></li>
					<li><input id="txtIdCard" type="text" name="model.tenementModel.idCard"/></li>
					<li id="search"><span></span><a>搜索</a></li>
					
					<li><input id="txtKeywords" type="text" /></li>
					<li class="shaixuan"><span><img src="images/t04.png" /></span>筛选</li>
				</ul>
				<ul class="toolbar1">
					<li class="meiye">每页显示<input id="txtPageSize" type="text"
						value="${pager.pageSize }" name="pager.pageSize" />条记录
					</li>
					<li><span><img src="images/t05.png" /></span><input
						class="shezhi" type="submit" value="设置" /></li>
				</ul>
			</div>
			<!-- 工具栏结束 -->

			<!-- table表格数据开始 -->
			<table id="completeCostList" class="tablelist" style="text-align: center;">
				<thead>
					<tr>
						<th><input name="" type="checkbox" class="selectall" /></th>
						<th>序号</th>
						<th>缴费编号</th>
						<th>住户姓名</th>
						<th>费用名称</th>
						<th>应缴费用（元）</th>
						<th>实缴费用（元）</th>
						<th>欠缴费（元）</th>
						<th>缴费日期</th>
						<th>缴费时间</th>
						<th>操作</th>
					</tr>
				</thead>
				<tbody>
					<s:iterator var="item" value="completeCostList" status="stat">
						<tr class="trZebra">
							<td><input name="ckbCompleteCost" type="checkbox" value="${ item.payId }"
								class="ckbCompleteCost" /></td>
							<td><s:property value="#stat.index+1" /></td>
							<td><s:property value="#item.payId" /></td>
							<td><s:property value="#item.tenementModel.tenementName" /></td>
							<td><s:property value="#item.costModel.costName" /></td>
							<td><s:property value="#item.payable" /></td>
							<td><s:property value="#item.practical" /></td>
							<s:if test="0 <= (#item.practical - #item.payable)">
								<td>0.0</td>
							</s:if>
							<s:else>
								<td class="qianfei"><s:property value="#item.practical - #item.payable" /></td>
							</s:else>
							<td><s:property value="#item.years" /> - <s:property value="#item.months" /></td>
							<td><s:property value="#item.payDate" /></td>
							<td><a onclick="return confirm('确定补齐该费用？');" id="completeCostA" 
								href="admin/completeCostList!addCompleteCost?id=<s:property value="#item.payId" />">
								补齐费用
								</a>
							</td>
						</tr>
					</s:iterator>
				</tbody>
			</table>
			<!-- table表格数据结束 -->
		</div>
		<s:set var="actionName" value="'admin/completeCostList'"></s:set>
		<s:include value="../inc/pager.jsp"></s:include>
	</form>
	<!-- form表单结束 -->
	<script type="text/javascript">
		$('.tablelist tbody tr:odd').addClass('odd');
	</script>

</body>
<s:include value="../inc/tips.jsp"></s:include>
</html>
