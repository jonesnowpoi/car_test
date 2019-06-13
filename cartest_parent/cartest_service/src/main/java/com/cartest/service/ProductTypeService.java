package com.cartest.service;

import com.cartest.pojo.ProductType;

import java.util.List;

public interface ProductTypeService {


    /**
     * 查找所有商品的类型信息
     * @return
     */
    public List<ProductType> findAll();
}
