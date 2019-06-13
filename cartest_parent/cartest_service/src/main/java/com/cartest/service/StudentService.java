package com.cartest.service;



import com.cartest.pojo.Student;

import java.util.List;
import java.util.Map;

public interface StudentService {
    /**
     * 获取单个考生信息信息
     * @return Student
     */
    public Student findStudent(int studentId);

    /**
     * 考生注册
     * @return StudentID
     */
    public int createStudent(Student student);
}
