<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE>
<html>
<head>
    <base href="<%=basePath%>">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="bootstrap-3.3.7-dist/css/bootstrap.css">
    <link rel="stylesheet" href="bootstrapvalidator/css/bootstrapValidator.css">
    <script src="jquery/jquery-2.2.4.min.js" type="text/javascript"></script>
    <script src="bootstrap-3.3.7-dist/js/bootstrap.min.js" type="text/javascript"></script>
    <!-- 表单验证 -->
    <script src="bootstrapvalidator/js/bootstrapValidator.js" type="text/javascript"></script>
    <title>登录界面</title>
    <script type="text/javascript">
        function _hyz() {
            var img = document.getElementById("imgVerifyCode");
            // 需要给出一个参数，这个参数每次都不同，这样才能干掉浏览器缓存！
            img.src = "VerifyCodeServlet?a=" + new Date().getTime();
        }
        $(function(){
            validateForm();
        });
        function validateForm(){
            // 验证表单
            $("#loginform").bootstrapValidator({
                message: 'This value is not valid',
                feedbackIcons: {/*输入框不同状态，显示图片的样式*/
                    valid: 'glyphicon glyphicon-ok',
                    invalid: 'glyphicon glyphicon-remove',
                    validating: 'glyphicon glyphicon-refresh'
                },
                fields: {/*验证*/
                    username: {/*键名username和input name值对应*/
                        message: 'The username is not valid',
                        validators: {
                            notEmpty: {/*非空提示*/
                                message: '用户名不能为空'
                            },
                            stringLength: {/*长度提示*/
                                min: 2,
                                max: 8,
                                message: '用户名长度必须在2到8之间'
                            }/*最后一个没有逗号*/

                        }
                    },
                    password: {
                        message:'密码无效',
                        validators: {
                            notEmpty: {
                                message: '密码不能为空'
                            },
                            regexp: {
                                regexp: /^[a-zA-Z0-9_\.]+$/,
                                message: '密码不合法, 请重新输入'
                            },
                            stringLength: {
                                min: 6,
                                max: 30,
                                message: '密码长度必须在6到30之间'
                            }
                        }
                    },
                    verifyCode : {
                        messaage : 'The validate is not valid',
                        validators : {
                            notEmpty : {
                                message : '验证码不能为空'
                            },
                            stringLength: {
                                min: 4,
                                max: 4,
                                message: '验证码长度必须为四位'
                            },
                            regexp: {
                                regexp: /^[a-zA-Z0-9]+$/,
                                message: '验证码不合法, 请重新输入'
                            }
                        }
                    }
                }
            });
        }
        function login() {
            var username = $("input[name='username']").val();
            var password = $("input[name='password']").val();
            var verifyCode=$("input[name='verifyCode']").val();
            // Ajax 异步请求登录
            $.ajax({
                url: "driverServlet?action=login",
                type: "POST",
                async: "true",
                data: {"action": "login", "username": username, "password": password, "verifyCode": verifyCode},
                dataType: "json",
                success: function (data) {
                    if (data.res == 1) {
                        alert(data.info);
                        window.location.replace("driver/index.jsp");
                    } else if (data.res == 2) {
                        alert(data.info);
                        window.location.replace("driverServlet?action=queryDriverAplication");
                    }
                    else if (data.res == -1) {
                        alert(data.info);
                        $("input[name='username']").val("");
                        $("input[name='password']").val("");
                    } else if (data.res == 3) {
                        alert(data.info);
                        $("input[name='verifyCode']").val("");
                        _hyz();
                    }
                    else {
                        alert(data.info);
                        $("input[name='username']").val("");
                        $("input[name='password']").val("");
                    }
                }
            });
            return false;
        }
        function gg() {
            var bootstrapValidator=$("#loginform").data("bootstrapValidator");
            //触发验证
            bootstrapValidator.validate();
            //如果验证通过，则调用login方法
            if(bootstrapValidator.isValid()){
                login();
            }
        }
        function loadmsg() {
            var msg = "<%=request.getAttribute("info")%>";
            if (msg != "null") {
                alert(msg);
            }
        }
    </script>
</head>
<body onload="loadmsg()" background="Images/bg.jpg"
      style=" background-repeat:no-repeat ;
background-size:100% 100%;
background-attachment: fixed;">
<div class="container">
    <div class="row">
        <div class="col-sm-offset-3 col-sm-6 text-center">
            <h3>司机登录-快车系统</h3>
        </div>
    </div>
    <%
        String username = "";
        String password = "";
        //获取当前站点的所有Cookie
        Cookie[] cookies = request.getCookies();
        for (int i = 0; i < cookies.length; i++) {//对cookies中的数据进行遍历，找到用户名、密码的数据
            if ("username".equals(cookies[i].getName())) {
                username = cookies[i].getValue();
            } else if ("password".equals(cookies[i].getName())) {
                password = cookies[i].getValue();
            }
        }
    %>
    <form class="form-horizontal col-sm-offset-3" id="loginform" method="post">
        <div class="form-group">
            <label for="username" class="col-sm-2 control-label">用户名：</label>
            <div class="col-sm-4">
                <input type="text" class="form-control" name="username" placeholder="请输入用户名" id="username" value="<%=username%>">
            </div>
        </div>
        <div class="form-group">
            <label for="password" class="col-sm-2 control-label">密码：</label>
            <div class="col-sm-4">
                <input type="password" class="form-control" name="password" placeholder="请输入密码" id="password" value="<%=password%>">
            </div>
        </div>
        <div class="form-group">
            <label for="input1" class="col-sm-2 control-label">验证码：</label>
            <div class="col-sm-4">
                <input type="text" class="form-control"  name="verifyCode" id="input1" placeholder="请输入验证码"/>
                <img src="VerifyCodeServlet" id="imgVerifyCode" class="form-control" style="width: 117px;"/>
                <a href="javascript:_hyz()">换一张</a>
            </div>
        </div>
        <div class="form-group has-error">
            <div class="col-sm-offset-2 col-sm-4 col-xs-6 ">
                <span class="text-warning"></span>
                <label for="rememberme"><input name="rememberme" type="checkbox" id="rememberme" value="1" style="cursor:pointer;" checked /> 记住密码</label>
            </div>
        </div>
        <div class="form-group">
            <div class="col-sm-offset-2 col-sm-2 col-xs-6">
                <button class="btn btn-success btn-block" onclick="gg()">登录</button>
            </div>
            <div class="col-sm-2  col-xs-6">
                <a class="btn btn-warning btn-block" href="drregister.jsp">注册</a>
            </div>
        </div>
    </form>
</div>
</body>
</html>