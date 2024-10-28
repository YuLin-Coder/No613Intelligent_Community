package com.jypc.dao;

import java.sql.SQLException;
import java.util.List;

import javax.annotation.Resource;

import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.springframework.orm.hibernate3.HibernateCallback;
import org.springframework.orm.hibernate3.HibernateTemplate;
import org.springframework.stereotype.Component;

import com.jypc.bean.PagerView;
import com.jypc.bean.PaymentBean;
import com.jypc.bean.TenementBean;

/**
 * 住户补款类
 * 
 * @author 郭波
 * 
 */
@Component(value = "completeCostDao")
public class CompleteCostDao {
	HibernateTemplate hibernateTemplate;

	@Resource(name = "hibernateTemplate")
	public void setHibernateTemplate(HibernateTemplate hibernateTemplate) {
		this.hibernateTemplate = hibernateTemplate;
	}

	/**
	 * 统计记录总数（存在欠费）
	 * 
	 * @return 记录条数
	 */
	public int getDataNum() {
		return this.hibernateTemplate.find(
				"from PaymentBean p where p.payable > p.practical").size();
	}

	/**
	 * 获取住户补款信息（分页）
	 * 
	 * @param pager
	 *            页码
	 * @return 住户补款信息
	 */
	@SuppressWarnings("unchecked")
	public List<PaymentBean> getCompleteCostList(final PagerView pager) {
		return this.hibernateTemplate.executeFind(new HibernateCallback() {
			@Override
			public Object doInHibernate(Session session)
					throws HibernateException, SQLException {
				List<PaymentBean> list = session
						.createQuery(
								"from PaymentBean p where p.payable > p.practical")
						.setFirstResult(pager.getFirstRecordIndex())// 查询开始条数
						.setMaxResults(pager.getPageSize()).list();// 每个页面显示的条数
				return list;
			}
		});
	}

	/**
	 * 统计记录总数（存在欠费，并且根据身份证号进行查询）
	 * 
	 * @return 记录条数
	 */
	public int getDataNumIdcard(String idCard) {
		return this.hibernateTemplate
				.find("from PaymentBean p where p.payable > p.practical and p.tenementModel.idCard=?",
						new String[] { idCard }).size();
	}

	/**
	 * 根据身份证号获取存在欠费的信息列表（分页）
	 * 
	 * @param pager
	 * @param idCard
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<PaymentBean> getCompleteCostIdcard(final PagerView pager,
			final String idCard) {
		return this.hibernateTemplate.executeFind(new HibernateCallback() {
			@Override
			public Object doInHibernate(Session session)
					throws HibernateException, SQLException {
				List<PaymentBean> list = session
						.createQuery(
								"from PaymentBean p where p.tenementModel.idCard=:idCard and p.payable > p.practical")
						.setParameter("idCard", idCard)
						.setFirstResult(pager.getFirstRecordIndex())// 查询开始条数
						.setMaxResults(pager.getPageSize()).list();// 每个页面显示的条数
				return list;
			}
		});
	}

	/**
	 * 获取住户缴费信息
	 * 
	 * @return 住户缴费信息
	 */
	@SuppressWarnings("unchecked")
	public List<PaymentBean> getPaymentList() {
		return this.hibernateTemplate.find("from PaymentBean");
	}

	/**
	 * 判断要确认信息的身份证号是否存在
	 * 
	 * @param idCard
	 *            待判断的身份证号
	 * @return true[重复] false[不重复]
	 */
	public boolean existsIdCard(String idCard) {
		int result = this.hibernateTemplate.findByNamedParam(
				"from TenementBean t where t.idCard=:id", "id", idCard).size();
		return result > 0 ? true : false;
	}

	/**
	 * 获取缴费信息
	 * 
	 * @param payId
	 *            缴费编号
	 * @return 存在，返回对象信息；不存在，则返回空
	 */
	public PaymentBean getEditInfo(String payId) {
		return (PaymentBean) this.hibernateTemplate.get(PaymentBean.class,
				payId);
	}

	/**
	 * 根据身份证号码获取住户信息
	 * 
	 * @param idCard
	 *            身份证号
	 * @return 存在，返回对象信息；不存在，则返回空
	 */
	@SuppressWarnings("unchecked")
	public List<TenementBean> getTenementInfo(String idCard) {
		return this.hibernateTemplate.findByNamedParam(
				"from TenementBean t where t.idCard=:id", "id", idCard);
	}

	/**
	 * 修改物业费用信息
	 * 
	 * @param model携带修改过后的物业费用信息
	 * @return 0[失败] >0[成功]
	 */
	public int paymentUpdate(PaymentBean model) {
		try {
			this.hibernateTemplate.update(model);
			return 1;
		} catch (Exception e) {
			return 0;
		}
	}

}
