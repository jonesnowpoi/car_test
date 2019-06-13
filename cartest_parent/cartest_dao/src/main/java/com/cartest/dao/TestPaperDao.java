package com.cartest.dao;

import com.cartest.pojo.TestPaper;

public interface TestPaperDao {
    public TestPaper selectTestPaperById(int paperId);
    public int insertTestPaper(TestPaper testPaper);
}
