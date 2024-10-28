package com.jypc.dao;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.orm.hibernate3.HibernateTemplate;
import org.springframework.stereotype.Component;

import com.jypc.bean.ParkTypeBean;

@Component("parkTypeDao")
public class ParkTypeDao {
	private HibernateTemplate hibernateTemplate;

	public HibernateTemplate getHibernateTemplate() {
		return hibernateTemplate;
	}

	@Resource(name = "hibernateTemplate")
	public void setHibernateTemplate(HibernateTemplate hibernateTemplate) {
		this.hibernateTemplate = hibernateTemplate;
	}

	/**
	 * 
	 * @return list集合
	 */
	@SuppressWarnings("unchecked")
	public List<ParkTypeBean> getAllParkTypeList() {
		return this.hibernateTemplate.find("from ParkTypeBean");
	}

	/**
	 * 统计总记录数
	 * 
	 * @return记录总数
	 */
	public int getRecordCounter() {
		return this.hibernateTemplate.find("from ParkTypeBean").size();
	}
}
