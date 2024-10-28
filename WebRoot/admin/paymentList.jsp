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
<script type="text/javascript" src="js/jquery.watermark.min.js"></script>	<!-- 水印控件 -->
<script type="text/javascript" src="js/jquery-ui-1.8.12.custom.min.js"></script>	<!-- 模态框控件 -->
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
		//编辑信息
		$('table#paymentList span.spanEdit').click(
				function() {
					$.getJSON( //加载数据-----start----------
					"admin/paymentList!getPaymentInfo", {
						"id" : $(this).attr("data-custom")
					}, function(json) { //加载数据 回调函数-----start----------
						$('#txtPayId').val(json.payId); //加载初始值
						$('#txtTenementId').val(json.tenementModel.tenementId); //加载初始值
						$('#txtTenementName').val(json.tenementModel.tenementName); //加载初始值
						$('#selCostName').val(json.costModel.costId); //加载初始值
						$('#txtPayable').val(json.payable); //加载初始值
						$('#txtPractical').val(json.practical); //加载初始值
						$('#selYears').val(json.years); //加载初始值
						$('#selMonths').val(json.months); //加载初始值
						$('#txtPayDate').val(toDate(json.payDate,"yyyy-MM-dd hh:ss:mm"));
						$('#txtPayId').attr("readonly", true); //费用编号文本框不可用
						$('#txtTenementId').attr("readonly", true); //费用编号文本框不可用
						$('#txtPayable').attr("readonly", true); //费用编号文本框不可用
						$('#txtTenementName').attr("readonly", true); //费用编号文本框不可用
						$('div#paymentInfo').dialog(
								{ //弹出编辑框-----start----------				
									title : "修改信息",
									resizable : false,
									width : 420,
									height : 400,
									modal : true,
									buttons : {
										"更新" : function() {
											if (submitCheck() == false) { //客户端验证未通过
												return;
											}
											
											$("#paymentForm").attr("action","admin/paymentList!paymentEdit"); //设置form的action属性
											$("#paymentForm").submit(); //提交form
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
					$(".ckbCost:checkbox").attr("checked",
							$(".selectall:checkbox").attr("checked"));
				});

		//删除所选
		$('#delSelect').click(function() {
			if ($(":checkbox.ckbCost:checked").size() == 0) {
				alert("请选择所需删除选项！");
				return false;
			}
			if (confirm("确定删除所选？")) {
				$('#formData').attr("action","admin/paymentList!delPaymentLists");
				$('#formData').submit();
			} else {
			}
		});

		//添加水印
		$('#txtKeywords').watermark("- - -请输入筛选条件- - -");

		//条件筛选
		$('#txtKeywords').keyup(function() {
			$("table#paymentList tr.trZebra").each(function() {
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

	//编辑信息时的客户端检查
	function submitCheck() {
		if ($('#selCostName').val() == "-1") {
			$("#selCostName+span").text("请选择费用名称！");
			return false;
		}
		$("#selCostName+span").text(''); //清空
		
		var teg = /^\d+(\.\d+)?$/;	//测试非负数
		if ($.trim($("#txtPractical").val()) == "") {
			$("#txtPractical+span").text("请输入实缴费用！");
			$('#txtPractical').focus();
			return false;
		}
		if (!teg.test($("#txtPractical").val())) {
			$("#txtPractical+span").text("格式不对,请输入非负数！");
			$('#txtPractical').val("");
			$('#txtPractical').focus();
			return false;
		}
		$("#txtPractical+span").text(''); //清空
		
		if ($('#selYears').val() == "-1") {
			$("#selYears+span").text("请选择缴费年份！");
			return false;
		}
		$("#selYears+span").text(''); //清空
		
		if ($('#selMonths').val() == "-1") {
			$("#selMonths+span").text("请选择缴费月份！");
			return false;
		}
		$("#selMonths+span").text(''); //清空

		if ($.trim($("#txtPayDate").val()) == "") {
			$("#message").text("请选择缴费时间！");
			$('#txtPayDate').focus();
			return false;
		}
		
		/* var dataTest = "/^\s*$|^\d{4}\-\d{1,2}\-\d{1,2}\s{1}(\d{1,2}:){2}\d{1,2}$/";
		if (!dataTest.test($("#txtPayDate").val())) {
			$("#txtPayDate+span").text("格式不对,请选择真确的时间格式！");
			$('#txtPayDate').val("");
			$('#txtPayDate').focus();
			return false;
		}
		$("#txtPayDate+span").text(''); //清空 */
		return true;
	}

	//清空添加或编辑信息框
	function clearDeptForm() {
		$('#txtPayId').val("");
		$('#txtTenementId').val("");
		$('#txtTenementName').val("");
		$('#txtPayable').val("");
		$('#txtPractical').val("");
		$('#selYears').val("");
		$('#selMonths').val("");
		$('#txtPayDate').val("");

		$("#txtPayId+span").text("");
		$("#txtTenementId+span").text("");
		$("#txtTenementName+span").text("");
		$("#txtPayable+span").text("");
		$("#txtPractical+span").text("");
		$("#selYears+span").text("");
		$("#selMonths+span").text("");
		$("#txtPayDate+span").text("");
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
<style type="text/css">
.qianfei{
	color: red;
}
</style>
</head>
<body>
	<!-- 导航栏开始 -->
	<div class="place">
		<span>位置：</span>
		<ul class="placeul">
			<li><a href="index.jsp">首页</a></li>
			<li><a href="admin/paymentList">居民固定费用缴费查询</a></li>
			<li>基本内容</li>
		</ul>
	</div>
	<!-- 导航栏结束 -->

	<!-- 编辑信息开始 -->
	<div id="paymentInfo" class="hidden">
	 	<form method="post" id="paymentForm">
	 		&nbsp;缴费编号：<input  type="text"  id="txtPayId"  name="model.payId" />
	 		<br/><br/>
			&nbsp;住户编号：<input  type="text"  id="txtTenementId"  name="model.tenementModel.tenementId" />
			<span class='validate'></span>
			<br/><br/>
			&nbsp;住户姓名：<input  type="text"  id="txtTenementName" name="model.tenementModel.tenementName" />
			<span class='validate'></span>
			<br/><br/>
			&nbsp;费用名称：<select id="selCostName" name="model.costModel.costId">
								<option value="-1">-- 请选择类型 --</option>
									<s:iterator var="item" value="costList">
										<option value="${ item.costId}">${item.costName}</option>
									</s:iterator>
						   </select> 
			<span class='validate'></span> 
			<br/><br/>
			&nbsp;应缴费用：<input  type="text"  id="txtPayable"  name="model.payable" />
			<span class='validate'></span>
			<br/><br/>
			&nbsp;实缴费用：<input  type="text"  id="txtPractical"  name="model.practical" />
			<span class='validate'></span>
			<br/><br/>
			<%
				Calendar c = Calendar.getInstance();
				int year = c.get(Calendar.YEAR);//获取当前年份
			%>
			&nbsp;缴费年份：<select id="selYears" name="model.years">
								<option value="-1">-- 请选择缴费年份 --</option>
								<option value="<%=year%>"><%=year%>年
								</option>
								<option value="<%=year - 1%>"><%=year - 1%>年
								</option>
								<option value="<%=year - 2%>"><%=year - 2%>年
								</option>
								<option value="<%=year - 3%>"><%=year - 3%>年
								</option>
								<option value="<%=year - 4%>"><%=year - 4%>年
								</option>
								<option value="<%=year - 5%>"><%=year - 5%>年
								</option>
								<option value="<%=year - 6%>"><%=year - 6%>年
								</option>
								<option value="<%=year - 7%>"><%=year - 7%>年
								</option>
								<option value="<%=year - 8%>"><%=year - 8%>年
								</option>
							</select> 
			<span class='validate'></span>
			<br/><br/>
			&nbsp;缴费月份：<select id="selMonths" name="model.months">
								<option value="-1">-- 请选择缴费月份 --</option>
								<option value="1">1月</option>
								<option value="2">2月</option>
								<option value="3">3月</option>
								<option value="4">4月</option>
								<option value="5">5月</option>
								<option value="6">6月</option>
								<option value="7">7月</option>
								<option value="8">8月</option>
								<option value="9">9月</option>
								<option value="10">10月</option>
								<option value="11">11月</option>
								<option value="12">12月</option>
						   </select> 
			<span class='validate'></span>
			<br/><br/>
			&nbsp;缴费时间：<input  type="text"  id="txtPayDate"  name="model.payDate" 
							onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" />
			<span class='validate'></span>
			<br/><br/>
			<span id="message" class='validate'></span>
		</form>
	</div>
	<!-- 编辑信息结束-->


	<!-- form表单开始 -->
	<form id="formData" action="admin/paymentList" method="post"
		onsubmit="return check();">
		<div class="rightinfo">
			<!-- 工具栏开始 -->
			<div class="tools">
				<ul class="toolbar">
					<li id="addInfo"><span><img src="images/t01.png" /></span><a href="admin/paymentList!costInit">添加收费信息</a></li>
					<li id="delSelect"><span><img src="images/t03.png" /></span><a>删除所勾选项</a></li>
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
			<table id="paymentList" class="tablelist" style="text-align: center;">
				<thead>
					<tr>
						<th><input name="" type="checkbox" class="selectall" /></th>
						<th>序号</th>
						<th>缴费编号</th>
						<th>住户姓名</th>
						<th>费用名称</th>
						<th>应缴费用（元）</th>
						<th>实缴费用（元）</th>
						<th>欠缴费（元）</th>
						<th>缴费日期</th>
						<th>缴费时间</th>
						<th>操作</th>
					</tr>
				</thead>
				<tbody>
					<s:iterator var="item" value="paymentList" status="stat">
						<tr class="trZebra">
							<td><input name="delPaymentList" type="checkbox" value="${ item.payId }"
								class="ckbCost" /></td>
							<td><s:property value="#stat.index+1" /></td>
							<td><s:property value="#item.payId" /></td>
							<td><s:property value="#item.tenementModel.tenementName" /></td>
							<td><s:property value="#item.costModel.costName" /></td>
							<td><s:property value="#item.payable" /></td>
							<td><s:property value="#item.practical" /></td>
							<s:if test="0 <= (#item.practical - #item.payable)">
								<td>0.0</td>
							</s:if>
							<s:else>
								<td class="qianfei"><s:property value="#item.practical - #item.payable" /></td>
							</s:else>
							<td><s:property value="#item.years" /> - <s:property value="#item.months" /></td>
							<td><s:property value="#item.payDate" /></td>
							<td><span class="spanEdit blue-pointer" data-custom='${ item.payId }'><img
									src="images/application_edit.png" title="修改" /> </span>
								&nbsp;&nbsp; 
								<a onclick="return confirm('确定删除该条信息？');" 
								href="admin/paymentList!delInfo?id=<s:property value="#item.payId" />">
									<img src="images/application_delete.png" title="删除" /> 
								</a>
							</td>
						</tr>
					</s:iterator>
				</tbody>
			</table>
			<!-- table表格数据结束 -->
		</div>
		<s:set var="actionName" value="'admin/paymentList'"></s:set>
		<s:include value="../inc/pager.jsp"></s:include>
	</form>
	<!-- form表单结束 -->
	<script type="text/javascript">
		$('.tablelist tbody tr:odd').addClass('odd');
	</script>

</body>
<s:include value="../inc/tips.jsp"></s:include>
</html>
