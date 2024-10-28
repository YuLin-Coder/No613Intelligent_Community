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
	
		//添加信息
		$('#addInfo').click(function(){			//------添加按钮开始------
			$('#txtDutyId').focus();
			$('#txtDutyId').attr("disabled",false);
			$('#dutyInfo').dialog({			//------弹出模态框开始------
				title:"添加信息",
				resizable: false,
				width:420,
				height:550,
				modal: true,
				buttons: {			//------按钮事件开始------
					"保存": function() {
						if(submitCheck()==false){
							return;
						}else{
							$.post(
								'admin/dutyList!existed',//Ajax请求目标地址
								{ 
									'id':$('#txtDutyId').val()     //JSON参数
								},
								function(response){
								  	if(Number(response)>0){			 //已存在  		
								  		$('#txtDutyId+span').text("该编号已存在！");
								  		$('#txtDutyId').focus();
								  	}
								  	else{    //如果不存在
								  		$("#dutyForm").attr("action","admin/dutyList!add");   //设置form的action属性
								  		$("#dutyForm").submit();   //提交form
								  	}
							  	}
							);//post结束
						}//else结束
					},
					"取消": function() {
						clearDutyForm();
						$( this ).dialog( "close" );
					}
				}//------按钮结束开始------
			});//------弹出模态框结束------
		});//------添加按钮结束------
						
		//编辑信息
		$('table#dutyList span.spanEdit').click(function(){
			$.getJSON(			//加载数据-----start----------
					"admin/dutyList!getDutyModel",
					{
						"id":$(this).attr("data-custom")
					},
					function(json){     //加载数据 回调函数-----start----------
						$('#txtDutyId').val(json.dutyId);  //加载初始值
						$('#txtDutyName').val(json.dutyName);  //加载初始值
						$('#selWorkerName').val(json.workerModel.workerId);  //加载初始值
						$('#txtStartTime').val(toDate(json.startTime,"yyyy-MM-dd hh:mm:ss"));  //加载初始值
						$('#txtEndTime').val(toDate(json.endTime,"yyyy-MM-dd hh:mm:ss"));  //加载初始值
						$('#txtPlace').val(json.place);  //加载初始值
						if(json.sign=="是"){
							$('#is').attr("checked",true);
						}else{
							$('#no').attr("checked",true);
						}//加载初始值
						$('#txtDutyId').attr("readonly",true);   //费用编号文本框不可用
						$('div#dutyInfo').dialog({        //弹出编辑框-----start----------				
							title:"修改信息",
							resizable: false,
							width:420,
							height:550,
							modal: true,
							buttons: {
								"更新": function() {
									if(submitCheck()==false){  //客户端验证未通过
										return;
									}
									$("#dutyForm").attr("action","admin/dutyList!edit");   //设置form的action属性
									$("#dutyForm").submit();   //提交form
								},
								"取消": function() {
									clearDutyForm();  //清空
									$( this ).dialog( "close" );
								}
							}
						});			//弹出编辑框-----end----------	
					}			//加载数据 回调函数-----end----------
				);			//加载数据-----end----------	
		});
		
		//全选
		$(".selectall:checkbox").click(function() {
			$(".ckbDuty:checkbox").attr("checked",$(".selectall:checkbox").attr("checked"));
		});
		
		//删除所选
		$('#delSelect').click(function() {
			if (confirm("确定删除所选？")) {
				$('#formData').attr("action",
						"admin/dutyList!deleteDutyLists");
				$('#formData').submit();
			} else {
			}
		});

		//添加水印
		$('#txtKeywords').watermark("- - -请输入筛选条件- - -");
		//条件筛选
		$('#txtKeywords').keyup(function() {
			$("table#dutyList tr.trZebra").each(function() {
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
	function clearDutyForm() {
		$('#txtDutyId').val('');
		$('#selWorkerName').val('');
		$('#txtStartTime').val('');
		$('#txtEndTime').val('');
		$('#txtPlace').val('');
		$("#txtDutyId+span").text('');
		$("#txtDutyName+span").text('');
		$("#txtStartTime+span").text('');
		$("#txtEndTime+span").text('');
		$("#txtPlace+span").text('');
		$('#message').text('');
	}

	//添加或编辑系部信息时的客户端检查
	function submitCheck() {
		if ($.trim($("#txtDutyId").val()) == "") {
			$("#txtDutyId+span").text("请输入值班人员编号！");
			return false;
		}
		var i = /^[0-9]*[1-9][0-9]*$/;
		if (!$.trim($("#txtDutyId").val()).match(i)) {
			$("#txtDutyId+span").text("编号必须是正整数！");
			$('#txtDutyId').focus();
			return false;
		}
		$("#txtDutyId+span").text(''); //清空

		if ($.trim($("#selWorkerName").val()) == "-1") {
			$("#selWorkerName+span").text("请选择值班人员姓名！");
			return false;
		}
		$("#selWorkerName+span").text(''); //清空
		
		if ($.trim($("#txtStartTime").val()) == "") {
			$("#txtStartTime+span").text("请输入开始时间！");
			return false;
		}
		
		var i = /^(\d{4}|\d{2})-((1[0-2])|(0?[1-9]))-(([12][0-9])|(3[01])|(0?[1-9])) ((1|0?)[0-9]|2[0-3]):([0-5][0-9]):([0-5][0-9])*$/;
		if (!$.trim($("#txtStartTime").val()).match(i)) {
			$("#txtStartTime+span").text("时间格式不正确！");
			$('#txtStartTime').focus();
			return false;
		}
		$("#txtStartTime+span").text(''); //清空
		
		if ($.trim($("#txtEndTime").val()) == "") {
			$("#txtEndTime+span").text("请输入结束时间！");
			return false;
		}
		var i = /^(\d{4}|\d{2})-((1[0-2])|(0?[1-9]))-(([12][0-9])|(3[01])|(0?[1-9])) ((1|0?)[0-9]|2[0-3]):([0-5][0-9]):([0-5][0-9])*$/;
		if (!$.trim($("#txtEndTime").val()).match(i)) {
			$("#txtEndTime+span").text("时间格式不正确！");
			$('#txtEndTime').focus();
			return false;
		}
		$("#txtEndTime+span").text(''); //清空
		
		if ($.trim($("#txtPlace").val()) == "") {
			$("#txtPlace+span").text("请输入值班地点！");
			return false;
		}
		$("#txtPlace+span").text(''); //清空

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
			<li><a href="admin/costList">值班人员管理</a></li>
			<li>基本内容</li>
		</ul>
	</div>
	<!-- 导航栏结束 -->

	<!-- 信息添加开始 -->
	<div id="dutyInfo" style="display: none;">
		<form id="dutyForm" action="admin/dutyList" method="post">
			&nbsp;值班人员编号：<input type="text" id="txtDutyId" name="model.dutyId" title="请输入值班人员编号。" /> 
			<span class='validate'></span>
			<br /> <br />
			&nbsp;值班人员编号：<input type="text" id="txtDutyName" name="model.dutyName" title="请输入值班人员编号。" /> 
			<span class='validate'></span>
			<br /> <br />
			 &nbsp;工作人员姓名：<select id="selWorkerName" name="model.workerModel.workerId">
								<option value="-1">---请选择值班人员 ---</option>
									<s:iterator var="item" value="workerList">
										<option value="${ item.workerId}">${item.workerName}</option>
									</s:iterator>
						   </select>  
			<span class='validate'></span>
			 <br /> <br />
			&nbsp;值班开始时间：<input  onclick="return  WdatePicker({'dateFmt':'yyyy-MM-dd HH:mm:ss'})" type="text" id="txtStartTime" name="model.startTime" title="请输入值班开始时间。" class="input date"/> 
			<span class='validate'></span>
			 <br /> <br />
			&nbsp;值班结束时间：<input  onclick="return  WdatePicker({'dateFmt':'yyyy-MM-dd HH:mm:ss'})" type="text" id="txtEndTime" name="model.endTime" title="请输入值班结束时间。" class="input date" /> 
			<span class='validate'></span> 
			<br /> <br />
			&nbsp;值班地点：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="text" id="txtPlace" name="model.place" title="请输入值班地点。" /> 
			<span class='validate'></span>
			 <br /> <br />
			&nbsp;是否签到：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input id="is" name="model.sign" type="radio" checked="checked" value="是" >是
					    <input id="no" name="model.sign" type="radio" value="否" >否 
			<span class='validate'></span>
			<br /> <br />
			<span id="message" class='validate'></span>
		</form>
	</div>

	<!-- 信息添加结束-->

	<form id="formData" action="admin/dutyList" method="post"
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
			<table id="dutyList" class="tablelist" style="text-align: center;">
				<thead>
					<tr>
						<th><input name="" type="checkbox"  type="checkbox" class="selectall" /></th>
						<th>序号</th>
						<th>值班人员编号</th>
						<th>值班人员姓名</th>
						<th>值班开始时间</th>
						<th>值班结束时间</th>
						<th>值班地点</th>
						<th>是否签到</th>
						<th>操作</th>
					</tr>
				</thead>
				<tbody>
					<s:iterator var="item" value="dutyList" status="stat">
						<tr class="trZebra">
							<td><input name="delDuty" type="checkbox" value="${item.dutyId }" class="ckbDuty"/></td>
							<td><s:property value="#stat.index+1" /></td>
							<td><s:property value="#item.dutyId" /></td>
							<td><s:property value="#item.workerModel.workerName" /></td>
							<td><s:property value="#item.startTime" /></td>
							<td><s:property value="#item.endTime" /></td>
							<td><s:property value="#item.place" /></td>
							<td><s:property value="#item.sign" /></td>
							<td><span class="spanEdit blue-pointer"
								data-custom='${ item.dutyId }'><img
									src="images/application_edit.png" title="修改" /> </span>&nbsp;&nbsp;<a
								onclick="return confirm('确定删除该条信息？');"
								href="admin/dutyList!delInfo?id=<s:property value="#item.dutyId" />"><img
									src="images/application_delete.png" title="删除" /></a></td>
						</tr>
					</s:iterator>
				</tbody>
			</table>
			<!-- table表格数据结束 -->
			<s:set var="actionName" value="'admin/dutyList'"></s:set>
			<s:include value="../inc/pager.jsp"></s:include>
		</div>
	</form>
	<script type="text/javascript">
		$('.tablelist tbody tr:odd').addClass('odd');
	</script>
</body>
<s:include value="../inc/tips.jsp"></s:include>
</html>
