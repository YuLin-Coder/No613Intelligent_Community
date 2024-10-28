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
import com.jypc.bean.ParkkingBean;

@Component("parkkingDao")
public class ParkkingDao {
	private HibernateTemplate hibernateTemplate;

	public HibernateTemplate getHibernateTemplate() {
		return hibernateTemplate;
	}

	@Resource(name = "hibernateTemplate")
	public void setHibernateTemplate(HibernateTemplate hibernateTemplate) {
		this.hibernateTemplate = hibernateTemplate;
	}

	/**
	 * 
	 * @return list集合
	 */
	@SuppressWarnings("unchecked")
	public List<ParkkingBean> getAllParkkingList() {

		return this.hibernateTemplate
				.find("from ParkkingBean p where p.RoomId is not null");

		/*
		 * List<ParkkingBean> list = new ArrayList<ParkkingBean>(); DbHelper db
		 * = new DbHelper(); String sql = "SELECT * FROM tb_parkking"; ResultSet
		 * rs = db.executeQuery(sql); try { while (rs.next()) { ParkkingBean
		 * model = new ParkkingBean(); model.setCarNum(rs.getString("carNum"));
		 * model.setExtent(rs.getString("extent"));
		 * model.setCarType(rs.getString("carType"));
		 * model.setParkkingId(rs.getString("parkkingId"));
		 * model.setRemarks(rs.getString("remarks"));
		 * 
		 * RoomBean roomModel = new RoomBean();
		 * roomModel.setRoomId(rs.getString("roomId"));
		 * roomModel.setRoomName(rs.getString("roomName"));
		 * model.setRoomModel(roomModel);
		 * 
		 * ParkSRTypeBean parkSRTypeModel = new ParkSRTypeBean();
		 * parkSRTypeModel.setParkSRId(rs.getString("parkSRId"));
		 * parkSRTypeModel.setParkSRName(rs.getString("parkSRName"));
		 * model.setParkSRTypeModel(parkSRTypeModel);
		 * 
		 * ParkTypeBean parkTypeModel = new ParkTypeBean();
		 * parkTypeModel.setPtId(rs.getString("ptId"));
		 * parkTypeModel.setName(rs.getString("name"));
		 * model.setParkTypeModel(parkTypeModel);
		 * 
		 * list.add(model); } } catch (SQLException e) { // TODO Auto-generated
		 * e.printStackTrace(); }
		 * 
		 * finally { db.close(); } return list;
		 */

	}

	/**
	 * 统计总记录数
	 * 
	 * @return记录总数
	 */
	public int getRecordCounter() {
		return this.hibernateTemplate.find("from ParkkingBean").size();
	}

	/**
	 * 分页
	 * 
	 * @param
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<ParkkingBean> getPagerCardList(final PagerView pager) {
		return this.hibernateTemplate.executeFind(new HibernateCallback() {

			@Override
			public Object doInHibernate(Session session)
					throws HibernateException, SQLException {

				return session
						.createQuery(
								" from ParkkingBean p join fetch p.roomModel ")
						.setFirstResult(pager.getFirstRecordIndex())
						.setMaxResults(pager.getPageSize()).list();
			}
		});
	}

	/**
	 * 出租销售分页
	 * 
	 * @param
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<ParkkingBean> getPagerList(final PagerView pager) {
		return this.hibernateTemplate.executeFind(new HibernateCallback() {

			@Override
			public Object doInHibernate(Session session)
					throws HibernateException, SQLException {

				return session.createQuery("from ParkkingBean")
						.setFirstResult(pager.getFirstRecordIndex())
						.setMaxResults(pager.getPageSize()).list();
			}
		});
	}

	/**
	 * 添加信息
	 * 
	 * @param model
	 *            班级对象
	 * @return 受影响的记录行数
	 */
	public int add(ParkkingBean model) {
		try {
			this.hibernateTemplate.save(model);
			return 1;
		} catch (Exception e) {
			e.printStackTrace();
			/*this.hibernateTemplate.update(model);*/
			return 0;
		}
	}

	/**
	 * 判重
	 * 
	 * @param roomName
	 * @return
	 */
	/*
	 * public boolean IsExstCarNum(String parkkingId) { return
	 * (this.hibernateTemplate .findByNamedParam(
	 * "select (carNum) from ParkkingBean s where s.parkkingId=:parkkingId",
	 * "parkkingId", parkkingId).size()) > 0 ? true : false; }
	 *//**
	 * 判重
	 * 
	 * @param roomName
	 * @return
	 */
	public boolean IsExstCarNum(String carNum) {
		return (this.hibernateTemplate.findByNamedParam(
				"from ParkkingBean s where s.carNum=:carNum", "carNum", carNum)
				.size()) > 0 ? true : false;
	}

	/**
	 * 删除所选信息 parkkingId 
	 * 
	 * @return 删除的记录条数
	 */
	public int delSelected(String parkkingId) {
		try {
			this.hibernateTemplate.delete(this.hibernateTemplate.load(
					ParkkingBean.class, parkkingId));
			return 1;
		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		}
	}

	/**
	 * 获取对象
	 * 
	 * @param parkkingId
	 * @return
	 */
	public ParkkingBean getParkkingBean(String parkkingId) {
		return (ParkkingBean) this.hibernateTemplate.get(ParkkingBean.class,
				parkkingId);
	}

	/**
	 * 修改
	 * 
	 * @param model
	 * @return
	 */
	public int Update(ParkkingBean model) {

		try {
			this.hibernateTemplate.update(model);
			return 1;
		} catch (Exception e) {
			return 0;
		}
	}

	/**
	 * 判断未处理的车位是否存在
	 * 
	 * @param rid
	 * @return
	 */
	public boolean IsExisted(String parkkingId) {

		ParkkingBean parkkingBean = (ParkkingBean) this.hibernateTemplate.get(
				ParkkingBean.class, parkkingId);
		if (parkkingBean == null) {
			return true;
		} else {
			return false;
		}
	}
	/**
	 * 获取待编辑的已处理的车位对象
	 * @param parkkingId
	 * @return
	 */
	public ParkkingBean getParkkingModel(String id) {
		return (ParkkingBean) this.hibernateTemplate.get(ParkkingBean.class, id);
	}

	/**
	 * 修改编辑的已处理的车位对象
	 * @param model
	 * @return
	 */
	public int UpdateParkkingModel(ParkkingBean model) {

		try {
			this.hibernateTemplate.update(model);
			return 1;
		} catch (Exception e) {
			return 0;
		}
	}
}
