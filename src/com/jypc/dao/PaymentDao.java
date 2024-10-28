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
import com.jypc.bean.CostTypeBean;
import com.jypc.bean.PagerView;
import com.jypc.bean.PaymentBean;
import com.jypc.bean.TenementBean;

/**
 * 住户缴费类
 * 
 * @author 郭波
 * 
 */
@Component(value = "paymentDao")
public class PaymentDao {
	HibernateTemplate hibernateTemplate;

	@Resource(name = "hibernateTemplate")
	public void setHibernateTemplate(HibernateTemplate hibernateTemplate) {
		this.hibernateTemplate = hibernateTemplate;
	}

	/**
	 * 统计固定费用记录总数
	 * 
	 * @return 记录条数
	 */
	public int getDataNum() {
		return this.hibernateTemplate.find(
				"from PaymentBean p where p.costModel.costTypeModel.ctId=01")
				.size();
	}

	/**
	 * 获取住户固定缴费信息（分页）
	 * 
	 * @param pager
	 *            页码
	 * @return 住户缴费信息
	 */
	@SuppressWarnings("unchecked")
	public List<PaymentBean> getPaymentList(final PagerView pager) {
		return this.hibernateTemplate.executeFind(new HibernateCallback() {
			@Override
			public Object doInHibernate(Session session)
					throws HibernateException, SQLException {
				List<CostBean> list = session
						.createQuery(
								"from PaymentBean p where p.costModel.costTypeModel.ctId=01")
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
	 * 获取费用类型信息
	 * 
	 * @return 费用类型信息
	 */
	@SuppressWarnings("unchecked")
	public List<CostTypeBean> getCostTypeList() {
		return this.hibernateTemplate.find("from CostTypeBean");
	}

	/**
	 * 获取所有固定费用信息列表
	 * 
	 * @return 固定费用信息
	 */
	@SuppressWarnings("unchecked")
	public List<CostBean> getCostList() {
		return this.hibernateTemplate
				.find("from CostBean c where c.costTypeModel.ctId=01");
	}

	/**
	 * 判断要添加的缴费编号是否重复
	 * 
	 * @param payId
	 *            待判断的缴费编号
	 * @return true[重复] false[不重复]
	 */
	public boolean existsPayId(String payId) {
		int result = this.hibernateTemplate.findByNamedParam(
				"from PaymentBean p where p.payId=:id", "id", payId).size();
		return result > 0 ? true : false;
	}

	/**
	 * 判断要添加的缴费数据是否存在
	 * 
	 * @param id
	 *            待判断的缴费编号
	 * @param costId
	 *            待判断的费用编号
	 * @param years
	 *            待判断的年份
	 * @param momths
	 *            待判断的月份
	 * @return true[存在] false[不存在]
	 */
	public boolean exists(String tenementId, String costId, String years,
			String months) {
		int result = this.hibernateTemplate
				.find("from PaymentBean p where p.tenementModel.tenementId=? and p.costModel.costId=? and p.years=? and p.months=?",
						new String[] { tenementId, costId, years, months })
				.size();
		return result > 0 ? true : false;
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
	 * 添加住户缴费信息
	 * 
	 * @param model
	 *            携带添加数据的JavaBean
	 * @return 0[失败] >0[成功]
	 */
	public int paymentAdd(PaymentBean model) {
		return Integer.parseInt(this.hibernateTemplate.save(model).toString());
	}

	/**
	 * 删除住户缴费信息
	 * 
	 * @param payId
	 *            缴费编号
	 * @return
	 */
	public int delInfo(String payId) {
		try {
			this.hibernateTemplate.delete(this.hibernateTemplate.load(
					PaymentBean.class, payId));
			return 1;
		} catch (Exception e) {
			return 0;
		}
	}

	/**
	 * 获取要修改的缴费信息
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
