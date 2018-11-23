package dao;

import entity.Admin;
import entity.Driver;
import entity.Passenger;
import util.PageBean;

public interface AdminDao {
    Admin login(String name, String password)throws Exception;
    PageBean<Passenger> findAllPassenger(int pc, int pr);//分页查找平台已注册乘客
    PageBean<Driver> findAllDriver(int pc, int pr);//分页查找平台已注册司机
    PageBean<Driver> findAllDriverByexamineStates(int pc, int pr,int states);//分页查找平台已注册司机,通过平台审核状态
    int changedriverexamineStates(int driverid) throws Exception;
    int nochangedriverexamineStates(int driverid) throws Exception;
    Driver queryDriverBypaexist(int states);

}
