package service;

import entity.Admin;
import entity.Driver;
import entity.Passenger;
import util.PageBean;

public interface AdminService {
    Admin login(String name, String password)throws Exception ;
    PageBean<Passenger> findAllPassenger(int pc, int pr);//分页查找平台已注册乘客
    PageBean<Driver> findAllDriver(int pc, int pr);//分页查找平台已注册司机
    PageBean<Driver> findAllDriverByexamineStates(int pc, int pr,int states);
    int changedriverexamineStates(int driverid) throws Exception;//平台审核，改变司机状态
    Driver queryDriverBypaexist(int states);//根据司机状态查找司机信息
    int nochangedriverexamineStates(int driverid) throws Exception;//平台审核，不通过
}
