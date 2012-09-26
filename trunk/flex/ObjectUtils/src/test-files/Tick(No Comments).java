package com.tp.entity;

import java.math.BigDecimal;
import java.util.Date;

public class Tick {
	
	private BigDecimal askPrice;
	private BigDecimal bidPrice;
	private BigDecimal midPrice;
	private Date tickTime;
	private String seqno;

	public Tick() {
		super();
	}

	public Tick(BigDecimal askPrice, BigDecimal bidPrice, BigDecimal midPrice,
			Date tickTime, String seqno) {
		super();
		this.askPrice = askPrice;
		this.bidPrice = bidPrice;
		this.midPrice = midPrice;
		this.tickTime = tickTime;
		this.seqno = seqno;
	}

	public BigDecimal getAskPrice() {
		return askPrice;
	}

	public void setAskPrice(BigDecimal askPrice) {
		this.askPrice = askPrice;
	}

	public BigDecimal getBidPrice() {
		return bidPrice;
	}

	public void setBidPrice(BigDecimal bidPrice) {
		this.bidPrice = bidPrice;
	}

	public BigDecimal getMidPrice() {
		return midPrice;
	}

	public void setMidPrice(BigDecimal midPrice) {
		this.midPrice = midPrice;
	}

	public Date getTickTime() {
		return tickTime;
	}

	public void setTickTime(Date tickTime) {
		this.tickTime = tickTime;
	}

	public String getSeqno() {
		return seqno;
	}

	public void setSeqno(String seqno) {
		this.seqno = seqno;
	}
}
