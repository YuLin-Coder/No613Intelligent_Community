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
import com.jypc.bean.DeliveryMoneyBean;
import com.jypc.bean.PagerView;

/**
 * 物业费用类
 * 
 * @author 郭波
 * 
 */
@Component(value = "deliveryMoneyDao")
public class DeliveryMoneyDao {
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
		return this.hibernateTemplate.find("from DeliveryMoneyBean").size();
	}

	/**
	 * 获取快递信息信息列表（分页）
	 * 
	 * @param pager
	 * @return 快递信息
	 */
	@SuppressWarnings("unchecked")
	public List<DeliveryMoneyBean> getDeliveryMoneyList(final PagerView pager) {
		return this.hibernateTemplate.executeFind(new HibernateCallback() {
			@Override
			public Object doInHibernate(Session session)
					throws HibernateException, SQLException {
				List<DeliveryMoneyBean> list = session
						.createQuery("from DeliveryMoneyBean")
						.setFirstResult(pager.getFirstRecordIndex())// 查询开始条数
						.setMaxResults(pager.getPageSize()).list();// 每个页面显示的条数

				return list;
			}
		});
	}

	/**
	 * 获取快递公司信息列表
	 * 
	 * @return 快递公司信息
	 */
	@SuppressWarnings("unchecked")
	public List<DeliveryFirmBean> getDeliveryMoneyList() {
		return this.hibernateTemplate.find("from DeliveryFirmBean");
	}

	/**
	 * 判断要添加的快递编号是否重复
	 * 
	 * @param mid
	 *            待判断的快递编号
	 * @return true[重复] false[不重复]
	 */
	public boolean exists(String mid) {
		int result = this.hibernateTemplate.findByNamedParam(
				"from DeliveryMoneyBean d where d.mid=:id", "id", mid).size();
		return result > 0 ? true : false;
	}

	/**
	 * 添加快递信息
	 * 
	 * @param model
	 *            携带添加数据的JavaBean
	 * @return 0[失败] >0[成功]
	 */
	public int deliveryMoneyAdd(DeliveryMoneyBean model) {
		return Integer.parseInt(this.hibernateTemplate.save(model).toString());
	}

	/**
	 * 删除快递收入信息
	 * 
	 * @param costId
	 *            物业费用costId
	 * @return
	 */
	public int delInfo(String mid) {
		try {
			this.hibernateTemplate.delete(this.hibernateTemplate.load(
					DeliveryMoneyBean.class, mid));
			return 1;
		} catch (Exception e) {
			return 0;
		}
	}

	/**
	 * 获取要修改的快递信息
	 * 
	 * @param mid
	 *            快递编号
	 * @return 存在，返回对象信息；不存在，则返回空
	 */
	public DeliveryMoneyBean getEditInfo(String mid) {
		return (DeliveryMoneyBean) this.hibernateTemplate.get(
				DeliveryMoneyBean.class, mid);
	}

	/**
	 * 修改快递收入信息
	 * 
	 * @param model携带修改过后的快递收入信息
	 * @return 0[失败] >0[成功]
	 */
	public int deliveryMoneyUpdate(DeliveryMoneyBean model) {
		try {
			this.hibernateTemplate.update(model);
			return 1;
		} catch (Exception e) {
			return 0;
		}
	}
}
