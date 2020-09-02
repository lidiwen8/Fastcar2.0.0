<%--
  Created by IntelliJ IDEA.
  User: 16320
  Date: 2018/11/3
  Time: 10:29
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<html>
<head>
<base href="<%=basePath%>">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" href="bootstrap-3.3.7-dist/css/bootstrap.css">
    <link rel="stylesheet" href="css/bootstrap.min.css">
<link rel="stylesheet" href="bootstrapvalidator/css/bootstrapValidator.css">
<script src="jquery/jquery-2.2.4.min.js" type="text/javascript"></script>
<script src="bootstrap-3.3.7-dist/js/bootstrap.min.js" type="text/javascript"></script>
<!-- 表单验证 -->
<script src="bootstrapvalidator/js/bootstrapValidator.js" type="text/javascript"></script>
    <link href="css/bootstrap-select.min.css" rel="stylesheet" />
    <script src="js/bootstrap-select.min.js"></script>
    <script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=6tYzTvGZSOpYB5Oc2YGGOKt8"></script>
    <title>乘客创建订单</title>
    <style type="text/css">
        body, html {width: 100%;height: 100%; margin:0;font-family:"微软雅黑";}
        #allmap{height:320px;width:100%;}
        #r-result,#r-result table{width:100%;}
    </style>
<script type="text/javascript">
    var locationla;//当前位置经度
    var locationdi;//当前位置维度
    $(function(){
        //ip定位，精度为城市级别
        function myFun(result){
            var cityName = result.name;
            $("#hidden1_region").val(cityName);
            $("#hidden1_region1").val(cityName);
        }
        var myCity = new BMap.LocalCity();
        myCity.get(myFun);
        var geolocation = new BMap.Geolocation();
        geolocation.getCurrentPosition(function(r){
            if(this.getStatus() == BMAP_STATUS_SUCCESS){
                locationla=r.point.lng;
                locationdi=r.point.lat;
                // 百度地图API功能
                var map = new BMap.Map("allmap");
                map.centerAndZoom(new BMap.Point(locationla,locationdi),12);  // 当前地图的中心点经纬度
                map.enableScrollWheelZoom(true);
            }
            else {
                alert('获取当前位置经纬度失败'+this.getStatus());
            }
        });
        // 百度地图API功能
        var map = new BMap.Map("allmap");
        map.centerAndZoom(new BMap.Point(113.547343,22.358211),12);  // 当前地图的中心点经纬度
        map.enableScrollWheelZoom(true);
        validateForm();
    });

    function validateForm(){
        // 验证表单
        $("#orderform").bootstrapValidator({
            message: 'This value is not valid',
            feedbackIcons: {/*输入框不同状态，显示图片的样式*/
                valid: 'glyphicon glyphicon-ok',
                invalid: 'glyphicon glyphicon-remove',
                validating: 'glyphicon glyphicon-refresh'
            },
            /*验证*/
            fields: {
                origin: {/*键名username和input name值对应*/
                    message: 'The username is not valid',
                    validators: {
                        notEmpty: {
                            message: '起点不能为空',
                        }
                    }
                },
                destination : {
                    message : '终点无效',
                    validators : {
                        notEmpty : {
                            message : '终点不能为空'
                        }
                    }
                },
                taximode:{
                    validators : {
                        callback:{
                            message : '请选择打车方式',
                            callback: function(value, validator) {
                                if (value == 0) {
                                    return false;
                                }else{
                                    return true;
                                }

                            }
                        }
                    }
                }
            }
        });
    }

    function createOrder() {
        // 异步创建乘客订单
        $.ajax({
            url : "passengerServlet?action=createOrder",// 请求地址
            type : "POST", // 请求类型
            async : "true", // 是否异步方式
            data : $("#orderform").serialize(), // 表单的序列化
            dataType : "json",
            success : function(data) {
                if (data.res == 1) {
                    alert(data.info);
                    // window.location.replace("orderServlet?action=findOrder");
                    window.location.replace("orderServlet?action=currentorder");
                }else if(data.res==2){
                    alert(data.info);
                    window.location.replace("orderServlet?action=currentorder");
                }
                else {
                    alert(data.info);
                }
            }
        });
        return false;
    }
    function gg() {
        var bootstrapValidator=$("#orderform").data("bootstrapValidator");
        //触发验证
        bootstrapValidator.validate();
        //如果验证通过，则调用login方法
        if(bootstrapValidator.isValid()){
            createOrder();
        }
    }
    function querymap() {
            var map = new BMap.Map("allmap");
            map.centerAndZoom(new BMap.Point(113.547343,22.358211),12);  // 当前地图的中心点经纬度（珠海）
            map.enableScrollWheelZoom(true);
            var start = $("#theid1").val();
            var end = $("#theid2").val();
            map.clearOverlays();
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
    <script>
        $(document).ready(function(){
            $("#query").keydown(function(){
                $("#theid1").empty();
                $.post("<%=basePath%>/passengerServlet?action=queryinput",
                    {
                        region:$("#hidden1_region").val(),
                        query:$("#query").val()
                    },
                    function(result){

                        var jsobject = JSON.parse(result);
                        var theme1=$("select[name='theid1']");
                        for (var i = 0; i < jsobject.result.length; i++) {

                            // $(".addresstop").append("<div class='addressli'>"
                            //     +"<div class='addressli2'>"+jsobject.result[i].name+"</div>"
                            //     +"<div class='addressli3'>"+jsobject.result[i].city+""+jsobject.result[i].district+"</div></div>");
                            theme1.append("<option value='"+jsobject.result[i].name+jsobject.result[i].city+""+jsobject.result[i].district+"'>"+jsobject.result[i].name+jsobject.result[i].city+""+jsobject.result[i].district+"</option>");
                        }


                    });
            });
            $("#query1").keydown(function(){
                $("#theid2").empty();
                $.post("<%=basePath%>/passengerServlet?action=queryinput",
                    {
                        region:$("#hidden1_region1").val(),
                        query:$("#query1").val()
                    },
                    function(result){

                        var jsobject = JSON.parse(result);
                        var theme2=$("select[name='theid2']");
                        for (var i = 0; i < jsobject.result.length; i++) {

                            // $(".addresstop1").append("<div class='addressli'>"
                            //     +"<div class='addressli2'>"+jsobject.result[i].name+"</div>"
                            //     +"<div class='addressli3'>"+jsobject.result[i].city+""+jsobject.result[i].district+"</div></div>");
                            theme2.append("<option value='"+jsobject.result[i].name+jsobject.result[i].city+""+jsobject.result[i].district+"'>"+jsobject.result[i].name+jsobject.result[i].city+""+jsobject.result[i].district+"</option>");
                        }


                    });
            });
        });
    </script>
</head>
<body>
<div id="allmap"></div>
<div class="container">
    <div class="row">
        <div class="col-sm-offset-3 col-sm-6 text-center">
            <h3>乘客创建订单</h3>
        </div>
    </div>
    <form class="form-horizontal col-sm-offset-3" id="orderform">
        <div id="driving_way">
        <div class="form-group">
            <label for="origin" class="col-sm-2 control-label">起点：</label>
            <div class="col-sm-4">
                <input type="text" class="form-control" name="origin" id="query" placeholder="从哪儿出发">
                <input type="hidden" id="hidden1_region" name="city1">
                <span class="help-block1" style="color: #a94442"></span>
                <select class="form-control" name="theid1" id="theid1" onmouseover="size=10;" onmouseout="size=1;" onchange="size=1;">
                </select>
            </div>
        </div>
        <div class="form-group">
            <label for="destination" class="col-sm-2 control-label">终点：</label>
            <div class="col-sm-4">
                <input type="text" class="form-control" id="query1" name="destination" placeholder="你要去哪儿">
                <input type="hidden" id="hidden1_region1" name="city2">
                <select class="form-control" name="theid2" id="theid2" onmouseover="size=10;" onmouseout="size=1;" onchange="size=1;">
                </select>
            </div>
        </div>
        </div>
        <%--<div class="dropdown" name="taximode" id="taximode">--%>
            <%--<button class="btn btn-default dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">--%>
                <%--选择打车方式--%>
                <%--<span class="caret"></span>--%>
            <%--</button>--%>
            <%--<ul class="dropdown-menu" aria-labelledby="dropdownMenu1">--%>
                <%--<li class="dropdown-header">选择打车方式</li>--%>
                <%--<li><a href="#"><span class='label label-warning'>快车</span></a></li>--%>
                <%--<li><a href="#"><span class='label label-warning'>顺风车</span></a></li>--%>
                <%--<li><a href="#"><span class='label label-warning'>专车</span></a> </li>--%>
                <%--<li><a href="#"><span class='label label-warning'>出租车</span></a> </li>--%>
            <%--</ul>--%>
        <%--</div>--%>
        <div class="form-group" style="height: 10px;width: 160px;margin-left: 150px;">
            <select class="form-control selectpicker" name="taximode" id="taximode" title="请选择打车方式">
                <option data-content="<span class='label label-success'>快车</span>" value="快车">快车</option>
                <option data-content="<span class='label label-info'>顺风车</span>" value="顺风车">顺风车</option>
                <option data-content="<span class='label label-warning'>专车</span>" value="专车">专车</option>
                <option data-content="<span class='label label-danger'>出租车</span>" value="出租车">出租车</option>
            </select>
        </div>
        <div class="form-group has-error">
            <div class="col-sm-offset-2 col-sm-4 col-xs-6 ">
                <span class="text-warning" style="color: #a94442"></span>
            </div>
        </div>
        <div class="form-group">
            <div class="col-sm-offset-2 col-sm-4 col-xs-12">
                <button class="btn btn-primary" id="result" onclick="querymap()">查询路线</button>
            </div>
        </div>
        <div class="form-group">
            <div class="col-sm-offset-2 col-sm-4 col-xs-12">
                <button class="btn btn-success btn-block" id="btn btn-success btn-block" onclick="gg()">发出订单</button>
            </div>
        </div>
        <div class="form-group">
            <div class="col-sm-offset-2 col-sm-4 col-xs-6">
                <a href="passenger/index.jsp">返回</a>
            </div>
        </div>
        <div id="r-result"></div>
    </form>
</div>
</body>
</html>
