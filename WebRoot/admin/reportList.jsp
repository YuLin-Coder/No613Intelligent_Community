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

<script type="text/javascript"  src="<%=request.getContextPath() %>/js/My97DatePicker/WdatePicker.js"></script>
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
			$('#txtRid').focus();
			$('#txtRid').attr("disabled",false);
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
								'admin/reportList!exists',//Ajax请求目标地址
								{ 
									'id':$('#txtRid').val()     //JSON参数
								},
								function(response){
								  	if(Number(response)>0){			 //已存在  		
								  		$('#txtRid+span').text("该编号已存在！");
								  		$('#txtRid').focus();
								  	}
								  	else{    //如果不存在
								  		$("#costAddForm").attr("action","admin/reportList!costAdd");   //设置form的action属性
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
		$('table#reportList span.spanEdit').click(function(){//alert("11");
			$.getJSON(			//加载数据-----start----------
					"admin/reportList!getReportModel",
					{
						"id":$(this).attr("data-custom")
					},
					function(json){     //加载数据 回调函数-----start----------
						$('#txtRid').val(json.repairId);  //加载初始值
						$('#txtEquipment').val(json.equipment);  //加载初始值
						$('#selEquName').val(json.equTypeModel.equTypeId);  //加载初始值
						$('#selCtName').val(json.tenementModel.tenementId);  //加载初始值
						$('#txtInjureReason').val(json.injureReason);  //损坏原因
						$('#txtRid').attr("readonly",true);   //费用编号文本框不可用
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
									$("#costAddForm").attr("action","admin/reportList!costEdit");   //设置form的action属性
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
			if (confirm("确定删除所选？")) {
				$('#formData').attr("action",
						"admin/reportList!deleteCostLists");
				$('#formData').submit();
			} else {
			}
		});
		
		//添加水印
		$('#txtKeywords').watermark("- - -请输入筛选条件- - -");
		
		//条件筛选
		$('#txtKeywords').keyup(function() {
			$("table#reportList tr.trZebra").each(function() {
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
		if ($.trim($("#txtRid").val()) == "") {
			$("#txtRid+span").text("请输入报修编号！");
			$('#txtRid').focus();
			return false;
		}
		if (!teg.test($("#txtRid").val())) {
			$("#txtRid+span").text("格式不对,请输入正整数！");
			$('#txtRid').val("");
			$('#txtRid').focus();
			return false;
		}
		$("#txtRid+span").text(''); //清空

		if ($.trim($("#txtEquipment").val()) == "") {
			$("#txtEquipment+span").text("请输入设备名称！");
			$('#txtEquipment').focus();
			return false;
		}
		$("#txtEquipment+span").text(''); //清空
		
		if ($('#selEquName').val() == "-1") {
			$("#selEquName+span").text("请选择类型！");
			return false;
		}
		$("#selCtName+span").text(''); //清空
		
		if ($('#selCtName').val() == "-1") {
			$("#selCtName+span").text("请选择住户！");
			return false;
		}
		$("#selCtName+span").text(''); //清空
		
		/* if ($.trim($("#txtReportName").val()) == "") {
			$("#txtReportName+span").text("请输入报修人！");
			$('#txtReportName').focus();
			return false;
		} */
		//$("#txtReportName+span").text(''); //清空
		
		/* if ($.trim($("#txtReportTime").val()) == "") {
			$("#txtReportTime+span").text("请输入报修时间！");
			$('#txtReportTime').focus();
			return false;
		}
		$("#txtReportTime+span").text(''); //清空 */
		
		/* if ($.trim($("#txtIsReport").val()) == "") {
			$("#txtIsReport+span").text("请输入是或否！");
			$('#txtIsReport').focus();
			return false;
		}
		$("#txtIsReport+span").text(''); //清空 */
		
			return true;
		}
	
	
	//清空添加或编辑信息框
	function clearDeptForm() {
		$('#txtRid').val("");
		$('#txtEquipment').val("");
		$('#selCtName').val("");
		$('#txtReportName').val("");
		$('#txtReportTime').val("");
		$('#txtIsReport').val("");
		
		$("#txtRid+span").text("");
		$("#txtEquipment+span").text("");
		$("#selCtName+span").text("");
		$("#txtReportName+span").text("");
		$("#selCtName+span").text("");
		$("#txtReportTime+span").text("");
		$("#txtIsReport+span").text("");
		
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
			<li><a href="admin/reportList">报修管理</a></li>
			<li>基本内容</li>
		</ul>
	</div>
	<!-- 导航栏结束 -->
	
	<!-- 信息添加开始 -->
	<div id="costInfo" class="hidden">
	 	<form method="post" id="costAddForm">
			&nbsp;维修编号：<input  type="text"  id="txtRid"  name="model.repairId" />
			<span class='validate'></span>
			<br/><br/>
			&nbsp;设备名称：<input  type="text"  id="txtEquipment" name="model.equipment" />
			<span class='validate'></span>
			<br/><br/>
			&nbsp;设备类型： <select id="selEquName" name="model.equTypeModel.equTypeId">
				<option value='-1'>--请选择类型--</option>
				<s:iterator var="items" value="equTypeList" status="stat">
					<option value="${items.equTypeId}">${items.equType}</option>
				</s:iterator>
				</select><span class="validate"></span>
			<br/><br/>
			&nbsp;住户姓名： <select id="selCtName" name="model.tenementModel.tenementId">
				<option value='-1'>--请选择住户--</option>
				<s:iterator var="items" value="tenementList" status="stat">
					<option value="${items.tenementId}">${items.tenementName}</option>
				</s:iterator>
				</select><span class="validate"></span>
			<br/><br/>
			&nbsp;损坏原因：<input  type="text"  id="txtInjureReason"  name="model.injureReason" />
			<span class='validate'></span>
			<br/><br/>
			<!-- <input  type="text"  id="txtReportTime"  name="model.reportTime" /> -->
			<span class='validate'></span>
			
			
		</form>
	</div>
	<!-- 信息添加结束-->
	
	<!-- form表单开始 -->
	<form id="formData" action="admin/reportList" method="post"
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
			<table id="reportList" class="tablelist" style="text-align: center;">
				<thead>
					<tr>
						<th><input name="" type="checkbox" class="selectall" /></th>
						<th>序号</th>
						<th>维修编号</th>
						<th>设备名称</th>
						<th>设备类型</th>
						<th>住户姓名</th>
						<th>损坏原因</th>
						<th>是否受理</th>
						<th>标记</th>
						<th>操作</th>
					</tr>
				</thead>
				<tbody>
					<s:iterator var="item" value="repairList" status="stat">
						<tr class="trZebra">
							<td><input name="delCost" type="checkbox" value="${item.repairId }" class="ckbCost" /></td>
							<td><s:property value="#stat.index+1" /></td>
							<td><s:property value="#item.repairId" /></td>
							<td><s:property value="#item.equipment" /></td>
							<td><s:property value="#item.equTypeModel.equType" /></td>
							<td><s:property value="#item.tenementModel.tenementName" /></td>
							<td><s:property value="#item.injureReason" /></td>
							<td><s:property value="#item.isRepair" /></td>
							<td><s:property value="#item.extent" /></td>
							<td><span class="spanEdit blue-pointer" data-custom='${ item.repairId }'><img
									src="images/application_edit.png" title="修改" />
								</span>&nbsp;&nbsp;
								<a onclick="return confirm('确定删除该条信息？');"
								href="admin/reportList!delInfo?id=<s:property value="#item.repairId" />"><img
									src="images/application_delete.png" title="删除" />
								</a>
							</td>
						</tr>
					</s:iterator>
				</tbody>
			</table>
			<!-- table表格数据结束 -->
		</div>
		<s:set var="actionName" value="'admin/reportList'"></s:set>
		<s:include value="../inc/pager.jsp"></s:include>
	</form>
	<!-- form表单结束 -->
<script type="text/javascript">
	$('.tablelist tbody tr:odd').addClass('odd');
</script>
 	
</body>
<s:include value="../inc/tips.jsp"></s:include>
</html>
