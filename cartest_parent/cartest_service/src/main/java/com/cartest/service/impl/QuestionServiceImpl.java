package com.cartest.service.impl;

import com.cartest.dao.ProductTypeDao;
import com.cartest.dao.QuestionDao;
import com.cartest.pojo.Question;
import com.cartest.service.QuestionService;
import oracle.jdbc.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@Transactional(propagation = Propagation.REQUIRED,rollbackFor = Exception.class)
public class QuestionServiceImpl  implements QuestionService {

    @Autowired
    private QuestionDao questionDao;

    @Override
    public List<Question> getTestPaper(Map testPaperMap) {
//        testPaperMap.put("res_cursor",null);
        questionDao.createTestPaper(testPaperMap);
        List<Question> questionList = (List<Question>) testPaperMap.get("res_cursor");
        return questionList;
    }

    @Override
    public Question queryQuestionById(int questionId) {
        return questionDao.selectQuestionById(questionId);
    }
}
