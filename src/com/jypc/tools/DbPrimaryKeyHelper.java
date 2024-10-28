package com.jypc.tools;

import java.util.Date;
import java.util.Random;

/**
 * 生成数据库表的主键编号
 * @author CDD
 *
 */
public class DbPrimaryKeyHelper {

	/**
	 * 生成主键编号
	 * @return 编号：年月日时分秒毫秒+3位随机数
	 */
	public static String getKey(){
		
		Random r = new Random();
		int result = r.nextInt(1000);
		String prefix = DateHelper.ConvertDateToFormatString(new Date(), "yyyyMMddHHmmssSSS");
		
		return prefix + int2String(result,3);
	}
	
	/**
	 * 整型转字符串
	 * @param num 需要转换的整型值
	 * @param param 转换后的字符串长度，不足补0
	 */
	public static String int2String(int num,int param){
		return String.format("%1$0"+param+"d", num);
	}
	
}
