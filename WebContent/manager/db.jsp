<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.sina.sae.util.SaeUserInfo"%> 
<%@page import="java.sql.DriverManager"%> 
<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  	<title>数据库</title>
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
    List<Map<String,String>> list = new ArrayList<Map<String,String>>();
	String sql = "show tables";
    Connection con = null;
	ResultSet rs = null;
	Statement stmt = null;
	try {
		Class.forName("com.mysql.jdbc.Driver").newInstance();
		con = DriverManager.getConnection("jdbc:mysql://w.rdc.sae.sina.com.cn:3307/app_"+SaeUserInfo.getAppName(), SaeUserInfo.getAccessKey(), SaeUserInfo.getSecretKey());
		//con = DriverManager.getConnection("jdbc:mysql://127.0.0.1:3306/test","root","123");
		stmt = con.createStatement();
		rs = stmt.executeQuery(sql);
		Map<String,String> row = null;
		int count = 1;
		while(rs.next()){
			row = new HashMap<String,String>();
			row.put("index", ""+count++);
			row.put("table", rs.getString(1));
			list.add(row);
		}
	}catch(Exception e){
		e.printStackTrace();
    }finally{
    	try{//关闭各种连接
	    	if(stmt!=null)stmt.close(); 
	    	if(rs!=null)rs.close(); 
	    	if(con!=null)con.close(); 
    	}catch(Exception e){}
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
              <li><a href="rest.jsp">接口调试</a></li>
              <li class="nav-header">服务管理</li>
              <li   class="active"><a href="db.jsp">数据库</a></li> 
              <li><a href="object.jsp">对象存储</a></li>
              <li><a href="file.jsp">文件存储</a></li> 
              <li class="nav-header">统计信息</li>
               <li ><a href="statisticuser.jsp">用户统计</a></li>
               <li><a href="statisticevent.jsp">事件统计</a></li> 
               <li><a href="statisticstay.jsp">界面统计</a></li> 
            </ul>
          </div><!--/.well -->
        </div><!--/span-->
        <div class="span9" >
            <h4>数据库</h4>
            <hr> 
            <div class="alert alert-success">
  				SAE 的 PHPAdmin 提供更加强大的数据库管理功能 <a target="_blank" href="http://sae.sina.com.cn/?m=mysqlmng&app_id=<%=SaeUserInfo.getAppName() %>&ver=<%=SaeUserInfo.getAppVersion() %>">点击进入</a> 
		 	</div>
		 	 <table class="table table-bordered"  >
				 <thead>
				    <tr >
				      <th  >#</th>
				      <th>数据表</th>
				      <th>操作</th>
				    </tr>
				  </thead>
				  <tbody>
				  <%
				  	for(int i=0;i<list.size();i++){
				  		Map<String,String> row = list.get(i);
				  %>
				  	<tr>
				  		<td><%=row.get("index") %></td>
				  		<td><%=row.get("table") %></td>
				  		<td><a href="dbdetail.jsp?table=<%=row.get("table") %>">详情</a></td>
				  	</tr>
				  <%}%>
				  </tbody>
			</table>
        </div><!--/span-->
      </div><!--/row-->
    </div><!--/.fluid-container-->
    
  </body>
</html>
