package com.cartest.service.impl;

import com.cartest.dao.ProductTypeDao;
import com.cartest.pojo.ProductType;
import com.cartest.service.ProductTypeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional(propagation = Propagation.REQUIRED,rollbackFor = Exception.class)
public class ProductTypeServiceImpl implements ProductTypeService {

    @Autowired
    private ProductTypeDao productTypeDao;

    @Override
    @Transactional(propagation = Propagation.SUPPORTS ,readOnly = true)
    public List<ProductType> findAll() {
        return productTypeDao.selectAll();
    }
}
