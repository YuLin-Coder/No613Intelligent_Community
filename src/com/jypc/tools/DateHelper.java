package com.jypc.tools;  

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class DateHelper {
	
	/**
	 * 将字符串格式的日期转换成日期格式
	 * @param strDate  字符串格式的日期
	 * @param format 转换格式，如yyyy-MM-dd等，y代表年，M代表月，d代表日，注意大小写。yyyy-MM-dd格式如：2011-10-09这样的格式
	 * @return
	 */
	public static Date ConvertStringToDate(String strDate, String format){
		SimpleDateFormat dateFormat = new SimpleDateFormat(format);
        Date result = null;
        try{
        	result = dateFormat.parse(strDate);
        }
        catch(ParseException e){
            e.printStackTrace();
        }
        return result;
	}
	
	
	/**
	 * 将字日期格式转换成符串格式的日期
	 * @param date  待转换的日期
	 * @param format 转换格式，如yyyy-MM-dd等，y代表年，M代表月，d代表日，注意大小写。yyyy-MM-dd格式如：2011-10-09这样的格式
	 * @return 对应格式的日期字符串
	 */
	public static String ConvertDateToFormatString(Date date, String format){
		SimpleDateFormat dateFormat = new SimpleDateFormat(format);		
        return  dateFormat.format(date);
	}
	
	
}
