<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.sina.sae.util.SaeUserInfo"%> 
<%@page import="java.sql.DriverManager"%> 
<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  	<title>事件统计</title>
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
    String pagecount = request.getParameter("pagecount");
    int pc = 0;
   	try{
   		pc = Integer.parseInt(pagecount);
   	}catch(Exception e ){}
	String sql = "select * from statistic_clicks limit ?,10";
    Connection con = null;
	ResultSet rs = null;
	PreparedStatement ps = null;
	try {
		Class.forName("com.mysql.jdbc.Driver").newInstance();
		con = DriverManager.getConnection("jdbc:mysql://w.rdc.sae.sina.com.cn:3307/app_"+SaeUserInfo.getAppName(), SaeUserInfo.getAccessKey(), SaeUserInfo.getSecretKey());
		ps = con.prepareStatement(sql);
		ps.setInt(1, pc*10);
		rs = ps.executeQuery();
		Map<String,String> row = null;
		int count = 1;
		while(rs.next()){
			row = new HashMap<String,String>();
			row.put("index", ""+count++);
			row.put("viewid", rs.getString("viewid"));
			row.put("inserttime", rs.getTimestamp("inserttime")+"");
			row.put("updatetime", rs.getTimestamp("updatetime")+"");
			row.put("count", rs.getInt("count")+"");
			list.add(row);
		}
	}catch(Exception e){
		e.printStackTrace();
    }finally{
    	try{//关闭各种连接
	    	if(ps!=null)ps.close(); 
	    	if(rs!=null)rs.close(); 
	    	if(con!=null)con.close(); 
    	}catch(Exception e){}
    }
    
    %>
     <script type="text/javascript">
    	function nextpage(){
    		document.getElementById("object").submit();
    	}
    	function backpage(){
    		var pagecount = document.getElementById("pagecount").value;
    		document.getElementById("pagecount").value = Number(pagecount) - Number(2);
    		document.getElementById("object").submit();
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
              <li><a href="app.jsp">应用信息</a></li>
              <li><a href="rest.jsp">接口调试</a></li>
              <li class="nav-header">服务管理</li>
              <li><a href="db.jsp">数据库</a></li> 
              <li><a href="object.jsp">对象存储</a></li>
              <li><a href="file.jsp">文件存储</a></li> 
              <li class="nav-header">统计信息</li>
               <li ><a href="statisticuser.jsp">用户统计</a></li>
               <li  class="active"><a href="statisticevent.jsp">事件统计</a></li> 
               <li><a href="statisticstay.jsp">界面统计</a></li> 
            </ul>
          </div><!--/.well -->
        </div><!--/span-->
        <div class="span9" >
            <h4>事件信息统计</h4>
            <hr> 
            <form class="form-search" method="get" id="object" action="statisticevent.jsp">
		 	 <table class="table table-bordered"  >
				 <thead>
				    <tr >
				      <th  >#</th>
				      <th >控件ID</th>
				      <th>触发次数</th>
				      <th>首次触发时间</th>
				      <th>最近触发时间</th>
				    </tr>
				  </thead>
				  <tbody>
				  <%
				  	for(int i=0;i<list.size();i++){
				  		Map<String,String> row = list.get(i);
				  %>
				  	<tr>
				  		<td><%=row.get("index") %></td>
				  		<td><%=row.get("viewid") %></td>
				  		<td><%=row.get("count") %></td>
				  		<td><%=row.get("inserttime") %></td>
				  		<td><%=row.get("updatetime") %></td>
				  	</tr>
				  <%}%>
				  </tbody>
			</table>
			 <input type="hidden" name="pagecount" id="pagecount"  value="<%=pc+1%>"/>
			<div class="btn-group">
			  <button class="btn" onclick="backpage()"  <%if(pc<1){ %>disabled="disabled"<%} %> >&laquo;</button>
			  <button class="btn" disabled="disabled">第<%=pc+1 %>页</button>
			  <button class="btn" onclick="nextpage()"  <%if(list.size()<10){ %>disabled="disabled"<%} %> >&raquo;</button>
			</div>		
			</form> 
        </div><!--/span-->
      </div><!--/row-->
    </div><!--/.fluid-container-->
    
  </body>
</html>
