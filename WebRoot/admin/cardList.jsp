<%@page import="java.sql.ResultSet"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
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
<link rel="stylesheet" href="css/jquery-ui.css" />
<!-- 模态框样式控制 -->

<script type="text/javascript" src="js/jquery-1.4.2.min.js"></script>
<script type="text/javascript" src="js/jquery.watermark.min.js"></script>
<script type="text/javascript" src="js/jquery-ui-1.8.12.custom.min.js"></script>
<!-- 模态框插件 -->
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
		//添加信息
		$('#addInfo').click(
				function() {//------添加按钮开始------
					$('#selectRoom').focus();
					$('#cardInfo').dialog(
							//------弹出模态框开始------
							{
								title : "添加新卡信息",
								resizable : false,
								width : 420,
								height : 350,
								modal : true,
								buttons : { //------按钮事件开始------
									"保存" : function() {
										if (submitCheck() == false) {
											return;
										} else {
											$("#cardAddForm").attr("action",
													"admin/cardList!cardAdd"); //设置form的action属性
											$("#cardAddForm").submit(); //提交form
										}
									},

									"取消" : function() {
										clearDeptForm();//清空
										$(this).dialog("close");
									}
								}
							//------按钮结束开始------
							//------按钮结束开始------
							});//------弹出模态框结束------
				});//------添加按钮结束------ */
		//编辑信息
		$('table#cardList span.spanEdit').click(
				function() {
					var cardId = $(this).attr("data-edite");
					$.post("admin/cardList!getEditeCard", {
						"cardId" : cardId
					}, function(json) {
						$("#txtcardId").val(json.cardId);
						$('#selectRoom').val(json.roomModel.roomId);
						if (json.stateFlag == 1) {
							$("#startFlag").attr("checked", true);
						} else {
							$("#stopFlag").attr("checked", true);
						}
						$('#txtextent').val(json.extent);
						$('#cardInfo').dialog(
								{
									title : "编辑房间信息",
									resizable : false,
									width : 420,
									height : 350,
									modal : true,
									buttons : {
										"编辑 " : function() {
											$("#cardAddForm").attr("action",
													"admin/cardList!update");
											$("#cardAddForm").submit();
										},
										"取消" : function() {
											$(this).dialog("close");
										}
									}
								});
						//--dialog---end---
					}, "json");
				});

		function submitCheck() {
			if ($('#selectRoom').val() == "-1") {
				$("#selectRoom+span").text("请选择你的住所！");
				return false;
			}
			$("#selectRoom+span").text(''); //清空
			return true;
		}
		//清空
		function clearDeptForm() {

			$('#selectRoom').val("-1");
			$("#selectRoom+span").text("");
		}
		
		//全选
		$(".selectall:checkbox").click(function() {
			$(".ckbCost:checkbox").attr("checked",$(".selectall:checkbox").attr("checked"));
		});
		
		//删除所选
		$('#delSelect').click(function() {
			if (confirm("确定删除所选？")) {
				$('#formData').attr("action", "admin/cardList!deletemany");
				$('#formData').submit();
			} else {
			}
		});
		//添加水印
		$('#txtKeywords').watermark("- - - - - - -请输入房间编号- - - - - - - ");
		//条件筛选
		$('#txtKeywords').keyup(function() {
			$("table#cardList tr.trZebra").each(function() {
				var txtKeywords = $('#txtKeywords').val();
				if ($(this).text().indexOf(txtKeywords) == -1) {
					$(this).hide();
				} else {
					$(this).show();
				}
			});
		});
	});
</script>
<style>
span {
	display: inline-block;
	margin: 0;
	padding: 0
}

.validate {
	color: red;
}
</style>
</head>

<body>
	<!-- 导航栏开始 -->
	<div class="place">
		<span>位置：</span>
		<ul class="placeul">
			<li><a href="#">首页</a></li>
			<li><a href="#">费用项目管理</a></li>
			<li><a href="#">基本内容</a></li>
		</ul>
	</div>
	<!--/导航栏开始 -->

	<!-- 信息添加开始 -->
	<div id="cardInfo" class="hidden" hidden>
		<form method="post" id="cardAddForm">
			<input type="hidden" name="cardBean.cardId" size="6" id="txtcardId">
			&nbsp;住所名称：<select id="selectRoom" name="cardBean.roomModel.roomId">
				<option value="-1">-- 请选择你的住所 --</option>
				<s:iterator var="items" value="roomList" status="stat">
					<option value="${items.roomId}">${items.roomName}</option>
				</s:iterator>
			</select> <span class='validate'></span> <br /> <br /> &nbsp;是否可用：<input
				id="startFlag" name="cardBean.stateFlag" type="radio" value="1"
				checked="checked" />启用 <input id="stopFlag"
				name="cardBean.stateFlag" type="radio" value="0" />停用<span
				class='validate'></span> <br /> <br />&nbsp;&nbsp;标记：<input
				type="text" id="txtextent" name="cardBean.extent" /> <span
				class='validate'></span> <br /> <br />

		</form>
	</div>
	<!-- 信息添加结束-->

	<!-- form表单开始 -->
	<form id="formData" action="admin/cardList" method="post">
		<div class="rightinfo">
			<!-- 工具栏开始 -->
			<div class="tools">
				<ul class="toolbar">
					<li id="addInfo"><span><img src="images/t01.png" /></span>添加信息</li>
					<%-- <li><a
					href='<s:url action="cardList!initroomInfro"></s:url>'><i></i><span><img
							src="../images/t01.png" /></span>添加信息</a></li> --%>
					<%-- <li><span><img src="../images/t01.png" /></span>添加信息</li> --%>
					<li id="delSelect"><span><img src="images/t03.png" /></span>删除所选</li>
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
			<table id="cardList" class="tablelist" style="text-align: center;">
				<thead>
					<tr>
						<th><input type="checkbox" class="selectall"/></th>
						<th align="center">序号</th>
						<th align="center">卡号</th>
						<th align="center">住房编号</th>
						<th align="center">是否可用</th>
						<th align="center">停用|启用</th>
						<th align="center">操作</th>
					</tr>
				</thead>
				<tbody>
					<s:iterator value="cardList" var="item" status="stat">
						<tr class="trZebra">
							<td><input name="delCard" type="checkbox" value="${item.cardId }" class="ckbCost"/></td>
							<td><s:property value="#stat.index+1"></s:property></td>
							<td><s:property value="#item.cardId" /></td>
							<td><s:property value="#item.roomModel.roomName" /></td>
							<td><c:if test="${item.stateFlag==1}">
									<span style="color: green;">可用</span>
								</c:if> <c:if test="${item.stateFlag==0}">
									<span style="color: red;">不可用</span>
								</c:if></td>

							<td><c:if test="${item.stateFlag==1}">
									<a href="admin/cardList!stopCard?cardId=${item.cardId}"
										onclick="return DelConfirm(this, '真的要停用吗');"><span
										style="cursor:pointer;">停用</span></a>
								</c:if> <c:if test="${item.stateFlag==0}">
									<a href="admin/cardList!startCard?cardId=${item.cardId}"
										onclick="return DelConfirm(this, '真的要启用吗');"><span
										style="cursor:pointer;";>启用</span></a>
								</c:if></td>
							<td><span class="spanEdit blue-pointer"
								data-edite='${ item.cardId }'><img
									src="images/application_edit.png" title="修改" /></span><span><a
									onclick="return confirm('确定删除该条信息？');"
									href="admin/cardList!delInfo?cardId=${item.cardId}"><img
										src="images/application_delete.png" title="删除" /></a></span></td>
						</tr>
					</s:iterator>
				</tbody>
			</table>
			<!-- table表格数据结束 -->
			<s:set var="actionName" value="'admin/cardList'"></s:set>
			<s:include value="../inc/pager.jsp"></s:include>

			<div class="tip">
				<div class="tiptop">
					<span>提示信息</span><a></a>
				</div>
				<div class="tipinfo">
					<span><img src="images/ticon.png" /></span>
					<div class="tipright">
						<p>是否确认对信息的修改 ？</p>
						<cite>如果是请点击确定按钮 ，否则请点取消。</cite>
					</div>
				</div>
				<div class="tipbtn">
					<input name="" type="button" class="sure" value="确定" />&nbsp; <input
						name="" type="button" class="cancel" value="取消" />
				</div>
			</div>
		</div>
	</form>
	<!-- form表单结束 -->
	<script type="text/javascript">
		$('.tablelist tbody tr:odd').addClass('odd');
	</script>
</body>
<s:include value="../inc/tips.jsp"></s:include>
</html>

