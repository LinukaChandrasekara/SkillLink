package com.skilllink.model;

public class Client {
    public long getUserId() {
		return userId;
	}
	public void setUserId(long userId) {
		this.userId = userId;
	}
	public String getClientType() {
		return clientType;
	}
	public void setClientType(String clientType) {
		this.clientType = clientType;
	}
	private long userId;
    private String clientType; // individual | business
    // getters/setters
}
