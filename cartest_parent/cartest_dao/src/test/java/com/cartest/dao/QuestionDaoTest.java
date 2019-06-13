package com.cartest.dao;

import com.cartest.pojo.Question;
import oracle.jdbc.OracleTypes;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static org.junit.Assert.*;


public class QuestionDaoTest {
    
    @Autowired
    private QuestionDao questionDao;

//    @Test
//    public void getdata(){
//        Map temp = new HashMap();
//        temp.put("res_cursor", OracleTypes.CURSOR);
//        List<Question> questions = questionDao.createTestPaper(temp);
//        System.out.println("questions = " + questions);
//    }
//    @Test
//    public void getdata1(){
//        Question q = (Question) questionDao.cTestPaper();
//        System.out.println("q.getQuestion_body() = " + q.getQuestion_body());
//    }
    
}