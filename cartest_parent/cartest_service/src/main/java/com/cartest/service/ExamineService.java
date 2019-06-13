package com.cartest.service;

import com.cartest.pojo.Examine;

import java.util.List;

public interface ExamineService {
    public int createExamine(Examine examine);
    public List<Examine> queryExamineByStudentId(int studentId);
    public Examine queryExamineById(int examineId);
}
