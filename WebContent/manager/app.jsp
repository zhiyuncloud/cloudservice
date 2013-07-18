<%@page import="com.sina.sae.cloudservice.Utils"%>
<%@page import="com.sina.sae.util.SaeUserInfo"%>
<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  	<title>应用信息</title>
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
              <li   class="active"><a href="app.jsp">应用信息</a></li>
              <li ><a href="rest.jsp">接口调试</a></li>
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
            <h4>应用信息</h4>
            <hr>
		 	
            <div class="well" >
            <p><b>App Name : </b><%=SaeUserInfo.getAppName() %></p>
            <p><b>Access Key: </b><%=SaeUserInfo.getAccessKey()%></p> 
            <p><b>Secret Key: </b><%=SaeUserInfo.getSecretKey()%></p> 
            <p><b>md5(Secret Key) : </b><%=Utils.md5(SaeUserInfo.getAccessKey()) %></p>
            <p><b>Debug Token:  </b><%=Utils.debugToken %></p>
            	
		 </div>
		    	 <div class="alert alert-success">
  				更详尽的的应用信息和管理功能进入 <b>SAE</b> 的应用管理面板对应用进行管理（<a target="_blank" href="http://sae.sina.com.cn/?m=sum&app_id=<%=SaeUserInfo.getAppName() %>&ver=<%=SaeUserInfo.getAppVersion() %>">进入</a>）
		 	</div>
		 	<table class="table table-hover">
		 		<tr>
		 			<td width="10%" ><b>服务</b></td>
		 			<td><b>描述</b></td>
		 		</tr>
		 		<tr>
		 			<td><b>Object</b></td>
		 			<td>对应<b>SAE</b>中的<b>KVDB</b>服务，使用前需先到应用的管理面板(<a target="_blank" href="http://sae.sina.com.cn/?m=kv&app_id=<%=SaeUserInfo.getAppName() %>&ver=<%=SaeUserInfo.getAppVersion() %>">进入</a>)启用服务</td>
		 		</tr>
		 		<tr>
		 			<td><b>File</b></td>
		 			<td>对应<b>SAE</b>中的<b>Storage</b>服务，使用前需先到应用的管理面板(<a target="_blank" href="http://sae.sina.com.cn/?m=storage&app_id=<%=SaeUserInfo.getAppName() %>&ver=<%=SaeUserInfo.getAppVersion() %>">进入</a>)启用服务，同时创建一个名称为<b>cloud</b>的域</td>
		 		</tr>
		 		<tr>
		 			<td><b>DB</b></td>
		 			<td>对应 <b>SAE</b>中的 <b>MySQL</b> 服务，使用前需先到应用的管理面板(<a target="_blank" href="http://sae.sina.com.cn/?m=mysqlmng&app_id=<%=SaeUserInfo.getAppName() %>&ver=<%=SaeUserInfo.getAppVersion() %>">进入</a>)启用服务，
		 			 可以使用 <b>SAE</b>提供的  <b>phpAdmin</b> (<a  target="_blank" href="http://pma.tools.sinaapp.com/index.php?db=app_<%=SaeUserInfo.getAppName() %>">进入</a>) 来管理  <b>MySQL</b></td>
		 		</tr>
			</table>
			<hr>
		 
        </div><!--/span-->
      </div><!--/row-->
    </div><!--/.fluid-container-->
    
  </body>
</html>
