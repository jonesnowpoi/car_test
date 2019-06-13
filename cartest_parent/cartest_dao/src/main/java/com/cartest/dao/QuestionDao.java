package com.cartest.dao;

import com.cartest.pojo.Question;
import org.apache.ibatis.annotations.Param;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface QuestionDao {
    public List<Question> createTestPaper(Map testPaperMap);
    public Question selectQuestionById(int questionId);
    public List<Question> cTestPaper();
}
