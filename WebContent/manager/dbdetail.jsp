<%@page import="java.sql.ResultSetMetaData"%>
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
  	<title>数据库详情</title>
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
    String table = request.getParameter("table");
    String pagecount = request.getParameter("pagecount");
    int pc = 0;
   	try{
   		pc = Integer.parseInt(pagecount);
   	}catch(Exception e ){}
    List<Map<String,String>> list = new ArrayList<Map<String,String>>();
    Set<String> cls = new HashSet<String>();
    if(table!=null){
    	String sql = "SELECT *  FROM "+ table +" limit ?,10";
	    Connection con = null;
		ResultSet rs = null;
		PreparedStatement ps = null;
		try {
			Class.forName("com.mysql.jdbc.Driver").newInstance();
			con = DriverManager.getConnection("jdbc:mysql://w.rdc.sae.sina.com.cn:3307/app_"+SaeUserInfo.getAppName(), SaeUserInfo.getAccessKey(), SaeUserInfo.getSecretKey());
			//con = DriverManager.getConnection("jdbc:mysql://127.0.0.1:3306/test","root","123");
			ps = con.prepareStatement(sql);
			ps.setInt(1, pc*10);
			rs = ps.executeQuery();
			ResultSetMetaData metaData = rs.getMetaData();
			int columnCount = metaData.getColumnCount();
			Map<String,String> row = null;
			int count = 1;
			while(rs.next()){
				row = new HashMap<String,String>(); 
				for(int i=1;i<=columnCount;i++){
					Object obj = rs.getObject(i);
					row.put(metaData.getColumnName(i), obj==null?"":obj.toString());
					cls.add(metaData.getColumnName(i));
				}
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
            <a class="btn" href="db.jsp">返回 »</a><br/><br/>    
            <form class="form-search" method="get" id="object"   action="dbdetail.jsp">
            <input type="hidden" name="pagecount" id="pagecount"  value="<%=pc+1%>"/>
             <input type="hidden" name="table"  value="<%=table%>"/>
		 	 <table class="table table-bordered"  >
				 <thead>
				    <tr >
				      <%for(String cl:cls){ %>
				      <th><%=cl %></th>
				      <%} %>
				    </tr>
				  </thead>
				  <tbody>
				  <%
				  	for(int i=0;i<list.size();i++){
				  		Map<String,String> row = list.get(i);
				  %>
				  	<tr>
				  		<%for(String cl:cls){ %>
				  		<td><%=row.get(cl) %></td>
				  		<%} %>
				  	</tr>
				  <%}%>
				  </tbody>
			</table>
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
