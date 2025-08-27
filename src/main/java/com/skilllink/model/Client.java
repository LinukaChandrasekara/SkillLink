package com.skilllink.model;

import com.skilllink.model.enums.ClientType;
import java.io.Serializable;

public class Client implements Serializable {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private Long userId;
    private ClientType clientType;

    public Client() {}
    public Client(Long userId, ClientType type) { this.userId = userId; this.clientType = type; }

    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }
    public ClientType getClientType() { return clientType; }
    public void setClientType(ClientType clientType) { this.clientType = clientType; }

    @Override public String toString() {
        return "Client{userId=" + userId + ", clientType=" + clientType + "}";
    }
}
