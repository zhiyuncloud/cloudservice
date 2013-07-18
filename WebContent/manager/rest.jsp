<%@page import="java.net.URLEncoder"%>
<%@page import="org.apache.http.Header"%>
<%@page import="org.apache.http.client.methods.HttpDelete"%>
<%@page import="org.apache.http.client.methods.HttpPut"%>
<%@page import="org.apache.http.client.entity.UrlEncodedFormEntity"%>
<%@page import="org.apache.http.message.BasicNameValuePair"%>
<%@page import="org.apache.http.NameValuePair"%>
<%@page import="org.apache.http.client.methods.HttpPost"%>
<%@page import="org.apache.http.util.EntityUtils"%>
<%@page import="org.apache.http.HttpResponse"%>
<%@page import="org.apache.http.client.methods.HttpGet"%>
<%@page import="org.apache.http.impl.client.DefaultHttpClient"%>
<%@page import="com.sina.sae.cloudservice.Utils"%>
<%@page import="com.sina.sae.util.SaeUserInfo"%>
<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  	<title>Rest调试</title>
	<link rel="shortcut icon" href="<%=request.getContextPath() %>/favicon.ico" />
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<link href="<%=request.getContextPath() %>/assets/css/bootstrap.css" rel="stylesheet">
    <link href="<%=request.getContextPath() %>/assets/css/bootstrap-responsive.css" rel="stylesheet">
       <style type="text/css">
      body {
        padding-top: 60px;
        padding-bottom: 40px;
      }
      .sidebar-nav {
        padding: 9px 0;
      }

    </style>
    <script type="text/javascript">
		function disabledToken(){
    		document.getElementById("type").value = "disabled";
    		document.getElementById("rest").submit();
    	}	
    	
    	function changeToken(){
    		document.getElementById("type").value = "change";
    		document.getElementById("rest").submit();
    	}
    </script>
    <%
    	String method = request.getParameter("method");
    	String params = request.getParameter("params");
    	String url = request.getParameter("url");
    	String type = request.getParameter("type");
    	String token = request.getParameter("token");
    	String result = "";
    	if(null!=url&&"".equals(type)){
    		DefaultHttpClient httpclient = new DefaultHttpClient();
    		String[] ps = params.split("&");
    		//处理get和delete带参数的url
   			StringBuilder urls = new StringBuilder(url);
   			urls.append("?");
   			for(String pair:ps){
   				int s = pair.indexOf("=");
   				if(-1!=s)urls.append(pair.substring(0,s)).append("=").append(URLEncoder.encode(pair.substring(s+1), "utf-8"));
   			}
   			
    		if(method.equals("get")){
    			HttpGet get = new HttpGet(urls.toString());
    			get.addHeader("token", token);
    			result= EntityUtils.toString(httpclient.execute(get).getEntity());
    		}else if(method.equals("delete")&&null!=params){
    			HttpDelete delete = new HttpDelete(urls.toString());
    			delete.addHeader("token", token);
    			result= EntityUtils.toString(httpclient.execute(delete).getEntity());
    		}else if(method.equals("post")&&null!=params){
    			HttpPost post = new HttpPost(url);
    			List<NameValuePair> nvps = new ArrayList<NameValuePair>();
    			for(String pair:ps){
    				int s = pair.indexOf("=");
    				if(-1!=s)nvps.add(new BasicNameValuePair(pair.substring(0,s),pair.substring(s+1)));
    			}
    			post.setEntity(new UrlEncodedFormEntity(nvps, "UTF-8"));
    			post.addHeader("token",token);
    			result= EntityUtils.toString(httpclient.execute(post).getEntity());
    		}
    	}
    	
    	
    	if(null!=type){
    		if("change".equals(type)){
    			Utils.changeDebugToken();
    		}else if("disabled".equals(type)){
    			Utils.disabledDebugToken();
    		}
    	}
    	
    %>
  </head>
  <body>
  	<div class="navbar navbar-inverse navbar-fixed-top">
      <div class="navbar-inner">
        <div class="container">
          <a class="brand" href="#">Cloud Service</a>
          </div><!--/.nav-collapse -->
        </div>
      </div>
    
     <div class="container-fluid">
      <div class="row-fluid">
        <div class="span3">
          <div class="well sidebar-nav">
           <ul class="nav nav-list">
              <li class="nav-header">管理</li>
              <li><a href="app.jsp">应用信息</a></li>
              <li   class="active"><a href="rest.jsp">接口调试</a></li>
              <li class="nav-header">服务管理</li>
              <li><a href="db.jsp">数据库</a></li> 
              <li ><a href="object.jsp">对象存储</a></li>
              <li ><a href="file.jsp">文件存储</a></li> 
              <li class="nav-header">统计信息</li>
               <li><a href="statisticuser.jsp">用户统计</a></li>
               <li><a href="statisticevent.jsp">事件统计</a></li> 
               <li><a href="statisticstay.jsp">界面统计</a></li> 
            </ul>
          </div><!--/.well -->
        </div><!--/span-->
        <div class="span9" >
            <h4>Rest 调试</h4>
            <hr>
            <form action="rest.jsp" id="rest" method="post">
            	<input type="hidden" name="type" id="type">
				<div class="input-prepend">
				  <span class="add-on">&nbsp;请求&nbsp;URL</span>
				   <input class="input-block-level" id="url" value="<%=url==null? ("http://"+SaeUserInfo.getAppName()+".sinaapp.com/api/"):url%>" name="url" style="width: 560px;" type="text">
				</div> 
				<div class="input-prepend">
				  <span class="add-on">&nbsp;请求参数&nbsp;</span>
				   <input class="input-block-level" name="params" value="<%=params==null?"":params %>"   placeholder="形如:param1=value1&param2=value2" style="width: 560px;" type="text">
				</div><br>
				<div class="input-prepend">
				  <span class="add-on">&nbsp; Method&nbsp;</span>
				  <select name="method">
				  	<option <%if("get".equals(method)) {%>selected<%} %> value="get">GET</option>
				  	<option <%if("post".equals(method)) {%>selected<%} %> value="post">POST</option>
				  	<option <%if("delete".equals(method)) {%>selected<%} %>  value="delete">DELETE</option>
				  </select>
				</div><br>
			<div class="input-append">
			 <input class="span2" name="token"  style="width: 300px;"   value="<%=Utils.debugToken %>" id="appendedInputButtons" type="text">
			  <button class="btn btn-primary" onclick="changeToken()"  type="button">生成Token</button>
			  <button class="btn btn-danger"  onclick="disabledToken()" type="button">清除Token</button> 
			</div>
			  <span class="help-block">请求rest接口时header带上此token可通过认证</span>	
				<div >
				  <button type="submit" class="btn btn-primary">&nbsp;发&nbsp;送&nbsp;</button>
				</div>            
			</form>
            <hr>
			<h5>请求结果</h5>
            <div class="well" style="word-break:break-all" >
            	<%=result %>
		 	</div>
        </div><!--/span-->
      </div><!--/row-->
    </div><!--/.fluid-container-->
    
  </body>
</html>
