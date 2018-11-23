<%--
  Created by IntelliJ IDEA.
  User: 16320
  Date: 2018/11/22
  Time: 12:55
  To change this template use File | Settings | File Templates.
--%>
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
    <link rel="stylesheet" href="/bootstrap-3.3.7-dist/css/bootstrap.css">
    <link rel="stylesheet" href="/bootstrapvalidator/css/bootstrapValidator.css">
    <link rel="stylesheet" href="/bootstrap-datetimepicker/css/bootstrap-datetimepicker.css">
    <script src="/jquery/jquery-2.2.4.min.js" type="text/javascript"></script>
    <script src="/bootstrap-3.3.7-dist/js/bootstrap.min.js" type="text/javascript"></script>
    <!-- 表单验证 -->
    <script src="/bootstrapvalidator/js/bootstrapValidator.js" type="text/javascript"></script>
    <script src="/bootstrap-datetimepicker/js/bootstrap-datetimepicker.js" type="text/javascript"></script>
    <script src="/bootstrap-datetimepicker/js/locales/bootstrap-datetimepicker.zh-CN.js" type="text/javascript"></script>
    <script type="text/javascript">
        $.fn.datetimepicker.dates['zh-CN'] = {
            days: ["星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六", "星期日"],
            daysShort: ["周日", "周一", "周二", "周三", "周四", "周五", "周六", "周日"],
            daysMin:  ["日", "一", "二", "三", "四", "五", "六", "日"],
            months: ["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"],
            monthsShort: ["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "11月", "12月"],
            today: "今天",
            suffix: [],
            meridiem: ["上午", "下午"]
        };

        $('#birthday').datetimepicker({
            format:'yyyy-mm-dd',
            language:'zh-CN',
            weekStart:1,
            //todayBtn:1,
            autoclose:1,
            todayHighlight:1,
            startView:2,
            minView:'month',
            forceParse:0
        });
    </script>
    <title>平台申请</title>
    <script type="text/javascript">
        $(function(){
            validateForm();
            $("#studentId").keyup(function () {
                validate_empName("#studentId");
            });
            $(".form_datetime").datetimepicker({
                format: 'yyyy-mm-dd',
                minView:'month',
                language: 'zh-CN',
                autoclose: true,//选中自动关闭
                startDate:'1900-01-01',
                todayBtn: true//显示今日按钮
            });

        });

        function validateForm(){
            // 验证表单
            $("#registerform").bootstrapValidator({
                message: 'This value is not valid',
                feedbackIcons: {/*输入框不同状态，显示图片的样式*/
                    valid: 'glyphicon glyphicon-ok',
                    invalid: 'glyphicon glyphicon-remove',
                    validating: 'glyphicon glyphicon-refresh'
                },
                /*验证*/
                fields: {
                    relname: {/*键名username和input name值对应*/
                        message: 'The username is not valid',
                        validators: {
                            notEmpty: {
                                message: '真实姓名不能为空',
                            },
                            stringLength: {/*长度提示*/
                                min: 2,
                                max: 8,
                                message: '真实姓名长度必须在2到8之间'
                            }
                        }
                    },
                    idcard : {
                        messaage : 'The two password must be consistent',
                        validators : {
                            notEmpty : {
                                message : '身份证号不能为空'
                            },
                            regexp: {
                                regexp: /^(^[1-9]\d{7}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{3}$)|(^[1-9]\d{5}[1-9]\d{3}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])((\d{4})|\d{3}[Xx])$)$/,
                                message: '身份证号码格式不正确，为15位和18位身份证号码！'
                            }
                        }
                    },
                    platenumber:{
                        messaage : 'The realname is not valid',
                        validators : {
                            notEmpty : {
                                message : '车牌号不能为空'
                            },
                            regexp: {
                                regexp: /^[京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领A-Z]{1}[A-Z]{1}[A-Z0-9]{4}[A-Z0-9挂学警港澳]{1}$/,
                                message: '请输入正确的车牌号！'
                            },
                            stringLength: {/*长度提示*/
                                min: 7,
                                max: 7,
                                message: '车牌号长度必须为7位'

                            }
                        }
                    },
                    carcolor:{
                        messaage : 'The realname is not valid',
                        validators : {
                            notEmpty : {
                                message : '车身颜色不能为空'
                            },
                            stringLength: {/*长度提示*/
                                min: 1,
                                max: 6,
                                message: '车身颜色长度必须在1到6之间'

                            }
                        }
                    },
                    motorcycle:{
                        messaage : 'The realname is not valid',
                        validators : {
                            notEmpty : {
                                message : '车型不能为空'
                            },
                            stringLength: {/*长度提示*/
                                min: 2,
                                max: 8,
                                message: '车型长度必须在2到8之间'

                            }
                        }
                    },
                    telephoneNumber : {
                        messaage : 'The realname is not valid',
                        validators : {
                            notEmpty : {
                                message : '电话号码不能为空'
                            },
                            regexp: {
                                regexp: /^1[34578]\d{9}$/,
                                message: '请输入正确的电话号码！'
                            }
                        }
                    },
                    sex : {
                        messaage : 'The sex is not valid',
                        validators : {
                            notEmpty : {
                                message : '性别不能为空'
                            }

                        }
                    }
                }
            });
        }

        function application() {
            // 异步添加学生
            $.ajax({
                url : "driverServlet?action=application",// 请求地址
                type : "POST", // 请求类型
                async : "true", // 是否异步方式
                data : $("#registerform").serialize(), // 表单的序列化
                dataType : "json",
                success : function(data) {
                    if (data.res == 1) {
                        alert(data.info);
                        window.location.replace("driverServlet?action=queryDriver");
                    }else if(data.res == -2){
                        alert(data.info);
                        window.location.replace("drlogin.jsp");
                    }
                    else {
                        alert(data.info);
                    }
                }
            });
            return false;
        }

        //显示校验结果的提示信息
        function show_validate_msg(ele, status, msg) {
            //清除当前元素的校验状态
            $(ele).parent().removeClass("has-success has-error");
//       $(ele).next("span").text("");
            $(".help-block1").text("");
            if (status == "success") {
                $(ele).parent().addClass("has-success");
//           $(ele).next("span").text(msg);
//           $(".help-block").text(msg);
            } else if (status == "error") {
                //渲染输入框,清空这个元素之前的样式
                $(ele).parent().addClass("has-error");
                //显示错误提示
//           $(ele).next("span").text(msg);
                $(".help-block1").text(msg);
            }
        }
        function gg() {
            var bootstrapValidator=$("#registerform").data("bootstrapValidator");
            //触发验证
            bootstrapValidator.validate();
            //如果验证通过，则调用login方法
            if(bootstrapValidator.isValid()){
                application();
            }
        }
    </script>
</head>
<body>
<div class="container">
    <div class="row">
        <div class="col-sm-offset-3 col-sm-6 text-center">
            <h3>申请成为平台正式司机</h3>
        </div>
    </div>
    <form class="form-horizontal col-sm-offset-3" id="registerform" method="post">
        <div class="form-group">
            <label for="relname" class="col-sm-2 control-label">真实姓名：</label>
            <div class="col-sm-4">
                <input type="text" class="form-control" name="relname" id="relname" placeholder="请输入你的真实姓名">
                <span class="help-block1" style="color: #a94442"></span>
            </div>
        </div>
        <div class="form-group">
            <label for="platenumber" class="col-sm-2 control-label">车牌号：</label>
            <div class="col-sm-4">
                <input type="text" class="form-control" name="platenumber" placeholder="请输入你的车牌号">
            </div>
        </div>
        <div class="form-group">
            <label for="idcard" class="col-sm-2 control-label">身份证号：</label>
            <div class="col-sm-4">
                <input type="number" class="form-control" name="idcard" placeholder="请输入身份证号">
            </div>
        </div>
        <div class="form-group">
            <label for="carcolor" class="col-sm-2 control-label">车身颜色：</label>
            <div class="col-sm-4">
                <input type="text" class="form-control" name="carcolor" placeholder="请输入车身颜色">
            </div>
        </div>
        <div class="form-group">
            <label for="motorcycle" class="col-sm-2 control-label">车型：</label>
            <div class="col-sm-4">
                <input type="text" class="form-control" name="motorcycle" placeholder="请输入车型">
            </div>
        </div>
        <div class="form-group">
            <label for="birthday" class="col-sm-2 control-label">出生日期：</label>
            <div class="col-sm-4">
                <div class="input-group date form_datetime" data-date-format="dd-MM-yyyy" data-link-field="dtp_input1">
                    <input class="form-control" size="16" type="text" name="birthday" id="birthday" value="2000-01-01" readonly>
                    <span class="input-group-addon"><span class="glyphicon glyphicon-remove"></span></span>
                    <span class="input-group-addon"><span class="glyphicon glyphicon-th"></span></span>
                </div>
            </div>
        </div>
        <div class="form-group has-error">
            <div class="col-sm-offset-2 col-sm-4 col-xs-6 ">
                <span class="text-warning" style="color: #a94442"></span>
            </div>
        </div>
        <div class="form-group">
            <div class="col-sm-offset-2 col-sm-4 col-xs-12">
                <button class="btn btn-success btn-block" id="btn btn-success btn-block" onclick="gg();">提交审核</button>
            </div>
        </div>
    </form>
</div>
</body>
</html>
