package com.cartest.service;

import com.cartest.pojo.User;

public interface UserService {
    public int createUser(User user);
    public User queryUserByLoginName(String loginName);
}
