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
<link href="css/payment.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" href="css/jquery-ui.css" />
<!-- 模态框样式控制 -->

<script type="text/javascript" src="js/jquery-1.4.2.min.js"></script>
<script type="text/javascript" src="js/jquery.watermark.min.js"></script>
<!-- 水印控件 -->
<script type="text/javascript" src="js/jquery-ui-1.8.12.custom.min.js"></script>
<!-- 模态框控件 -->
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
	
	//页面加载开始
	$(function() {
		$('#txtIdentityCard').focus();
		$('div#zhuhuInfo input').attr("readonly", true);
		$('#txtPayable').attr("readonly", true);
		$('#txtQuantity').attr("readonly", true);
		//添加收费按钮开始
		$('#btnSave').click(function() { //------添加按钮开始------
			if ($('#txtTenementId').val() == "") {
				alert("请确认住户信息是否正确！");
				return false;
			}
			if (submitCheck() == false) {
				return false;
			} else {
				$.post('admin/paymentList!existsPayId',//Ajax请求目标地址
				{	
					'id' : $('#txtpayId').val()
				//JSON参数
				}, function(response) {
					if (Number(response) > 0) { //已存在的缴费编号
						$("#txtpayId+span").text("该缴费编号已存在，请重新输入！");
						$('#txtpayId').focus();
						return false;
					} else { //如果缴费编号不存在
						$.post('admin/paymentList!exists',//Ajax请求目标地址
						{	
							'tenementId' : $('#txtTenementId').val(),
							'costId' : $('#selCtName').val(),
							'selYears' : $('#selYears').val(),
							'selMonths' : $('#selMonths').val()
						//JSON参数
						}, function(response) {
							if (Number(response) > 0) { //已存在的缴费信息  
								$("#selCtName+span").text("该缴费已经交过，请查看或修改相关信息！");
								return false;
							} else { //如果缴费信息不存在
								$("#paymentAddForm").attr("action",
										"admin/paymentList!paymentAdd"); //设置form的action属性
								$("#paymentAddForm").submit(); //提交form
							}//如果缴费信息不存在结束
						});//post结束
					}//如果缴费编号不存在结束
				});//post结束
			}//else结束
		});//------添加按钮结束------

		//信息确认按钮开始
		$('#btnConfirmInfo').click(function() {
			var idCard = $('#txtIdentityCard').val();
			if(idCardCheck() == false){
				return false;
			}else{
				$.post(
				'admin/paymentList!existsIdCard',//Ajax请求目标地址
				{
					'idCard' : idCard
				//JSON参数
				}, function(response) {
					if (Number(response) > 0) { //存在  	
						existsIdCard();	
					} else { //如果存在
						$('#txtIdentityCard+span').text("该身份证住户不存在！");
						clearDeptForm();
						$('#txtCostId').focus();
						
					} //else结束
				});//post结束
			}//else结束

		}); //信息确认按钮结束

		//计算按钮事件开始
		$('#btnCalculation').click(function() {
			var lastHalf = $("#txtLastHalf").val();
			var thisMonth = $("#txtThisMonth").val();
			var quantity = thisMonth - lastHalf;
			var selCtName = $('#selCtName').val();
			if (calculationCheck() == false) {
				return false;
			}else{
				$.getJSON(
					"admin/paymentList!getCostInfo",
					{
						"costId":selCtName
					},
					function (data) {
						$('#txtPayable').val(data.unitPrice * quantity);
					}
				);
			}
			$('#txtQuantity').val(quantity);
		}); //计算按钮事件结束

	}); //页面加载结束
	
	//判断所输入的身份证是否存在
	function existsIdCard(){
		var idCard = $('#txtIdentityCard').val();
		$.getJSON( //加载数据-----start----------
			"admin/paymentList!getTenementInfo", {
				"idCard" : idCard
			//传输的身份证号
			}, function(data) { //加载数据 回调函数-----start----------
				$.each(data,//数据
				function(index, obj) {//index是索引,obj是第几个元素
					$('#txtTenementId').val(data[index].tenementId);
					$('#txtTenementName').val(data[index].tenementName);
					$('#txtAunit').val(data[index].aunit);
					$('#txtPhone').val(data[index].phone);
					$('#txtMobilePhone').val(data[index].mobilePhone);
					$('#txteAddress').val(data[index].roomModel.buildingModel.buildingName
											+ data[index].roomModel.unitNum
											+ data[index].roomModel.roomName);
				});
			} //加载数据 回调函数-----end----------
		); //加载数据-----end----------	
	}
	
	//身份证客户端验证
	function idCardCheck(){
		var teg = /^\d{15}(\d\d[0-9xX])?$/;
		if ($.trim($("#txtIdentityCard").val()) == "") {
			$("#txtIdentityCard+span").text("请输入住户身份证号！");
			$('#txtIdentityCard').focus();
			return false;
		}
		if (!teg.test($("#txtIdentityCard").val())) {
			$("#txtIdentityCard+span").text("身份证格式错误！");
			$('#txtIdentityCard').val("");
			$('#txtIdentityCard').focus();
			return false;
		}
		$("#txtIdentityCard+span").text(''); //清空
		
		return true;
	}

	//添加信息时的客户端检查
	function submitCheck() {
		var teg = /^[0-9]*[1-9][0-9]*$/;
		if ($.trim($("#txtpayId").val()) == "") {
			$("#txtpayId+span").text("请输入缴费编号！");
			$('#txtpayId').focus();
			return false;
		}
		if (!teg.test($("#txtpayId").val())) {
			$("#txtpayId+span").text("格式不对,请输入正整数！");
			$('#txtpayId').val("");
			$('#txtpayId').focus();
			return false;
		}
		$("#txtpayId+span").text(''); //清空
	
		if ($('#selCtName').val() == "-1") {
			$("#selCtName+span").text("请选择费用名称！");
			return false;
		}
		$("#selCtName+span").text(''); //清空

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
		
		if($.trim($('#txtPayable').val()) == ""){
			$("#txtPayable+span").text("请计算应缴费用！");
			return false;
		}
		$("#txtPayable+span").text(''); //清空
		
		var teg = /^\d+(\.\d+)?$/;	//测试非负数
		if ($.trim($("#txtPractical").val()) == "") {
			$("#txtPractical+span").text("请输入实缴费用！");
			$('#txtPractical').focus();
			return false;
		}	
		
		if (!teg.test($("#txtPractical").val())) {
			$("#txtPractical+span").text("格式错误，请输入非负数！");
			$('#txtPractical').val("");
			$('#txtPractical').focus();
			return false;
		}
		$("#txtPractical+span").text(''); //清空
		return true;
	}
	
	
	function calculationCheck() {
		var teg = /^\d+(\.\d+)?$/;	//测试非负数
		if ($('#selCtName').val() == "-1") {
			$("#selCtName+span").text("请选择费用名称！");
			return false;
		}
		$("#selCtName+span").text(''); //清空
		
		if ($.trim($("#txtLastHalf").val()) == "") {
			$("#txtLastHalf+span").text("请输入上月读表数！");
			$('#txtLastHalf').focus();
			return false;
		}
		if (!teg.test($("#txtLastHalf").val())) {
			$("#txtLastHalf+span").text("格式错误，请输入非负数！");
			$('#txtLastHalf').val("");
			$('#txtLastHalf').focus();
			return false;
		}
		$("#txtLastHalf+span").text(''); //清空

		if ($.trim($("#txtThisMonth").val()) == "") {
			$("#txtThisMonth+span").text("请输入本月读表数！");
			$('#txtThisMonth').focus();
			return false;
		}	
			
		if (!teg.test($("#txtThisMonth").val())) {
			$("#txtThisMonth+span").text("格式错误，请输入非负数！");
			$('#txtThisMonth').val("");
			$('#txtThisMonth').focus();
			return false;
		}
		$("#txtThisMonth+span").text(''); //清空
		
		if($("#txtThisMonth").val() < $("#txtLastHalf").val()){
			$("#txtThisMonth+span").text("输入错误，本月应大于上月！");
			$('#txtThisMonth').focus();
			return false;
		}
		return true;
	}

	//清空添加或编辑信息框
	function clearDeptForm() {
		$('#txtTenementId').val("");
		$('#txtTenementName').val("");
		$('#txtAunit').val("");
		$('#txtPhone').val("");
		$('#txtMobilePhone').val("");
		$('#txteAddress').val("");

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
#payId {
	margin-left: 10px;
	margin-top: 5px;
	font-size: 15px;
}
</style>
</head>
<body>
	<!-- 导航栏开始 -->
	<div class="place">
		<span>位置：</span>
		<ul class="placeul">
			<li><a href="index.jsp">首页</a></li>
			<li><a href="admin/paymentList!costInit">居民固定类付费管理</a></li>
			<li>基本内容</li>
		</ul>
	</div>
	<!-- 导航栏结束 -->

	<!-- 信息添加开始 -->
	<div id="paymentInfo">
		<form method="post" id="paymentAddForm">
			<div class="title">住户固定费用缴纳</div>
			<div class="rightinfo">
				<!-- 缴费信息块开始 -->
				<div>
					<div id="payId">缴费编号：<input type="text" id="txtpayId" name="model.payId"/><span class='validate'></span></div>
					<div class="jiaofei">缴费信息：</div>
					<ul>
						<li class="one">身份证号：<input type="text" id="txtIdentityCard" /><span
							class='validate'></span></li>
						<li class="two">费用名称：<select id="selCtName"
							name="model.costModel.costId">
								<option value="-1">-- 请选择费用名称 --</option>
								<s:iterator var="item" value="costList">
									<option value="${ item.costId}">${item.costName}</option>
								</s:iterator>
						</select> <span class='validate'></span>
						</li>
						<li class="clear"></li>
						<%
							Calendar c = Calendar.getInstance();
							int year = c.get(Calendar.YEAR);//获取当前年份
						%>
						<li class="one">缴费年份：<select id="selYears" name="model.years">
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
						</select> <span class='validate'></span>
						</li>
						<li class="three">缴费月份：<select id="selMonths"
							name="model.months">
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
						</select> <span class='validate'></span>
						</li>
					</ul>
				</div>
				<!-- 缴费信息块结束 -->

				<!-- 住户信息块开始 -->
				<div id="zhuhuInfo">
					<div class="zhuhu">
						住户信息：<input type="button" value="信息确认" id="btnConfirmInfo" />
					</div>
					<ul>
						<li class="four">住户编号：<input type="text" id="txtTenementId" name="model.tenementModel.tenementId"/></li>
						<li class="four">住户名称：<input type="text" id="txtTenementName" /></li>
						<li class="four">所属单位：<input type="text" id="txtAunit" /></li>
						<li class="clear"></li>
						<li class="four">家庭电话：<input type="text" id="txtPhone" /></li>
						<li class="four">手机号码：<input type="text" id="txtMobilePhone" /></li>
						<li class="four">住户地址：<input type="text" id="txteAddress" /></li>
					</ul>
				</div>
				<!-- 缴费信息块结束 -->
				<!-- <input type="text" id="txtPayId" name="model.payId"/> -->
				
				<!-- 费用缴纳块开始 -->
				<div>
					<div class="zhuhu">费用缴纳：</div>
					<div>
						<ul>
							<li class="one">上月读表数：<input type="text" id="txtLastHalf" name="model.lastHalf"/><span
								class='validate'></span></li>
							<li class="five">应缴费用：<input type="text" id="txtPayable" name="model.payable"/>（元）<span
								class='validate'></span></li>
							<li class="clear"></li>
							<li class="one">本月走表数：<input type="text" id="txtThisMonth" name="model.thisMonth"/><span
								class='validate'></span></li>
							<li class="five">实缴费用：<input type="text" id="txtPractical" name="model.practical"/>（元）<span
								class='validate'></span></li>
							<li class="clear"></li>
							<li class="one">实际走表数：<input type="text" id="txtQuantity" name=""/><span
								class='validate'></span></li>
							<li><input type="button" value="计算" id="btnCalculation" /></li>
							<li class="clear"></li>
						</ul>
					</div>
				</div>
				<!-- 费用缴纳块结束-->

				<!-- 提交按钮块开始-->
				<div class="bottom">
					<input type="button" value="保存" class="btnSubmit" id="btnSave" />
					<input type="submit" value="重置" class="btnSubmit" id="" />
				</div>
				<!-- 提交按钮块结束-->
			</div>
		</form>
	</div>
	<!-- 信息添加结束-->

	<script type="text/javascript">
		$('.tablelist tbody tr:odd').addClass('odd');
	</script>

</body>
<s:include value="../inc/tips.jsp"></s:include>
</html>
