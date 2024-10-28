package com.jypc.dao;

import java.sql.SQLException;
import java.util.List;

import javax.annotation.Resource;

import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.springframework.orm.hibernate3.HibernateCallback;
import org.springframework.orm.hibernate3.HibernateTemplate;
import org.springframework.stereotype.Component;

import com.jypc.bean.CostBean;
import com.jypc.bean.PagerView;
import com.jypc.bean.ParkTypeBean;
import com.jypc.bean.ParkkingBean;
import com.jypc.bean.ParkkingMoneyBean;

/**
 * 车位缴费信息类
 * 
 * @author 郭波
 * 
 */
@Component(value = "parkkingMoneyDao")
public class ParkkingMoneyDao {
	HibernateTemplate hibernateTemplate;

	@Resource(name = "hibernateTemplate")
	public void setHibernateTemplate(HibernateTemplate hibernateTemplate) {
		this.hibernateTemplate = hibernateTemplate;
	}

	/**
	 * 统计记录总数
	 * 
	 * @return 记录条数
	 */
	public int getDataNum() {
		return this.hibernateTemplate.find("from ParkkingMoneyBean").size();
	}

	/**
	 * 获取车位缴费信息（分页）
	 * 
	 * @param pager
	 *            页码
	 * @return 车位缴费信息
	 */
	@SuppressWarnings("unchecked")
	public List<ParkkingMoneyBean> getParkkingMoneyList(final PagerView pager) {
		return this.hibernateTemplate.executeFind(new HibernateCallback() {
			@Override
			public Object doInHibernate(Session session)
					throws HibernateException, SQLException {
				List<CostBean> list = session
						.createQuery("from ParkkingMoneyBean")
						.setFirstResult(pager.getFirstRecordIndex())// 查询开始条数
						.setMaxResults(pager.getPageSize()).list();// 每个页面显示的条数
				return list;
			}
		});
	}

	/**
	 * 判断要确认信息的车牌号是否存在
	 * 
	 * @param carNum
	 *            待判断的身份证号
	 * @return true[重复] false[不重复]
	 */
	public boolean existsCarInfo(String carNum) {
		int result = this.hibernateTemplate.findByNamedParam(
				"from ParkkingBean p where p.carNum=:id", "id", carNum).size();
		return result > 0 ? true : false;
	}

	/**
	 * 判断要添加的车位缴费编号是否重复
	 * 
	 * @param payId
	 *            待判断的缴费编号
	 * @return true[重复] false[不重复]
	 */
	public boolean existsParkkingMoneyId(String parkkingMoneyId) {
		int result = this.hibernateTemplate.findByNamedParam(
				"from ParkkingMoneyBean p where p.parkkingMoneyId=:id", "id",
				parkkingMoneyId).size();
		return result > 0 ? true : false;
	}

	/**
	 * 添加车位缴费信息
	 * 
	 * @param model
	 *            携带添加数据的JavaBean
	 * @return 0[失败] >0[成功]
	 */
	public int parkkingMoneyAdd(ParkkingMoneyBean model) {
		return Integer.parseInt(this.hibernateTemplate.save(model).toString());
	}

	/**
	 * 删除车费缴费信息
	 * 
	 * @param parkkingMoneyId
	 *            车费缴费编号
	 * @return
	 */
	public int delInfo(String parkkingMoneyId) {
		try {
			this.hibernateTemplate.delete(this.hibernateTemplate.load(
					ParkkingMoneyBean.class, parkkingMoneyId));
			return 1;
		} catch (Exception e) {
			return 0;
		}
	}

	/**
	 * 获取车位类型信息
	 * 
	 * @return 车位类型信息
	 */
	@SuppressWarnings("unchecked")
	public List<ParkTypeBean> getParkTypeList() {
		return this.hibernateTemplate.find("from ParkTypeBean");
	}

	/**
	 * 根据车牌号获取相关信息
	 * 
	 * @param carNum
	 *            车牌号
	 * @return 存在，返回对象信息；不存在，则返回空
	 */
	@SuppressWarnings("unchecked")
	public List<ParkkingBean> getCarInfo(String carNum) {
		return this.hibernateTemplate.findByNamedParam(
				"from ParkkingBean p where p.carNum=:id", "id", carNum);
	}

	/**
	 * 获取要修改的车费缴费信息
	 * 
	 * @param parkkingMoneyId
	 *            车费缴费编号
	 * @return 存在，返回对象信息；不存在，则返回空
	 */
	public ParkkingMoneyBean getEditInfo(String parkkingMoneyId) {
		return (ParkkingMoneyBean) this.hibernateTemplate.get(
				ParkkingMoneyBean.class, parkkingMoneyId);
	}

	/**
	 * 修改车费缴费信息
	 * 
	 * @param model携带修改过后的物业费用信息
	 * @return 0[失败] >0[成功]
	 */
	public int parkkingMoneyUpdate(ParkkingMoneyBean model) {
		try {
			this.hibernateTemplate.update(model);
			return 1;
		} catch (Exception e) {
			return 0;
		}
	}
}
