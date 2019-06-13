package com.cartest.service.impl;

import com.cartest.dao.TestPaperDao;
import com.cartest.pojo.TestPaper;
import com.cartest.service.TestPaperService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional(propagation = Propagation.REQUIRED,rollbackFor = Exception.class)
public class TestPaperServiceImpl implements TestPaperService {
    @Autowired
    private TestPaperDao testPaperDao;


    @Override
    @Transactional
    public int createTestPaper(TestPaper testPaper) {
        if(testPaper.getQuestion_id_seq() != null && !"".equals(testPaper.getQuestion_id_seq())){
            if(testPaper.getKey_seq() != null && !"".equals(testPaper.getKey_seq())){
                try{
                    int paperInsertSuccess = testPaperDao.insertTestPaper(testPaper);
                    if(paperInsertSuccess > 0){
                        return paperInsertSuccess;
                    }else{
                        throw new RuntimeException("插入考卷失败！");
                    }
                }catch (Exception e){
                    throw new RuntimeException("插入考卷失败！");
                }
            }
        }
        return 0;
    }

    @Override
    public TestPaper queryTestPaperById(int paperId) {
        return testPaperDao.selectTestPaperById(paperId);
    }
}
