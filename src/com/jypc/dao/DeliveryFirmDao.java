package com.jypc.dao;

import java.sql.SQLException;
import java.util.List;

import javax.annotation.Resource;

import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.springframework.orm.hibernate3.HibernateCallback;
import org.springframework.orm.hibernate3.HibernateTemplate;
import org.springframework.stereotype.Component;

import com.jypc.bean.DeliveryFirmBean;
import com.jypc.bean.PagerView;

/**
 * 快递公司类
 * 
 * @author 郭波
 * 
 */
@Component(value = "deliveryFirmDao")
public class DeliveryFirmDao {
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
		return this.hibernateTemplate.find("from DeliveryFirmBean").size();
	}

	/**
	 * 获取快递公司信息列表（分页）
	 * 
	 * @param pager
	 * @return 快递公司信息
	 */
	@SuppressWarnings("unchecked")
	public List<DeliveryFirmBean> getDeliveryFirmList(final PagerView pager) {
		return this.hibernateTemplate.executeFind(new HibernateCallback() {
			@Override
			public Object doInHibernate(Session session)
					throws HibernateException, SQLException {
				List<DeliveryFirmBean> list = session
						.createQuery("from DeliveryFirmBean")
						.setFirstResult(pager.getFirstRecordIndex())// 查询开始条数
						.setMaxResults(pager.getPageSize()).list();// 每个页面显示的条数

				return list;
			}
		});
	}

	/**
	 * 判断要添加的快递公司编号是否重复
	 * 
	 * @param deliveryfirmId
	 *            待判断的公司编号
	 * @return true[重复] false[不重复]
	 */
	public boolean exists(String deliveryfirmId) {
		int result = this.hibernateTemplate.findByNamedParam(
				"from DeliveryFirmBean d where d.deliveryfirmId=:id", "id",
				deliveryfirmId).size();
		return result > 0 ? true : false;
	}

	/**
	 * 添加快递公司信息
	 * 
	 * @param model
	 *            携带添加数据的JavaBean
	 * @return 0[失败] >0[成功]
	 */
	public int deliveryFirmAdd(DeliveryFirmBean model) {
		return Integer.parseInt(this.hibernateTemplate.save(model).toString());
	}

	/**
	 * 删除快递公司信息
	 * 
	 * @param deliveryfirmId
	 *            快递公司编号
	 * @return
	 */
	public int delInfo(String deliveryfirmId) {
		try {
			this.hibernateTemplate.delete(this.hibernateTemplate.load(
					DeliveryFirmBean.class, deliveryfirmId));
			return 1;
		} catch (Exception e) {
			return 0;
		}
	}

	/**
	 * 获取要修改的快递公司信息
	 * 
	 * @param deliveryfirmId
	 *            公司编号
	 * @return 存在，返回对象信息；不存在，则返回空
	 */
	public DeliveryFirmBean getEditInfo(String deliveryfirmId) {
		return (DeliveryFirmBean) this.hibernateTemplate.get(
				DeliveryFirmBean.class, deliveryfirmId);
	}

	/**
	 * 修改快递公司信息
	 * 
	 * @param model携带修改过后的快递公司信息
	 * @return 0[失败] >0[成功]
	 */
	public int deliveryFirmUpdate(DeliveryFirmBean model) {
		try {
			this.hibernateTemplate.update(model);
			return 1;
		} catch (Exception e) {
			return 0;
		}
	}
}
