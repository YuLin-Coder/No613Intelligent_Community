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
			$('#txtRoomId').focus();
			$('#txtRoomId').attr("disabled",false);
			$('#roomInfo').dialog({			//------弹出模态框开始------
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
								'admin/roomList!existed',//Ajax请求目标地址
								{ 
									'id':$('#txtRoomId').val()     //JSON参数
								},
								function(response){
								  	if(Number(response)>0){			 //已存在  		
								  		$('#txtRoomId+span').text("该费用编号已存在！");
								  		$('#txtRoomId').focus();
								  	}
								  	else{    //如果不存在
								  		$("#roomAddForm").attr("action","admin/roomList!add");   //设置form的action属性
								  		$("#roomAddForm").submit();   //提交form
								  	}
							  	}
							);//post结束
						}//else结束
					},
					"取消": function() {
						clearRoomForm();//清空
						$( this ).dialog( "close" );
					}
				}//------按钮结束开始------
			});//------弹出模态框结束------
		});//------添加按钮结束------
		
		//编辑信息
		$('table#roomList span.spanEdit').click(function(){
			$.getJSON(			//加载数据-----start----------
					"admin/roomList!getRoomModel",
					{
						"id":$(this).attr("data-custom")
					},
					function(json){     //加载数据 回调函数-----start----------
						$('#txtRoomId').val(json.roomId);  //加载初始值
						$('#txtRoomName').val(json.roomName);  //加载初始值
						$('#selBuildingName').val(json.buildingModel.buildingId);  //加载初始值
						$('#txtUnitNum').val(json.unitNum);  //加载初始值
						$('#txtHouseType').val(json.houseType);  //加载初始值
						$('#txtBuildArea').val(json.buildArea);  //加载初始值
						$('#txtUsingArea').val(json.usingArea);  //加载初始值
						if(json.face=="东"){
							$('#dong').attr("checked",true);
						}else if(json.face=="南"){
							$('#nan').attr("checked",true);
						}else if(json.face=="西"){
							$('#xi').attr("checked",true);
						}else{
							$('#bei').attr("checked",true);
						}//加载初始值
						if(json.lease=="租凭"){
							$('#is').attr("checked",true);
						}else{
							$('#no').attr("checked",true);
						}//加载初始值
						$('#txtRoomId').attr("readonly",true);   //费用编号文本框不可用
						$('div#roomInfo').dialog({        //弹出编辑框-----start----------				
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
									$("#roomAddForm").attr("action","admin/roomList!edit");   //设置form的action属性
									$("#roomAddForm").submit();   //提交form
								},
								"取消": function() {
									clearRoomForm();  //清空
									$( this ).dialog( "close" );
								}
							}
						});			//弹出编辑框-----end----------	
					}			//加载数据 回调函数-----end----------
				);			//加载数据-----end----------	
		});
		
		//全选
		$(".selectall:checkbox").click(function() {
			$(".ckbRoom:checkbox").attr("checked",$(".selectall:checkbox").attr("checked"));
		});
		
		//删除所选
		$('#delSelect').click(function() {
			if (confirm("确定删除所选？")) {
				$('#formData').attr("action",
						"admin/roomList!deleteRoomLists");
				$('#formData').submit();
			} else {
			}
		});
		
		//添加水印
		$('#txtKeywords').watermark("- - -请输入筛选条件- - -");
		
		//条件筛选
		$('#txtKeywords').keyup(function() {
			$("table#roomList tr.trZebra").each(function() {
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
	function clearRoomForm() {
		$('#txtRoomId').val('');
		$('#txtRoomName').val('');
		$('#txtUnitNum').val('');
		$('#txtHouseType').val('');
		$('#txtBuildArea').val('');
		$('#txtUsingArea').val('');
		$("#txtRoomId+span").text('');
		$("#txtRoomName+span").text('');
		$("#txtUnitNum+span").text('');
		$("#txtHouseType+span").text('');
		$("#txtBuildArea+span").text('');
		$("#txtUsingArea+span").text('');
		$('#message').text('');
	}

	//添加或编辑系部信息时的客户端检查
	function submitCheck() {
		if ($.trim($("#txtRoomId").val()) == "") {
			$("#txtRoomId+span").text("请输入房间编号！");
			return false;
		}
		var i = /^[0-9]*[1-9][0-9]*$/;
		if (!$.trim($("#txtRoomId").val()).match(i)) {
			$("#txtRoomId+span").text("编号必须是正整数！");
			$('#txtRoomId').focus();
			return false;
		}
		$("#txtRoomId+span").text(''); //清空

		if ($.trim($("#txtRoomName").val()) == "") {
			$("#txtRoomName+span").text("请输入房间名称！");
			return false;
		}
		$("#txtRoomName+span").text(''); //清空
		
		if ($.trim($("#selBuildingName").val()) == "-1") {
			$("#selBuildingName+span").text("请输入房间名称！");
			return false;
		}
		$("#txtRoomName+span").text(''); //清空

		if ($.trim($("#txtUnitNum").val()) == "") {
			$("#txtUnitNum+span").text("请输入单元号！");
			return false;
		}
		$("#txtUnitNum+span").text(''); //清空
		
		if ($.trim($("#txtHouseType").val()) == "") {
			$("#txtHouseType+span").text("请输入户型！");
			return false;
		}
		$("#txtHouseType+span").text(''); //清空
		
		if ($.trim($("#txtBuildArea").val()) == "") {
			$("#txtBuildArea+span").text("请输入建筑面积！");
			return false;
		}
		$("#txtBuildArea+span").text(''); //清空
		
		if ($.trim($("#txtUsingArea").val()) == "") {
			$("#txtUsingArea+span").text("请输入使用面积！");
			return false;
		}
		$("#txtUsingArea+span").text(''); //清空

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
			<li><a href="admin/roomList">房间管理</a></li>
			<li>基本内容</li>
		</ul>
	</div>
	<!-- 导航栏结束 -->
	
	<!-- 信息添加开始 -->
	<div id="roomInfo" class="hidden">
	 	<form method="post" id="roomAddForm">
			&nbsp;房间编号：<input  type="text"  id="txtRoomId"  name="model.roomId" title="请输入房间编号。"/>
			<span class='validate'></span>
			<br/><br/>
			&nbsp;房间名称：<input  type="text"  id="txtRoomName" name="model.roomName" title="请输入房间名称。"/>
			<span class='validate'></span>
			<br/><br/>
			&nbsp;楼房名称：<select id="selBuildingName" name="model.buildingModel.buildingId">
								<option value="-1">----- 请选择楼房 -----</option>
									<s:iterator var="item" value="buildingList">
										<option value="${ item.buildingId}">${item.buildingName}</option>
									</s:iterator>
						   </select> 
			<br/><br/>
			&nbsp;单元号：&nbsp;&nbsp;&nbsp;<input  type="text"  id="txtUnitNum"  name="model.unitNum" title="请输入单元号。"/>
			<span class='validate'></span>
			<br/><br/>
			&nbsp;户型：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input  type="text"  id="txtHouseType"  name="model.houseType" title="请输入房间户型。"/>
			<span class='validate'></span>
			<br/><br/>
			&nbsp;建筑面积：<input  type="text"  id="txtBuildArea"  name="model.buildArea" title="请输入建筑面积。"/>
			<span class='validate'></span>
			<br/><br/>
			&nbsp;使用面积：<input  type="text"  id="txtUsingArea"  name="model.usingArea" title="请输入使用面积。"/>
			<span class='validate'></span>
			<br/><br/>
			&nbsp;朝向：&nbsp;&nbsp;<input id="dong" name="model.face" type="radio" checked="checked" value="东" >东
								  <input id="nan" name="model.face" type="radio" value="南" >南
								  <input id="xi" name="model.face" type="radio" value="西" >西
								  <input id="bei" name="model.face" type="radio" value="北" >北
			<span class='validate'></span>
			<br/><br/>
			&nbsp;是否租凭：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input id="is" name="model.lease" type="radio" checked="checked" value="租凭" >租凭
					    <input id="no" name="model.lease" type="radio" value="非租凭" >非租凭 
			<span class='validate'></span>
			<br /> <br />
			<span id="message" class='validate'></span>
		</form>
	</div>
	<!-- 信息添加结束-->
	
	<!-- form表单开始 -->
	<form id="formData" action="admin/roomList" method="post" onsubmit="return check();">
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
			<table id="roomList" class="tablelist" style="text-align: center;">
				<thead>
					<tr>
						<th><input name="" type="checkbox" value="" class="selectall" /></th>
						<th>序号</th>
						<th>房间编号</th>
						<th>房间名称</th>
						<th>楼房名称</th>
						<th>单元号</th>
						<th>户型</th>
						<th>建筑面积</th>
						<th>使用面积</th>
						<th>朝向</th>
						<th>是否租凭</th>
						<th>操作</th>
					</tr>
				</thead>
				<tbody>
					<s:iterator var="item" value="roomList" status="stat">
						<tr class="trZebra">
							<td><input name="delRoom" type="checkbox" value="${item.roomId }" class="ckbRoom"/></td>
							<td><s:property value="#stat.index+1" /></td>
							<td><s:property value="#item.roomId" /></td>
							<td><s:property value="#item.roomName" /></td>
							<td><s:property value="#item.buildingModel.buildingName" /></td>
							<td><s:property value="#item.unitNum" /></td>
							<td><s:property value="#item.houseType" /></td>
							<td><s:property value="#item.buildArea" /></td>
							<td><s:property value="#item.usingArea" /></td>
							<td><s:property value="#item.face" /></td>
							<td><s:property value="#item.lease" /></td>
							<td><span class="spanEdit blue-pointer" data-custom='${ item.roomId }'><img
									src="images/application_edit.png" title="修改" />
								</span>&nbsp;&nbsp;
								<a onclick="return confirm('确定删除该条信息？');"
								href="admin/roomList!delInfo?id=<s:property value="#item.roomId" />"><img
									src="images/application_delete.png" title="删除" /></a></td>
						</tr>
					</s:iterator>
				</tbody>
			</table>
			<!-- table表格数据结束 -->
			<s:set var="actionName" value="'admin/roomList'"></s:set>
			<s:include value="../inc/pager.jsp"></s:include>
		</div>
	</form>
	<script type="text/javascript">
		$('.tablelist tbody tr:odd').addClass('odd');
	</script>
</body>
<s:include value="../inc/tips.jsp"></s:include>
</html>
