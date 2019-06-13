package com.cartest.service;

import com.cartest.pojo.TestPaper;

public interface TestPaperService {
    public int createTestPaper(TestPaper testPaper);
    public TestPaper queryTestPaperById(int paperId);
}
