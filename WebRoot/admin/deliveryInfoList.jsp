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
			$('#txtDeliveryId').focus();
			$('#deliveryInfo').dialog({			//------弹出模态框开始------
				title:"添加信息",
				resizable: false,
				width:450,
				height:410,
				modal: true,
				buttons: {			//------按钮事件开始------
					"保存": function() {
						if(submitCheck()==false){
							return;
						}else{
							$.post(
								'admin/deliveryInfoList!exists',//Ajax请求目标地址
								{ 
									'id':$('#txtDeliveryId').val()     //JSON参数
								},
								function(response){
								  	if(Number(response)>0){			 //已存在  		
								  		$('#txtDeliveryId+span').text("该快递编号已存在！");
								  		$('#txtDeliveryId').focus();
								  	}
								  	else{    //如果不存在
								  		$("#addForm").attr("action","admin/deliveryInfoList!deliveryInfoAdd");   //设置form的action属性
								  		$("#addForm").submit();   //提交form
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
		$('table#deliveryInfoList span.spanEdit').click(function(){
			$.getJSON(			//加载数据-----start----------
					"admin/deliveryInfoList!getDeliveryInfo",
					{
						"id":$(this).attr("data-custom")
					},
					function(json){     //加载数据 回调函数-----start----------
						$('#txtDeliveryId').val(json.deliveryId);  //加载初始值
						$('#selDFname').val(json.deliveryfirmModel.deliveryfirmId);  //加载初始值
						$('#txtDelivery').val(json.delivery);  //加载初始值
						$('#txtDeliveryPhone').val(json.deliveryPhone);  //加载初始值
						$('#txtRecipient').val(json.recipient);  //加载初始值
						$('#txtRecipientPhone').val(json.recipientPhone);  //加载初始值
						$('#txtAddress').val(json.address);  //加载初始值
						$('#selExtent').val(json.extent);  //加载初始值
						$('#txtDeliveryId').attr("readonly",true);   //费用编号文本框不可用
						$('div#deliveryInfo').dialog({        //弹出编辑框-----start----------				
							title:"修改信息",
							resizable: false,
							width:450,
							height:410,
							modal: true,
							buttons: {
								"更新": function() {
									if(submitCheck()==false){  //客户端验证未通过
										return;
									}
									$("#addForm").attr("action","admin/deliveryInfoList!deliveryInfoEdit");   //设置form的action属性
									$("#addForm").submit();   //提交form
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
			$(".ckbDeliveryInfo:checkbox").attr("checked",$(".selectall:checkbox").attr("checked"));
		});
		
		//删除所选
		$('#delSelect').click(function() {
			if ($(":checkbox.ckbDeliveryInfo:checked").size() == 0) {
				alert("请选择所需删除选项！");
				return false;
			}
			if (confirm("确定删除所选？")) {
				$('#formData').attr("action",
						"admin/deliveryInfoList!delDeliveryInfos");
				$('#formData').submit();
			} else {
			}
		});
		
		//添加水印
		$('#txtKeywords').watermark("- - -请输入筛选条件- - -");
		
		//条件筛选
		$('#txtKeywords').keyup(function() {
			$("table#deliveryInfoList tr.trZebra").each(function() {
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
		if ($.trim($("#txtDeliveryId").val()) == "") {
			$("#txtDeliveryId+span").text("请输入快递编号！");
			$('#txtDeliveryId').focus();
			return false;
		}
		if (!teg.test($("#txtDeliveryId").val())) {
			$("#txtDeliveryId+span").text("格式不对,请输入正整数！");
			$('#txtDeliveryId').val("");
			$('#txtDeliveryId').focus();
			return false;
		}
		$("#txtDeliveryId+span").text(''); //清空

		if ($('#selDFname').val() == "-1") {
			$("#selDFname+span").text("请选择快递公司！");
			return false;
		}
		$("#selDFname+span").text(''); //清空
		
		if ($.trim($("#txtDelivery").val()) == "") {
			$("#txtDelivery+span").text("请输入送件人姓名！");
			$('#txtDelivery').focus();
			return false;
		}
		$("#txtDelivery+span").text(''); //清空
		
		
		if ($.trim($("#txtRecipient").val()) == "") {
			$("#txtRecipient+span").text("请输入收件人姓名！");
			$('#txtRecipient').focus();
			return false;
		}
		$("#txtRecipient+span").text(''); //清空
		
		var teg = /^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9])\d{8}$/;
		if ($.trim($("#txtDeliveryPhone").val()) == "") {
			$("#txtDeliveryPhone+span").text("请输入送件人手机号码！");
			$('#txtDeliveryPhone').focus();
			return false;
		}
		
		if (!teg.test($("#txtDeliveryPhone").val())) {
			$("#txtDeliveryPhone+span").text("格式不对,请输入手机号码！");
			$('#txtDeliveryPhone').val("");
			$('#txtDeliveryPhone').focus();
			return false;
		}
		$("#txtDeliveryPhone+span").text(''); //清空
		
		if ($.trim($("#txtRecipientPhone").val()) == "") {
			$("#txtRecipientPhone+span").text("请输入收件人手机号码！");
			$('#txtRecipientPhone').focus();
			return false;
		}
		
		if (!teg.test($("#txtRecipientPhone").val())) {
			$("#txtRecipientPhone+span").text("格式不对,请输入手机号码！");
			$('#txtRecipientPhone').val("");
			$('#txtRecipientPhone').focus();
			return false;
		}
		$("#txtRecipientPhone+span").text(''); //清空
		
		if ($('#selExtent').val() == "-1") {
			$("#selExtent+span").text("请选择是否收取！");
			return false;
		}
		$("#selExtent+span").text(''); //清空
		
		if ($.trim($("#txtAddress").val()) == "") {
			$("#txtAddress+span").text("请输入收件人地址！");
			$('#txtAddress').focus();
			return false;
		}
		$("#txtAddress+span").text(''); //清空
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
<style type="text/css">
#shouqu{
	color: #3EAFE0;
}
#shouqu:HOVER{
	text-decoration: underline;
}
.fou{
	color: red;
}
#txtAddress{
	width: 300px;
	height: 50px;
}
.addRess{
	float: left;
}
</style>
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
	<div id="deliveryInfo" class="hidden">
	 	<form method="post" id="addForm">
			&nbsp;快递编号：&nbsp;&nbsp;&nbsp;<input  type="text"  id="txtDeliveryId"  name="model.deliveryId" />
			<span class='validate'></span>
			<br/><br/>
			&nbsp;快递公司：&nbsp;&nbsp;&nbsp;<select id="selDFname" name="model.deliveryfirmModel.deliveryfirmId">
								<option value="-1">-- 请选择类型 --</option>
									<s:iterator var="item" value="deliveryFirmList">
										<option value="${ item.deliveryfirmId}">${item.deliveryfirmName}</option>
									</s:iterator>
						   </select> 
			<span class='validate'></span> 
			<br /> <br />
			&nbsp;送件人姓名：<input  type="text"  id="txtDelivery" name="model.delivery" />
			<span class='validate'></span>
			<br/><br/>
			&nbsp;收件人姓名：<input  type="text"  id="txtRecipient"  name="model.recipient" />
			<span class='validate'></span>
			<br/><br/>
			&nbsp;送件人手机号码：<input  type="text"  id="txtDeliveryPhone"  name="model.deliveryPhone" />
			<span class='validate'></span>
			<br/><br/>
			&nbsp;收件人手机号码：<input  type="text"  id="txtRecipientPhone"  name="model.recipientPhone" />
			<span class='validate'></span>
			<br/><br/>
			&nbsp;是否收取：&nbsp;&nbsp;&nbsp;<select id="selExtent" name="model.extent">
								<option value="-1">-- 请选择 --</option>
								<option value="0">否</option>
								<option value="1">是</option>
						   </select> 
			<span class='validate'></span> 
			<br /> <br />
			&nbsp;<div class="addRess">收件人地址：</div><textarea id="txtAddress"  name="model.address"></textarea>
			<span class='validate'></span>
			<br/><br/>
			<span id="message" class='validate'></span>
		</form>
	</div>
	<!-- 信息添加结束-->
	
	<!-- form表单开始 -->
	<form id="formData" action="admin/deliveryInfoList" method="post"
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
			<table id="deliveryInfoList" class="tablelist" style="text-align: center;">
				<thead>
					<tr>
						<th><input name="" type="checkbox" class="selectall" /></th>
						<th>序号</th>
						<th>快递编号</th>
						<th>快递公司</th>
						<th>送件人</th>
						<th>送件人手机号码</th>
						<th>收件人</th>
						<th>收件人手机号码</th>
						<th>收件人地址</th>
						<th>是否收取</th>
						<th>收取</th>
						<th>操作</th>
					</tr>
				</thead>
				<tbody>
					<s:iterator var="item" value="deliveryInfoList" status="stat">
						<tr class="trZebra">
							<td><input name="delDeliveryInfos" type="checkbox" value="${item.deliveryId }" class="ckbDeliveryInfo" /></td>
							<td><s:property value="#stat.index+1" /></td>
							<td><s:property value="#item.deliveryId" /></td>
							<td><s:property value="#item.deliveryfirmModel.deliveryfirmName" /></td>
							<td><s:property value="#item.delivery" /></td>
							<td><s:property value="#item.deliveryPhone" /></td>
							<td><s:property value="#item.recipient" /></td>
							<td><s:property value="#item.recipientPhone" /></td>
							<td><s:property value="#item.address" /></td>
							<s:if test="#item.extent == 0">
								<td class="fou">否</td>
								<td><a onclick="return confirm('确定收取该快递？');" id="shouqu"
									href="admin/deliveryInfoList!collect?id=<s:property value="#item.deliveryId" />">收取</a></td>
							</s:if>
							<s:else>
								<td>是</td>
								<td>已收取</td>
							</s:else>
							<td><span class="spanEdit blue-pointer" data-custom='${ item.deliveryId }'><img
									src="images/application_edit.png" title="修改" />
								</span>&nbsp;&nbsp;
								<a onclick="return confirm('确定删除该条信息？');"
								href="admin/deliveryInfoList!delInfo?id=<s:property value="#item.deliveryId" />"><img
									src="images/application_delete.png" title="删除" />
								</a>
							</td>
						</tr>
					</s:iterator>
				</tbody>
			</table>
			<!-- table表格数据结束 -->
		</div>
		<s:set var="actionName" value="'admin/deliveryInfoList'"></s:set>
		<s:include value="../inc/pager.jsp"></s:include>
	</form>
	<!-- form表单结束 -->
<script type="text/javascript">
	$('.tablelist tbody tr:odd').addClass('odd');
</script>
 	
</body>
<s:include value="../inc/tips.jsp"></s:include>
</html>
