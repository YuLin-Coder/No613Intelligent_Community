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

/**
 * 物业费用类
 * 
 * @author 郭波
 * 
 */
@Component(value = "costDao")
public class CostDao {
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
		return this.hibernateTemplate.find("from CostBean").size();
	}

	/**
	 * 获取物业费用信息列表（分页）
	 * 
	 * @param pager
	 * @return 物业费用信息
	 */
	@SuppressWarnings("unchecked")
	public List<CostBean> getCostList(final PagerView pager) {
		return this.hibernateTemplate.executeFind(new HibernateCallback() {
			@Override
			public Object doInHibernate(Session session)
					throws HibernateException, SQLException {
				List<CostBean> list = session.createQuery("from CostBean")
						.setFirstResult(pager.getFirstRecordIndex())// 查询开始条数
						.setMaxResults(pager.getPageSize()).list();// 每个页面显示的条数

				return list;
			}
		});
	}

	/**
	 * 获取物业费用信息列表
	 * 
	 * @return 物业费用信息
	 */
	@SuppressWarnings("unchecked")
	public List<CostBean> getCostList() {
		return this.hibernateTemplate.find("from CostBean");
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
	 * 判断要添加的费用编号是否重复
	 * 
	 * @param costId
	 *            待判断的费用编号
	 * @return true[重复] false[不重复]
	 */
	public boolean exists(String costId) {
		int result = this.hibernateTemplate.findByNamedParam(
				"from CostBean c where c.costId=:id", "id", costId).size();
		return result > 0 ? true : false;
	}

	/**
	 * 添加物业费用信息
	 * 
	 * @param model
	 *            携带添加数据的JavaBean
	 * @return 0[失败] >0[成功]
	 */
	public int costAdd(CostBean model) {
		return Integer.parseInt(this.hibernateTemplate.save(model).toString());
	}

	/**
	 * 删除物业费用信息
	 * 
	 * @param costId
	 *            物业费用costId
	 * @return
	 */
	public int delInfo(String costId) {
		try {
			this.hibernateTemplate.delete(this.hibernateTemplate.load(
					CostBean.class, costId));
			return 1;
		} catch (Exception e) {
			return 0;
		}
	}

	/**
	 * 获取要修改的物业费用信息
	 * 
	 * @param costId
	 *            费用编号
	 * @return 存在，返回费用对象信息；不存在，则返回空
	 */
	public CostBean getEditInfo(String costId) {
		return (CostBean) this.hibernateTemplate.get(CostBean.class, costId);
	}

	/**
	 * 修改物业费用信息
	 * 
	 * @param model携带修改过后的物业费用信息
	 * @return 0[失败] >0[成功]
	 */
	public int costUpdate(CostBean model) {
		try {
			this.hibernateTemplate.update(model);
			return 1;
		} catch (Exception e) {
			return 0;
		}
	}
}
