package com.sina.sae.cloudservice.web;

import java.io.IOException;
import java.io.Writer;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;

import com.sina.sae.cloudservice.Utils;
import com.sina.sae.util.SaeUserInfo;
import com.sun.xml.internal.messaging.saaj.packaging.mime.internet.HeaderTokenizer.Token;

/**
 * 过滤REST和管理请求
 */
public class Auth implements Filter {

	private static Logger logger = Logger.getLogger(Auth.class.getName());
	
	private static String ak;
	private static String sk;
	
	public Auth() {
		ak =SaeUserInfo.getAccessKey();
		sk =SaeUserInfo.getSecretKey();
	}

	public void init(FilterConfig fConfig) throws ServletException {
	}
	
	public void destroy() {
	}

	public void doFilter(ServletRequest servletRequest,ServletResponse servletResponse, FilterChain chain)throws IOException, ServletException {
		HttpServletRequest request = (HttpServletRequest) servletRequest;
		HttpServletResponse response = (HttpServletResponse) servletResponse;
		response.setContentType("text/html; charset=gbk"); 
		String url = request.getRequestURI();
		String contextPath = request.getContextPath();
		if(url.contains(contextPath)){//remove contextPath
			url = url.replaceFirst(contextPath, "");
		}
		if(url.equals("/api/token")){//获取token
			genToken(request,response);
		}else if(url.startsWith("/api/")){//验证rest请求中的token
			if(checkToken(request,response))
				chain.doFilter(servletRequest, servletResponse);
		}else if(url.startsWith("/manager/")&&!"/manager/login.jsp".equals(url)){//验证管理页面中的登陆信息
			if(checkSession(request,response)){
				chain.doFilter(servletRequest, servletResponse);
			}else{
				response.sendRedirect("/manager/login.jsp");//调整到登陆页面
			}
		}else{
			chain.doFilter(servletRequest, servletResponse);
		}
	}

	/**
	 * 生成token返回 验证request中的ak和sk生成
	 */
	private void genToken(HttpServletRequest request,HttpServletResponse response)throws IOException{
		Writer writer = response.getWriter();
		String accesskey = request.getParameter("accesskey");
		String secretkey = request.getParameter("secretkey");
		if(ak.equals(accesskey)&&sk.equals(secretkey)){
			HttpSession session = request.getSession();
			String timeStamp = Long.toString(System.currentTimeMillis());
			String ip = request.getRemoteHost();
			String content = "Ip"+ip+"TimeStamp"+timeStamp+"AccessKey"+accesskey;
			String token = Utils.calcSignature(content, secretkey);
			session.setAttribute("token", token);
			logger.info("Gen token success!content=>"+content+" token=>"+token);
			writer.write(Utils.toData("{\"token\":\""+token+"\"}", 0, "Success"));
		}else{
			logger.info("Gen token failed!Request accesskey=>"+accesskey+" Request secretkey=>"+secretkey+" Server ak=>"+ak+" Server sk"+sk);
			writer.write(Utils.toData(null, 1000, "Gen token failed"));
		}
		writer.close();
	}

	/**
	 * 验证rest请求中是否包含合法的token信息
	 * @return
	 */
	private boolean checkToken(HttpServletRequest request,HttpServletResponse response)throws IOException{
		HttpSession session = request.getSession();
		String token = request.getHeader("token");
		String currentToken = (String)session.getAttribute("token");
		if(!"".equals(Utils.debugToken)&&Utils.debugToken.equals(token)){//放过debug token
			logger.debug("debug Token =>"+Utils.debugToken+" requestToken=>"+token);
			return true;
		}
		if(token==null||currentToken==null||!token.equals(currentToken)){
			Writer writer = response.getWriter();
			logger.debug("Check Token failed!currentToken=>"+currentToken+" requestToken=>"+token);
			writer.write(Utils.toData(null, 1001, "Check Token Faile"));
			writer.close();
			return false;
		}
		return true;
	}
	
	/**
	 * 验证session中是否有登录信息 用于过滤查看管理页面请求
	 * @return
	 */
	private boolean checkSession(HttpServletRequest request,HttpServletResponse response){
		String user = (String)request.getSession().getAttribute("user");
		if((SaeUserInfo.getAccessKey()+"_"+SaeUserInfo.getSecretKey()).equals(user)){
			return true;
		}else{
			return false;
		}
	}
	
	
	
}
