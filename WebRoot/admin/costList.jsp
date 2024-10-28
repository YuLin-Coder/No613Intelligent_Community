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

<script type="text/javascript" src="js/jquery-1.4.2.min.js"></script>
<script type="text/javascript" src="js/jquery.watermark.min.js"></script>
<script type="text/javascript" src="js/jquery-ui-1.8.12.custom.min.js"></script>	<!-- 模态框插件 -->
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
		$('#addInfo').click(function(){			//------添加按钮开始------
			$('#txtCostId').focus();
			$('#txtCostId').attr("disabled",false);
			$('#costInfo').dialog({			//------弹出模态框开始------
				title:"添加信息",
				resizable: false,
				width:420,
				height:350,
				modal: true,
				buttons: {			//------按钮事件开始------
					"保存": function() {
						if(submitCheck()==false){
							return;
						}else{
							$.post(
								'admin/costList!exists',//Ajax请求目标地址
								{ 
									'id':$('#txtCostId').val()     //JSON参数
								},
								function(response){
								  	if(Number(response)>0){			 //已存在  		
								  		$('#txtCostId+span').text("该费用编号已存在！");
								  		$('#txtCostId').focus();
								  	}
								  	else{    //如果不存在
								  		$("#costAddForm").attr("action","admin/costList!costAdd");   //设置form的action属性
								  		$("#costAddForm").submit();   //提交form
								  	}
							  	}
							);//post结束
						}//else结束
					},
					"取消": function() {
						clearDeptForm();//清空
						$( this ).dialog( "close" );
					}
				}//------按钮结束开始------
			});//------弹出模态框结束------
		});//------添加按钮结束------
		
		//编辑信息
		$('table#costList span.spanEdit').click(function(){
			$.getJSON(			//加载数据-----start----------
					"admin/costList!getCostModel",
					{
						"id":$(this).attr("data-custom")
					},
					function(json){     //加载数据 回调函数-----start----------
						$('#txtCostId').val(json.costId);  //加载初始值
						$('#txtCostName').val(json.costName);  //加载初始值
						$('#txtUnitPrice').val(json.unitPrice);  //加载初始值
						$('#txtRemarks').val(json.remarks);  //加载初始值
						$('#txtMunit').val(json.munit);  //加载初始值
						$('#selCtName').val(json.costTypeModel.ctId);  //加载初始值
						$('#txtCostId').attr("readonly",true);   //费用编号文本框不可用
						$('div#costInfo').dialog({        //弹出编辑框-----start----------				
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
									$("#costAddForm").attr("action","admin/costList!costEdit");   //设置form的action属性
									$("#costAddForm").submit();   //提交form
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
		$(".selectall:checkbox").click(function() {
			$(".ckbCost:checkbox").attr("checked",$(".selectall:checkbox").attr("checked"));
		});
		
		//删除所选
		$('#delSelect').click(function() {
			if ($(":checkbox.ckbCost:checked").size() == 0) {
				alert("请选择所需删除选项！");
				return false;
			}
			if (confirm("确定删除所选？")) {
				$('#formData').attr("action",
						"admin/costList!deleteCostLists");
				$('#formData').submit();
			} else {
			}
		});
		
		//添加水印
		$('#txtKeywords').watermark("- - -请输入筛选条件- - -");
		
		//条件筛选
		$('#txtKeywords').keyup(function() {
			$("table#costList tr.trZebra").each(function() {
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
		if ($.trim($("#txtCostId").val()) == "") {
			$("#txtCostId+span").text("请输入费用编号！");
			$('#txtCostId').focus();
			return false;
		}
		if (!teg.test($("#txtCostId").val())) {
			$("#txtCostId+span").text("格式不对,请输入正整数！");
			$('#txtCostId').val("");
			$('#txtCostId').focus();
			return false;
		}
		$("#txtCostId+span").text(''); //清空

		if ($.trim($("#txtCostName").val()) == "") {
			$("#txtCostName+span").text("请输入费用名称！");
			$('#txtCostName').focus();
			return false;
		}
		$("#txtCostName+span").text(''); //清空
		
		var teg = /^\d+(\.\d+)?$/;	//测试非负数
		if ($.trim($("#txtUnitPrice").val()) == "") {
			$("#txtUnitPrice+span").text("请输入费用单价！");
			$('#txtUnitPrice').focus();
			return false;
		}
		
		if (!teg.test($("#txtUnitPrice").val())) {
			$("#txtUnitPrice+span").text("格式不对,请输入非负数！");
			$('#txtUnitPrice').val("");
			$('#txtUnitPrice').focus();
			return false;
		}
		$("#txtUnitPrice+span").text(''); //清空
		
		if ($.trim($("#txtRemarks").val()) == "") {
			$("#txtRemarks+span").text("请输入费用说明！");
			$('#txtRemarks').focus();
			return false;
		}
		$("#txtRemarks+span").text(''); //清空
		
		if ($.trim($("#txtMunit").val()) == "") {
			$("#txtMunit+span").text("请输入计价单位！");
			$('#txtMunit').focus();
			return false;
		}
		$("#txtMunit+span").text(''); //清空
		
		if ($('#selCtName').val() == "-1") {
			$("#selCtName+span").text("请选择所属类型！");
			return false;
		}
		$("#selCtName+span").text(''); //清空
		return true;
	}
	
	//清空添加或编辑信息框
	function clearDeptForm() {
		$('#txtCostId').val("");
		$('#txtCostName').val("");
		$('#txtUnitPrice').val("");
		$('#txtRemarks').val("");
		$('#txtMunit').val("");
		
		$("#txtCostId+span").text("");
		$("#txtCostName+span").text("");
		$("#txtUnitPrice+span").text("");
		$("#txtRemarks+span").text("");
		$("#txtMunit+span").text("");
		$("#selCtName+span").text("");
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
			<li><a href="admin/costList">费用项目管理</a></li>
			<li>基本内容</li>
		</ul>
	</div>
	<!-- 导航栏结束 -->
	
	<!-- 信息添加开始 -->
	<div id="costInfo" class="hidden">
	 	<form method="post" id="costAddForm">
			&nbsp;费用编号：<input  type="text"  id="txtCostId"  name="model.costId" />
			<span class='validate'></span>
			<br/><br/>
			&nbsp;费用名称：<input  type="text"  id="txtCostName" name="model.costName" />
			<span class='validate'></span>
			<br/><br/>
			&nbsp;费用单价：<input  type="text"  id="txtUnitPrice"  name="model.unitPrice" />
			<span class='validate'></span>
			<br/><br/>
			&nbsp;费用说明：<input  type="text"  id="txtRemarks"  name="model.remarks" />
			<span class='validate'></span>
			<br/><br/>
			&nbsp;计价单位：<input  type="text"  id="txtMunit"  name="model.munit" />
			<span class='validate'></span>
			<br/><br/>
			&nbsp;所属类型：<select id="selCtName" name="model.costTypeModel.ctId">
								<option value="-1">-- 请选择类型 --</option>
									<s:iterator var="item" value="costTypeList">
										<option value="${ item.ctId}">${item.ctName}</option>
									</s:iterator>
						   </select> 
			<span class='validate'></span> 
			<br /> <br />
			<span id="message" class='validate'></span>
		</form>
	</div>
	<!-- 信息添加结束-->
	
	<!-- form表单开始 -->
	<form id="formData" action="admin/costList" method="post"
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
						class="shezhi" type="submit" value="设置" />
					</li>
				</ul>
			</div>
			<!-- 工具栏结束 -->

			<!-- table表格数据开始 -->
			<table id="costList" class="tablelist" style="text-align: center;">
				<thead>
					<tr>
						<th><input name="" type="checkbox" class="selectall" /></th>
						<th>序号</th>
						<th>费用编号</th>
						<th>费用名称</th>
						<th>费用单价（元）</th>
						<th>计价单位</th>
						<th>费用所属类型</th>
						<th>费用说明</th>
						<th>操作</th>
					</tr>
				</thead>
				<tbody>
					<s:iterator var="item" value="costList" status="stat">
						<tr class="trZebra">
							<td><input name="delCost" type="checkbox" value="${item.costId }" class="ckbCost" /></td>
							<td><s:property value="#stat.index+1" /></td>
							<td><s:property value="#item.costId" /></td>
							<td><s:property value="#item.costName" /></td>
							<td><s:property value="#item.unitPrice" /></td>
							<td><s:property value="#item.munit" /></td>
							<td><s:property value="#item.costTypeModel.ctName" /></td>
							<td><s:property value="#item.remarks" /></td>
							<td><span class="spanEdit blue-pointer" data-custom='${ item.costId }'><img
									src="images/application_edit.png" title="修改" />
								</span>&nbsp;&nbsp;
								<a onclick="return confirm('确定删除该条信息？');"
								href="admin/costList!delInfo?id=<s:property value="#item.costId" />"><img
									src="images/application_delete.png" title="删除" />
								</a>
							</td>
						</tr>
					</s:iterator>
				</tbody>
			</table>
			<!-- table表格数据结束 -->
		</div>
		<s:set var="actionName" value="'admin/costList'"></s:set>
		<s:include value="../inc/pager.jsp"></s:include>
	</form>
	<!-- form表单结束 -->
<script type="text/javascript">
	$('.tablelist tbody tr:odd').addClass('odd');
</script>
 	
</body>
<s:include value="../inc/tips.jsp"></s:include>
</html>
