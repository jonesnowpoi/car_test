package com.cartest.frontweb.controller;

import cartest.common.constant.ResponseStatusConstant;
import cartest.common.util.ResponseResult;
import com.cartest.pojo.Student;
import com.cartest.pojo.User;
import com.cartest.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Enumeration;

@Controller
@RequestMapping("/user")
public class UserController {

    @Autowired
    private UserService userService;

    @RequestMapping("/login")
    @ResponseBody
    public ResponseResult login(@RequestBody User user, HttpServletRequest request){
        //实现登录
        ResponseResult result = new ResponseResult();
        User user_data = userService.queryUserByLoginName(user.getLogin_name());
        if(user_data != null){
            if(user.getPassword().equals(user_data.getPassword())){
                result.setStatus(ResponseStatusConstant.RESPONSE_STATUS_SUCCESS);
                result.setMessage("登录成功！");
                request.getSession().setAttribute("user",user_data);
                request.getSession().setMaxInactiveInterval(60*60);//以秒为单位，即在没有活动1小时后，session将失效
            }else{
                result.setStatus(ResponseStatusConstant.RESPONSE_STATUS_FAILURE_ERROR);
                result.setMessage("密码错误,请检查后重新输入!");
            }
        }else{
            result.setStatus(ResponseStatusConstant.RESPONSE_STATUS_FAILURE);
            result.setMessage("用户不存在,请检查后重新输入!");
        }

        return result;
    }
    @RequestMapping(value = "/userRegistered",method = RequestMethod.GET)
    public String getUserRegistered(){
        //返回注册页面
        return "userRegistered";
    }
    @RequestMapping(value = "/userRegistered",method = RequestMethod.POST)
    @ResponseBody
    public ResponseResult UserRegistered(@RequestBody User user){
        //实现注册
        ResponseResult result = new ResponseResult();
        User userExist = userService.queryUserByLoginName(user.getLogin_name());
        System.out.println("userExist = " + userExist);
        if(userExist != null){
            result.setStatus(ResponseStatusConstant.RESPONSE_STATUS_FAILURE);
            result.setMessage("帐号已存在，请输入别的账号进行注册！");
            return result;
        }
        int userInsertSuccess = userService.createUser(user);
        if(userInsertSuccess > 0){
            result.setStatus(ResponseStatusConstant.RESPONSE_STATUS_SUCCESS);
            result.setMessage("用户注册成功");
        }

        return result;
    }

    @RequestMapping("/exit")
    @ResponseBody
    public ResponseResult userExit(HttpServletRequest request){
        //实现退出
        ResponseResult result = new ResponseResult();
        HttpSession session = request.getSession();
        //清除原有session中的所有数据
        Enumeration em = request.getSession().getAttributeNames();
        while(em.hasMoreElements()){
            request.getSession().removeAttribute(em.nextElement().toString());
        }
        //设置返回参数
        result.setStatus(ResponseStatusConstant.RESPONSE_STATUS_SUCCESS);
        result.setMessage("考生退出成功");

        return result;
    }
}
