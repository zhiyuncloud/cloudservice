package com.sina.sae.cloudservice.web;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import com.sina.sae.cloudservice.Utils;
import com.sina.sae.mail.SaeMail;

/**
 * Rest接口
 * 对应后端Mail服务
 */
public class MailRest extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	private static Logger logger = Logger.getLogger(MailRest.class.getName());

	/**
	 * 用于发送邮件接口
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String from = request.getParameter("from");
		String to = request.getParameter("to");
		String cc = request.getParameter("cc");
		String smtpHost = request.getParameter("smtpHost");
		String smtpUsername = request.getParameter("smtpUsername");
		String smtpPassword = request.getParameter("smtpPassword");
		String subject = request.getParameter("subject");
		String content = request.getParameter("content");
		String contentType = request.getParameter("contentType");
		String chartset = request.getParameter("chartset");
		String tls = request.getParameter("tls");
		String compress = request.getParameter("compress");
		PrintWriter writer = response.getWriter();
		if(null!=from&&null!=to&&null!=smtpHost&&null!=smtpUsername&&null!=smtpPassword&&null!=subject&&null!=content){//必选参数
			SaeMail mail = new SaeMail();
			if(null!=cc)mail.setCc(cc.split(";"));
			if(null!=contentType)mail.setContentType(contentType);
			if(null!=chartset)mail.setChartset(chartset);
			if(null!=compress)mail.setCompress(compress);
			if(null!=tls)mail.setTls(Boolean.parseBoolean(tls));
			mail.setFrom(from);
			mail.setTo(to.split(";"));//使用分号风开
			mail.setSmtpHost(smtpHost);
			mail.setSmtpUsername(smtpUsername);
			mail.setSmtpPassword(smtpPassword);
			mail.setSubject(subject);
			mail.setContent(content);
			mail.send();//发送邮件
			String data = Utils.toData(null, Integer.parseInt(mail.getErrno()), mail.getErrmsg());;
			logger.debug("send Mail from:"+from+"|to:"+to+"|cc:"+cc+"|smtpHost:"+smtpHost+
					"|smtpUsername:"+smtpUsername+"|smtpPassword:"+smtpPassword+"|subject:"+subject+
					"|content:"+content+"|contentType:"+contentType+"|chartset:"+chartset+"|tls:"+tls+"|compress:"+compress+"|data:"+data);
			writer.write(data);
		}else{
			writer.write(Utils.toData(null,1002,"bad parameter"));//参数不符合规范返回值
		}
		writer.close();
		
	}
	
}
