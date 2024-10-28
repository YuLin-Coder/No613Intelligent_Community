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
<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="js/jquery-1.4.2.min.js"></script>
<script type="text/javascript" src="js/jquery.watermark.min.js"></script>
<script type="text/javascript" src="js/jquery-ui-1.8.12.custom.min.js"></script>
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
					$('#txtCarNum').focus();
					$('#parkkingAddsInfo').dialog(
							//------弹出模态框开始------
							{
								title : "添加车位信息",
								resizable : false,
								width : 420,
								height : 350,
								modal : true,
								buttons : { //------按钮事件开始------
									"保存" : function() {
										if (submitCheck() == false) {
											return;
										} else {
											$("#parkkingAddForm").attr(
													"action",
													"admin/parkkingList!add"); //设置form的action属性
											$("#parkkingAddForm").submit(); //提交form
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
		//编辑
		$('table#parkkingList span.spanEdit')
				.click(
						function() {
							var parkkingId = $(this).attr("data-edite");
							$.getJSON("admin/parkkingList!getEditeParkModel", {
								"parkkingId" : parkkingId
							}, function(json) {
								$('#txtParkkingId').val(json.parkkingId);
								$('#txtCarNum').val(json.carNum);
								$('#txtCarType').val(json.carType);
								$('#selectRoom').val(json.roomModel.roomId);
								$('#txtCarTypeqq').val(
										json.parkTypeModel.ptId);
								$('#txtTimestart').val(
										toDate(json.timestart,
												"yyyy-MM-dd hh-ss-mm"));
								$('#txtTimend').val(
										toDate(json.timend,
												"yyyy-MM-dd hh-ss-mm"));

								if (json.parkSRTypeModel.parkSRId == 1) {
									$("#startFlag").attr("checked", true);
								}
								if (json.parkSRTypeModel.parkSRId == 3) {
									$("#stopFlag").attr("checked", true);
								}
								$('#txtTimestart').val(
										toDate(json.timestart, "yyyy-MM-dd")); //加载初始值
								$('#txtTimend').val(
										toDate(json.timend, "yyyy-MM-dd")); //加载初始值  
								$("#txtRemarks").val(json.remarks);
							});
							$('#parkkingAddsInfo')
									.dialog(
											{
												title : "编辑车位信息",
												resizable : false,
												disabled : false,
												draggable : true,
												width : 500,
												height : 430,
												model : true,
												buttons : {
													"编辑 " : function() {
														$("#parkkingAddForm")
																.attr("action",
																		"admin/parkkingList!UpdateParkkingModel");
														$("#parkkingAddForm")
																.submit();
													},
													"取消" : function() {
														clearDeptForm();//清空
														$(this).dialog("close");
													}
												}
											});//--dialog---end---
						});

		function submitCheck() {

			if ($.trim($("#txtParkkingId").val()) == "") {
				$("#txtParkkingId+span").text("请输入车位号！");
				$('#txtParkkingId').focus();
				return false;
			}

			$("#txtParkkingId+span").text(''); //清空

			if ($.trim($("#txtCarNum").val()) == "") {
				$("#txtCarNum+span").text("请输入车牌号！");
				$('#txtCarNum').focus();
				return false;
			}

			$("#txtCarNum+span").text(''); //清空

			/* if ($('#txtCarType').val() == "-1") {
				$("#txtCarType+span").text("请输入车类型！");
				$('#txtCarType').focus();
				return false;
			}
			$("#txtCarType+span").text(''); //清空 */

			if ($('#selectRoom').val() == "-1") {
				$("#selectRoom+span").text("请选择你的住所！");
				return false;
			}
			$("#selectRoom+span").text(''); //清空
			
			if ($('#txtCarTypeqq').val() == "-1") {
				$("#txtCarTypeqq+span").text("请选择车位类型！");
				return false;
			}
			$("#txtCarTypeqq+span").text(''); //清空

			return true;
		}
		//清空
		function clearDeptForm() {
			$('#txtParkkingId').val("");
			$("#txtParkkingId+span").text("");
			$('#txtCarNum').val("");
			$("#txtCarNum+span").text("");
			$('#txtCarType').val("");
			$("#txtCarType+span").text("");
			$('#selectRoom').val("-1");
			$("#selectRoom+span").text("");
			$('#selectParkType').val("-1");
			$("#selectParkType+span").text("");
			$('#txtTimestart').val("");
			$("#txtTimestart+span").text("");
			$('#txtTimend').val("");
			$("#txtTimend+span").text("");
			$('#txtRemarks').val("");
			$("#txtRemarks+span").text("");
			$('#message').text("");

		}
		//删除所选
		$('#delSelect').click(function() {
			alert("122312323");
			if (confirm("确定删除所选？")) {
				$('#formData').attr("action", "admin/parkkingList!deletemany");
				$('#formData').submit();
			} else {
			}
		});
		/* //删除所选
		$('#delSelect').click(function() {
			alert("122312323");
			if (confirm("确定删除所选？")) {
				$('#formData').attr("action", "admin/parkkingList!deletemany");
				$('#formData').submit();
			} else {
			}
		}); */
		//添加水印
		$('#txtKeywords').watermark("- - - - - - -请输入车牌号- - - - - - -");
		//条件筛选
		$('#txtKeywords').keyup(function() {
			$("table#parkkingList tr.trZebra").each(function() {
				var txtKeywords = $('#txtKeywords').val();
				if ($(this).text().indexOf(txtKeywords) == -1) {
					$(this).hide();
				} else {
					$(this).show();
				}
			});
		});
	});

	//转化JSON日期格式
	function toDate(objDate, format) {
		var date = new Date();
		date.setTime(objDate.time);
		date.setHours(objDate.hours);
		date.setMinutes(objDate.minutes);
		date.setSeconds(objDate.seconds);
		return date.format(format);
	}
	Date.prototype.format = function(format) {
		var o = {
			"M+" : this.getMonth() + 1,
			"d+" : this.getDate(),
			"h+" : this.getHours(),
			"m+" : this.getMinutes(),
			"s+" : this.getSeconds(),
			"q+" : Math.floor((this.getMonth() + 3) / 3),
			"S" : this.getMilliseconds()
		};
		if (/(y+)/.test(format)) {
			format = format.replace(RegExp.$1, (this.getFullYear() + "")
					.substr(4 - RegExp.$1.length));
		}
		for ( var k in o) {
			if (new RegExp("(" + k + ")").test(format)) {
				format = format.replace(RegExp.$1, RegExp.$1.length == 1 ? o[k]
						: ("00" + o[k]).substr(("" + o[k]).length));
			}
		}
		return format;
	};
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
	<div id="parkkingAddsInfo" class="hidden" hidden>
		<form method="post" id="parkkingAddForm">
			&nbsp;车位号：&nbsp;&nbsp;&nbsp;<input name="model.parkkingId"
				type="text" id="txtParkkingId"> <span class='validate'></span>
			<br /> <br />&nbsp;车牌号：&nbsp;&nbsp;&nbsp;<input type="text"
				id="txtCarNum" name="model.carNum" /> <span class='validate'></span>
			<br /> <br /> <%-- &nbsp;车类型：&nbsp;&nbsp;&nbsp;<input type="text"
				id="txtCarType" name="model.carType" /> <span class='validate'></span> --%>
			住所名称：&nbsp;<select id="selectRoom"
				name="model.roomModel.roomId">
				<option value="-1">-- 请选择你的住所 --</option>
				<s:iterator var="items" value="roomlist" status="stat">
					<option value="${items.roomId}">${items.roomName}</option>
				</s:iterator>
			</select> <span class='validate'></span> <br /> <br />车位类型：&nbsp;<select
				id="txtCarTypeqq" name="model.parkTypeModel.ptId">
				<option value="-1">-- 请选择你车位 --</option>
				<s:iterator var="items" value="ptlist" status="stat">
					<option value="${items.ptId}">${items.name}</option>
				</s:iterator>
			</select><span class='validate'></span> <br /> <br />是否出售：&nbsp;<input id="startFlag"
				name="model.parkSRTypeModel.parkSRId" type="radio" value="1"
				checked="checked" />已出售<input id="stopFlag"
				name="model.parkSRTypeModel.parkSRId" type="radio" value="3" />已出租<span
				class='validate'></span> <br /> <br /> &nbsp;开始时间：<input
				onclick="return  WdatePicker({'dateFmt':'yyyy-MM-dd'})" type="text"
				id="txtTimestart" name="model.timestart"
				onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})"
				datatype="/^\s*$|^\d{4}\-\d{1,2}\-\d{1,2}\s{1}(\d{1,2}:){2}\d{1,2}$/" />
			<span class='validate'></span> <br /> <br /> &nbsp;结束时间：<input
				type="text" id="txtTimend" name="model.timend"
				onfocus="WdatePicker({dateFmt:'yyyy-MM-dd  HH:mm:ss'})"
				datatype="/^\s*$|^\d{4}\-\d{1,2}\-\d{1,2}\s{1}(\d{1,2}:){2}\d{1,2}$/" />
			<span class='validate'></span> <br /> <br /> &nbsp;备注：
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="text"
				id="txtRemarks" name="model.remarks" /> <span class='validate'></span>
			<br /> <br />

		</form>
	</div>
	<!-- 信息添加结束-->

	<!-- form表单开始 -->
	<form id="formData" action="admin/parkkingList" method="post">
		<div class="rightinfo">

			<!-- 工具栏开始 -->
			<div class="tools">
				<ul class="toolbar">
					<li id="addInfo"><span><img src="images/t01.png" /></span>添加信息</li>
					<%-- <li><a
					href='<s:url action="parkkingList!initroomInfro"></s:url>'><i></i><span><img
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
			<table id="parkkingList" class="tablelist"
				style="text-align: center;">

				<thead>
					<tr class="odd_bg">
						<th>&nbsp;&nbsp;&nbsp;&nbsp;<input name="" type="checkbox"
							class="hidden" hidden /></th>
						<th width="left">序号</th>
						<th align="left">车牌号</th>
						<!-- <th align="left">车类型</th> -->
						<th align="left">房间名称</th>
						<th align="left">车位名称</th>
						<th align="left">出售|出租</th>
						<th align="left">开始时间</th>
						<th align="left">结束时间</th>
						<th align="left">备注信息</th>
						<th align="center">操作</th>

					</tr>
				</thead>
				<tbody>
					<s:iterator value="parkkingList" var="item" status="stat">
						<tr class="trZebra">
							<td align="center"><span class="checkall"
								style="vertical-align:middle;"><input name="checkId"
									type="checkbox" value='<s:property value="#item.parkkingId" />'></span>
							</td>
							<%-- <td><s:property value="#stat.index+1"></s:property></td> --%>
							<td><s:property value="#item.parkkingId" /></td>
							<td><s:property value="#item.carNum" /></td>
							<%-- <td><s:property value="#item.carType" /></td> --%>
							<td><s:property value="#item.roomModel.roomName" /></td>
							<td><s:property value="#item.parkTypeModel.name" /></td>
							<%-- <td><s:property value="#item.parkSRTypeModel.parkSRName" /></td> --%>
							<td align="center"><c:if
									test="${item.parkSRTypeModel.parkSRId==1}">
									<span style="color: green;">已出售</span>
								</c:if> <c:if test="${item.parkSRTypeModel.parkSRId==3}">
									<span style="color: red;">已出租</span>
								</c:if></td>
							<td><s:property value="#item.timestart" /></td>
							<td><s:property value="#item.timend" /></td>
							<td><s:property value="#item.remarks" /></td>
							<td><span class="spanEdit blue-pointer"
								data-edite='${ item.parkkingId }'><img
									src="images/application_edit.png" title="修改" /></span><span><a
									onclick="return confirm('确定删除该条信息？');"
									href="admin/parkkingList!delInfo?parkkingId=${item.parkkingId}"><img
										src="images/application_delete.png" title="删除" /></a></span></td>
						</tr>
					</s:iterator>
				</tbody>
			</table>
			<!-- table表格数据结束 -->
			<s:set var="actionName" value="'admin/parkkingList'"></s:set>
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

