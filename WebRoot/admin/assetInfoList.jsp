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
							$('#txtAssetId').focus();
							$('#txtAssetId').attr("disabled", false);
							$('#assetInfo')
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
																			'admin/assetInfoList!exists',//Ajax请求目标地址
																			{
																				'id' : $(
																						'#txtAssetId')
																						.val()
																			//JSON参数
																			},
																			function(
																					response) {
																				if (Number(response) > 0) { //已存在  		
																					$(
																							'#txtAssetId+span')
																							.text(
																									"该资产编号已存在！");
																					$(
																							'#txtAssetId')
																							.focus();
																				} else { //如果不存在
																					$(
																							"#assetAddForm")
																							.attr(
																									"action",
																									"admin/assetInfoList!assetAdd"); //设置form的action属性
																					$(
																							"#assetAddForm")
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
		$('table#assetInfoList span.spanEdit').click(
				function() {
					$.getJSON( //加载数据-----start----------
					"admin/assetInfoList!getAssetModel", {
						"id" : $(this).attr("data-custom")
					}, function(json) { //加载数据 回调函数-----start----------
						$('#txtAssetId').val(json.assetId); //加载初始值
						$('#txtAssetName').val(json.assetName); //加载初始值
						$('#selAtName').val(json.assetTypeModel.assetTypeId); //加载初始值
						//$('#txtBuyDate').val(toDate(json.buyDate,"yyyy-MM-dd hh:mm:ss")); // 加载初始值
						$('#txtBuyDate').val(json.buyDate); //加载初始值
						$('#txtUserLife').val(json.userLife); //加载初始值
						$('#txtAssetNum').val(json.assetNum); //加载初始值
						
						$('#txtAssetId').attr("readonly", true); //资产编号文本框不可用
						$('div#assetInfo').dialog(
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
											$("#assetAddForm").attr("action",
													"admin/assetInfoList!assetEdit"); //设置form的action属性
											$("#assetAddForm").submit(); //提交form
										},
										"取消" : function() {
											clearDeptForm(); //清空
											$(this).dialog("close");
										}
									}
								}); //弹出编辑框-----end----------	
					} //加载数据 回调函数-----end----------
					); //加载数据-----end----------	
				});
		

		//全选
		$(".selectall:checkbox").click(
				function() {
					$(".ckbAsset:checkbox").attr("checked",
							$(".selectall:checkbox").attr("checked"));
				});

		//删除所选
		$('#delSelect').click(
				function() {
					if (confirm("确定删除所选？")) {
						$('#formData').attr("action",
								"admin/assetInfoList!deleteAssetLists");
						$('#formData').submit();
					} else {
					}
				});

		//添加水印
		$('#txtKeywords').watermark("- - -请输入筛选条件- - -");

		//条件筛选
		$('#txtKeywords').keyup(function() {
			$("table#assetInfoList tr.trZebra").each(function() {
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
	
	 //格式化时间
function dateFormate(){
	var value=$("#date_year").val()+"-"+$("#date_month").val()+"-"+$("#date_day").val()+" "+$("#date_h").val()+":"+$("#date_m").val();
	//var dt = Date.parse(value.replace(/-/g, "/"));
	//var date = new Date(value);
	$("#setUpTime").val(value);
	alert(value);
}
Date.prototype.format = function(format) {

    /*
     * format="yyyy-MM-dd hh:mm:ss";
     */
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
            format = format.replace(RegExp.$1, (this.getFullYear() + "").substr(4- RegExp.$1.length));
        }
    for (var k in o) {
        if (new RegExp("(" + k + ")").test(format)){
            format = format.replace(RegExp.$1, RegExp.$1.length == 1? o[k]:("00" + o[k]).substr(("" + o[k]).length));
        }
    }
    return format;
    
};
//转化JSON日期格式
function toDate(objDate, format) {
    var date = new Date();
    date.setTime(objDate.time);
    date.setHours(objDate.hours);
    date.setMinutes(objDate.minutes);
    date.setSeconds(objDate.seconds);
    return date.format(format);
}
	

	//添加或编辑信息时的客户端检查
	function submitCheck() {
		if ($.trim($("#txtAssetId").val()) == "") {
			$("#txtAssetId+span").text("请输入资产编号！");
			$('#txtAssetId').focus();
			return false;
		}
		$("#txtAssetId+span").text(''); //清空

		if ($.trim($("#txtAssetName").val()) == "") {
			$("#txtAssetName+span").text("请输入资产名称！");
			$('#txtAssetName').focus();
			return false;
		}
		$("#txtAssetName+span").text(''); //清空
		
		if ($('#selAtName').val() == "-1") {
			$("#selAtName+span").text("请选择所属类型！");
			return false;
		}
		$("#selAtName+span").text('');//清空
		
		if ($.trim($("#txtBuyDate").val()) == "") {
			$("#txtBuyDate+span").text("请输入买入时间！");
			$('#txtBuyDate').focus();
			return false;
		}
		$("#txtBuyDate+span").text(''); //清空

		if ($.trim($("#txtUserLife").val()) == "") {
			$("#txtUserLife+span").text("请输入使用寿命！");
			$('#txtUserLife').focus();
			return false;
		}
		$("#txtUserLife+span").text(''); //清空
		
		var teg = /^[0-9]*[1-9][0-9]*$/;
		if ($.trim($("#txtAssetNum").val()) == "") {
			$("#txtAssetNum+span").text("请输入资产数目！");
			$('#txtAssetNum').focus();
			return false;
		}
		if (!teg.test($("#txtAssetNum").val())) {
			$("#txtAssetNum+span").text("格式不对,请输入正整数！");
			$('#txtAssetNum').val("");
			$('#txtAssetNum').focus();
			return false;
		}
		$("#txtAssetNum+span").text(''); //清空


		return true;
	}

	//清空添加或编辑信息框
	function clearDeptForm() {
		$('#txtAssetId').val("");
		$('#txtAssetName').val("");
		$('#txtBuyDate').val("");
		$('#txtUserLife').val("");
		$('#txtAssetNum').val("");

		$("#txtAssetId+span").text("");
		$("#txtAssetName+span").text("");
		$("#selAtName+span").text("");
		$("#txtBuyDate+span").text("");
		$("#txtUserLife+span").text("");
		$("#txtAssetNum+span").text("");
		
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
			<li><a href="admin/assetList">资产项目管理</a></li>
			<li>基本内容</li>
		</ul>
	</div>
	<!-- 导航栏结束 -->

	<!-- 信息添加开始 -->
	<div id="assetInfo" class="hidden" hidden>
		<form method="post" id="assetAddForm">
			&nbsp;资产编号：<input type="text" id="txtAssetId" name="model.assetId" />
			<span class='validate'></span> <br /> <br /> &nbsp;资产名称：<input
				type="text" id="txtAssetName" name="model.assetName" /> <span
				class='validate'></span> <br /> <br /> &nbsp;资产所属类型：<select
				id="selAtName" name="model.assetTypeModel.assetTypeId">
				<option value="-1">-- 请选择类型 --</option>
				<s:iterator var="item" value="assetTypeList">
					<option value="${ item.assetTypeId}">${item.assetTypeName}</option>
				</s:iterator>
			</select>  <span
				class='validate'></span> <br /> <br /> &nbsp;买入时间：<input onclick="return  WdatePicker({'dateFmt':'yyyy-MM-dd'})"
				type="text" id="txtBuyDate" name="model.buyDate" class="input date"/>&nbsp;<i>日期</i> <span
				class='validate'></span> <br /> <br /> &nbsp;使用寿命：<input
				type="text" id="txtUserLife" name="model.userLife" /> <span
				class='validate'></span> <br /> <br /> &nbsp;资产数目：<input
				type="text" id="txtAssetNum" name="model.assetNum" />
				 <span class='validate'></span> <br /> <br /> <span id="message"
				class='validate'></span>
		</form>
	</div>
	<!-- 信息添加结束-->

	<!-- form表单开始 -->
	<form id="formData" action="admin/assetInfoList" method="post"
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
			<table id="assetInfoList" class="tablelist"
				style="text-align: center;">
				<thead>
					<tr>
						<th><input name="" type="checkbox" class="selectall" /></th>
						<th>序号</th>
						<th>资产编号</th>
						<th>资产名称</th>
						<th>资产所属类型</th>
						<th>买入时间</th>
						<th>使用寿命</th>
						<th>资产数目</th>
						<th>操作</th>
					</tr>
				</thead>
				<tbody>
					<s:iterator var="item" value="assetInfoList" status="stat">
						<tr class="trZebra">
							<td><input name="delAsset" type="checkbox" value="${item.assetId }" class="ckbAsset"/></td>
							<td><s:property value="#stat.index+1" /></td>
							<td><s:property value="#item.assetId" /></td>
							<td><s:property value="#item.assetName" /></td>
							<td><s:property value="#item.assetTypeModel.assetTypeName" /></td>
							<td><%-- <s:date name="buyDate" format="yyyy-MM-dd"/> --%><s:property value="#item.buyDate" /></td>
							<td><s:property value="#item.userLife" /></td>
							<td><s:property value="#item.assetNum" /></td>
							<td><span class="spanEdit blue-pointer"
								data-custom='${ item.assetId }'><img
									src="images/application_edit.png" title="修改" /> </span>&nbsp;&nbsp; <a
								onclick="return confirm('确定删除该条信息？');"
								href="admin/assetInfoList!delInfo?id=<s:property value="#item.assetId" />"><img
									src="images/application_delete.png" title="删除" /> </a></td>
						</tr>
					</s:iterator>
				</tbody>
			</table>
			<!-- table表格数据结束 -->
		</div>
		<s:set var="actionName" value="'admin/assetInfoList'"></s:set>
		<s:include value="../inc/pager.jsp"></s:include>
	</form>
	<!-- form表单结束 -->
	<script type="text/javascript">
		$('.tablelist tbody tr:odd').addClass('odd');
	</script>

</body>
<s:include value="../inc/tips.jsp"></s:include>
</html>
