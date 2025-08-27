package com.skilllink.model;

import com.skilllink.model.enums.RoleName;
import java.io.Serializable;

public class Role implements Serializable {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private Integer roleId;       // TINYINT UNSIGNED
    private RoleName roleName;

    public Role() {}
    public Role(Integer roleId, RoleName roleName) {
        this.roleId = roleId;
        this.roleName = roleName;
    }
    public Integer getRoleId() { return roleId; }
    public void setRoleId(Integer roleId) { this.roleId = roleId; }
    public RoleName getRoleName() { return roleName; }
    public void setRoleName(RoleName roleName) { this.roleName = roleName; }

    @Override public String toString() {
        return "Role{roleId=" + roleId + ", roleName=" + roleName + '}';
    }
}
