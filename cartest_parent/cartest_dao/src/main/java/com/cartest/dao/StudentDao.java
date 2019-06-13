package com.cartest.dao;

import com.cartest.pojo.Student;

public interface StudentDao {
    public Student queryStudentById(int studentId);
    public int insertStudent(Student student);
}
