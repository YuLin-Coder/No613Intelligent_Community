package com.jypc.dao;

import java.sql.SQLException;
import java.util.List;

import javax.annotation.Resource;

import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.springframework.orm.hibernate3.HibernateCallback;
import org.springframework.orm.hibernate3.HibernateTemplate;
import org.springframework.stereotype.Component;

import com.jypc.bean.OwenrBean;
import com.jypc.bean.PagerView;

/**
 * 物业费用类
 * 
 */
@Component(value = "owenrDao")
public class OwenrDao {
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
		return this.hibernateTemplate.find("from OwenrBean").size();
	}

	/**
	 * 获取物业费用信息列表（分页）
	 * 
	 * @param pager
	 * @return 物业费用信息
	 */
	@SuppressWarnings("unchecked")
	public List<OwenrBean> getOwenrList(final PagerView pager) {
		return this.hibernateTemplate.executeFind(new HibernateCallback() {
			@Override
			public Object doInHibernate(Session session)
					throws HibernateException, SQLException {
				List<OwenrBean> list = session.createQuery("from OwenrBean")
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
	public List<OwenrBean> getOwenrList() {
		return this.hibernateTemplate.find("from OwenrBean");
	}

	/**
	 * 判断要添加的费用编号是否重复
	 * 
	 * @param owenrId
	 *            待判断的费用编号
	 * @return true[重复] false[不重复]
	 */
	public boolean exists(String owenrId) {
		int result = this.hibernateTemplate.findByNamedParam(
				"from OwenrBean o where o.owenrId=:id", "id", owenrId).size();
		return result > 0 ? true : false;
	}

	/**
	 * 添加物业费用信息
	 * 
	 * @param model
	 *            携带添加数据的JavaBean
	 * @return 0[失败] >0[成功]
	 */
	public int owenrAdd(OwenrBean model) {
		return Integer.parseInt(this.hibernateTemplate.save(model).toString());
	}

	/**
	 * 删除物业费用信息
	 * 
	 * @param owenrId
	 *            物业费用owenrId
	 * @return
	 */
	public int delInfo(String owenrId) {
		try {
			this.hibernateTemplate.delete(this.hibernateTemplate.load(
					OwenrBean.class, owenrId));
			return 1;
		} catch (Exception e) {
			return 0;
		}
	}

	/**
	 * 获取要修改的物业费用信息
	 * 
	 * @param owenrId
	 *            费用编号
	 * @return 存在，返回费用对象信息；不存在，则返回空
	 */
	public OwenrBean getEditInfo(String owenrId) {
		return (OwenrBean) this.hibernateTemplate.get(OwenrBean.class, owenrId);
	}

	/**
	 * 修改物业费用信息
	 * 
	 * @param model携带修改过后的物业费用信息
	 * @return 0[失败] >0[成功]
	 */
	public int owenrUpdate(OwenrBean model) {
		try {
			this.hibernateTemplate.update(model);
			return 1;
		} catch (Exception e) {
			return 0;
		}
	}
}
