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
			$('#txtAssetId').focus();
			$('#txtAssetId').attr("disabled",false);
			$('#assetInfo').dialog({			//------弹出模态框开始------
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
								'admin/assetTypeList!exists',//Ajax请求目标地址
								{ 
									'id':$('#txtAssetTypeId').val()     //JSON参数
								},
								function(response){
								  	if(Number(response)>0){			 //已存在  		
								  		$('#txtAssetTypeId+span').text("该费用编号已存在！");
								  		$('#txtAssetTypeId').focus();
								  	}
								  	else{    //如果不存在
								  		$("#assetAddForm").attr("action","admin/assetTypeList!assetAdd");   //设置form的action属性
								  		$("#assetAddForm").submit();   //提交form
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
		$('table#assetTypeList span.spanEdit').click(function(){
			$.getJSON(			//加载数据-----start----------
					"admin/assetTypeList!getAssetModel",
					{
						"id":$(this).attr("data-custom")
					},
					function(json){     //加载数据 回调函数-----start----------
						$('#txtAssetTypeId').val(json.assetTypeId);  //加载初始值
						$('#txtAssetTypeName').val(json.assetTypeName);  //加载初始值
						
						$('#txtAssetTypeId').attr("readonly",true);   //费用编号文本框不可用
						$('div#assetInfo').dialog({        //弹出编辑框-----start----------				
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
									$("#assetAddForm").attr("action","admin/assetTypeList!assetEdit");   //设置form的action属性
									$("#assetAddForm").submit();   //提交form
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
			$(".ckbAsset:checkbox").attr("checked",$(".selectall:checkbox").attr("checked"));
		});
		
		//删除所选
		$('#delSelect').click(function() {
			if (confirm("确定删除所选？")) {
				$('#formData').attr("action",
						"admin/assetTypeList!deleteAssetLists");
				$('#formData').submit();
			} else {
			}
		});
		
		//添加水印
		$('#txtKeywords').watermark("- - -请输入筛选条件- - -");
		
		//条件筛选
		$('#txtKeywords').keyup(function() {
			$("table#assetTypeList tr.trZebra").each(function() {
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
		if ($.trim($("#txtAssetTypeId").val()) == "") {
			$("#txtAssetTypeId+span").text("请输入资产类型编号！");
			$('#txtAssetAssetTypeId').focus();
			return false;
		}
		$("#txtAssetTypeId+span").text(''); //清空

		if ($.trim($("#txtAssetTypeName").val()) == "") {
			$("#txtAssetTypeName+span").text("请输入资产类型名称！");
			$('#txtAssetTypeName').focus();
			return false;
		}
		$("#txtAssetTypeName+span").text(''); //清空
		
		
	}
	
	//清空添加或编辑信息框
	function clearDeptForm() {
		$('#txtAssetTypeId').val("");
		$('#txtAssetTypeName').val("");
		
		
		$("#txtAssetTypeId+span").text("");
		$("#txtAssetTypeCostName+span").text("");
		
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
	<div id="assetInfo" class="hidden" hidden>
	 	<form method="post" id="assetAddForm">
			&nbsp;资产类型编号：<input  type="text"  id="txtAssetTypeId"  name="model.assetTypeId" />
			<span class='validate'></span>
			<br/><br/>
			&nbsp;资产类型名称：<input  type="text"  id="txtAssetTypeName" name="model.assetTypeName" />
			<span class='validate'></span>
			<br/><br/>
			
			<span id="message" class='validate'></span>
		</form>
	</div>
	<!-- 信息添加结束-->
	
	<!-- form表单开始 -->
	<form id="formData" action="admin/assetTypeList" method="post"
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
	<table id="assetTypeList" class="tablelist" style="text-align: center;">
				<thead>
					<tr>
						<th><input name="" type="checkbox" class="selectall"/></th>
						<th>序号</th>
						<th>资产类型编号</th>
						<th>资产类型名称</th>
						<th>操作</th>
					</tr>
				</thead>
				<tbody>
					<s:iterator var="item" value="assetTypeList" status="stat">
						<tr class="trZebra">
						
							<td><input name="delAssetType" type="checkbox" value="${item.assetTypeId }" class="ckbAsset"/></td>
							<td><s:property value="#stat.index+1" /></td>
							<td><s:property value="#item.assetTypeId" /></td>
							<td><s:property value="#item.assetTypeName" /></td>
							<td><span class="spanEdit blue-pointer" data-custom='${ item.assetTypeId }'><img
									src="images/application_edit.png" title="修改" /></span>&nbsp;&nbsp;<a
								onclick="return confirm('确定删除该条信息？');"
								href="admin/assetTypeList!delInfo?id=<s:property value="#item.assetTypeId" />"><img
									src="images/application_delete.png" title="删除" /></a></td>
						</tr>
					</s:iterator>
				</tbody>
			</table>
			<s:set var="actionName" value="'admin/assetTypeList'"></s:set>
			<s:include value="../inc/pager.jsp"></s:include>

			<div class="tip">
				<div class="tiptop">
					<span>提示信息</span><a></a>
				</div>
				<div class="tipinfo">
					<span><img src="../images/ticon.png" /></span>
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

