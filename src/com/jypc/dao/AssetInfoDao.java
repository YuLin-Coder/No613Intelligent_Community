package com.jypc.dao;

import java.sql.SQLException;
import java.util.List;

import javax.annotation.Resource;

import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.springframework.orm.hibernate3.HibernateCallback;
import org.springframework.orm.hibernate3.HibernateTemplate;
import org.springframework.stereotype.Component;

import com.jypc.bean.AssetInfoBean;
import com.jypc.bean.AssetTypeBean;
import com.jypc.bean.PagerView;

/**
 * 资产类
 * 
 */
@Component(value = "assetInfoDao")
public class AssetInfoDao {
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
		return this.hibernateTemplate.find("from AssetInfoBean").size();
	}

	/**
	 * 获取资产信息列表（分页）
	 * 
	 * @param pager
	 * @return 资产信息
	 */
	@SuppressWarnings("unchecked")
	public List<AssetInfoBean> getAssetInfoList(final PagerView pager) {
		return this.hibernateTemplate.executeFind(new HibernateCallback() {
			@Override
			public Object doInHibernate(Session session)
					throws HibernateException, SQLException {
				List<AssetInfoBean> list = session
						.createQuery(
								"from AssetInfoBean c join fetch c.assetTypeModel")
						.setFirstResult(pager.getFirstRecordIndex())
						.setMaxResults(pager.getPageSize()).list();

				return list;
			}
		});
	}

	/**
	 * 获取资产信息列表
	 * 
	 * @return 资产信息
	 */
	@SuppressWarnings("unchecked")
	public List<AssetInfoBean> getAassetInfoList() {
		return this.hibernateTemplate.find("from AssetInfoBean");
	}

	/**
	 * 获取资产类型信息
	 * 
	 * @return 资产类型信息
	 */
	@SuppressWarnings("unchecked")
	public List<AssetTypeBean> getAssetTypeList() {
		return this.hibernateTemplate.find("from AssetTypeBean");
	}

	/**
	 * 判断要添加的资产编号是否重复
	 * 
	 * @param assetId
	 *            待判断的资产编号
	 * @return true[重复] false[不重复]
	 */
	public boolean exists(String assetId) {
		int result = this.hibernateTemplate.findByNamedParam(
				"from AssetInfoBean c where c.assetId=:id", "id", assetId)
				.size();
		return result > 0 ? true : false;
	}

	/**
	 * 添加资产信息
	 * 
	 * @param model
	 *            携带添加数据的JavaBean
	 * @return 0[失败] >0[成功]
	 */
	public int assetAdd(AssetInfoBean model) {
		return Integer.parseInt(this.hibernateTemplate.save(model).toString());
	}

	/**
	 * 删除单条资产信息
	 * 
	 * @param assetId
	 *            资产assetId
	 * @return
	 */
	public int delInfo(String assetId) {
		try {
			this.hibernateTemplate.delete(this.hibernateTemplate.load(
					AssetInfoBean.class, assetId));
			return 1;
		} catch (Exception e) {
			return 0;
		}
	}

	/**
	 * 获取要修改的资产信息
	 * 
	 * @param assetId
	 *            资产编号
	 * @return 存在，返回资产对象信息；不存在，则返回空
	 */
	public AssetInfoBean getEditInfo(String assetId) {
		return (AssetInfoBean) this.hibernateTemplate.get(AssetInfoBean.class,
				assetId);
	}

	/**
	 * 修改物业资产信息
	 * 
	 * @param model携带修改过后的资产信息
	 * @return 0[失败] >0[成功]
	 */
	public int assetUpdate(AssetInfoBean model) {
		try {
			this.hibernateTemplate.update(model);
			return 1;
		} catch (Exception e) {
			return 0;
		}
	}
}
