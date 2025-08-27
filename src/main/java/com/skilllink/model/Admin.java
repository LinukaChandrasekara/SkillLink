package com.skilllink.model;

import java.io.Serializable;

public class Admin implements Serializable {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private Long userId;

    public Admin() {}
    public Admin(Long userId) { this.userId = userId; }

    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }

    @Override public String toString() { return "Admin{userId=" + userId + "}"; }
}
