package com.jypc.bean;

public class PagerView {
	private int currrntPageNum = 1;// 当前页码
	private int allPage;// 总页数
	private int pageSize = 10;// 每页显示的记录条数
	private int allData;// 总记录条数

	/**
	 * 获取当前页面索引，用于页面分页标准
	 * 
	 * @return 索引值
	 */
	public int getFirstRecordIndex() {
		return (currrntPageNum - 1) * pageSize;
	}

	/**
	 * 各个变量取值途径
	 */
	public void calculate() {
		int shang = allData / pageSize;
		int yushu = allData % pageSize;
		allPage = yushu == 0 ? shang : shang + 1;
	}

	/**
	 * 判断是否为首页
	 * 
	 * @return 如果为首页，则返回ture
	 */
	public boolean isFirstPage() {
		return this.currrntPageNum == 1;
	}

	/**
	 * 判断是否为尾页
	 * 
	 * @return 如果为尾页，则返回ture
	 */
	public boolean isLastPage() {
		return this.currrntPageNum == this.allPage;
	}

	public int getCurrrntPageNum() {
		return currrntPageNum;
	}

	public void setCurrrntPageNum(int currrntPageNum) {
		this.currrntPageNum = currrntPageNum;
		this.calculate();
	}

	public int getAllPage() {
		return allPage;
	}

	public void setAllPage(int allPage) {
		this.allPage = allPage;
		this.calculate();
	}

	public int getPageSize() {
		return pageSize;
	}

	public void setPageSize(int pageSize) {
		this.pageSize = pageSize;
		this.calculate();
	}

	public int getAllData() {
		return allData;
	}

	public void setAllData(int allData) {
		this.allData = allData;
		this.calculate();
	}
}
