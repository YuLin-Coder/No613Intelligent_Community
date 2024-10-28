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
<link rel="stylesheet" href="css/jquery-ui.css" />
<!-- 模态框样式控制 -->

<script type="text/javascript" src="js/jquery-1.4.2.min.js"></script>
<script type="text/javascript" src="js/jquery.watermark.min.js"></script>
<script type="text/javascript" src="js/jquery-ui-1.8.12.custom.min.js"></script>
<!-- 模态框插件 -->
<script type="text/javascript"  src="scripts/My97DatePicker/WdatePicker.js"></script>
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

		//  点击系部添加图片按钮-----start----------
		$('#addInfo')
				.click(
						function() {
							$('#txtBuildingId').attr("disabled", false);//启用系部编号文本框
							$('div#buildingInfo')
									.dialog(
											{ // 显示添加系部模态框  -----start----------			
												title : "添加工作人员",
												resizable : false,
												width : 440,
												height : 355,
												modal : true,
												buttons : {
													"确定" : function() {
														if (submitCheck() == false) {//客户端验证未通过
															return;
														}
														$
																.post(
																		'admin/buildingList!existed', //Ajax请求目标地址
																		{
																			'id' : $(
																					'#txtBuildingId')
																					.val()
																		//JSON参数
																		},
																		function(
																				response) {
																			if (Number(response) > 0) { //已存在  		
																				$(
																						'#message')
																						.text(
																								"该编号已存在，不能重复添加！");
																			} else { //如果不存在
																				$(
																						"#buildingForm")
																						.attr(
																								"action",
																								"admin/buildingList!add"); //设置form的action属性
																				$(
																						"#buildingForm")
																						.submit(); //提交form
																			}
																		});

													},
													"取消" : function() {
														clearbuildingForm(); //清空
														$(this).dialog("close");//关闭模态框
													}
												}
											}); //  显示添加系部模态框    -----end----------
						});//  点击系部添加图片按钮-----end----------
						
		//编辑信息
		$('table#buildingList span.spanEdit').click(function(){
			$.getJSON(			//加载数据-----start----------
					"admin/buildingList!getBuildingModel",
					{
						"id":$(this).attr("data-custom")
					},
					function(json){     //加载数据 回调函数-----start----------
						$('#txtBuildingId').val(json.buildingId);  //加载初始值
						$('#txtBuildingName').val(json.buildingName);  //加载初始值
						if(json.face=="朝东"){
							$('#dong').attr("checked",true);
						}else if(json.face=="朝南"){
							$('#nan').attr("checked",true);
						}else if(json.face=="朝西"){
							$('#xi').attr("checked",true);
						}else{
							$('#bei').attr("checked",true);
						}//加载初始值
						$('#txtBuildArea').val(json.buildArea);  //加载初始值
						$('#txtFloorNum').val(json.floorNum);  //加载初始值
						$('#txtHeight').val(json.height);  //加载初始值
						$('#txtBuildTime').val(toDate(json.buildTime,"yyyy-MM-dd hh:mm:ss"));  //加载初始值
						if(json.type=="门面"){
							$('#isType').attr("checked",true);
						}else{
							$('#noType').attr("checked",true);
						}//加载初始值
						$('#selVillageName').val(json.villageInfoModel.villageId);  //加载初始值
						
						$('#txtBuildingId').attr("readonly",true);   //费用编号文本框不可用
						$('div#buildingInfo').dialog({        //弹出编辑框-----start----------				
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
									$("#buildingForm").attr("action","admin/buildingList!edit");   //设置form的action属性
									$("#buildingForm").submit();   //提交form
								},
								"取消": function() {
									clearbuildingForm();  //清空
									$( this ).dialog( "close" );
								}
							}
						});			//弹出编辑框-----end----------	
					}			//加载数据 回调函数-----end----------
				);			//加载数据-----end----------	
		});
		
		//全选
		$(".selectall:checkbox").click(function() {
			$(".ckbBuilding:checkbox").attr("checked",$(".selectall:checkbox").attr("checked"));
		});
		
		//删除所选
		$('#delSelect').click(function() {
			if (confirm("确定删除所选？")) {
				$('#formData').attr("action",
						"admin/buildingList!deleteBuildingLists");
				$('#formData').submit();
			} else {
			}
		});

		//添加水印
		$('#txtKeywords').watermark("- - -请输入筛选条件- - -");
		//条件筛选
		$('#txtKeywords').keyup(function() {
			$("table#buildingList tr.trZebra").each(function() {
				var txtKeywords = $('#txtKeywords').val();
				if ($(this).text().indexOf(txtKeywords) == -1) {
					$(this).hide();
				} else {
					$(this).show();
				}
			});
		});
	});

Date.prototype.format = function(format) {

    /*
     * format="yyyy-MM-dd hh:mm:ss";
     */
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
            format = format.replace(RegExp.$1, (this.getFullYear() + "").substr(4- RegExp.$1.length));
        }
    for (var k in o) {
        if (new RegExp("(" + k + ")").test(format)){
            format = format.replace(RegExp.$1, RegExp.$1.length == 1? o[k]:("00" + o[k]).substr(("" + o[k]).length));
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
	function clearbuildingForm() {
		$('#txtBuildingId').val('');
		$('#txtBuildingName').val('');
		$('#txtFace').val('');
		$('#txtBuildArea').val('');
		$('#txtFloorNum').val('');
		$('#txtHeight').val('');
		$('#txtBuildTime').val('');
		$('#selVillageName').val('');
		$("#txtBuildingId+span").text('');
		$("#txtBuildingName+span").text('');
		$("#txtFace+span").text('');
		$("#txtBuildArea+span").text('');
		$("#txtFloorNum+span").text('');
		$("#txtHeight+span").text('');
		$("#txtBuildTime+span").text('');
		$("#selVillageName+span").text('');
		$('#message').text('');
	}

	//添加或编辑系部信息时的客户端检查
	function submitCheck() {
		if ($.trim($("#txtBuildingId").val()) == "") {
			$("#txtBuildingId+span").text("请输入楼房编号！");
			return false;
		}
		var i = /^[0-9]*[1-9][0-9]*$/;
		if (!$.trim($("#txtBuildingId").val()).match(i)) {
			$("#txtBuildingId+span").text("编号必须是正整数！");
			$('#txtBuildingId').focus();
			return false;
		}
		$("#txtBuildingId+span").text(''); //清空

		if ($.trim($("#txtBuildingName").val()) == "") {
			$("#txtBuildingName+span").text("请输入楼房名称！");
			return false;
		}
		$("#txtBuildingName+span").text(''); //清空
		
		if ($.trim($("#txtBuildArea").val()) == "") {
			$("#txtBuildArea+span").text("请输入建筑面积！");
			return false;
		}
		$("#txtBuildArea+span").text(''); //清空
		
		if ($.trim($("#txtFloorNum").val()) == "") {
			$("#txtFloorNum+span").text("请输入楼房层数！");
			return false;
		}
		$("#txtFloorNum+span").text(''); //清空
		
		if ($.trim($("#txtHeight").val()) == "") {
			$("#txtHeight+span").text("请输入高度！");
			return false;
		}
		$("#txtHeight+span").text(''); //清空
		
		if ($.trim($("#txtBuildTime").val()) == "") {
			$("#txtBuildTime+span").text("请输入建成时间！");
			return false;
		}
		/* var dataTest = /^\s*$|^\d{4}\-\d{1,2}\-\d{1,2}\s{1}(\d{1,2}:){2}\d{1,2}$/; */
		/* if ($("#txtBuildTime").val()) {
			$("#txtBuildTime+span").text("时间格式不正确！");
			$('#txtBuildTime').focus();
			return false;
		}
		$("#txtBuildTime+span").text(''); //清空 */
		
		if ($.trim($("#selVillageName").val()) == "-1") {
			$("#selVillageName+span").text("请选择所属小区！");
			return false;
		}
		$("#selVillageName+span").text(''); //清空

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
			<li><a href="admin/costList">楼房管理</a></li>
			<li>基本内容</li>
		</ul>
	</div>
	<!-- 导航栏结束 -->
	<!-- 信息添加开始 -->
	<div id="buildingInfo" style="display: none;">
		<form id="buildingForm" action="admin/buildingList" method="post">
			&nbsp;楼房编号：<input type="text" id="txtBuildingId" name="model.buildingId" title="请输入楼房编号。" /> 
			<span class='validate'></span><br /> <br /> 
			&nbsp;楼房名称：<input type="text" id="txtBuildingName" name="model.buildingName" title="请输入楼房名称。" /> 
			<span class='validate'></span> <br /> <br /> 
			&nbsp;朝向：&nbsp;&nbsp;<input id="dong" name="model.face" type="radio" checked="checked" value="朝东" >朝东
								  <input id="nan" name="model.face" type="radio" value="朝南" >朝南
								  <input id="xi" name="model.face" type="radio" value="朝西" >朝西
								  <input id="bei" name="model.face" type="radio" value="朝北" >朝北
			<span class='validate'></span> <br /> <br />
			&nbsp;建筑面积：<input type="text" id="txtBuildArea" name="model.buildArea" title="请输入楼房建筑面积。" /> 
			<span class='validate'></span> <br /> <br />
			&nbsp;楼房层数：<input type="text" id="txtFloorNum" name="model.floorNum" title="请输入楼房层数。" /> 
			<span class='validate'></span> <br /> <br />
			&nbsp;高度：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="text" id="txtHeight" name="model.height" title="请输入楼房高度。" /> 
			<span class='validate'></span> <br /> <br />
			&nbsp;建成时间：<input  onclick="return WdatePicker({'dateFmt':'yyyy-MM-dd HH:mm:ss'})" type="text" id="txtBuildTime" name="model.buildTime" title="请输入楼房建成时间。" /> 
			<span class='validate'></span> <br /> <br />
			&nbsp;类别：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input id="isType" name="model.type" type="radio" checked="checked" value="门面" >门面
					    <input id="noType" name="model.type" type="radio" value="非门面" >非门面 
			<span class='validate'></span> <br /> <br />
			&nbsp;所属小区名称：<select id="selVillageName" name="model.villageInfoModel.villageId">
								<option value="-1">---请选择小区 ---</option>
									<s:iterator var="item" value="villageInfoList">
										<option value="${ item.villageId}">${item.villageName}</option>
									</s:iterator>
						   </select>  
			<span class='validate'></span> <br /> <br />
			<span id="message" class='validate'></span>
		</form>
	</div>

	<!-- 信息添加结束-->
	<!-- form表单开始 -->
	<form id="formData" action="admin/buildingList" method="post"
		onsubmit="return check()">
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
						class="shezhi" type="submit" value="设置" /></li>
				</ul>
			</div>
			<!-- 工具栏结束 -->
			<!-- table表格数据开始 -->
			<table id="buildingList" class="tablelist"
				style="text-align: center;">
				<thead>
					<tr>
						<th><input name="" type="checkbox" value="" class="selectall"/></th>
						<th>序号</th>
						<th>楼房编号</th>
						<th>楼房名称</th>
						<th>朝向</th>
						<th>建筑面积</th>
						<th>层数</th>
						<th>高度</th>
						<th>建成时间</th>
						<th>类别</th>
						<th>小区名称</th>
						<th>操作</th>
					</tr>
				</thead>
				<tbody>
					<s:iterator var="item" value="buildingList" status="stat">
						<tr class="trZebra">
							<td><input name="delBuilding" type="checkbox" class="ckbBuilding" value="${item.buildingId }" /></td>
							<td><s:property value="#stat.index+1" /></td>
							<td><s:property value="#item.buildingId" /></td>
							<td><s:property value="#item.buildingName" /></td>
							<td><s:property value="#item.face" /></td>
							<td><s:property value="#item.buildArea" /></td>
							<td><s:property value="#item.floorNum" /></td>
							<td><s:property value="#item.height" /></td>
							<td><s:property value="#item.buildTime" /></td>
							<td><s:property value="#item.type" /></td>
							<td><s:property value="#item.villageInfoModel.villageName" /></td>
							<td><span class="spanEdit blue-pointer" data-custom='${ item.buildingId }'><img
									src="images/application_edit.png" title="修改" />
								</span>&nbsp;&nbsp;<a
								onclick="return confirm('确定删除该条信息？');"
								href="admin/buildingList!delInfo?id=<s:property value="#item.buildingId" />"><img
									src="images/application_delete.png" title="删除" /></a></td>
						</tr>
					</s:iterator>
				</tbody>
			</table>
			<!-- table表格数据结束 -->
			<s:set var="actionName" value="'admin/buildingList'"></s:set>
			<s:include value="../inc/pager.jsp"></s:include>
		</div>
	</form>
	<!-- form表单结束 -->
	<script type="text/javascript">
		$('.tablelist tbody tr:odd').addClass('odd');
	</script>
</body>
<s:include value="../inc/tips.jsp"></s:include>
</html>
