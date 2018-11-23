package servlet;
import entity.Admin;
import entity.Driver;
import entity.Order;
import entity.Passenger;
import service.AdminService;
import service.DriverService;
import service.OrderService;
import service.impl.AdminServiceImpl;
import service.impl.DrvierServiceImpl;
import service.impl.OrderServiceImpl;
import util.JsonUtil;
import util.Md5Encrypt;
import util.PageBean;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.Serializable;
import java.lang.reflect.Method;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

@WebServlet("/adminServlet")
public class AdminServlet extends HttpServlet {
    DriverService driverService = new DrvierServiceImpl();
    OrderService orderService = new OrderServiceImpl();
    AdminService adminService = new AdminServiceImpl();
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AdminServlet() {
        super();
    }

    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("utf-8");
        response.setContentType("text/html;charset=utf-8");
        String action=request.getParameter("action");
        try {
            //使用反射定义方法
            Method method=getClass().getDeclaredMethod(action, HttpServletRequest.class,
                    HttpServletResponse.class);
            //调用方法
            method.invoke(this, request,response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    private void logout(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String name= (String) request.getSession().getAttribute("admin");
        if(request.getSession().getAttribute("admin") != null) {
            request.getSession().invalidate();//使session无效
        }
        request.setAttribute("info", name+"管理员退出成功,欢迎你下次继续访问");
        request.getRequestDispatcher("login.jsp").forward(request,response);
    }

    private void login(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String name = request.getParameter("username");
        String password= request.getParameter("password");
        String password1=password;
        String verifyCode = request.getParameter("verifyCode");
        String rememberme = request.getParameter("rememberme");//记住登陆
        if ((name!=""&&password!="")) {
            String vcode = (String) request.getSession().getAttribute("vCode");
            if (verifyCode.equalsIgnoreCase(vcode)) {
                Md5Encrypt md5 = new Md5Encrypt();
                try {
                    password = md5.Encrypt(request.getParameter("password"));
                } catch (Exception e) {
                    e.printStackTrace();
                }
                if (adminService.login(name, password) != null) {
                        HttpSession session = request.getSession();
                        session.setAttribute("admin", name);//获取用户名
                        Admin admin = adminService.login(name, password);
                        request.setAttribute("info", name + "管理员登陆成功，欢迎你！");
                        //存入cookie
                        if(rememberme!=null) {
                            //创建两个Cookie对象
                            Cookie nameCookie = new Cookie("username", name);
                            //设置Cookie的有效期为3天
                            nameCookie.setMaxAge(60 * 60 * 24 * 3);
                            Cookie pwdCookie = new Cookie("password", password1);
                            pwdCookie.setMaxAge(60 * 60 * 24 * 3);
                            response.addCookie(nameCookie);
                            response.addCookie(pwdCookie);
                        }
                        request.getRequestDispatcher("admin/index.jsp").forward(request, response);
                        return;
                } else {
                    request.setAttribute("info", "用户名或密码错误！");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                    return;
                }
            }else {
                request.setAttribute("info", "验证码错误！");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }
        }else {
            request.setAttribute("info", "请输入用户名和密码！");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }
    }

    public String findAllDriver(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int pc = getPc(request);
        int pr = 5;//给定pr的值，每页5行纪录
        try {
            if(adminService.queryDriverBypaexist(3)==null){
                request.setAttribute("info", "尊敬的管理员你好，暂时还没有司机递交审核消息哟！");
                request.getRequestDispatcher("admin/index.jsp").forward(request, response);
                return "admin/index.jsp";
            }
            PageBean<Driver> pb = adminService.findAllDriverByexamineStates(pc, pr,3);
            pb.setUrl(getUrl(request));
            request.setCharacterEncoding("utf-8");
            request.setAttribute("pb",pb);
        }catch (RuntimeException e){
            request.setAttribute("info", "系统出错了！");
            request.getRequestDispatcher("admin/index.jsp").forward(request, response);
            return "admin/index.jsp";
        }
        request.getRequestDispatcher("admin/drvierlist.jsp").forward(request,response);
        return "f:admin/drvierlist.jsp";
    }
    public String findAllRegisterDriver(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int pc = getPc(request);
        int pr = 5;//给定pr的值，每页5行纪录
        try {
            PageBean<Driver> pb = adminService.findAllDriver(pc,pr);
            pb.setUrl(getUrl(request));
            request.setCharacterEncoding("utf-8");
            request.setAttribute("pb",pb);
        }catch (RuntimeException e){
            request.setAttribute("info", "系统出错了！");
            request.getRequestDispatcher("admin/index.jsp").forward(request, response);
            return "admin/index.jsp";
        }
        request.getRequestDispatcher("admin/registerdrvierlist.jsp").forward(request,response);
        return "f:admin/registerdrvierlist.jsp";
    }

    public String findAllDriverBypass(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int pc = getPc(request);
        int pr = 5;//给定pr的值，每页5行纪录
        try {
            PageBean<Driver> pb = adminService.findAllDriverByexamineStates(pc,pr,1);
            pb.setUrl(getUrl(request));
            request.setCharacterEncoding("utf-8");
            request.setAttribute("pb", pb);
        }catch (RuntimeException e){
            request.setAttribute("info", "系统出错了！");
            request.getRequestDispatcher("admin/index.jsp").forward(request, response);
            return "admin/index.jsp";
        }
        request.getRequestDispatcher("admin/drvierlist.jsp").forward(request,response);
        return "f:admin/drvierlist.jsp";
    }

    public String findAllDriverBynopass(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int pc = getPc(request);
        int pr = 5;//给定pr的值，每页5行纪录
        try {
            if(adminService.queryDriverBypaexist(2)==null){
                request.setAttribute("info", "尊敬的管理员你好，暂时还没有不通过审核的司机！");
                request.getRequestDispatcher("admin/index.jsp").forward(request, response);
                return "admin/index.jsp";
            }
            PageBean<Driver> pb = adminService.findAllDriverByexamineStates(pc,pr,2);
            pb.setUrl(getUrl(request));
            request.setCharacterEncoding("utf-8");
            request.setAttribute("pb", pb);
        }catch (RuntimeException e){
            request.setAttribute("info", "系统出错了！");
            request.getRequestDispatcher("admin/index.jsp").forward(request, response);
            return "admin/index.jsp";
        }
        request.getRequestDispatcher("admin/drvierlist.jsp").forward(request,response);
        return "f:admin/drvierlist.jsp";
    }
    public String findAllPassenger(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int pc = getPc(request);
        int pr = 5;//给定pr的值，每页5行纪录
        try {
            PageBean<Passenger> pb = adminService.findAllPassenger(pc,pr);//已结束的订单
            pb.setUrl(getUrl(request));
            request.setCharacterEncoding("utf-8");
            request.setAttribute("pb", pb);
        }catch (RuntimeException e){
            request.setAttribute("info", "系统出错了！");
            request.getRequestDispatcher("admin/index.jsp").forward(request, response);
            return "admin/index.jsp";
        }
        request.getRequestDispatcher("admin/passengerlist.jsp").forward(request,response);
        return "f:admin/passengerlist.jsp";
    }
    public void changedriverexamineStates(HttpServletRequest request, HttpServletResponse response)throws Exception{
        int driverid = Integer.parseInt(request.getParameter("driverid"));
        if(adminService.changedriverexamineStates(driverid)==1) {
            response.getWriter().print("{\"res\": 1, \"info\":\"该司机已审核通过\"}");
            return;
        }else{
            response.getWriter().print("{\"res\": -1, \"info\":\"司机审核不通过\"}");
            return;
        }
    }

    public void nochangedriverexamineStates(HttpServletRequest request, HttpServletResponse response)throws Exception{
        int driverid = Integer.parseInt(request.getParameter("driverid"));
        if(adminService.nochangedriverexamineStates(driverid)==1) {
            response.getWriter().print("{\"res\": 1, \"info\":\"司机审核不通过\"}");
            return;
        }else{
            response.getWriter().print("{\"res\": -1, \"info\":\"系统出错了！\"}");
            return;
        }
    }

    private int getPc(HttpServletRequest request) {
        String value = request.getParameter("pc");

        if (value == null || value.trim().isEmpty()) {
            return 1;
        }
        return Integer.parseInt(value);
    }
    private String getUrl(HttpServletRequest request) {
        String contextPath = request.getContextPath();
        String servletPath = request.getServletPath();
        String queryString = request.getQueryString();

        if (queryString.contains("&pc=")) {
            int index = queryString.lastIndexOf("&pc=");
            queryString = queryString.substring(0, index);
        }

        return contextPath + servletPath + "?" + queryString;
    }
    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // TODO Auto-generated method stub
        doGet(request, response);
    }

}
