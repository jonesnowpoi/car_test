package com.cartest.service.impl;

import com.cartest.dao.UserDao;
import com.cartest.pojo.User;
import com.cartest.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional(propagation = Propagation.REQUIRED,rollbackFor = Exception.class)
public class UserServiceImpl implements UserService {
    @Autowired
    private UserDao userDao;

    @Override
    public int createUser(User user) {
        if(user.getUser_name() != null && !"".equals(user.getUser_name())){
            if(user.getLogin_name() != null && !"".equals(user.getLogin_name())){
                if(user.getPassword()!= null && !"".equals(user.getPassword())){
                    try{
                        int userInsertSuccess = userDao.insertUser(user);
                        if(userInsertSuccess > 0){
                            return userInsertSuccess;
                        }else{
                            throw new RuntimeException("插入用户失败！");
                        }
                    }catch (Exception e){
                        throw new RuntimeException("插入用户失败！");
                    }

                }
            }
        }
        return 0;
    }

    @Override
    public User queryUserByLoginName(String loginName) {
        return userDao.selectUserByLoginName(loginName);
    }
}
