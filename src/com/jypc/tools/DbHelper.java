package com.jypc.tools;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

public class DbHelper {

	private final String url = "jdbc:mysql://localhost:3306/community_manager";

	private final String userName = "root";
	private final String password = "root";

	private Connection conn = null;
	private Statement stmt = null;
	private PreparedStatement pstmt = null;

	// 以上都是成员变量

	// 通过构造方法加载数据库驱动
	public DbHelper() {
		try {
			Class.forName("com.mysql.jdbc.Driver").newInstance();
			conn = DriverManager.getConnection(url, userName, password);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * @功能 获取数据库连接对象
	 * @return 数据库连接对象
	 */
	public Connection getConnection() {
		return conn;
	}

	/**
	 * @功能 执行非查询的SQL语句，主要用于：增删改【Add、Del、Update】操作
	 * @参数 sql为要执行的SQL语句
	 * @返回值 受影响的行数
	 */
	public int executeUpdate(String sql) {
		int result = 0;
		try {
			stmt = conn.createStatement();
			result = stmt.executeUpdate(sql);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	/**
	 * @功能 执行事务
	 * @参数 sqlList 为要执行的SQL语句列表
	 * @返回值 受影响的行数
	 */
	public int executeTrans(List<String> sqlList) {
		int result = 0;
		try {
			conn.setAutoCommit(false); // 取消自动提交

			stmt = conn.createStatement();

			for (String item : sqlList) {
				result += stmt.executeUpdate(item);
			}
			conn.commit(); // 手动提交事务
		} catch (Exception e) {
			result = 0;
			try {
				conn.rollback(); // 回滚事务
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
			e.printStackTrace();
		}
		return result;
	}

	/**
	 * @功能 （重载方法）执行带参数的非查询的SQL语句，主要用于：增删改【Add、Del、Update】操作
	 * @参数 sql为要执行的SQL语句 obj 参数列表
	 * @返回值 受影响的行数
	 */
	public int executeUpdate(String sql, Object... obj) {
		int result = 0;
		try {
			pstmt = conn.prepareStatement(sql);

			for (int i = 0; i < obj.length; i++) {
				pstmt.setObject(i + 1, obj[i]);
			}
			result = pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	/**
	 * 查询数据库
	 * 
	 * @param sql
	 *            SQL语句
	 * @return
	 */
	public ResultSet executeQuery(String sql) {
		ResultSet rs = null;
		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(sql);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return rs;
	}

	/**
	 * （带参数）查询数据库
	 * 
	 * @param sql
	 *            SQL语句
	 * @param obj
	 * @return
	 */
	public ResultSet executeQuery(String sql, Object... obj) {
		ResultSet rs = null;
		try {
			pstmt = conn.prepareStatement(sql);
			for (int i = 0; i < obj.length; i++) {
				pstmt.setObject(i + 1, obj[i]);
			}
			rs = pstmt.executeQuery();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return rs;
	}

	/**
	 * 获取统计结果
	 * 
	 * @param sql
	 * @return
	 */
	public Object getScalar(String sql) {

		Object result = null;
		ResultSet rs = null;

		try {

			rs = executeQuery(sql);
			if (rs.next()) {
				result = rs.getObject(1);
			}
		} catch (SQLException ex) {
			ex.printStackTrace();
		}
		return result;
	}

	/**
	 * （带参数）获取统计结果
	 * 
	 * @param sql
	 * @return
	 */
	public Object getScalar(String sql, Object... obj) {

		Object result = null;
		ResultSet rs = null;

		try {
			pstmt = conn.prepareStatement(sql);
			for (int i = 0; i < obj.length; i++) {
				pstmt.setObject(i + 1, obj[i]);
			}
			rs = pstmt.executeQuery();
			if (rs.next()) {
				result = rs.getObject(1);
			}
		} catch (SQLException ex) {
			ex.printStackTrace();
		}
		return result;
	}

	/**
	 * （重载方法）获取整型统计结果
	 * 
	 * @param sql
	 * @return
	 */
	public int getIntScalar(String sql) {
		return Integer.parseInt(getScalar(sql).toString());
	}

	/**
	 * （重载方法）获取整型统计结果
	 * 
	 * @param sql
	 * @return
	 */
	public int getIntScalar(String sql, Object... obj) {
		return Integer.parseInt(getScalar(sql, obj).toString());
	}

	/**
	 * （重载方法）获取浮点型统计结果
	 * 
	 * @param sql
	 * @return
	 */
	public double getDoubleScalar(String sql) {
		return Double.parseDouble(getScalar(sql).toString());
	}

	/* 关闭数据库的操作 */
	public void close() {
		try {
			if (stmt != null)
				stmt.close();
			if (pstmt != null)
				pstmt.close();
			if (conn != null)
				conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

}
