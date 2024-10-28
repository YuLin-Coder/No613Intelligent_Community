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
<script type="text/javascript"  src="<%=request.getContextPath() %>/js/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="js/jquery-1.4.2.min.js"></script>
<script type="text/javascript" src="js/jquery.watermark.min.js"></script>
<script type="text/javascript" src="js/jquery-ui-1.8.12.custom.min.js"></script>
<!-- 模态框插件 -->
<script type="text/javascript" src="js/jquery.tipsy.js"></script>
<style type="text/css">
.span {
	display: inline-block;
	margin: 0;
	padding: 0
}
</style>
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
							$('#txtOwenrId').focus();
							$('#txtOwenrId').attr("disabled", false);
							$('#owenrInfo')
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
																			'admin/owenrList!exists',//Ajax请求目标地址
																			{
																				'id' : $(
																						'#txtOwenrId')
																						.val()
																			//JSON参数
																			},
																			function(
																					response) {
																				if (Number(response) > 0) { //已存在  		
																					$(
																							'#txtOwenrId+span')
																							.text(
																									"该费用编号已存在！");
																					$(
																							'#txtOwenrId')
																							.focus();
																				} else { //如果不存在
																					$(
																							"#owenrAddForm")
																							.attr(
																									"action",
																									"admin/owenrList!owenrAdd"); //设置form的action属性
																					$(
																							"#owenrAddForm")
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
		$('table#owenrList span.spanEdit').click(function(){
			$.getJSON(			//加载数据-----start----------
					"admin/owenrList!getOwenrModel",
					{
						"id":$(this).attr("data-custom")
					},
					function(json){     //加载数据 回调函数-----start----------
						$('#txtOwenrId').val(json.owenrId);  //加载初始值
						$('#txtOwenrName').val(json.owenrName);  //加载初始值
												if (json.sex == "女") {
													$('#txtWomen').attr(
															"checked", true);
												} else {
													$('#txtMan').attr(
															"checked", true);
												}
						$('#txtAUnit').val(json.aUnit);  //加载初始值
						$('#txtIdCard').val(json.idCard);  //加载初始值
						$('#txtPhone').val(json.phone);  //加载初始值
						$('#txtMobilePhone').val(json.mobilePhone);  //加载初始值
						$('#txtEmail').val(json.email);  //加载初始值
						$('#txtBuyDate').val(toDate(json.buyDate,"yyyy-MM-dd hh:mm:ss"));  //加载初始值
						$('#txtOwenrId').attr("readonly",true);   //费用编号文本框不可用
						$('div#owenrInfo').dialog({        //弹出编辑框-----start----------				
							title:"修改信息",
							resizable: false,
							width:420,
							height:350,
							modal: true,
							buttons: {
								"更新": function() {
									if(submitCheck()==false){  //客户端验证未通过
										return;
									}
									$("#owenrAddForm").attr("action","admin/owenrList!owenrEdit");   //设置form的action属性
									$("#owenrAddForm").submit();   //提交form
								},
								"取消": function() {
									clearDeptForm();  //清空
									$( this ).dialog( "close" );
								}
							}
						});			//弹出编辑框-----end----------	
					}			//加载数据 回调函数-----end----------
				);			//加载数据-----end----------	
		});

		//全选
		$(".selectall:checkbox").click(
				function() {
					$(".ckbOwenr:checkbox").attr("checked",
							$(".selectall:checkbox").attr("checked"));
				});

		//删除所选
		$('#delSelect').click(
				function() {
					if (confirm("确定删除所选？")) {
						$('#formData').attr("action",
								"admin/owenrList!deleteOwenrLists");
						$('#formData').submit();
					} else {
					}
				});

		//添加水印
		$('#txtKeywords').watermark("- - -请输入筛选条件- - -");

		//条件筛选
		$('#txtKeywords').keyup(function() {
			$("table#owenrList tr.trZebra").each(function() {
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
		if ($.trim($("#txtOwenrId").val()) == "") {
			$("#txtOwenrId+span").text("请输入业主编号！");
			$('#txtOwenrId').focus();
			return false;
		}
		if (!teg.test($("#txtOwenrId").val())) {
			$("#txtOwenrId+span").text("格式不对,请输入正整数！");
			$('#txtOwenrId').val("");
			$('#txtOwenrId').focus();
			return false;
		}
		$("#txtOwnerId+span").text(''); //清空

		if ($.trim($("#txtOwenrName").val()) == "") {
			$("#txtOwenrName+span").text("请输入业主名称！");
			$('#txtOwenrName').focus();
			return false;
		}
		$("#txtOwenrName+span").text(''); //清空

		if ($.trim($("#txtAUnit").val()) == "") {
			$("#txtAUnit+span").text("请输入所属单位！");
			$('#txtAUnit').focus();
			return false;
		}
		$("#txtAUnit+span").text(''); //清空

		if ($.trim($("#txtIdCard").val()) == "") {
			$("#txtIdCard+span").text("请输入身份证号！");
			$('#txtIdCard').focus();
			return false;
		}
		if(isNaN($.trim($("#txtIdCard").val()))){
			$("#txtIdCard+span").text("请输入数字");
			return false;
			}
		$("#txtIdCard+span").text(''); //清空

		if ($.trim($("#txtPhone").val()) == "") {
			$("#txtPhone+span").text("请输入电话！");
			$('#txtPhone').focus();
			return false;
		}
		$("#txtPhone+span").text(''); //清空

          
		if ($.trim($("#txtMobilePhone").val()) == "") {
			$("#txtMobilePhone+span").text("请输入手机号码！");
			$('#txtMobilePhone').focus();
			return false;
		}
		if(isNaN($.trim($("#txtMobilePhone").val()))){
			$("#txtMobilePhone+span").text("格式不正确");
			return false;
			}
		  $("#txtMobilePhone+span").text(''); //清空
		
		if ($.trim($("#txtEmail").val()) == "") {
			$("#txtEmail+span").text("请输入邮箱！");
			$('#txtEmail').focus();
			return false;
		}
		$("#txtEmail+span").text(''); //清空
		
        if ($.trim($("#txtBuyDate").val()) == "") {
			$("#txtBuyDate+span").text("请输入买房时间！");
			$('#txtBuyDate').focus();
			return false;
		}
		$("#txtBuyDate+span").text(''); //清空
	}

	//清空添加或编辑信息框
	function clearDeptForm() {
		$('#txtOwenrId').val("");
		$('#txtOwenrName').val("");
		$('#txtAUnit').val("");
		$('#txtIdCard').val("");
		$('#txtPhone').val("");
		$('#txtMobilePhone').val("");
		$('#txtEmail').val("");

		$("#txtOwenrId+span").text("");
		$("#txtOwenrName+span").text("");
		$("#txtAUnit+span").text("");
		$("#txtIdCard+span").text("");
		$("#txtPhone+span").text("");
		$("#txtMobilePhone+span").text("");
		$("#txtEmail+span").text("");
		$('#message').text("");
		
	}
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
</script>
</head>
<body>
	<!-- 导航栏开始 -->
	<div class="place">
		<span>位置：</span>
		<ul class="placeul">
			<li><a href="index.jsp">首页</a></li>
			<li><a href="admin/owenrList">业主项目管理</a></li>
			<li>基本内容</li>
		</ul>
	</div>
	<!-- 导航栏结束 -->

	<!-- 信息添加开始 -->
	<div id="owenrInfo" class="hidden" hidden>
		<form method="post" id="owenrAddForm">
			&nbsp;业主编号：<input type="text" id="txtOwenrId" name="model.owenrId" />
			<span class='validate'></span> <br /> <br /> &nbsp;业主姓名：<input
				type="text" id="txtOwenrName" name="model.owenrName" /> <span
				class='validate'></span> <br /> <br />
			&nbsp;性&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;别：&nbsp;&nbsp;&nbsp; 男<input
				type="radio" id="txtMan" name="model.sex" value="男">&nbsp;&nbsp;
			&nbsp;&nbsp;女<input type="radio" id="txtWomen" name="model.sex"
				value="女" checked="checked"><span class='validate'></span> <br />


			&nbsp;所属单位：<input type="text" id="txtAUnit" name="model.aUnit" /> <span
				class='validate'></span> <br /> <br /> &nbsp;身份证号：<input
				type="text" id="txtIdCard" name="model.idCard" /> <span
				class='validate'></span> <br /> <br /> &nbsp;电话号码：<input type="text"
				id="txtPhone" name="model.phone" /> <span class='validate'></span>
			<br /> <br /> &nbsp;手机号码：<input type="text" id="txtMobilePhone"
				name="model.mobilePhone" /> <span class='validate'></span> <br />
			<br />&nbsp;电子邮箱：<input type="text" id="txtEmail"
				name="model.email" /> <span class='validate'></span> <br />
			<br />&nbsp;买房时间：<input onclick="return  WdatePicker({'dateFmt':'yyyy-MM-dd'})"
							name="model.buyDate" type="text" id="txtBuyDate"
							class="input date" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})"
				datatype="/^\s*$|^\d{4}\-\d{1,2}\-\d{1,2}\s{1}(\d{1,2}:){2}\d{1,2}$/"
				/> &nbsp;
			<!-- <input  type="text"  id="txtBuyDate"  name="model.buyDate" /> -->
			<span class='validate'></span>
			<br/><br/>
			 <span id="message" class='validate'></span>
		</form>
	</div>
	<!-- 信息添加结束-->

	<!-- form表单开始 -->
	<form id="formData" action="admin/owenrList" method="post"
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
			<table id="owenrList" class="tablelist" style="text-align: center;">
				<thead>
					<tr>
						<th><input name="" type="checkbox" class="selectall" /></th>
						<th>序号</th>
						<th>业主编号</th>
						<th>业主姓名</th>
						<th>性别</th>
						<th>所属单位</th>
						<th>身份证号</th>
						<th>电话</th>
						<th>手机</th>
						<th>邮箱</th>
						<th>购买时间</th>
						<th>操作</th>
					</tr>
				</thead>
				<tbody>
					<s:iterator var="item" value="owenrList" status="stat">
						<tr class="trZebra">
							<td><input name="delOwenr" type="checkbox"
								value="${item.owenrId }" class="ckbOwenr" /></td>
							<td><s:property value="#stat.index+1" /></td>
							<td><s:property value="#item.owenrId" /></td>
							<td><s:property value="#item.owenrName" /></td>
							<td><s:property value="#item.sex" /></td>
							<td><s:property value="#item.aUnit" /></td>
							<td><s:property value="#item.idCard" /></td>
							<td><s:property value="#item.phone" /></td>
							<td><s:property value="#item.mobilePhone" /></td>
							<td><s:property value="#item.email" /></td>
							<td><s:date name="buyDate" format="yyyy-MM-dd" /></td>
							<td><span class="spanEdit blue-pointer" data-custom='${ item.owenrId }'><img
									src="images/application_edit.png" title="修改" /> </span>&nbsp;&nbsp; <a
								onclick="return confirm('确定删除该条信息？');"
								href="admin/owenrList!delInfo?id=<s:property value="#item.owenrId" />"><img
									src="images/application_delete.png" title="删除" /> </a></td>
						</tr>
					</s:iterator>
				</tbody>
			</table>
			<!-- table表格数据结束 -->
		</div>
		<s:set var="actionName" value="'admin/owenrList'"></s:set>
		<s:include value="../inc/pager.jsp"></s:include>
	</form>
	<!-- form表单结束 -->
	<script type="text/javascript">
		$('.tablelist tbody tr:odd').addClass('odd');
	</script>

</body>
<s:include value="../inc/tips.jsp"></s:include>
</html>
