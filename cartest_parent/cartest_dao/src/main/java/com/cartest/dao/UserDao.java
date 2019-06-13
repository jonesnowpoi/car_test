package com.cartest.dao;

import com.cartest.pojo.User;

public interface UserDao {
    public int insertUser(User user);
    public User selectUserByLoginName(String LoginName);
}
