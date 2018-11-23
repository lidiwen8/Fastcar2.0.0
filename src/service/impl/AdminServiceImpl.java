package service.impl;

import dao.AdminDao;
import dao.impl.AdminDaoImpl;
import entity.Admin;
import entity.Driver;
import entity.Passenger;
import service.AdminService;
import util.PageBean;

public class AdminServiceImpl implements AdminService {
   AdminDao adminDao= new AdminDaoImpl();
    public Admin login(String name, String password)throws Exception {
        return adminDao.login(name,password);
    }
    public PageBean<Passenger> findAllPassenger(int pc, int pr){
        return adminDao.findAllPassenger(pc,pr);
    }
    public PageBean<Driver> findAllDriver(int pc, int pr){
        return adminDao.findAllDriver(pc,pr);
    }
    public PageBean<Driver> findAllDriverByexamineStates(int pc, int pr,int states){
        return  adminDao.findAllDriverByexamineStates(pc,pr,states);
    }
    public int changedriverexamineStates(int driverid) throws Exception{
        return  adminDao.changedriverexamineStates(driverid);
    }
    public int nochangedriverexamineStates(int driverid) throws Exception{
        return  adminDao.nochangedriverexamineStates(driverid);
    }
    public Driver queryDriverBypaexist(int states){
        return adminDao.queryDriverBypaexist(states);
    }
}
