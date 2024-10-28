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
<link rel="stylesheet" href="css/jquery-ui.css" />
<!-- 模态框样式控制 -->

<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/My97DatePicker/WdatePicker.js"></script>
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
		$('#addInfo')
				.click(
						function() { //------添加按钮开始------
							$('#txtTenementId').focus();
							$('#txtTenementId').attr("disabled", false);
							$('#tenementInfo')
									.dialog(
											{ //------弹出模态框开始------
												title : "添加信息",
												resizable : false,
												width : 420,
												height : 350,
												modal : true,
												buttons : { //------按钮事件开始------
													"保存" : function() {
														if (submitCheck() == false) {
															return;
														} else {
															$
																	.post(
																			'admin/tenementList!exists',//Ajax请求目标地址
																			{
																				'id' : $(
																						'#txtTenementId')
																						.val()
																			//JSON参数
																			},
																			function(
																					response) {
																				if (Number(response) > 0) { //已存在  		
																					$(
																							'#txtTenementId+span')
																							.text(
																									"该居民编号已存在！");
																					$(
																							'#txtTenementId')
																							.focus();
																				} else { //如果不存在
																					$(
																							"#tenementAddForm")
																							.attr(
																									"action",
																									"admin/tenementList!tenementAdd"); //设置form的action属性
																					$(
																							"#tenementAddForm")
																							.submit(); //提交form
																				}
																			});//post结束
														}//else结束
													},
													"取消" : function() {
														clearDeptForm();//清空
														$(this).dialog("close");
													}
												}
											//------按钮结束开始------
											});//------弹出模态框结束------
						});//------添加按钮结束------

		//编辑信息
		$('table#tenementList span.spanEdit')
				.click(
						function() {//alert("11");
							$
									.getJSON(
											//加载数据-----start----------
											"admin/tenementList!getTenementModel",
											{
												"id" : $(this).attr(
														"data-custom")
											},
											function(json) { //加载数据 回调函数-----start----------
												$('#txtTenementId').val(
														json.tenementId); //加载初始值
												$('#txtTenementName').val(
														json.tenementName); //加载初始值
												if (json.sex == "女") {
													$('#txtWomen').attr(
															"checked", true);
												} else {
													$('#txtMan').attr(
															"checked", true);
												}
												$('#txtPhone').val(json.phone); //
												$('#txtMobilePhone').val(
														json.mobilePhone);
												$('#txtEmail').val(json.email); //
												if (json.areStay == "是") {
													$("#is").attr("checked",
															true);
												} else {
													$("#no").attr("checked",
															true);
												}
												$('#selCtNameqq').val(
														json.roomModel.roomId); //加载初始值
												$('div#tenementInfo')
														.dialog(
																{ //弹出编辑框-----start----------				
																	title : "修改信息",
																	resizable : false,
																	width : 420,
																	height : 450,
																	modal : true,
																	buttons : {
																		"更新" : function() {
																			if (submitCheck() == false) { //客户端验证未通过
																				return;
																			}
																			$(
																					"#tenementAddForm")
																					.attr(
																							"action",
																							"admin/tenementList!tenementEdit"); //设置form的action属性
																			$(
																					"#tenementAddForm")
																					.submit(); //提交form
																		},
																		"取消" : function() {
																			clearDeptForm(); //清空
																			$(
																					this)
																					.dialog(
																							"close");
																		}
																	}
																}); //弹出编辑框-----end----------	
											} //加载数据 回调函数-----end----------
									); //加载数据-----end----------	
						});

		//全选
		$(".selectall:checkbox").click(
				function() {
					$(".ckbTenement:checkbox").attr("checked",
							$(".selectall:checkbox").attr("checked"));
				});

		//删除所选
		$('#delSelect').click(
				function() {
					if (confirm("确定删除所选？")) {
						$('#formData').attr("action",
								"admin/tenementList!deleteTenementLists");
						$('#formData').submit();
					} else {
					}
				});

		//添加水印
		$('#txtKeywords').watermark("- - -请输入筛选条件- - -");

		//条件筛选
		$('#txtKeywords').keyup(function() {
			$("table#tenementList tr.trZebra").each(function() {
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

	//添加或编辑信息时的客户端检查
	function submitCheck() {
		var teg = /^[0-9]*[1-9][0-9]*$/;
		if ($.trim($("#txtTenementId").val()) == "") {
			$("#txtTenementId+span").text("请输入居民编号！");
			$('#txtTenementId').focus();
			return false;
		}
		if (!teg.test($("#txtTenementId").val())) {
			$("#txtTenementId+span").text("格式不对,请输入正整数！");
			$('#txtTenementId').val("");
			$('#txtTenementId').focus();
			return false;
		}
		$("#txtTenementId+span").text(''); //清空

		if ($.trim($("#txtTenementName").val()) == "") {
			$("#txtTenementName+span").text("请输入居民姓名！");
			$('#txtTenementName').focus();
			return false;
		}
		$("#txtTenementName+span").text(''); //清空

		if ($('#selSex').val() == "-1") {
			$("#selSex").text("请选择类型！");
			return false;
		}
		$("#selSex+span").text(''); //清空

		if ($.trim($("#txtPhone").val()) == "") {
			$("#txtPhone+span").text("请输入电话！");
			$('#txtPhone').focus();
			return false;
		}
		$("#txtMobilePhone+span").text(''); //清空

		if ($.trim($("#txtMobilePhone").val()) == "") {
			$("#txtMobilePhone+span").text("请输入手机号！");
			$('#txtMobilePhone').focus();
			return false;
		}
		$("#txtMobilePhone+span").text(''); //清空

		if ($.trim($("#txtEmail").val()) == "") {
			$("#txtEmail+span").text("请输入电子邮箱！");
			$('#txtEmail').focus();
			return false;
		}
		$("#txtEmail+span").text(''); //清空

		if ($('#selCtNameqq').val() == "-1") {
			$("#selCtNameqq+span").text("请选择房间编号！");
			return false;
		}
		$("#selCtNameqq+span").text(''); //清空
		return true;
	}

	//清空添加或编辑信息框
	function clearDeptForm() {
		$('#txtTenementId').val("");
		$('#txtTenementName').val("");
		$('#selSex').val("");
		$('#txtPhone').val("");
		$('#txtMmobilePhone').val("");
		$('#txtEmail').val("");
		$('#selCtNameqq').val("");

		$("#txtTenementId+span").text("");
		$("#txtTenementName+span").text("");
		$("#selSex+span").text("");
		$("#txtPhone+span").text("");
		$("#txtMmobilePhone+span").text("");
		$("#txtEmail+span").text("");
		$("#selCtNameqq+span").text("");
		$('#message').text("");

	}
</script>
</head>

<body>
	<!-- 导航栏开始 -->
	<div class="place">
		<span>位置：</span>
		<ul class="placeul">
			<li><a href="index.jsp">首页</a></li>
			<li><a href="admin/tenementList">维修管理</a></li>
			<li>基本内容</li>
		</ul>
	</div>
	<!-- 导航栏结束 -->

	<!-- 信息添加开始 -->
	<div id="tenementInfo" class="hidden">
		<form method="post" id="tenementAddForm">
			&nbsp;居民编号：<input type="text"  id="txtTenementId"  name="model.tenementId" /> <span class='validate'></span> <br /> <br />

			&nbsp;居民姓名：<input type="text" id="txtTenementName" name="model.tenementName" /> <span class='validate'></span> <br /><br /> 

			&nbsp;性&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;别：<span class="trHead" style="text-align: left">
				&nbsp;&nbsp;&nbsp;男<input type="radio" id="txtMan" name="model.sex" value="男">
				&nbsp;&nbsp;女<input type="radio" id="txtWomen" name="model.sex" value="女"
				checked="checked">
			</span> <br /> <br /> &nbsp;电话号码：<input type="text" id="txtPhone"
				name="model.phone" /> <span class='validate'></span> <br /> <br />

			&nbsp;手机号码：<input type="text"  id="txtMobilePhone"
				name="model.mobilePhone" /> <span class='validate'></span> <br />

			<br /> &nbsp;电子邮箱：<input type="text"  id="txtEmail"
				name="model.email" /> <span class='validate'></span> <br /> <br />

			&nbsp;是否入住： <input type="radio" name="model.areStay"  id="is"
				value="是" checked="checked" />是 <input type="radio"
				name="model.areStay" id="no" value="否" />否 <span class="validate"></span>
			<br /> <br /> &nbsp;房间编号： <select id="selCtNameqq"
				name="model.roomModel.roomId">
				<option value="-1">---请选择房间编号---</option>
				<s:iterator value="roomList" var="item">
					<option value="${item.roomId }">${item.roomId}</option>
				</s:iterator>
			</select> <span class="validate"></span> <br /> <br /> 
			<span id="message"
				class='validate'></span>
		</form>
	</div>
	<!-- 信息添加结束-->

	<!-- form表单开始 -->
	<form id="formData" action="admin/tenementList" method="post"
		onsubmit="return check();">
		<div class="rightinfo">

			<!-- 工具栏开始 -->
			<div class="tools">
				<ul class="toolbar">
					<li id="addInfo"><span><img src="images/t01.png" /></span>添加信息</li>
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
			<table id="tenementList" class="tablelist"
				style="text-align: center;">
				<thead>
					<tr>
						<th><input name="" type="checkbox" class="selectall" /></th>
						<th>序号</th>
						<th>居民编号</th>
						<th>居民姓名</th>
						<th>性别</th>
						<th>电话</th>
						<th>手机</th>
						<th>邮箱</th>
						<th>是否入住</th>
						<th>房间编号</th>
						<th>操作</th>
					</tr>
				</thead>
				<tbody>
					<s:iterator var="item" value="tenementList" status="stat">
						<tr class="trZebra">
							<td><input name="delTenement" type="checkbox"
								value="${item.tenementId }" class="ckbTenement" /></td>
							<td><s:property value="#stat.index+1" /></td>
							<td><s:property value="#item.tenementId" /></td>
							<td><s:property value="#item.tenementName" /></td>
							<td><s:property value="#item.sex" /></td>
							<td><s:property value="#item.phone" /></td>
							<td><s:property value="#item.mobilePhone" /></td>
							<td><s:property value="#item.email" /></td>
							<td><s:property value="#item.areStay" /></td>
							<td><s:property value="#item.roomModel.roomId" /></td>

							<td><span class="spanEdit blue-pointer"
								data-custom='${ item.tenementId }'><img
									src="images/application_edit.png" title="修改" /> </span>&nbsp;&nbsp; <a
								onclick="return confirm('确定删除该条信息？');"
								href="admin/tenementList!delInfo?id=<s:property value="#item.tenementId" />"><img
									src="images/application_delete.png" title="删除" /> </a></td>
						</tr>
					</s:iterator>
				</tbody>
			</table>
			<!-- table表格数据结束 -->
		</div>
		<s:set var="actionName" value="'admin/tenementList'"></s:set>
		<s:include value="../inc/pager.jsp"></s:include>
	</form>
	<!-- form表单结束 -->
	<script type="text/javascript">
		$('.tablelist tbody tr:odd').addClass('odd');
	</script>

</body>
<s:include value="../inc/tips.jsp"></s:include>
</html>
