package com.cartest.frontweb.controller;

import cartest.common.constant.PaginationConstant;
import com.cartest.pojo.ProductType;
import com.cartest.service.ProductTypeService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.ObjectUtils;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequestMapping("/productType")
public class ProductTypeController {

    @Autowired
    private ProductTypeService productTypeService;

    @RequestMapping("/findAll")
    public String findAll(Integer pageNum,Model model){
//        if(ObjectUtils.isEmpty(pageNum)){
//            pageNum = PaginationConstant.PAGE_NUM;
//        }
//        //设置分页
//        PageHelper.startPage(pageNum,PaginationConstant.PAGE_SIZE);
//
//
//        //查找所有商品类型
//        List<ProductType> productTypes = productTypeService.findAll();
//        //将查询出来的对象封装到PageInfo对象中
//        PageInfo<ProductType> pageInfo = new PageInfo<>(productTypes);
//        model.addAttribute("pageInfo",pageInfo);

        return "productTypeManager";
    }

}
