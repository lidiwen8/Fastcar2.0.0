<%--
  Created by IntelliJ IDEA.
  User: 16320
  Date: 2018/11/22
  Time: 12:37
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java"  pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<html>
<head>
    <title>司机个人信息</title>
    <base href="<%=basePath%>">
    <link href="/css/bootstrap.min.css" rel="stylesheet">
    <link href="/css/bootstrap-theme.min.css" rel="stylesheet">
    <script src="/jquery/jquery-2.2.4.min.js" type="text/javascript"></script>
    <script src="/bootstrap-3.3.7-dist/js/bootstrap.min.js" type="text/javascript"></script>
</head>
<body>
<nav class="navbar navbar-inverse">
    <p class="navbar-text">司机提交审核个人信息</p>
</nav>
<div class="container">
    <h2 class="sub-header">司机信息分页列表</h2><br>
    <div class="table-responsive">
        <table class="table table-striped">
            <thead>
            <tr>
                <th>司机编号</th>
                <th>司机姓名</th>
                <th>联系方式</th>
                <th>性别</th>
                <th>最近一次登录时间</th>
                <th>司机的车型</th>
                <th>车身颜色</th>
                <th>车牌号</th>
                <th>司机身份证号</th>
                <th>司机信息审核状态</th>
                <th>司机状态</th>
                <th>操作</th>
            </tr>
            </thead>
                <tbody>
                <tr>
                    <td>${cstm.driverid}</td>
                    <td>${cstm.relname}</td>
                    <td>${cstm.number}</td>
                    <td>${cstm.sex}</td>
                    <td>${cstm.logintime}</td>
                    <td>${cstm.motorcycle}</td>
                    <td>${cstm.carcolor}</td>
                    <td>${cstm.platenumber}</td>
                    <td>${cstm.idcard}</td>
                    <c:if test="${cstm.examineStates==0}">
                        <td>未递交审核申请</td>
                    </c:if>
                    <c:if test="${cstm.examineStates==1}">
                        <td>已审核</td>
                    </c:if>
                    <c:if test="${cstm.examineStates==2}">
                        <td>审核不通过</td>
                    </c:if>
                    <c:if test="${cstm.examineStates==3}">
                        <td>已递交审核申请</td>
                    </c:if>
                    <c:if test="${cstm.states==0}">
                        <td>司机当前未接单</td>
                    </c:if>
                    <c:if test="${cstm.states==1}">
                        <td>司机当前已接单</td>
                    </c:if>
                    <td>
                        <c:if test="${cstm.examineStates==0}">
                            <button class="btn-success" onclick="javascript:window.location.href='driver/application.jsp'">申请审核</button>
                        </c:if>
                        <button class="btn btn-danger btn-sm delete_btn" onclick="javascript:window.location.href='driver/index.jsp'">返回</button>
                    </td>
                </tr>
                </tbody>
        </table>
        <br/>
    </div>
</div>
</body>
</html>

