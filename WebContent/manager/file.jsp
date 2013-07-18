<%@page import="com.sina.sae.cloudservice.web.FileRest"%>
<%@page import="com.sina.sae.storage.SaeStorage"%>
<%@page import="com.sina.sae.kvdb.SaeKVUtil"%>
<%@page import="com.sina.sae.kvdb.SaeKV"%>
<%@page import="com.sina.sae.cloudservice.Utils"%>
<%@page import="com.sina.sae.util.SaeUserInfo"%>
<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  	<title>文件存储</title>
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
    <%
    	String filepath = request.getParameter("filepath");
    	String prefixpath = request.getParameter("prefixpath");
    	String deletepath = request.getParameter("deletepath");
    	String skip = request.getParameter("skip");
    	String appname = SaeUserInfo.getAppName();
    	int pageSize = 10;//设置每页10条数据
    	if(!Utils.checkInteger(skip))skip = "1";//从第几页开始
    	int start = (Integer.parseInt(skip)-1)*10;
      	SaeStorage storage = new SaeStorage();
      	boolean deleteFlag = false;
      	List<String> list = new ArrayList<String>();
      	if(null!=filepath&&!"".equals(filepath)){
      		boolean exist = storage.fileExists(FileRest.DOMAIN, filepath);
			if(exist)list.add(filepath); //文件存在则显示当前文件
      	}else if(null!=deletepath&&!"".equals(deletepath)){
      		deleteFlag = storage.delete("cloud", deletepath);
      	}else{ 
      		if(null==prefixpath)prefixpath = "";
      		list = storage.getList(FileRest.DOMAIN,prefixpath,pageSize,start);//每页显示10条数据
      	}
      	//控制翻页按钮
      	int length = list.size();
    %>
    <script type="text/javascript">
    	function nextpage(){
    		var skip = document.getElementById("skip").value;
    		document.getElementById("skip").value = Number(skip) + Number(1);
    		document.getElementById("file").submit();
    	}
    	function backpage(){
    		var skip = document.getElementById("skip").value;
    		document.getElementById("skip").value = Number(skip) - Number(1);
    		document.getElementById("file").submit();
    	}
    </script>
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
              <li  ><a href="app.jsp">应用信息</a></li>
              <li ><a href="rest.jsp">接口调试</a></li>
              <li class="nav-header">服务管理</li>
              <li><a href="db.jsp">数据库</a></li> 
              <li ><a href="object.jsp">对象存储</a></li>
              <li  class="active"><a href="file.jsp">文件存储</a></li> 
              <li class="nav-header">统计信息</li>
               <li><a href="statisticuser.jsp">用户统计</a></li>
               <li><a href="statisticevent.jsp">事件统计</a></li> 
               <li><a href="statisticstay.jsp">界面统计</a></li> 
            </ul>
          </div><!--/.well -->
        </div><!--/span-->
        <div class="span9" >
            <h4>文件存储</h4>
            <hr>
            <%if(deleteFlag) {%>
              <div class="alert alert-success">
  				删除成功
		 	</div>
		 	<%} %>
		 	<form class="form-search" method="post" id="file" action="file.jsp">
		 		<input type="hidden" name="skip" id="skip" value="<%=skip%>">
			 <div class="input-append">
			  <input class="span2" name="filepath" placeholder="file path" value="<%=filepath==null?"":filepath %>" id="appendedInputButton" style="width: 150px;" type="text">
			  <button class="btn" type="submit">精确查找</button>
			</div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<div class="input-append">
			  <input class="span2" name="prefixpath" placeholder="prefix path"  value="<%=prefixpath==null?"":prefixpath %>" id="appendedInputButton" style="width: 150px;" type="text">
			  <button class="btn" type="submit">前缀查找</button>
			</div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<div class="input-append">
			  <input class="span2" name="deletepath" placeholder="delete path" value="<%=deletepath==null?"":deletepath %>" id="appendedInputButton" style="width: 150px;" type="text">
			  <button class="btn" type="submit">精确删除</button>
			</div>
			<hr>
			<table class="table table-bordered" >
				 <thead>
				    <tr>
				      <th width="5%">#</th>
				      <th width="20%">path</th>
				      <th>url</th>
				    </tr>
				  </thead>
				  <tbody>
				  	<% 	if(list.size()>0)
				  	  for(String name:list){
				  	%>
				    <tr>
				       <td><%=++start%></td>
				      <td><%=name%></td>
				      <td style="word-break:break-all; word-wrap:break-word;"><a target="_blank" href="http://<%=appname%>-<%=FileRest.DOMAIN %>.stor.sinaapp.com/<%=name%>">http://<%=appname%>-<%=FileRest.DOMAIN %>.stor.sinaapp.com/<%=name%></a> </td>
				    </tr>
				    <%} %>
				  </tbody>
			</table>
			<div class="btn-group">
			  <button class="btn" onclick="backpage()" <%if(Integer.parseInt(skip)<=1){ %>disabled="disabled"<%} %> >&laquo;</button>
			  <button class="btn" disabled="disabled">第 <%=skip %> 页</button>
			  <button class="btn" onclick="nextpage()" <%if(length<10){ %>disabled="disabled"<%} %> >&raquo;</button>
			</div>
			</form>
		    
        </div><!--/span-->
      </div><!--/row-->
    </div><!--/.fluid-container-->
    
  </body>
</html>
