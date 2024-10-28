package com.jypc.dao;

import java.sql.SQLException;
import java.util.List;

import javax.annotation.Resource;

import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.springframework.orm.hibernate3.HibernateCallback;
import org.springframework.orm.hibernate3.HibernateTemplate;
import org.springframework.stereotype.Component;

import com.jypc.bean.CommunityInfoBean;
import com.jypc.bean.PagerView;
import com.jypc.bean.VillageInfoBean;

@Component(value = "villageinfoDao")
public class VillageinfoDao {
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
		return this.hibernateTemplate.find("from VillageInfoBean ").size();
	}

	/**
	 * 获取楼房信息列表（分页）
	 * 
	 * @param pager
	 * @return 物业费用信息
	 */
	@SuppressWarnings("unchecked")
	public List<VillageInfoBean> getVillageInfoList(final PagerView pager) {
		return this.hibernateTemplate.executeFind(new HibernateCallback() {
			@Override
			public Object doInHibernate(Session session)
					throws HibernateException, SQLException {
				List<VillageInfoBean> list = session
						.createQuery(
								"from VillageInfoBean v join fetch v.communityModel")
						.setFirstResult(pager.getFirstRecordIndex())
						.setMaxResults(pager.getPageSize()).list();

				return list;
			}
		});
	}

	/**
	 * 获取信息列表
	 * 
	 * @return 信息
	 */
	@SuppressWarnings("unchecked")
	public List<VillageInfoBean> getVillageInfoList() {
		return this.hibernateTemplate.find("from VillageInfoBean");
	}

	/**
	 * 判断要添加的小区是否重复
	 * 
	 * @param villageId
	 *            待判断的小区编号
	 * @return true[重复] false[不重复]
	 */
	public boolean exists(String villageId) {
		int result = this.hibernateTemplate
				.findByNamedParam(
						"from VillageInfoBean c where c.villageId=:id", "id",
						villageId).size();
		return result > 0 ? true : false;
	}

	/**
	 * 添加小区信息
	 * 
	 * @param model
	 *            携带添加数据的JavaBean
	 * @return 0[失败] >0[成功]
	 */
	public int villageAdd(VillageInfoBean model) {
		try {
			this.hibernateTemplate.save(model);
			return 1;
		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		}
	}

	/**
	 * 删除单条小区信息
	 * 
	 * @param villageId
	 *            小区villageId
	 * @return
	 */
	public int delInfo(String villageId) {
		try {
			this.hibernateTemplate.delete(this.hibernateTemplate.load(
					VillageInfoBean.class, villageId));
			return 1;
		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		}
	}

	/**
	 * 获取要修改的小区信息
	 * 
	 * @param villageId
	 *            小区编号
	 * @return 存在，返回小区对象信息；不存在，则返回空
	 */
	public VillageInfoBean getEditInfo(String villageId) {
		return (VillageInfoBean) this.hibernateTemplate.get(
				VillageInfoBean.class, villageId);
	}

	/**
	 * 修改小区信息
	 * 
	 * @param model携带修改过后的小区信息
	 * @return 0[失败] >0[成功]
	 */
	public int villageUpdate(VillageInfoBean model) {
		try {
			this.hibernateTemplate.update(model);
			return 1;
		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		}
	}

}
