package com.jypc.dao;

import java.sql.SQLException;
import java.util.List;

import javax.annotation.Resource;

import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.springframework.orm.hibernate3.HibernateCallback;
import org.springframework.orm.hibernate3.HibernateTemplate;
import org.springframework.stereotype.Component;

import com.jypc.bean.AssetTypeBean;

import com.jypc.bean.PagerView;

/**
 * 资产类型类
 * 
 */
@Component(value = "assetTypeDao")
public class AssetTypeDao {
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
		return this.hibernateTemplate.find("from AssetTypeBean").size();
	}

	/**
	 * 获取资产类型信息列表（分页）
	 * 
	 * @param pager
	 * @return 资产类型信息
	 */
	@SuppressWarnings("unchecked")
	public List<AssetTypeBean> getAssetTypeList(final PagerView pager) {
		return this.hibernateTemplate.executeFind(new HibernateCallback() {
			@Override
			public Object doInHibernate(Session session)
					throws HibernateException, SQLException {
				List<AssetTypeBean> list = session
						.createQuery("from AssetTypeBean")
						.setFirstResult(pager.getFirstRecordIndex())
						.setMaxResults(pager.getPageSize()).list();

				return list;
			}
		});
	}

	/**
	 * 获取资产类型信息列表
	 * 
	 * @return 资产类型信息
	 */
	@SuppressWarnings("unchecked")
	public List<AssetTypeBean> getAssetTypeList() {
		return this.hibernateTemplate.find("from AssetTypeBean");
	}

	/**
	 * 判断要添加的资产类型编号是否重复
	 * 
	 * @param assetTypeId
	 *            待判断的资产类型编号
	 * @return true[重复] false[不重复]
	 */
	public boolean exists(String assetTypeId) {
		int result = this.hibernateTemplate.findByNamedParam(
				"from AssetTypeBean where assetTypeId=:id", "id", assetTypeId)
				.size();
		return result > 0 ? true : false;
	}

	/**
	 * 添加物业资产类型信息
	 * 
	 * @param model
	 *            携带添加数据的JavaBean
	 * @return 0[失败] >0[成功]
	 */
	public int assetAdd(AssetTypeBean model) {
		return Integer.parseInt(this.hibernateTemplate.save(model).toString());
	}

	/**
	 * 删除单条资产类型信息
	 * 
	 * @param assetTypeId
	 *            资产类型assetTypeId
	 * @return
	 */
	public int delInfo(String assetTypeId) {
		try {
			this.hibernateTemplate.delete(this.hibernateTemplate.load(
					AssetTypeBean.class, assetTypeId));
			return 1;
		} catch (Exception e) {
			return 0;
		}
	}

	/**
	 * 获取要修改的资产类型信息
	 * 
	 * @param assetTypeId
	 *            费用编号
	 * @return 存在，返回费用对象信息；不存在，则返回空
	 */
	public AssetTypeBean getEditInfo(String assetTypeId) {
		return (AssetTypeBean) this.hibernateTemplate.get(AssetTypeBean.class,
				assetTypeId);
	}

	/**
	 * 修改物业费用信息
	 * 
	 * @param model携带修改过后的物业费用信息
	 * @return 0[失败] >0[成功]
	 */
	public int assetUpdate(AssetTypeBean model) {
		try {
			this.hibernateTemplate.update(model);
			return 1;
		} catch (Exception e) {
			return 0;
		}
	}
}
