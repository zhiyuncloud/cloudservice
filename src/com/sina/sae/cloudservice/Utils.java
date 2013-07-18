package com.sina.sae.cloudservice;

import java.math.BigInteger;
import java.security.MessageDigest;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

import com.sina.sae.util.SaeUserInfo;

/**
 * 工具类
 */
public class Utils {

	public static String debugToken ;
	
	static{
		changeDebugToken();
	}
	
	
	/**
	 * 重新生成debugToken
	 * @return
	 */
	public static String changeDebugToken(){
		String token = "debug_token_"+System.currentTimeMillis();
		debugToken = md5(token);
		return debugToken;
	}
	
	/**
	 * 重新生成debugToken
	 * @return
	 */
	public static void disabledDebugToken(){
		debugToken = "";
	}
	
	/**
	 * 将需要返回的数据组成json格式
	 * 形如{"code":4000,"message":"success","data":{"className":"user","name":"lizy","age":"23","sex":"man"}}
	 * @param data 数据
	 * @param code 错误码
	 * @param message 错误信息
	 * @return
	 */
	public static String toData(String data,int code,String message){
		StringBuilder sb = new StringBuilder();
		sb.append("{\"code\":").append(code).append(",\"message\":\"").append(message).append("\"");
		if(data!=null){
			sb.append(",\"data\":").append(data);
		}
		sb.append("}");
		return sb.toString();
	}
	
	/**
	 * 验证是否为整数
	 * @param str
	 * @return
	 */
	public static boolean checkInteger(String str) {  
		try {  
			if(null==str)return false;
	        Integer.parseInt(str);  
	     } catch (Exception ex) {  
	         return false;  
	     }  
	     return true;  
	}  
	
	/**
	 * 将Map<String,Object>转换为Map<String,String> 
	 * 其中Object为byte[] 主要用于kvdb的list接口出来的Map
	 * 因为kvdb中存储的是byte[]而非String
	 * @param map 需要转换的map
	 * @return
	 */
	public static Map<String,String> changeToStringMap(Map<String,Object> map){
		Map<String,String> retMap = new HashMap<String,String>();
		if(null!= map){
			Set<String> keys = map.keySet();
			for(String key:keys){
				retMap.put(key, new String((byte[])map.get(key)));
			}
		}
		return retMap;
	}
	
	/**
	 * 将List<String>转换为List<Map>
	 * 因为storage的list接口返回的是文件列表，这里重新瓶装一下再返回
	 * @param list  转换的list
	 * @param domain 域名称
	 * @return
	 */
	public static List<Map<String,String>> changeToMapList(List<String> list,String domain){
		List<Map<String,String>> retList = new ArrayList<Map<String,String>>();
		Map<String,String> map;
		for(String path:list){
			map = new HashMap<String,String>();
			map.put("filepath", path);
			map.put("url", "http://"+SaeUserInfo.getAppName()+"-"+domain+".stor.sinaapp.com/"+path);
			retList.add(map);
		}
		return retList;
	}
	
	/**
	 * 对字符串进行md5加密
	 * @param password 加密字符串
	 * @return 返回加密结果
	 */
	public static String md5(String password) {
		try {
			MessageDigest md = MessageDigest.getInstance("md5");
			md.update(password.getBytes());
			return  new BigInteger(1, md.digest()).toString(16);
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
	

	/**
	 * 将指定的内容进行加密，采用HmacSHA256方式加密，加密后再对内容进行Base64编码
	 * @param cryptoType 加密的类型
	 * @param content 需要加密的内容
	 * @param secretKey 加密所需的Key
	 * @return 加密后的数据
	 */
	public static String calcSignature(String content,String secretKey) {
        try {
			Mac mac = Mac.getInstance("HmacSHA256");
	        SecretKeySpec secret = new SecretKeySpec(secretKey.getBytes(),"HmacSHA256");
	        mac.init(secret);
	        byte[] digest = mac.doFinal(content.getBytes());
	        sun.misc.BASE64Encoder encode = new sun.misc.BASE64Encoder();
			return encode.encode(digest);
        } catch(Exception e) {
        	e.printStackTrace();
        	return null;
        }
	}
	
}
