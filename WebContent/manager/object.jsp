<%@page import="com.sina.sae.kvdb.SaeKVUtil"%>
<%@page import="com.sina.sae.kvdb.SaeKV"%>
<%@page import="com.sina.sae.cloudservice.Utils"%>
<%@page import="com.sina.sae.util.SaeUserInfo"%>
<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  	<title>对象存储</title>
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
    	function nextpage(){
    		var skip = document.getElementById("skip").value;
    		document.getElementById("operation").value = "next";
    		document.getElementById("skip").value = Number(skip) + Number(1);
    		document.getElementById("object").submit();
    	}
    	function backpage(){
    		var skip = document.getElementById("skip").value;
    		document.getElementById("operation").value = "back";
    		document.getElementById("skip").value = Number(skip) - Number(1);
    		document.getElementById("object").submit();
    	}
    </script>
    
    <%
    	String getkey = request.getParameter("getkey");
    	String deletekey = request.getParameter("deletekey");
    	String savevalue = request.getParameter("savevalue");
    	String savekey = request.getParameter("savekey");
    	String prefixkey = request.getParameter("prefixkey");
    	String skip = request.getParameter("skip");
    	String operation = request.getParameter("operation");//前后翻页动作
    	String lastkey = request.getParameter("lastkey");//最后一个key值 用于下一页时做比较
    	if(null==prefixkey)prefixkey = "";
    	String comparekey = "";
    	String message = "";
    	if(!Utils.checkInteger(skip))skip = "1";//默认第一页
    	int pagecount = Integer.parseInt(skip);//当前页数
    	int pagesize = 10;//设置每页10条数据
    	List<Map<String,String>> list = new ArrayList<Map<String,String>>();
    	SaeKV kv = new SaeKV();
    	kv.init();
    	//set key-value
    	if(null!=savekey&&!"".equals(savekey)&&null!=savevalue&&!"".equals(savevalue)){
     		if(kv.set(savekey, SaeKVUtil.StringToByte(savevalue))){
     			message = "保存key->"+savekey+" | value->"+savevalue +" 成功!";
     			Map<String,String> map = new HashMap<String,String>();
				map.put("key", savekey);
				map.put("value", savevalue);
     			list.add(map);
     		}else{
     			message = "保存 key->"+savekey+" | value->"+savevalue +" 失败!";
     		}	
     		pagecount = 1;
     	//delete key
     	}else if(null!=deletekey&&!"".equals(deletekey)){
    		if(kv.delete(deletekey)){
    			message = "删除key->"+deletekey+" 成功!";
    		}else{
    			message = "删除key->"+deletekey+" 失败!";
    		}
    		pagecount = 1;
    	//get key
    	}else if(null!=getkey&&!"".equals(getkey)){
    		String value = null;
			byte[] bs = kv.get(getkey);
			if(bs!=null){
				value = SaeKVUtil.byteToString(bs);
				Map<String,String> map = new HashMap<String,String>();
				map.put("key", getkey);
				map.put("value", value);
	    		list.add(map);
			}else{
				message = "未查到key-> "+getkey+" 的数据!";
			}
			pagecount = 1;
		//prefix get	
    	}else{
    		if("next".equals(operation)){//下一页
    			comparekey = lastkey;
    		}else if("back".equals(operation)&&pagecount!=1){//前一页 
    			comparekey = (String)session.getAttribute(prefixkey+"_"+pagecount);//从session中取出对应的comparekey
    		}else{
    			comparekey = prefixkey;//第一次查询
    		}
    		Map<String, Object> pairs = kv.pkrget(prefixkey, pagesize, comparekey);
    		if(null!=pairs){
    			Set<String> keys = pairs.keySet();
    			Map<String,String> map;
    			for(String key:keys){
    				map = new HashMap<String,String>();
    				map.put("key", key);
    				map.put("value", SaeKVUtil.byteToString((byte[])pairs.get(key)));
    				list.add(map);
    			}
    		}
    	}
    	//处理翻页信息
    	int length = list.size();
		if(length==pagesize){
			lastkey = list.get(length-1).get("key");//翻至下一页时的comparekey
			session.setAttribute(prefixkey+"_"+(pagecount+1), lastkey);//记录下下页向前翻页时候的comparekey 存到session中
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
              <li><a href="db.jsp">数据库</a></li> 
              <li   class="active"><a href="object.jsp">对象存储</a></li>
              <li ><a href="file.jsp">文件存储</a></li> 
              <li class="nav-header">统计信息</li>
               <li><a href="statisticuser.jsp">用户统计</a></li>
               <li><a href="statisticevent.jsp">事件统计</a></li> 
               <li><a href="statisticstay.jsp">界面统计</a></li> 
            </ul>
          </div><!--/.well -->
        </div><!--/span-->
        <div class="span9" >
            <h4>对象存储</h4>  
            <hr>
             <%if(!"".equals(message)) {%>
              <div class="alert alert-success">
  				<%=message %>
		 	</div>
		 	<%} %>
		 	<form class="form-search" method="post" id="object" action="object.jsp">
			 <div class="input-append">
			  <input class="span2" name="getkey" value="<%=getkey==null?"":getkey %>" placeholder="get key" id="appendedInputButton" style="width: 100px;" type="text">
			  <button class="btn" type="submit">精确查找</button>
			</div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<div class="input-append">
			  <input class="span2" placeholder="prefix key" name="prefixkey" value="<%=prefixkey==null?"":prefixkey %>" id="appendedInputButton" style="width: 100px;" type="text">
			  <button class="btn"  type="submit">前缀查找</button>
			</div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<div class="input-append">
			  <input class="span2" name="deletekey" value="<%=deletekey==null?"":deletekey %>" placeholder="delete key" id="appendedInputButton" style="width: 100px;" type="text">
			  <button class="btn" type="submit">精确删除</button>
			</div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<div class="input-append">
			  <input class="span2" id="prependedInput" name="savekey" value="<%=savekey==null?"":savekey %>" type="text" style="width: 100px;" placeholder="save key">
			</div>
			<div class="input-append">
			  <input class="span2" id="prependedInput" name="savevalue" value="<%=savevalue==null?"":savevalue %>" type="text" style="width: 100px;" placeholder="save value">
			   <button class="btn" type="submit">保存</button>
			</div>
		 	
			<hr>
			<table class="table table-bordered"  >
				 <thead>
				    <tr >
				      <th  width="5%">#</th>
				      <th width="15%">key</th>
				      <th>data</th>
				    </tr>
				  </thead>
				  <tbody>
				  	<%
				  		int start = (pagecount-1)*pagesize ;
				  		for(int i=0;i<list.size();i++){
				  			Map<String,String> map = list.get(i);
				  	%>
				    <tr>
				      <td><%=++start %></td>
				      <td><%=map.get("key") %></td>
				      <td style="word-break:break-all; word-wrap:break-word;"><%=map.get("value") %></td>
				    </tr>
				    <%} %>
				  </tbody>
			</table>
			<input type="hidden" name="skip" id="skip" value="<%=skip%>">
		 	<input type="hidden" name="lastkey" id="lastkey" value="<%=lastkey%>">
		 	<input type="hidden" name="operation" id="operation"  >
			<div class="btn-group">
			  <button class="btn" onclick="backpage()" <%if(pagecount<=1){ %>disabled="disabled"<%} %> >&laquo;</button>
			  <button class="btn" disabled="disabled">第 <%=pagecount %> 页</button>
			  <button class="btn" onclick="nextpage()" <%if(length<pagesize){ %>disabled="disabled"<%} %> >&raquo;</button>
			</div>
			</form>
		    
        </div><!--/span-->
      </div><!--/row-->
    </div><!--/.fluid-container-->
    
  </body>
</html>
