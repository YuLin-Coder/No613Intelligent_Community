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
				alert("请确认车主信息是否正确！");
				return false;
			}
			if (submitCheck() == false) {
				return false;
			} else {
				$.post('admin/parkkingMoneyList!existsParkkingMoneyId',//Ajax请求目标地址
				{	
					'id' : $('#txtpayId').val()
				//JSON参数
				}, function(response) {
					if (Number(response) > 0) { //已存在的缴费编号
						$("#txtpayId+span").text("该缴费编号已存在，请重新输入！");
						$('#txtpayId').focus();
						return false;
					} else { //如果缴费编号不存在
						$.post('admin/parkkingMoneyList!exists',//Ajax请求目标地址
						{	
							'parkkingMoneyId' : $('#txtpayId').val(),//缴费编号
							'carNum' : $('#txtIdentityCard').val(),//车牌号
							'year' : $('#selYears').val()//缴费年份
						//JSON参数
						}, function(response) {
							if (Number(response) > 0) { //已存在的缴费信息  
								$("#selCtName+span").text("该缴费已经交过，请查看或修改相关信息！");
								return false;
							} else { //如果缴费信息不存在
								$("#paymentAddForm").attr("action",
										"admin/parkkingMoneyList!parkkingMoneyAdd"); //设置form的action属性
								$("#paymentAddForm").submit(); //提交form
							}//如果缴费信息不存在结束
						});//post结束
					}//如果缴费编号不存在结束
				});//post结束
			}//else结束
		});//------添加按钮结束------

		//信息确认按钮开始
		$('#btnConfirmInfo').click(function() {
			var carNum = $('#txtIdentityCard').val();
			if(idCardCheck() == false){
				return false;
			}else{
				$.post(
				'admin/parkkingMoneyList!existsIdCard',//Ajax请求目标地址
				{
					'carNum' : carNum
				//JSON参数
				}, function(response) {
					if (Number(response) > 0) { //存在  	
						existsIdCard(); //加载数据	
					} else { //如果存在
						$('#txtIdentityCard+span').text("该车牌号不存在！");
						$('#txtIdentityCard').focus();
						clearDeptForm();
						$('#txtCostId').focus();
						
					} //else结束
				});//post结束
			}//else结束
		}); //信息确认按钮结束
	}); //页面加载结束
	
	//判断所输入的身份证是否存在
	function existsIdCard(){
		var carNum = $('#txtIdentityCard').val();
		$.getJSON( //加载数据-----start----------
			"admin/parkkingMoneyList!getCarInfo", {
				"carNum" : carNum
			//传输的身份证号
			}, function(data) { //加载数据 回调函数-----start----------
				$.each(data,//数据
				function(index, obj) {//index是索引,obj是第几个元素
					$('#txtTenementId').val(data[index].roomModel.buildingModel.buildingName
											+ data[index].roomModel.unitNum
											+ data[index].roomModel.roomName);
					$('#txtTenementName').val(data[index].carType);
					$('#txtAunit').val(data[index].parkTypeModel.name);
					$('#txtPhone').val(data[index].carNum);
					$('#txtMobilePhone').val(data[index].parkTypeModel.managercost);
					$('#txteAddress').val(data[index].parkTypeModel.basecost);
					$('#txtPayable').val(Number(data[index].parkTypeModel.managercost)+Number(data[index].parkTypeModel.basecost));
					$('#txtParkkingId').val(data[index].parkkingId);
					
				});
			} //加载数据 回调函数-----end----------
		); //加载数据-----end----------	
	}
	
	//车牌号客户端验证
	function idCardCheck(){
		if ($.trim($("#txtIdentityCard").val()) == "") {
			$("#txtIdentityCard+span").text("请输入车牌号！");
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
		
		if ($('#selPtId').val() == "-1") {
			$("#selPtId+span").text("请选择车位类型！");
			return false;
		}
		$("#selPtId+span").text(''); //清空
		
		if ($('#selYears').val() == "-1") {
			$("#selYears+span").text("请选择缴费年份！");
			return false;
		}
		$("#selYears+span").text(''); //清空
		
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
			<li><a href="admin/parkkingMoneyList!parkTypeInit">停车位付费管理</a></li>
			<li>车位费用缴纳</li>
		</ul>
	</div>
	<!-- 导航栏结束 -->

	<!-- 信息添加开始 -->
	<div id="paymentInfo">
		<form method="post" id="paymentAddForm">
			<div class="title">车位费用缴纳</div>
			<div class="rightinfo">
				<!-- 缴费信息块开始 -->
				<div>
					<div id="payId">缴费编号：<input type="text" id="txtpayId" name="model.parkkingMoneyId"/><span class='validate'></span></div>
					<div class="jiaofei">缴费信息：</div>
					<ul>
						<li class="one">车牌号：&nbsp;&nbsp;&nbsp;<input type="text" id="txtIdentityCard" name="model.parkkingModel.carNum"/><span
							class='validate'></span></li>
						<li class="five">车费类型：<select id="selPtId" name="model.parkkingModel.parkTypeModel.ptId">
							<option value="-1">-- 请选择车位类型 --</option>
							<s:iterator var="item" value="parkTypeList">
									<option value="${ item.ptId}">${item.name}</option>
							</s:iterator>
						</select> <span class='validate'></span>
						</li>
					</ul>
				</div>
				<!-- 缴费信息块结束 -->

				<!-- 住户信息块开始 -->
				<div id="zhuhuInfo">
					<div class="zhuhu">
						车位信息：<input type="button" value="信息确认" id="btnConfirmInfo" />
					</div>
					<ul>
						<li class="four">车位编号：<input type="text" id="txtParkkingId" name="model.parkkingModel.parkkingId"/></li>
						<li class="four">汽车品牌：<input type="text" id="txtTenementName" /></li>
						<li class="four">车位类型：<input type="text" id="txtAunit" /></li>
						<li class="clear"></li>
						<li class="four">车牌号码：<input type="text" id="txtPhone" /></li>
						<li class="four">能耗费用：<input type="text" id="txtMobilePhone" /></li>
						<li class="four">车位低价：<input type="text" id="txteAddress" /></li>
						<li class="clear"></li>
						<li class="four">车主地址：<input type="text" id="txtTenementId"/></li>
					</ul>
				</div>
				<!-- 缴费信息块结束 -->
				<!-- <input type="text" id="txtPayId" name="model.payId"/> -->
				
				<!-- 费用缴纳块开始 -->
				<div>
					<div class="zhuhu">费用缴纳：</div>
					<div>
						<ul>
							<li class="one">应缴费用：<input type="text" id="txtPayable" />（元）<span
								class='validate'></span></li>
							<%
								Calendar c = Calendar.getInstance();
								int year = c.get(Calendar.YEAR);//获取当前年份
							%>
							<li class="five">缴费年份：<select id="selYears" name="model.year">
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
							</select><span class='validate'></span>
							</li>
							<li class="clear"></li>
							<li class="one">实缴费用：<input type="text" id="txtPractical" name="model.parkkingMoney"/>（元）<span
								class='validate'></span></li>
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
