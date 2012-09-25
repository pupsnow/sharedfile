/**
 * 
 * @author yxhuang
 * @date 2012-4-22 下午5:56:54
 */
package com.tp.entity;

import java.math.BigDecimal;
import java.util.Date;

/**
 * 
 * @author yxhuang
 * @date 2012-4-22 下午5:56:54
 */
public class Tick {
	
	private BigDecimal askPrice;
	private BigDecimal bidPrice;
	private BigDecimal midPrice;
	private Date tickTime;
	private String seqno;

	/**
	 * 
	 * @author yxhuang
	 * @date 2012-4-22 下午5:57:58
	 */
	public Tick() {
		super();
	}

	/**
	 * 
	 * @author yxhuang
	 * @date 2012-4-22 下午5:57:50
	 * @param askPrice
	 * @param bidPrice
	 * @param midPrice
	 * @param tickTime
	 * @param seqno
	 */
	public Tick(BigDecimal askPrice, BigDecimal bidPrice, BigDecimal midPrice,
			Date tickTime, String seqno) {
		super();
		this.askPrice = askPrice;
		this.bidPrice = bidPrice;
		this.midPrice = midPrice;
		this.tickTime = tickTime;
		this.seqno = seqno;
	}

	/**
	 * 
	 * @author yxhuang
	 * @date 2012-4-22 下午5:58:12
	 * @return the askPrice
	 */
	public BigDecimal getAskPrice() {
		return askPrice;
	}

	/**
	 * @author yxhuang
	 * @date 2012-4-22 下午5:58:12
	 * 
	 * @param askPrice
	 *            the askPrice to set
	 */
	public void setAskPrice(BigDecimal askPrice) {
		this.askPrice = askPrice;
	}

	/**
	 * 
	 * @author yxhuang
	 * @date 2012-4-22 下午5:58:12
	 * @return the bidPrice
	 */
	public BigDecimal getBidPrice() {
		return bidPrice;
	}

	/**
	 * @author yxhuang
	 * @date 2012-4-22 下午5:58:12
	 * 
	 * @param bidPrice
	 *            the bidPrice to set
	 */
	public void setBidPrice(BigDecimal bidPrice) {
		this.bidPrice = bidPrice;
	}

	/**
	 * 
	 * @author yxhuang
	 * @date 2012-4-22 下午5:58:12
	 * @return the midPrice
	 */
	public BigDecimal getMidPrice() {
		return midPrice;
	}

	/**
	 * @author yxhuang
	 * @date 2012-4-22 下午5:58:12
	 * 
	 * @param midPrice
	 *            the midPrice to set
	 */
	public void setMidPrice(BigDecimal midPrice) {
		this.midPrice = midPrice;
	}

	/**
	 * 
	 * @author yxhuang
	 * @date 2012-4-22 下午5:58:12
	 * @return the tickTime
	 */
	public Date getTickTime() {
		return tickTime;
	}

	/**
	 * @author yxhuang
	 * @date 2012-4-22 下午5:58:12
	 * 
	 * @param tickTime
	 *            the tickTime to set
	 */
	public void setTickTime(Date tickTime) {
		this.tickTime = tickTime;
	}

	/**
	 * 
	 * @author yxhuang
	 * @date 2012-4-22 下午5:58:12
	 * @return the seqno
	 */
	public String getSeqno() {
		return seqno;
	}

	/**
	 * @author yxhuang
	 * @date 2012-4-22 下午5:58:12
	 * 
	 * @param seqno
	 *            the seqno to set
	 */
	public void setSeqno(String seqno) {
		this.seqno = seqno;
	}
}
