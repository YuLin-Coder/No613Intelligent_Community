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
import com.jypc.bean.RoomBean;

@Component("roomDao")
public class RoomDao {

	private HibernateTemplate hibernateTemplate;

	public HibernateTemplate getHibernateTemplate() {
		return hibernateTemplate;
	}

	@Resource(name = "hibernateTemplate")
	public void setHibernateTemplate(HibernateTemplate hibernateTemplate) {
		this.hibernateTemplate = hibernateTemplate;
	}

	/**
	 * 取得所有房间
	 * 
	 * @return list集合
	 */
	@SuppressWarnings("unchecked")
	public List<RoomBean> getAllRoomList() {
		return this.hibernateTemplate.find("from RoomBean u");
	}

	/**
	 * 分页
	 * 
	 * @param
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<RoomBean> getPagedRoomList(final PagerView pager) {
		return this.hibernateTemplate.executeFind(new HibernateCallback() {

			@Override
			public Object doInHibernate(Session session)
					throws HibernateException, SQLException {
				return session.createQuery("from RoomBean")
						.setFirstResult(pager.getFirstRecordIndex())
						.setMaxResults(pager.getPageSize()).list();
			}
		});
	}

	/**
	 * 删除房间信息
	 * 
	 * @param roomId
	 *            房间号
	 * @return 删除的记录条数
	 */
	public int delSelected(String roomId) {
		try {
			this.hibernateTemplate.delete(this.hibernateTemplate.load(
					RoomBean.class, roomId));
			return 1;
		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		}
	}

	/**
	 * 添加房间
	 * 
	 * @param model
	 * @return
	 */
	public int addroom(RoomBean model) {
		try {
			this.hibernateTemplate.save(model);
			return 1;
		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		}
	}

	/**
	 * 获取对象
	 * 
	 * @param roomId
	 * @return
	 */
	public RoomBean getRoomBean(String roomId) {
		return (RoomBean) this.hibernateTemplate.get(RoomBean.class, roomId);
	}

	/**
	 * 修改
	 * 
	 * @param model
	 * @return
	 */
	public int Update(RoomBean model) {
		try {
			this.hibernateTemplate.update(model);
			return 1;
		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		}

	}

	/**
	 * 判重
	 * 
	 * @param roomName
	 * @return
	 */
	public boolean IsExstRoomName(String roomName) {
		return (this.hibernateTemplate.findByNamedParam(
				"from RoomBean r where r.roomName=:roomName", "roomName",
				roomName).size()) > 0 ? true : false;
	}

	/**
	 * 统计总记录数
	 * 
	 * @return记录总数
	 */
	public int getRecordCounter() {
		return this.hibernateTemplate.find("from RoomBean").size();
	}

	/**
	 * 统计记录总数
	 * 
	 * @return 记录条数
	 */
	public int getDataNum() {
		return this.hibernateTemplate.find("from RoomBean ").size();
	}

	/**
	 * 获取楼房信息列表（分页）
	 * 
	 * @param pager
	 * @return 物业费用信息
	 */
	@SuppressWarnings("unchecked")
	public List<RoomBean> getRoomList(final PagerView pager) {
		return this.hibernateTemplate.executeFind(new HibernateCallback() {
			@Override
			public Object doInHibernate(Session session)
					throws HibernateException, SQLException {
				List<RoomBean> list = session
						.createQuery(
								"from RoomBean r join fetch r.buildingModel")
						.setFirstResult(pager.getFirstRecordIndex())
						.setMaxResults(pager.getPageSize()).list();

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
	public List<RoomBean> getRoomList() {
		return this.hibernateTemplate.find("from RoomBean");
	}

	/**
	 * 删除单条物业费用信息
	 * 
	 * @param costId
	 *            物业费用costId
	 * @return
	 */
	public int delInfo(String roomId) {
		try {
			this.hibernateTemplate.delete(this.hibernateTemplate.load(
					RoomBean.class, roomId));
			return 1;
		} catch (Exception e) {
			return 0;
		}
	}

	/**
	 * 添加信息
	 * 
	 * @param model
	 * @return
	 */
	public int add(RoomBean model) {
		try {
			this.hibernateTemplate.save(model);
			return 1;
		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		}
	}

	/**
	 * 获取要修改的信息
	 * 
	 * @param roomId
	 *            编号
	 * @return 存在，返回对象信息；不存在，则返回空
	 */
	public RoomBean getEditInfo(String roomId) {
		return (RoomBean) this.hibernateTemplate.get(RoomBean.class, roomId);
	}

	/**
	 * 修改信息
	 * 
	 * @param model携带修改过后的信息
	 * @return 0[失败] >0[成功]
	 */
	public int update(RoomBean model) {
		try {
			this.hibernateTemplate.update(model);
			return 1;
		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		}
	}

	/**
	 * 判断是否存在
	 * 
	 * @param roomId
	 * @return
	 */
	public boolean existed(String roomId) {
		int result = this.hibernateTemplate.findByNamedParam(
				"from RoomBean r where r.roomId=:id", "id", roomId).size();
		return result > 0 ? true : false;
	}
}
