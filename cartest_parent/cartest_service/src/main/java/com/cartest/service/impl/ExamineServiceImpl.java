package com.cartest.service.impl;

import cartest.common.util.NullJudge;
import com.cartest.dao.ExamineDao;
import com.cartest.pojo.Examine;
import com.cartest.service.ExamineService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.lang.reflect.InvocationTargetException;
import java.util.List;


@Service
@Transactional(propagation = Propagation.REQUIRED,rollbackFor = Exception.class)
public class ExamineServiceImpl implements ExamineService {

    @Autowired
    private ExamineDao examineDao;

    @Override
    @Transactional
    public int createExamine(Examine examine) {
        if(examine.getExamine_in() != null && !"".equals(examine.getExamine_in())){
            if(examine.getExamine_pwd() != null && !"".equals(examine.getExamine_pwd())){
                if(examine.getStudent_id() != 0){
                    if(examine.getStudent_answer() != null && !"".equals(examine.getStudent_answer())) {
                        if(examine.getScore() != 0){
                            if(examine.getPaper_id() != 0){
                                if(examine.getExamine_date() != null){
                                    if(examine.getStatus() != '\u0000'){
                                        try{
                                            int insertExamineSuccess = examineDao.insertExamine(examine);
                                            if(insertExamineSuccess > 0){
                                                return insertExamineSuccess;
                                            }else{
                                                throw new RuntimeException("插入考试信息失败！");
                                            }
                                        }catch (Exception e){
                                            throw new RuntimeException("插入考试信息失败！");
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        return 0;
    }

    @Override
    public List<Examine> queryExamineByStudentId(int studentId) {
        return examineDao.selectExamineByStudentId(studentId);
    }

    @Override
    public Examine queryExamineById(int examineId) {
        return examineDao.selectExamineById(examineId);
    }
}
