<%--
  Created by IntelliJ IDEA.
  User: 16320
  Date: 2018/11/4
  Time: 11:57
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<html>
<head>
    <base href="<%=basePath%>">
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <link href="css/bootstrap-theme.min.css" rel="stylesheet">
    <script src="jquery/jquery-2.2.4.min.js" type="text/javascript"></script>
    <script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=6tYzTvGZSOpYB5Oc2YGGOKt8"></script>
    <title>订单详情页</title>
    <style type="text/css">
        body, html {width: 100%;height: 100%; margin:0;font-family:"微软雅黑";}
        #allmap{height:400px;width:100%;}
        #r-result,#r-result table{width:100%;}
    </style>
    <script>
        var locationla;//当前位置经度
        var locationdi;//当前位置维度
        $(function() {
            var geolocation = new BMap.Geolocation();
            geolocation.getCurrentPosition(function (r) {
                if (this.getStatus() == BMAP_STATUS_SUCCESS) {
                    locationla = r.point.lng;
                    locationdi = r.point.lat;
                    // // 百度地图API功能
                    // var map = new BMap.Map("allmap");
                    // map.centerAndZoom(new BMap.Point(locationla, locationdi), 12);  // 当前地图的中心点经纬度
                    // map.enableScrollWheelZoom(true);
                    // map.clearOverlays();
                }
                else {
                    alert('获取当前位置经纬度失败' + this.getStatus());
                }
            });
        });
        function querymap() {
            var map = new BMap.Map("allmap");
            // map.centerAndZoom(new BMap.Point(113.547343,22.358211),12);  // 当前地图的中心点经纬度（珠海）
            map.centerAndZoom(new BMap.Point(locationla, locationdi), 12);
            map.enableScrollWheelZoom(true);
            map.clearOverlays();
            var start = $("#point_start").val();
            var end = $("#pint_end").val();
            var i=$("#driving_way select").val();
            if(start != '' && end != ''&&start!=null&&end!=null){
                searchPointWay(start,end);
            }else{
                alert('起终点地址都不能为空！');
            }

            function searchPointWay(start,end){
                var driving = new BMap.DrivingRoute(map, {renderOptions:{map: map, autoViewport: true}});
                driving.search(start,end);
            }
        }
    </script>
</head>
<body>
<nav class="navbar navbar-inverse">
    <p class="navbar-text">订单信息</p>
    <input id="point_start" type="hidden" value="${order.origin}"/>
    <input id="pint_end" type="hidden"  value="${order.destination}"/>
</nav>
<div class="container">
    <h2 class="sub-header">当前订单详情页</h2><br>
    <div class="table-responsive">
        <table class="table table-striped">
            <thead>
            <tr>
                <th>订单id</th>
                <th>乘客</th>
                <th>接单司机</th>
                <th>起始点</th>
                <th>终点</th>
                <th>直线距离</th>
                <th>乘客联系方式</th>
                <th>司机联系方式</th>
                <th>叫车类型</th>
                <th>订单创建日期</th>
                <c:if test="${not empty order.singletime}">
                    <th>司机接单时间</th>
                </c:if>
                <th>订单结束日期</th>
                <th>订单状态</th>
                <c:if test="${order.orderprize!=0}">
                    <th>订单总金额</th>
                </c:if>
                <th>评价信息</th>
                <th>评价详情</th>
                <th>操作</th>
            </tr>
            </thead>
            <tbody>
            <tr>
                <td>${order.orderid}</td>
                <td>${order.username}</td>
                <td>${order.drivername}</td>
                <td>${order.origin}</td>
                <td>${order.destination}</td>
                <td>${order.distance}</td>
                <td>${order.passengernumber}</td>
                <td>${order.drviernumber}</td>
                <td>${order.taximode}</td>
                <td>${order.createtime}</td>
                <c:if test="${not empty order.singletime}">
                    <td>${order.singletime}</td>
                </c:if>
                <td>${order.endtime}</td>
                <td>${order.statesmean}</td>
                <c:if test="${order.orderprize!=0}">
                    <td>${order.orderprize}</td>
                </c:if>
                <c:if test="${not empty order.evaluate}">
                    <td>${order.evaluate}</td>
                </c:if>
                <c:if test="${empty order.evaluate}">
                    <td>未评价</td>
                </c:if>
                <c:if test="${not empty order.evaluateinfo}">
                    <td>${order.evaluateinfo}</td>
                </c:if>
                <c:if test="${empty order.evaluateinfo}">
                    <td>未评价</td>
                </c:if>
                <td> <button class="btn btn-danger" id="result" onclick="querymap()">查询路线</button></td>
                <td>
                    <button type="button" class="btn btn-primary" onclick="javascript:window.location.href='driver/index.jsp'">返回首页</button>
                </td>
            </tr>
            </tbody>
        </table>
    </div>
</div>
<div id="allmap"></div>
</body>
</html>
