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

<script type="text/javascript" src="<%=request.getContextPath()%>/js/My97DatePicker/WdatePicker.js"></script> <!-- 日期控件 -->
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
			$('#txtMid').focus();
			$('#deliveryInfo').dialog({			//------弹出模态框开始------
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
								'admin/deliveryMoneyList!exists',//Ajax请求目标地址
								{ 
									'id':$('#txtMid').val()     //JSON参数
								},
								function(response){
								  	if(Number(response)>0){			 //已存在  		
								  		$('#txtMid+span').text("该快递编号已存在！");
								  		$('#txtMid').focus();
								  	}
								  	else{    //如果不存在
								  		$("#addForm").attr("action","admin/deliveryMoneyList!deliveryMoneyAdd");   //设置form的action属性
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
		$('table#deliveryMoneyList span.spanEdit').click(function(){
			$.getJSON(			//加载数据-----start----------
					"admin/deliveryMoneyList!getDeliveryMoneyInfo",
					{
						"id":$(this).attr("data-custom")
					},
					function(json){     //加载数据 回调函数-----start----------
						$('#txtMid').val(json.mid);  //加载初始值
						$('#txtDeliveryfirmName').val(json.deliveryfirmModel.deliveryfirmId);  //加载初始值
						$('#txtMoney').val(json.money);  //加载初始值
						$('#txtPayee').val(json.payee);  //加载初始值
						$('#txtDrawee').val(json.drawee);  //加载初始值
						$('#selYears').val(json.years);  //加载初始值
						$('#txtTradedate').val(toDate(json.tradedate,"yyyy-MM-dd"));  //加载初始值
						$('#txtMid').attr("readonly",true);   //快递编号文本框不可用
						$('#txtTradedate').attr("readonly",true);	//交易时间文本框不可用
						$('div#deliveryInfo').dialog({        //弹出编辑框-----start----------				
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
									$("#addForm").attr("action","admin/deliveryMoneyList!deliveryMoneyEdit");   //设置form的action属性
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
			$(".ckbDeliveryMoney:checkbox").attr("checked",$(".selectall:checkbox").attr("checked"));
		});
		
		//删除所选
		$('#delSelect').click(function() {
			if ($(":checkbox.ckbDeliveryMoney:checked").size() == 0) {
				alert("请选择所需删除选项！");
				return false;
			}
			if (confirm("确定删除所选？")) {
				$('#formData').attr("action",
						"admin/deliveryMoneyList!delDeliveryMoneyLists");
				$('#formData').submit();
			} else {
			}
		});
		
		//添加水印
		$('#txtKeywords').watermark("- - -请输入筛选条件- - -");
		$('#txtTradedate').watermark("--如不填，默认为当前时间--");
		
		//条件筛选
		$('#txtKeywords').keyup(function() {
			$("table#deliveryMoneyList tr.trZebra").each(function() {
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
		if ($.trim($("#txtMid").val()) == "") {
			$("#txtMid+span").text("请输入快递编号！");
			$('#txtMid').focus();
			return false;
		}
		if (!teg.test($("#txtMid").val())) {
			$("#txtMid+span").text("格式不对,请输入正整数！");
			$('#txtMid').val("");
			$('#txtMid').focus();
			return false;
		}
		$("#txtMid+span").text(''); //清空

		if ($('#txtDeliveryfirmName').val() == "-1") {
			$("#txtDeliveryfirmName+span").text("请选择快递公司！");
			return false;
		}
		$("#txtDeliveryfirmName+span").text(''); //清空

		if ($.trim($("#txtMoney").val()) == "") {
			$("#txtMoney+span").text("请输入快递费用！");
			$('#txtMoney').focus();
			return false;
		}
		$("#txtMoney+span").text(''); //清空
		
		var teg = /^\d+(\.\d+)?$/;	//测试非负数
		if (!teg.test($("#txtMoney").val())) {
			$("#txtMoney+span").text("格式不对,请输入非负数！");
			$('#txtMoney').val("");
			$('#txtMoney').focus();
			return false;
		}
		$("#txtMoney+span").text(''); //清空
		
		if ($.trim($("#txtPayee").val()) == "") {
			$("#txtPayee+span").text("请输入付款人！");
			$('#txtPayee').focus();
			return false;
		}
		$("#txtPayee+span").text(''); //清空
		
		if ($.trim($("#txtDrawee").val()) == "") {
			$("#txtDrawee+span").text("请输入收款人！");
			$('#txtDrawee').focus();
			return false;
		}
		$("#txtDrawee+span").text(''); //清空
		
		var teg = /^(\d{4}|\d{2})$/;
		if ($.trim($("#selYears").val()) == "") {
			$("#selYears+span").text("请输入收费年份！");
			$('#selYears').focus();
			return false;
		}
		
		if(!teg.test($("#selYears").val())){
			$("#selYears+span").text("格式不对,请输入真确的年份格式！");
			$('#selYears').val("");
			$('#selYears').focus();
			return false;
		}
		$("#selYears+span").text(''); //清空
		
		var teg = /^(\d{4}|\d{2})-((1[0-2])|(0?[1-9]))-(([12][0-9])|(3[01])|(0?[1-9]))$/;
		if($("#txtTradedate").val() == ""){
			return true;
		}else{
			if (!teg.test($("#txtTradedate").val())) {
				$("#txtTradedate+span").text("请输入正确的日期格式，如xxxx年-xx月-xx日！");
				$('#txtTradedate').focus();
				return false;
			}else{
				$("#txtTradedate+span").text(''); //清空
				return true;
			}
		}
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
	//时间格式
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
			format = format.replace(RegExp.$1, (this.getFullYear() + "")
					.substr(4 - RegExp.$1.length));
		}
		for ( var k in o) {
			if (new RegExp("(" + k + ")").test(format)) {
				format = format.replace(RegExp.$1, RegExp.$1.length == 1 ? o[k]
						: ("00" + o[k]).substr(("" + o[k]).length));
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
	
	<!-- 信息添加、编辑开始 -->
	<div id="deliveryInfo" class="hidden">
	 	<form method="post" id="addForm">
			&nbsp;快递编号：<input  type="text"  id="txtMid"  name="model.mid" />
			<span class='validate'></span>
			<br/><br/>
			&nbsp;快递公司：<select id="txtDeliveryfirmName" name="model.deliveryfirmModel.deliveryfirmId">
								<option value="-1">-- 请选择类型 --</option>
									<s:iterator var="item" value="deliveryFirmList">
										<option value="${ item.deliveryfirmId}">${item.deliveryfirmName}</option>
									</s:iterator>
						   </select> 
			<span class='validate'></span>
			<br/><br/>
			&nbsp;快递费用：<input  type="text"  id="txtMoney"  name="model.money" />
			<span class='validate'></span>
			<br/><br/>
			&nbsp;付款人名：<input  type="text"  id="txtPayee"  name="model.payee" />
			<span class='validate'></span>
			<br/><br/>
			&nbsp;收款人名：<input  type="text"  id="txtDrawee"  name="model.drawee" />
			<span class='validate'></span>
			<br/><br/>
			&nbsp;快递年份：<input  type="text"  id="selYears"  name="model.years" />
			<span class='validate'></span> 
			<br/><br/>
			&nbsp;交易时间：<input  type="text"  id="txtTradedate"  name="model.tradedate"/>
			<span class='validate'></span>
			<br/><br/>
			<span id="message" class='validate'></span>
		</form>
	</div>
	<!-- 信息添加、编辑结束-->
	
	<!-- form表单开始 -->
	<form id="formData" action="admin/deliveryMoneyList" method="post"
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
			<table id="deliveryMoneyList" class="tablelist" style="text-align: center;">
				<thead>
					<tr>
						<th><input name="" type="checkbox" class="selectall" /></th>
						<th>序号</th>
						<th>快递编号</th>
						<th>快递公司</th>
						<th>费用</th>
						<th>年份</th>
						<th>付款人</th>
						<th>收款人</th>
						<th>交易时间</th>
						<th>操作</th>
					</tr>
				</thead>
				<tbody>
					<s:iterator var="item" value="deliveryMoneyList" status="stat">
						<tr class="trZebra">
							<td><input name="deliveryMoney" type="checkbox" value="${item.mid }" class="ckbDeliveryMoney" /></td>
							<td><s:property value="#stat.index+1" /></td>
							<td><s:property value="#item.mid" /></td>
							<td><s:property value="#item.deliveryfirmModel.deliveryfirmName" /></td>
							<td><s:property value="#item.money" /></td>
							<td><s:property value="#item.years" /></td>
							<td><s:property value="#item.payee" /></td>
							<td><s:property value="#item.drawee" /></td>
							<td><s:property value="#item.tradedate" /></td>
							<td><span class="spanEdit blue-pointer" data-custom='${ item.mid }'><img
									src="images/application_edit.png" title="修改" />
								</span>&nbsp;&nbsp;
								<a onclick="return confirm('确定删除该条信息？');"
								href="admin/deliveryMoneyList!delInfo?id=<s:property value="#item.mid" />"><img
									src="images/application_delete.png" title="删除" />
								</a>
							</td>
						</tr>
					</s:iterator>
				</tbody>
			</table>
			<!-- table表格数据结束 -->
		</div>
		<s:set var="actionName" value="'admin/deliveryMoneyList'"></s:set>
		<s:include value="../inc/pager.jsp"></s:include>
	</form>
	<!-- form表单结束 -->
<script type="text/javascript">
	$('.tablelist tbody tr:odd').addClass('odd');
</script>
 	
</body>
<s:include value="../inc/tips.jsp"></s:include>
</html>
