<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<script type="text/javascript">
	var tip="${tips}";
	if(tip!=""){
		$('<div><p>${tips}</p></div>').dialog({        //弹出编辑框-----start----------				
				title:"提示",
				resizable: false,
				width:300,
				height:200,
				modal: true,
				buttons: {
					"关闭": function() {
						$( this ).dialog( "close" );
					}
				}
			});       //弹出编辑框-----end----------
	}
</script>