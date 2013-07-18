package com.sina.sae.cloudservice.web;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import org.apache.log4j.Logger;

import com.sina.sae.cloudservice.Utils;
import com.sina.sae.kvdb.SaeKV;
import com.sina.sae.kvdb.SaeKVUtil;

/**
 * Rest接口（Object）
 * 对应sae后端的kvdb服务
 * 存储数据为对象的json格式
 */
public class ObjectRest extends HttpServlet {
	
	private static final long serialVersionUID = 1L;

	private static Logger logger = Logger.getLogger(ObjectRest.class.getName());
	
	/**
	 * 包含get和list两个接口(通过参数来判定使用哪个接口)
	 * get接口参数=>key
	 * count接口参数=>prefix、count、compare
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String key = request.getParameter("key");//查找的key
		String prefix = request.getParameter("prefix");//前缀
		String count = request.getParameter("count");//取值数量
		String compare = request.getParameter("compare");//比较的key
		PrintWriter writer = response.getWriter();
		SaeKV kv = new SaeKV();
    	kv.init();
		if(key!=null){//get接口
			String value = null;
			byte[] bs = kv.get(key);
			if(bs!=null){
				value = SaeKVUtil.byteToString(bs);
			}
			writer.write(Utils.toData(value,kv.getErrCode(),kv.getErrMsg()));
			logger.debug("getObject key:"+key+" |value:"+value);
		}else if(count!=null&&Utils.checkInteger(count)){//list接口
			if(null==prefix)prefix = "";
			Map<String, Object> map = kv.pkrget(prefix, Integer.parseInt(count), compare);
			//因为存储在kvdb中的都是byte[]需要将其转换为String
			String data = JSONObject.fromObject(Utils.changeToStringMap(map)).toString();
			writer.write(Utils.toData(data,kv.getErrCode(),kv.getErrMsg()));
			logger.debug("listObject count:"+count+" |prefix:"+prefix+"|compare:"+compare+"|data:"+data);
		}else{
			writer.write(Utils.toData(null,1002,"bad parameter"));//参数不符合规范返回值
		}
		writer.close();
	}

	
	/**
	 * 包含save接口 保存数据至云端
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		PrintWriter writer = response.getWriter();
    	String key = request.getParameter("key");//保存的key
    	String data = request.getParameter("data");//保存的value
    	if(key!=null&&data!=null){
    		SaeKV kv = new SaeKV();
    		kv.init();
    		kv.set(key, SaeKVUtil.StringToByte(data));
    		writer.write(Utils.toData(null,kv.getErrCode(),kv.getErrMsg()));
    		logger.debug("saveObject key:"+key+" |data:"+data);
    	}else{
    		writer.write(Utils.toData(null,1002,"bad parameter"));//参数错误返回
		}
		writer.close();
	}


	/**
	 * 包含delete接口 删除云端数据
	 */
	protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		PrintWriter writer = response.getWriter();
    	String key = request.getParameter("key");//需要删除的key
    	if(key!=null){
    		SaeKV kv = new SaeKV();
    		kv.init();
    		kv.delete(key);
    		writer.write(Utils.toData(null,kv.getErrCode(),kv.getErrMsg()));
    		logger.debug("deleteObject key:"+key+" |code:"+kv.getErrCode());
    	}else{
    		writer.write(Utils.toData(null,1002,"bad parameter"));//参数错误返回
		}
		writer.close();
	}

}
