<%--
  Created by IntelliJ IDEA.
  User: 16320
  Date: 2018/12/7
  Time: 12:38
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <base href="<%=basePath%>">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Insert title here</title>
</head>
<script type="text/javascript" src="/jquery/jquery-1.8.2.min.js" ></script>
<script>
    $(document).ready(function(){
        $("#query").keydown(function(){
            $(".addresstop").empty();
            $.post("<%=basePath%>/passengerServlet?action=queryinput",
                {
                    region:$("#hidden1_region").val(),
                    query:$("#query").val()
                },
                function(result){

                    var jsobject = JSON.parse(result);

                    for (var i = 0; i < jsobject.result.length; i++) {

                        $(".addresstop").append("<div class='addressli'>"
                            +"<div class='addressli1'>"+jsobject.result[i].name+"</div>"
                            +"<div class='addressli2'>"+jsobject.result[i].city+""+jsobject.result[i].district+"</div></div>");
                    }


                });
        });
    });
</script>

<input type="text" id="query"><input type="text" value="珠海" id="hidden1_region">
<div class="addresstop">

</div>
</body>
</html>
