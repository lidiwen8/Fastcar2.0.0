package dao.impl;

import cn.itcast.jdbc.TxQueryRunner;
import dao.AdminDao;
import entity.Admin;
import entity.Driver;
import entity.Passenger;
import org.apache.commons.dbutils.QueryRunner;
import org.apache.commons.dbutils.handlers.BeanHandler;
import org.apache.commons.dbutils.handlers.BeanListHandler;
import org.apache.commons.dbutils.handlers.ScalarHandler;
import util.PageBean;

import java.util.List;

public class AdminDaoImpl implements AdminDao {
    private QueryRunner mysqlDao = new TxQueryRunner();
    @Override
    public Admin login(String name, String password) {
        try {
            return mysqlDao.query("select * from admin where name=? and pwd=?", new BeanHandler<Admin>(Admin.class),name,password);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }

    }

    @Override
    public PageBean<Passenger> findAllPassenger(int pc, int pr)//分页查找全部乘客
    {
        try{
            PageBean<Passenger> pb=new PageBean<>();
            pb.setPc(pc);
            pb.setPr(pr);
            String sql="select count(*) from passenger";
//            Object[] param={0};
            Number number=(Number) mysqlDao.query(sql,new ScalarHandler<>());
            int tr=number.intValue();
            pb.setTr(tr);
            sql="select * from passenger order by passengerid limit ?,?";
            Object[] params={(pc-1)*pr,pr};
            List<Passenger> beanList=mysqlDao.query(sql,new BeanListHandler<>(Passenger.class),params);
            pb.setBeanList(beanList);
            return pb;
        }catch (Exception e)
        {
            throw new RuntimeException(e);
        }
    }

    @Override
    public PageBean<Driver> findAllDriver(int pc, int pr)//分页查找全部司机
    {
        try{
            PageBean<Driver> pb=new PageBean<>();
            pb.setPc(pc);
            pb.setPr(pr);
            String sql="select count(*) from driver";
//            Object[] param={0};
            Number number=(Number) mysqlDao.query(sql,new ScalarHandler<>());
            int tr=number.intValue();
            pb.setTr(tr);
            sql="select * from driver order by driverid limit ?,?";
            Object[] params={(pc-1)*pr,pr};
            List<Driver> beanList=mysqlDao.query(sql,new BeanListHandler<>(Driver.class),params);
            pb.setBeanList(beanList);
            return pb;
        }catch (Exception e)
        {
            throw new RuntimeException(e);
        }
    }
    @Override
    public PageBean<Driver> findAllDriverByexamineStates(int pc, int pr,int states)//分页查找全部司机
    {
        try{
            PageBean<Driver> pb=new PageBean<>();
            pb.setPc(pc);
            pb.setPr(pr);
            String sql="select count(*) from driver where examineStates= ?";
            Object[] param={states};
            Number number=(Number) mysqlDao.query(sql,new ScalarHandler<>(),param);
            int tr=number.intValue();
            pb.setTr(tr);
            sql="select * from driver where examineStates= ? order by driverid limit ?,?";
            Object[] params={states,(pc-1)*pr,pr};
            List<Driver> beanList=mysqlDao.query(sql,new BeanListHandler<>(Driver.class),params);
            pb.setBeanList(beanList);
            return pb;
        }catch (Exception e)
        {
            throw new RuntimeException(e);
        }
    }
    @Override
    public int changedriverexamineStates(int driverid)throws Exception{
        int flag=0;
        String sql ="update driver set examineStates=? where driverid=?";
        Object[] params={1,driverid};
        try {
            //事务开始
            mysqlDao.update(sql,params);
            flag=1;
            //事务提交
        } catch (Exception e) {
            e.printStackTrace();
            //事务回滚
            flag=0;
            throw e;
        }
        return flag;
    }

    @Override
    public int nochangedriverexamineStates(int driverid)throws Exception{
        int flag=0;
        String sql ="update driver set examineStates=? where driverid=?";
        Object[] params={2,driverid};
        try {
            //事务开始
            mysqlDao.update(sql,params);
            flag=1;
            //事务提交
        } catch (Exception e) {
            e.printStackTrace();
            //事务回滚
            flag=0;
            throw e;
        }
        return flag;
    }

    @Override
    public Driver queryDriverBypaexist(int states){
        try {
            return mysqlDao.query("select * from driver where examineStates=?", new BeanHandler<Driver>(Driver.class),states);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }

    }
}
