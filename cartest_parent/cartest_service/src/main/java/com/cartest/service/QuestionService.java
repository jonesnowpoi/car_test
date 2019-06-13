package com.cartest.service;

import com.cartest.pojo.ProductType;
import com.cartest.pojo.Question;

import java.util.List;
import java.util.Map;

public interface QuestionService {
    /**
     * 获取10道考题信息
     * @return List<Question>
     */
    public List<Question> getTestPaper(Map testPaperMap);
    /**
     * 获取单道考题信息
     * @return Question
     */
    public Question queryQuestionById(int questionId);
}
