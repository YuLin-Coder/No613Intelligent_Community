package com.jypc.dao;

import java.sql.SQLException;
import java.util.List;

import javax.annotation.Resource;

import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.springframework.orm.hibernate3.HibernateCallback;
import org.springframework.orm.hibernate3.HibernateTemplate;
import org.springframework.stereotype.Component;

import com.jypc.bean.CardBean;
import com.jypc.bean.PagerView;

@Component(value = "cardDao")
public class CardDao {

	private HibernateTemplate hibernateTemplate;

	@Resource(name = "hibernateTemplate")
	public void setHibernateTemplate(HibernateTemplate hibernateTemplate) {
		this.hibernateTemplate = hibernateTemplate;
	}

	/**
	 * 分页
	 * 
	 * @param
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<CardBean> getPagerCardList(final PagerView pager) {
		return this.hibernateTemplate.executeFind(new HibernateCallback() {

			@Override
			public Object doInHibernate(Session session)
					throws HibernateException, SQLException {

				return session
						.createQuery(" from CardBean c join fetch c.roomModel")
						.setFirstResult(pager.getFirstRecordIndex())
						.setMaxResults(pager.getPageSize()).list();
			}
		});
	}

	/*
	 * public List<CardBean> getPagerCardList(PagerViewBean pagerView) {
	 * 
	 * List<CardBean> list = new ArrayList<CardBean>(); DbHelper db = new
	 * DbHelper(); String sql =
	 * "select tb_card.*,tb_room.RoomName from tb_card INNER JOIN tb_room on tb_card.roomId=tb_room.roomId limit ?,?"
	 * ; ResultSet rs = db.executeQuery(sql, pagerView.getFristRecoredIndex(),
	 * pagerView.getPageSize());
	 * 
	 * try { while (rs.next()) { CardBean model = new CardBean();
	 * model.setCardId(rs.getString("cardId"));
	 * model.setExtent(rs.getString("extent"));
	 * model.setStateFlag(rs.getInt("stateFlag"));
	 * 
	 * RoomBean roomModel = new RoomBean();
	 * roomModel.setRoomId(rs.getString("roomId"));
	 * roomModel.setRoomName(rs.getString("roomName"));
	 * model.setRoomModel(roomModel); list.add(model); } } catch (SQLException
	 * e) { // TODO Auto-generated catch block e.printStackTrace(); }
	 * db.close(); return list;
	 * 
	 * }
	 */
	/**
	 * 
	 * @return list集合
	 */
	@SuppressWarnings("unchecked")
	public List<CardBean> getAllCardList() {

		/*
		 * List<CardBean> list = new ArrayList<CardBean>(); DbHelper db = new
		 * DbHelper(); String sql = "select * from tb_card "; ResultSet rs =
		 * db.executeQuery(sql); try { while (rs.next()) { CardBean model = new
		 * CardBean(); model.setCardId(rs.getString("cardId"));
		 * model.setExtent(rs.getString("extent"));
		 * model.setStateFlag(rs.getInt("stateFlag"));
		 * 
		 * RoomBean roomModel = new RoomBean();
		 * roomModel.setRoomId(rs.getString("roomId"));
		 * roomModel.setRoomName(rs.getString("roomName"));
		 * model.setRoomModel(roomModel);
		 * 
		 * list.add(model); } } catch (SQLException e) { // TODO Auto-generated
		 * e.printStackTrace(); }
		 * 
		 * finally { db.close(); } return list;
		 */

		return this.hibernateTemplate.find("from CardBean ");
	}

	/**
	 * 统计总记录数
	 * 
	 * @return记录总数
	 */
	public int getRecordCounter() {

		/*
		 * DbHelper db = new DbHelper(); String sql =
		 * "select count(*) from tb_card";
		 * 
		 * return db.getIntScalar(sql);
		 */

		return this.hibernateTemplate.find("from CardBean").size();
	}

	/**
	 * 获取智能卡对象
	 * 
	 * @param cardId智能卡号
	 * @return cardBean
	 */

	public CardBean getCardBean(String cardId) {
		return (CardBean) this.hibernateTemplate.get(CardBean.class, cardId);
	}

	/**
	 * 修改
	 * 
	 * @param model
	 * @return
	 */

	public int Update(CardBean model) {

		try {
			this.hibernateTemplate.update(model);
			return 1;
		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		}
	}

	/**
	 * 删除所选信息
	 * 
	 * @param cardId
	 * @return
	 */

	public int delSelected(String cardId) {
		try {
			this.hibernateTemplate.delete(this.hibernateTemplate.load(
					CardBean.class, cardId));
			return 1;
		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		}
	}

	/*
	 * 添加班级信息
	 * 
	 * @param model 班级对象
	 * 
	 * @return 受影响的记录行数
	 */

	public int add(CardBean model) {
		try {
			this.hibernateTemplate.save(model);
			return 1;
		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		}
	}

}
