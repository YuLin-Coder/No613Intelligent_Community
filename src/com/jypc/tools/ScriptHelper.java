package com.jypc.tools;

public class ScriptHelper {

	/**
	 * 返回仅弹出对话框的拼接好的JavaScript拼接字符串
	 * @param msg 对话框中显示的信息
	 * @return JavaScript拼接字符串
	 */
	public static String Alert(String msg){
		return "<script language='javascript'>alert('" + msg + "');</script>";
	}
	
	/**
	 * 返回仅弹出对话框并且导向指定页面的拼接好的JavaScript拼接字符串
	 * @param msg 对话框中显示的信息
	 * @param url 需要导向的指定页面
	 * @return JavaScript拼接字符串
	 */
	public static String AlertAndRedirect(String msg,String url){
		return "<script language='javascript'>alert('" + msg + "');location.href='" + url + "';</script>";
	}
	
	
	/**
	 * 返回仅弹出对话框并且后退的拼接好的JavaScript拼接字符串
	 * @param msg 对话框中显示的信息
	 * @return JavaScript拼接字符串
	 */
	public static String AlertAndBack(String msg){
		return "<script language='javascript'>alert('" + msg + "');history.back();</script>";
	}
	
}
