package com.cartest.service.impl;

import com.cartest.dao.StudentDao;
import com.cartest.pojo.Student;
import com.cartest.service.StudentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;


@Service
@Transactional(propagation = Propagation.REQUIRED,rollbackFor = Exception.class)
public class StudentServiceImpl implements StudentService {

    @Autowired
    private StudentDao studentDao;

    @Override
    public Student findStudent(int studentId) {
        return studentDao.queryStudentById(studentId);
    }

    @Override
    @Transactional
    public int createStudent(Student student) {
        if(student.getStudent_name() != null && !"".equals(student.getStudent_name())){
            if (student.getStudent_pin() != null && !"".equals(student.getStudent_pin())){
                if(student.getStudent_phone() != null && !"".equals(student.getStudent_phone())){
                    try{
                        int studentInsertSuccess = studentDao.insertStudent(student);
                        if(studentInsertSuccess > 0){
                            return studentInsertSuccess;
                        }else{
                            throw new RuntimeException("插入考生信息失败！");
                        }
                    }catch (Exception e){
                        throw new RuntimeException("插入考生信息失败！");
                    }
                }
            }
        }
        return 0;
    }
}
