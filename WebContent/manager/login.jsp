<%@page import="com.sina.sae.util.SaeUserInfo"%>
<%@ page language="java" contentType="text/html; charset=GB18030" pageEncoding="GB18030"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<title>Cloud Service</title>
	<link rel="shortcut icon" href="<%=request.getContextPath() %>/favicon.ico" />
 	<link href="<%=request.getContextPath() %>/assets/css/bootstrap.css" rel="stylesheet">
    <link href="<%=request.getContextPath() %>/assets/css/bootstrap-responsive.css" rel="stylesheet">
    <link href="<%=request.getContextPath() %>/assets/css/docs.css" rel="stylesheet">
    <link href="<%=request.getContextPath() %>/assets/js/google-code-prettify/prettify.css" rel="stylesheet">
 
  	<link href="<%=request.getContextPath() %>/assets/css/bootstrap-responsive.css" rel="stylesheet">
    <style type="text/css">
      body {
        padding-top: 80px;
        padding-bottom: 40px;
        background-color: #f5f5f5;
      }
      .form-signin {
        max-width: 300px;
        padding: 19px 29px 29px;
        margin: 0 auto 20px;
        background-color: #fff;
        border: 1px solid #e5e5e5;
        -webkit-border-radius: 5px;
           -moz-border-radius: 5px;
                border-radius: 5px;
        -webkit-box-shadow: 0 1px 2px rgba(0,0,0,.05);
           -moz-box-shadow: 0 1px 2px rgba(0,0,0,.05);
                box-shadow: 0 1px 2px rgba(0,0,0,.05);
      }
      .form-signin .form-signin-heading,
      .form-signin .checkbox {
        margin-bottom: 10px;
      }
      .form-signin input[type="text"],
      .form-signin input[type="password"] {
        font-size: 16px;
        height: auto;
        margin-bottom: 15px;
        padding: 7px 9px;
      }

    </style>
    <%
		String ak = request.getParameter("ak");
		String sk = request.getParameter("sk");
		if(SaeUserInfo.getAccessKey().equals(ak)&&SaeUserInfo.getSecretKey().equals(sk)){
			session.setAttribute("user", ak+"_"+sk);
			response.sendRedirect("app.jsp");
		}
	%>
</head>
 <body>
	 <div class="navbar navbar-inverse navbar-fixed-top">
      <div class="navbar-inner">
        <div class="container">
          <a class="brand" href="#">Cloud Service</a>
        </div>
      </div>
    </div>

    <div class="container">

      <form class="form-signin" method="post" >
        <h3 class="form-signin-heading">Manage</h3>
        <input type="text" class="input-block-level" name="ak" placeholder="accesskey">
        <input type="password" class="input-block-level" name="sk"  placeholder="secretkey">
        <button class="btn btn-large btn-primary" type="submit">Login in</button>
      </form>

    </div> <!-- /container -->


  </body>
</html>