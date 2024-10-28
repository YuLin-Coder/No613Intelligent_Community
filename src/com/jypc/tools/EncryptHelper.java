package com.jypc.tools;

import java.security.MessageDigest;

public class EncryptHelper {
		/**
		 * MD5算法
		 * @param source  待加密的明文
		 * @return  加密后的字符串
		 */
	   public static String md5(String source) {    
		       StringBuffer sb = new StringBuffer(32);           
		       try {  
		           MessageDigest md    = MessageDigest.getInstance("MD5");  
		           byte[] array        = md.digest(source.getBytes("utf-8"));  
		                 
		           for (int i = 0; i < array.length; i++) {  
		               sb.append(Integer.toHexString((array[i] & 0xFF) | 0x100).toUpperCase().substring(1, 3));  
		           }  
		       } catch (Exception e) {  
		           return null;  
		       }  
		             
		       return sb.toString();  
	   }  
}
