package com.cartest.pojo;

import java.util.Date;

public class Examine {
    private int examine_id;
    private String examine_in;
    private String examine_pwd;
    private int student_id;
    private String student_answer;
    private int score;
    private int paper_id;
    private Date examine_date;
    private char status;

    public int getExamine_id() {
        return examine_id;
    }

    public void setExamine_id(int examine_id) {
        this.examine_id = examine_id;
    }

    public String getExamine_in() {
        return examine_in;
    }

    public void setExamine_in(String examine_in) {
        this.examine_in = examine_in;
    }

    public String getExamine_pwd() {
        return examine_pwd;
    }

    public void setExamine_pwd(String examine_pwd) {
        this.examine_pwd = examine_pwd;
    }

    public int getStudent_id() {
        return student_id;
    }

    public void setStudent_id(int student_id) {
        this.student_id = student_id;
    }

    public String getStudent_answer() {
        return student_answer;
    }

    public void setStudent_answer(String student_answer) {
        this.student_answer = student_answer;
    }

    public int getScore() {
        return score;
    }

    public void setScore(int score) {
        this.score = score;
    }

    public int getPaper_id() {
        return paper_id;
    }

    public void setPaper_id(int paper_id) {
        this.paper_id = paper_id;
    }

    public Date getExamine_date() {
        return examine_date;
    }

    public void setExamine_date(Date examine_date) {
        this.examine_date = examine_date;
    }

    public char getStatus() {
        return status;
    }

    public void setStatus(char status) {
        this.status = status;
    }
}
