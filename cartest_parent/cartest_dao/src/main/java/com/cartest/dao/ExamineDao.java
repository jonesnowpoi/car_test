package com.cartest.dao;

import com.cartest.pojo.Examine;

import java.util.List;

public interface ExamineDao {
    public int insertExamine(Examine examine);
    public List<Examine> selectExamineByStudentId(int studentId);
    public Examine selectExamineById(int examineId);
}
