<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>无标题文档</title>
<link href="css/style.css" rel="stylesheet" type="text/css" />
<script language="JavaScript" src="js/jquery.js"></script>

<script type="text/javascript">
	$(function() {
		$('dd').find('ul').slideUp();
		//导航切换
		$(".menuson li").click(function() {
			$(".menuson li.active").removeClass("active");
			$(this).addClass("active");
		});

		$('.title').click(function() {
			var $ul = $(this).next('ul');
			$('dd').find('ul').slideUp();
			if ($ul.is(':visible')) {
				$(this).next('ul').slideUp();
			} else {
				$(this).next('ul').slideDown();
			}
		});
	});
</script>
</head>

<body style="background:#f0f9fd;">
	<div class="lefttop">
		<span></span>管理功能栏
	</div>

	<dl class="leftmenu">
		<dd>
			<div class="title">
				<span><img src="images/leftico01.png" /></span>小区管理
			</div>
			<ul class="menuson">
				<li><cite></cite><a href="admin/villageInfoList"
					target="rightFrame">小区基本信息管理</a><i></i></li>
				<li><cite></cite><a href="admin/assetTypeList"
					target="rightFrame">小区资产类型管理</a><i></i></li>
				<li><cite></cite><a href="admin/assetInfoList"
					target="rightFrame">资产信息管理</a><i></i></li>
			</ul>
		</dd>


		<dd>
			<div class="title">
				<span><img src="images/leftico02.png" /></span>社区管理
			</div>
			<ul class="menuson">
				<li><cite></cite><a href="admin/communityInfoList"
					target="rightFrame">社区基本信息管理</a><i></i></li>
			</ul>
		</dd>


		<dd>
			<div class="title">
				<span><img src="images/leftico03.png" /></span>居民管理
			</div>
			<ul class="menuson">
				<li><cite></cite><a href="admin/tenementList"
					target="rightFrame">居民基本信息管理</a><i></i></li>
			</ul>
		</dd>

		<dd>
			<div class="title">
				<span><img src="images/leftico04.png" /></span>工作人员管理
			</div>
			<ul class="menuson">
				<li><cite></cite><a href="admin/workerList" target="rightFrame">人员基本信息管理</a><i></i></li>
				<li><cite></cite><a href="admin/dutyList" target="rightFrame">值班人员信息管理</a><i></i></li>
			</ul>
		</dd>

		<dd>
			<div class="title">
				<span><img src="images/leftico04.png" /></span>住宅管理
			</div>
			<ul class="menuson">
				<li><cite></cite><a href="admin/buildingList"
					target="rightFrame">楼号信息管理</a><i></i></li>
				<li><cite></cite><a href="admin/roomList" target="rightFrame">房屋信息管理</a><i></i></li>
			</ul>
		</dd>

		<dd>
			<div class="title">
				<span><img src="images/leftico04.png" /></span>停车位管理
			</div>
			<ul class="menuson">
				<li><cite></cite><a href="admin/parkkingList.action"
					target="rightFrame">停车位信息管理</a><i></i></li>
				<li><cite></cite><a href="admin/parkkingList!getList"
					target="rightFrame">停车位租售管理</a><i></i></li>
			</ul>
		</dd>

		<dd>
			<div class="title">
				<span><img src="images/leftico04.png" /></span>居民收费查询
			</div>
			<ul class="menuson">
				<li><cite></cite><a href="admin/paymentList"
					target="rightFrame">固定费用收费查询</a><i></i></li>
				<li><cite></cite><a href="admin/paymentNoFixedList"
					target="rightFrame">非固定费用收费查询</a><i></i></li>
				<li><cite></cite><a href="admin/parkkingMoneyList"
					target="rightFrame">车位费用收费查询</a><i></i></li>
			</ul>
		</dd>

		<dd>
			<div class="title">
				<span><img src="images/leftico04.png" /></span>居民付费管理
			</div>
			<ul class="menuson">
				<li><cite></cite><a href="admin/paymentList!costInit"
					target="rightFrame">固定类费用付费管理</a><i></i></li>
				<li><cite></cite><a
					href="admin/paymentNoFixedList!costInit_NoFixed"
					target="rightFrame">非固定类费用付费管理</a><i></i></li>
				<li><cite></cite><a href="admin/parkkingMoneyList!parkTypeInit"
					target="rightFrame">车位费用付费管理</a><i></i></li>
				<li><cite></cite><a href="admin/completeCostList"
					target="rightFrame">居民补款管理</a><i></i></li>
			</ul>
		</dd>

		<dd>
			<div class="title">
				<span><img src="images/leftico04.png" /></span>额外费用管理
			</div>
			<ul class="menuson">
				<li><cite></cite><a href="admin/deliveryMoneyList"
					target="rightFrame">代收快递费用管理</a><i></i></li>
			</ul>
		</dd>

		<dd>
			<div class="title">
				<span><img src="images/leftico04.png" /></span>小区快递管理
			</div>
			<ul class="menuson">
				<li><cite></cite><a href="admin/deliveryFirmList"
					target="rightFrame">快递公司管理</a><i></i></li>
				<li><cite></cite><a href="admin/deliveryInfoList"
					target="rightFrame">代收快递信息管理</a><i></i></li>
			</ul>
		</dd>

		<dd>
			<div class="title">
				<span><img src="images/leftico04.png" /></span>系统管理
			</div>
			<ul class="menuson">
				<li><cite></cite><a href="admin/userList" target="rightFrame">用户管理</a><i></i></li>
			</ul>
		</dd>

	</dl>
</body>
</html>
