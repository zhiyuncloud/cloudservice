package com.sina.sae.cloudservice.web;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileItemFactory;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.log4j.Logger;

import com.sina.sae.cloudservice.Utils;
import com.sina.sae.storage.SaeStorage;

/**
 * Rest接口（File）
 * 对应sae后端的Storage服务
 * 用于存储文件
 */
public class FileRest extends HttpServlet {
	
	private static final long serialVersionUID = 1L;

	private static Logger logger = Logger.getLogger(FileRest.class.getName());
	
	//文件存储在storage使用的domain
	public static final String DOMAIN = "cloud";
	
	/**
	 * 包含get和list两个接口(通过参数来判定使用哪个接口)
	 * get接口参数=>path
	 * list接口参数=>count
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String path = request.getParameter("path");//文件路径
		String prefix = request.getParameter("prefix");//文件前缀
		String count = request.getParameter("count");//list数量
		String skip = request.getParameter("skip");//list起始数
		PrintWriter writer = response.getWriter();
		SaeStorage storage = new SaeStorage();
		if(null!=path){//获取单个文件信息
			boolean exists = storage.fileExists(DOMAIN, path);
			String data;
			if(exists){//文件存在
				String url = storage.getUrl(DOMAIN, path);
				data = Utils.toData("{\"filepath\":\""+path+"\",\"url\":\""+url+"\"}", 0, "Success");
			}else{//文件不存在
				data = Utils.toData(null, 0, "file not exists");
			}
			logger.debug("getFile:"+data);
			writer.write(data);
		}else if(null!=count&&Utils.checkInteger(count)&&(skip==null||(skip!=null&&Utils.checkInteger(skip)))){//list文件信息
			int start = 0;
			if(Utils.checkInteger(skip))start = Integer.parseInt(skip);
			if(null==prefix)prefix = "";
			List<String> files = storage.getList(DOMAIN, prefix, Integer.parseInt(count), start);
			String data = Utils.toData(JSONArray.fromObject(Utils.changeToMapList(files, DOMAIN)).toString(), storage.getErrno(), storage.getErrno()==0?"success":storage.getErrmsg());;
			logger.debug("listFile count:"+count+"|prefix:"+prefix+"|skip:"+skip+"|data:"+data);
			writer.write(data);
		}else{
			writer.write(Utils.toData(null,1002,"bad parameter"));//参数不符合规范返回值
		}
		writer.close();
	}
	
	
	/**
	 * 包含save接口 保存文件至云端
	 * 为了代码可读性 这里使用commons-fileupload 上传文件
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		PrintWriter writer = response.getWriter();
		String contentType=request.getContentType();
		if(ServletFileUpload.isMultipartContent(request)){//检查输入请求是否为multipart表单数据
			try {
				FileItemFactory factory = new DiskFileItemFactory();
				ServletFileUpload upload = new ServletFileUpload(factory);
				List<FileItem> items = upload.parseRequest(request);// 得到所有的文件
				if (items != null && items.size() > 0) {
					FileItem item = items.get(0);// 仅处理第一个
					SaeStorage storage = new SaeStorage();
					//注意这里使用的是getFieldName 而不是文件的真实名称考虑到文件名中可能包含路径
					boolean flag = storage.write(DOMAIN, item.getFieldName(), item.get());
					logger.debug("saveFile filename:"+item.getFieldName()+"|flag:"+flag);
					writer.write(Utils.toData(null,storage.getErrno(),storage.getErrno()==0?"success":storage.getErrmsg()));
				}
			} catch (FileUploadException e) {
				logger.debug("saveFile field:"+e.getMessage());
				writer.write(Utils.toData(null,1002,"parse Request file Field"+e.getMessage()));
			}
		}else{
			writer.write(Utils.toData(null,1002,"bad parameter")+contentType);//参数不符合规范返回值
		}
		writer.close();
	}


	/**
	 * 包含delete接口 删除云端文件
	 */
	protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String path = request.getParameter("path");//list起始数
		PrintWriter writer = response.getWriter();
		if(null!=path){//获取单个文件信息
			SaeStorage storage = new SaeStorage();
			boolean flag = storage.delete(DOMAIN, path);
			logger.debug("deleteFile:"+flag);
			if(flag)
				writer.write(Utils.toData(null,0,"Success"));
			else
				writer.write(Utils.toData(null,storage.getErrno(),storage.getErrno()==0?"success":storage.getErrmsg()));
		}else{
			writer.write(Utils.toData(null,1002,"bad parameter"));//参数不符合规范返回值
		}
		writer.close();
	}

}
