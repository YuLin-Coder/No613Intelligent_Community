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

<script type="text/javascript" src="js/jquery-1.4.2.min.js"></script>
<script type="text/javascript" src="js/jquery.watermark.min.js"></script>
<script type="text/javascript" src="js/jquery-ui-1.8.12.custom.min.js"></script>
<!-- 模态框插件 -->
<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/My97DatePicker/WdatePicker.js"></script>
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
							$('#txtVillageId').focus();
							$('#txtVillageId').attr("disabled", false);
							$('#villageInfo')
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
																			'admin/villageInfoList!exists',//Ajax请求目标地址
																			{
																				'id' : $(
																						'#txtVillageId')
																						.val()
																			//JSON参数
																			},
																			function(
																					response) {
																				if (Number(response) > 0) { //已存在  		
																					$(
																							'#txtVillageId+span')
																							.text(
																									"该小区编号已存在！");
																					$(
																							'#txtVillageId')
																							.focus();
																				} else { //如果不存在
																					$(
																							"#villageAddForm")
																							.attr(
																									"action",
																									"admin/villageInfoList!villageAdd"); //设置form的action属性
																					$(
																							"#villageAddForm")
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
		$('table#villageInfoList span.spanEdit')
				.click(
						function() {
							$
									.getJSON(
											//加载数据-----start----------
											"admin/villageInfoList!getVillageModel",
											{
												"id" : $(this).attr(
														"data-custom")
											},
											function(json) { //加载数据 回调函数-----start----------
												$('#txtVillageId').val(
														json.villageId); //加载初始值
												$('#txtVillageName').val(
														json.villageName); //加载初始值
												$('#selCommunityName')
														.val(
																json.communityModel.communityId); //加载初始值
												$('#txtLinkman').val(
														json.linkman); //加载初始值
												$('#txtSetUpTime').val(toDate(json.setUpTime,"yyyy-MM-dd hh:mm:ss")); //加载初始值
												$('#txtPhone').val(json.phone); //加载初始值
												$('#txtMobilePhone').val(
														json.mobilePhone); //加载初始值
												$('#txtFloorArea').val(
														json.floorArea); //加载初始值
												$('#txtBuildingArea').val(
														json.buildingArea); //加载初始值
												$('#txtGarageArea').val(
														json.garageArea); //加载初始值
												$('#txtStallNum').val(
														json.stallNum); //加载初始值
												$('#txtGreenArea').val(
														json.greenArea); //加载初始值
												$('#txtLocation').val(
														json.location); //加载初始值
												$('#txtIntroduction').val(
														json.introduction); //加载初始值

												$('#txtVillageId').attr(
														"readonly", true); //费用编号文本框不可用
												$('div#villageInfo')
														.dialog(
																{ //弹出编辑框-----start----------				
																	title : "修改信息",
																	resizable : false,
																	width : 420,
																	height : 350,
																	modal : true,
																	buttons : {
																		"更新" : function() {
																			if (submitCheck() == false) { //客户端验证未通过
																				return;
																			}
																			$(
																					"#villageAddForm")
																					.attr(
																							"action",
																							"admin/villageInfoList!villageEdit"); //设置form的action属性
																			$(
																					"#villageAddForm")
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
					$(".ckbVillage:checkbox").attr("checked",
							$(".selectall:checkbox").attr("checked"));
				});

		//删除所选
		$('#delSelect').click(
				function() {
					if (confirm("确定删除所选？")) {
						$('#formData').attr("action",
								"admin/villageInfoList!deleteVillageLists");
						$('#formData').submit();
					} else {
					}
				});

		//添加水印
		$('#txtKeywords').watermark("- - -请输入筛选条件- - -");

		//条件筛选
		$('#txtKeywords').keyup(function() {
			$("table#villageInfoList tr.trZebra").each(function() {
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
			format = format.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
		}
		for ( var k in o) {
			if (new RegExp("(" + k + ")").test(format)) {
				format = format.replace(RegExp.$1, RegExp.$1.length == 1 ? o[k]: ("00" + o[k]).substr(("" + o[k]).length));
			}
		}
		return format;
	};

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

		if ($.trim($("#txtVillageId").val()) == "") {
			$("#txtVillageId+span").text("请输入小区编号！");
			return false;
		}
		var i = /^[0-9]*[1-9][0-9]*$/;
		if (!$.trim($("#txtVillageId").val()).match(i)) {
			$("#txtVillageId+span").text("编号必须是正整数！");
			$('#txtVillageId').focus();
			return false;
		}
		$("#txtVillageId+span").text(''); //清空

		if ($.trim($("#txtVillageName").val()) == "") {
			$("#txtVillageName+span").text("请输入小区名称！");
			return false;
		}
		$("#txtVillageName+span").text(''); //清空

		if ($.trim($("#selCommunityName").val()) == "-1") {
			$("#selCommunityName+span").text("请选择所属社区！");
			return false;
		}
		$("#selCommunityName+span").text(''); //清空

		if ($.trim($("#txtLinkman").val()) == "") {
			$("#txtLinkman+span").text("请输入负责人！");
			return false;
		}
		$("#txtLinkman+span").text(''); //清空

		if ($.trim($("#txtSetUpTime").val()) == "") {
			$("#txtSetUpTime+span").text("请输入建成日期！");
			return false;
		}
		$("#txtSetUpTime+span").text(''); //清空

		if ($.trim($("#txtPhone").val()) == "") {
			$("#txtPhone+span").text("请输入联系电话！");
			return false;
		}
		$("#txtPhone+span").text(''); //清空

		if ($.trim($("#txtStallNum").val()) == "") {
			$("#txtStallNum+span").text("请输入车位数！");
			return false;
		}
		$("#txtStallNum+span").text(''); //清空
		return true;
	}

	//清空添加或编辑信息框
	function clearDeptForm() {
		$('#txtVillageId').val("");
		$('#txtVillageName').val("");
		$('#txtLinkman').val("");
		$('#txtMobilePhone').val("");
		$('#txtStallNum').val("");

		$("#txtVillageId+span").text("");
		$("#txtVillageName+span").text("");
		$("#txtLinkman+span").text("");
		$("#txtMobilePhone+span").text("");
		$("#txtStallNum+span").text("");
		$("#selCommunityName+span").text("");
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
			<li><a href="admin/costList">小区基础信息管理</a></li>
			<li>基本内容</li>
		</ul>
	</div>
	<!-- 导航栏结束 -->

	<!-- 信息添加开始 -->
	<div id="villageInfo" style="display: none;">
		<form id="villageAddForm" method="post">
			&nbsp;小区编号：<input type="text" id="txtVillageId"
				name="model.villageId" title="请输入楼房编号。" /> <span class='validate'></span><br />
			<br /> &nbsp;小区名称：<input type="text" id="txtVillageName"
				name="model.villageName" title="请输入楼房名称。" /> <span class='validate'></span>
			<br /> <br /> &nbsp;所属社区：<select id="selCommunityName"
				name="model.communityModel.communityId">
				<option value="-1">---请选择社区 ---</option>
				<s:iterator var="item" value="communityList">
					<option value="${ item.communityId}">${item.communityName}</option>
				</s:iterator>
			</select> <span class='validate'></span> <br /> <br /> &nbsp;负责人：<input
				type="text" id="txtLinkman" name="model.linkman" title="请输入楼房建筑面积。" />
			<span class='validate'></span> <br /> <br /> &nbsp;建立日期：<input
				onclick="return WdatePicker({'dateFmt':'yyyy-MM-dd HH:mm:ss'})"
				type="text" id="txtSetUpTime" name="model.setUpTime"
				title="请输入楼房建成时间。" /> <span class='validate'></span> <br /> <br />
			&nbsp;联系电话：<input type="text" id="txtPhone" name="model.phone"
				title="请输入楼房层数。" /> <span class='validate'></span> <br /> <br />
			&nbsp;移动电话：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="text"
				id="txtMobilePhone" name="model.mobilePhone" title="请输入楼房高度。" /> <span
				class='validate'></span> <br /> <br />

			&nbsp;占地面积：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="text"
				id="txtFloorArea" name="model.floorArea" title="请输入楼房高度。" /> <span
				class='validate'></span> <br /> <br />
			&nbsp;建筑面积：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="text"
				id="txtBuildingArea" name="model.buildingArea" title="请输入楼房高度。" />
			<span class='validate'></span> <br /> <br />
			&nbsp;车库面积：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="text"
				id="txtGarageArea" name="model.garageArea" title="请输入楼房高度。" /> <span
				class='validate'></span> <br /> <br />
			&nbsp;车位数：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="text"
				id="txtStallNum" name="model.stallNum" title="请输入楼房高度。" /> <span
				class='validate'></span> <br /> <br />
			&nbsp;绿化面积：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="text"
				id="txtGreenArea" name="model.greenArea" title="请输入楼房高度。" /> <span
				class='validate'></span> <br /> <br />
			&nbsp;位置说明：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="text"
				id="txtLocation" name="model.location" title="请输入楼房高度。" /> <span
				class='validate'></span> <br /> <br />
			&nbsp;小区说明：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="text"
				id="txtIntroduction" name="model.introduction" title="请输入楼房高度。" />
			<span class='validate'></span> <br /> <br /> <span id="message"
				class='validate'></span>
		</form>
	</div>

	<!-- 信息添加结束-->

	<!-- form表单开始 -->
	<form id="formData" action="admin/villageInfoList" method="post"
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
			<table id="villageInfoList" class="tablelist"
				style="text-align: center;">
				<thead>
					<tr>
						<th><input name="" type="checkbox" class="selectall" /></th>
						<th>序号</th>
						<th>小区编号</th>
						<th>小区名称</th>
						<th>所属社区</th>
						<th>负责人</th>
						<th>建立日期</th>
						<th>联系电话</th>
						<th>移动电话</th>
						<th>占地面积</th>
						<th>建筑面积</th>
						<th>车库面积</th>
						<th>车位数</th>
						<th>绿化面积</th>
						<th>位置说明</th>
						<th>小区说明</th>

						<th>操作</th>
					</tr>
				</thead>
				<tbody>
					<s:iterator var="item" value="villageInfoList" status="stat">
						<tr class="trZebra">
							<td><input name="delVillage" type="checkbox"
								value="${item.villageId }" class="ckbVillage" /></td>
							<td><s:property value="#stat.index+1" /></td>
							<td><s:property value="#item.villageId" /></td>
							<td><s:property value="#item.villageName" /></td>
							<td><s:property value="#item.communityModel.communityName" /></td>
							<td><s:property value="#item.linkman" /></td>
							<td><s:property value="#item.setUpTime" /></td>
							<td><s:property value="#item.phone" /></td>
							<td><s:property value="#item.mobilePhone" /></td>
							<td><s:property value="#item.floorArea" /></td>
							<td><s:property value="#item.buildingArea" /></td>
							<td><s:property value="#item.garageArea" /></td>
							<td><s:property value="#item.stallNum" /></td>
							<td><s:property value="#item.greenArea" /></td>
							<td><s:property value="#item.location" /></td>
							<td><s:property value="#item.introduction" /></td>
							<td><span class="spanEdit blue-pointer"
								data-custom='${ item.villageId }'><img
									src="images/application_edit.png" title="修改" /> </span>&nbsp;&nbsp; <a
								onclick="return confirm('确定删除该条信息？');"
								href="admin/villageInfoList!delInfo?id=<s:property value="#item.villageId" />"><img
									src="images/application_delete.png" title="删除" /> </a></td>
						</tr>
					</s:iterator>
				</tbody>
			</table>
			<!-- table表格数据结束 -->
		</div>
		<s:set var="actionName" value="'admin/villageInfoList'"></s:set>
		<s:include value="../inc/pager.jsp"></s:include>
	</form>
	<!-- form表单结束 -->
	<script type="text/javascript">
		$('.tablelist tbody tr:odd').addClass('odd');
	</script>

</body>
<s:include value="../inc/tips.jsp"></s:include>
</html>
