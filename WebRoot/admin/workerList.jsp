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

		//  点击系部添加图片按钮-----start----------
		$('#addInfo')
				.click(
						function() {
							$('#txtWorkerId').attr("disabled", false);//启用系部编号文本框
							$('div#workerInfo')
									.dialog(
											{ // 显示添加系部模态框  -----start----------			
												title : "添加工作人员",
												resizable : false,
												width : 440,
												height : 355,
												modal : true,
												buttons : {
													"确定" : function() {
														if (submitCheck() == false) {//客户端验证未通过
															return;
														}
														$
																.post(
																		'admin/workerList!existed', //Ajax请求目标地址
																		{
																			'id' : $(
																					'#txtWorkerId')
																					.val()
																		//JSON参数
																		},
																		function(
																				response) {
																			if (Number(response) > 0) { //已存在  		
																				$(
																						'#message')
																						.text(
																								"该编号已存在，不能重复添加！");
																			} else { //如果不存在
																				$(
																						"#workerForm")
																						.attr(
																								"action",
																								"admin/workerList!add"); //设置form的action属性
																				$(
																						"#workerForm")
																						.submit(); //提交form
																			}
																		});

													},
													"取消" : function() {
														clearWorkerForm(); //清空
														$(this).dialog("close");//关闭模态框
													}
												}
											}); //  显示添加系部模态框    -----end----------
						});//  点击系部添加图片按钮-----end----------
						
		//编辑信息
		$('table#workerList span.spanEdit').click(function(){
			$.getJSON(			//加载数据-----start----------
					"admin/workerList!getWorkerModel",
					{
						"id":$(this).attr("data-custom")
					},
					function(json){     //加载数据 回调函数-----start----------
						$('#txtWorkerId').val(json.workerId);  //加载初始值
						$('#txtWorkerName').val(json.workerName);  //加载初始值
						$('#txtWorkerType').val(json.workerType);  //加载初始值
						$('#txtWorkerId').attr("readonly",true);   //费用编号文本框不可用
						$('div#workerInfo').dialog({        //弹出编辑框-----start----------				
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
									$("#workerForm").attr("action","admin/workerList!edit");   //设置form的action属性
									$("#workerForm").submit();   //提交form
								},
								"取消": function() {
									clearWorkerForm();  //清空
									$( this ).dialog( "close" );
								}
							}
						});			//弹出编辑框-----end----------	
					}			//加载数据 回调函数-----end----------
				);			//加载数据-----end----------	
		});
		
		//全选
		$(".selectall:checkbox").click(function() {
			$(".ckbWorker:checkbox").attr("checked",$(".selectall:checkbox").attr("checked"));
		});
		
		//删除所选
		$('#delSelect').click(function() {
			if (confirm("确定删除所选？")) {
				$('#formData').attr("action",
						"admin/workerList!deleteWorkerLists");
				$('#formData').submit();
			} else {
			}
		});

		//添加水印
		$('#txtKeywords').watermark("- - -请输入筛选条件- - -");
		//条件筛选
		$('#txtKeywords').keyup(function() {
			$("table#workerList tr.trZebra").each(function() {
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

	//清空添加或编辑信息框
	function clearWorkerForm() {
		$('#txtWorkerId').val('');
		$('#txtWorkerName').val('');
		$('#txtWorkerType').val('');
		$("#txtWorkerId+span").text('');
		$("#txtWorkerName+span").text('');
		$("#txtWorkerType+span").text('');
		$('#message').text('');
	}

	//添加或编辑系部信息时的客户端检查
	function submitCheck() {
		if ($.trim($("#txtWorkerId").val()) == "") {
			$("#txtWorkerId+span").text("请输入工作人员编号！");
			return false;
		}
		var i = /^[0-9]*[1-9][0-9]*$/;
		if (!$.trim($("#txtWorkerId").val()).match(i)) {
			$("#txtWorkerId+span").text("编号必须是正整数！");
			$('#txtWorkerId').focus();
			return false;
		}
		$("#txtWorkerId+span").text(''); //清空

		if ($.trim($("#txtWorkerName").val()) == "") {
			$("#txtWorkerName+span").text("请输入工作人员姓名！");
			return false;
		}
		$("#txtWorkerName+span").text(''); //清空

		if ($.trim($("#txtWorkerType").val()) == "") {
			$("#txtWorkerType+span").text("请输入工作类别！");
			return false;
		}
		$("#txtWorkerType+span").text(''); //清空

		return true;
	}
</script>
</head>

<body>
	<!-- 导航栏开始 -->
	<div class="place">
		<span>位置：</span>
		<ul class="placeul">
			<li><a href="index.jsp">首页</a></li>
			<li><a href="admin/costList">工作人员管理</a></li>
			<li>基本内容</li>
		</ul>
	</div>
	<!-- 导航栏结束 -->
	<!-- 信息添加开始 -->
	<div id="workerInfo" style="display: none;">
		<form id="workerForm" action="admin/workerList" method="post">
			&nbsp;工作人员编号：<input type="text" id="txtWorkerId"
				name="model.workerId" title="请输入工作人员编号。" /> <span class='validate'></span>
			<br /> <br /> &nbsp;工作人员姓名：<input type="text" id="txtWorkerName"
				name="model.workerName" title="请输入工作人员姓名。" /> <span
				class='validate'></span> <br /> <br /> &nbsp;工作类别：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input
				type="text" id="txtWorkerType" name="model.workerType"
				title="请输入工作类别。" /> <span class='validate'></span> <br /> <br />
			<span id="message" class='validate'></span>
		</form>
	</div>

	<!-- 信息添加结束-->
	<!-- form表单开始 -->
	<form id="formData" action="admin/workerList" method="post"
		onsubmit="return check()">
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
			<table id="workerList" class="tablelist" style="text-align: center;">
				<thead>
					<tr>
						<th><input name="" type="checkbox" class="selectall" /></th>
						<th>序号</th>
						<th>工作人员编号</th>
						<th>工作人员姓名</th>
						<th>工作类别</th>
						<th>操作</th>
					</tr>
				</thead>
				<tbody>
					<s:iterator var="item" value="workerList" status="stat" >
						<tr class="trZebra">
							<td><input name="delWorker" type="checkbox" value="${item.workerId }" class="ckbWorker"/></td>
							<td><s:property value="#stat.index+1" /></td>
							<td><s:property value="#item.workerId" /></td>
							<td><s:property value="#item.workerName" /></td>
							<td><s:property value="#item.workerType" /></td>
							<td><span class="spanEdit blue-pointer" data-custom='${ item.workerId }'><img
									src="images/application_edit.png" title="修改" />
								</span>&nbsp;&nbsp;
								<a onclick="return confirm('确定删除该条信息？');"
								href="admin/workerList!delInfo?id=<s:property value="#item.workerId" />"><img
									src="images/application_delete.png" title="删除" /></a></td>
						</tr>
					</s:iterator>
				</tbody>
			</table>
			<!-- table表格数据结束 -->
			<s:set var="actionName" value="'admin/workerList'"></s:set>
			<s:include value="../inc/pager.jsp"></s:include>
		</div>
	</form>
	<!-- form表单结束 -->
	<script type="text/javascript">
		$('.tablelist tbody tr:odd').addClass('odd');
	</script>
</body>
<s:include value="../inc/tips.jsp"></s:include>
</html>
