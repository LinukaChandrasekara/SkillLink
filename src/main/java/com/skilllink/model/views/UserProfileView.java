package com.skilllink.model.views;

import com.skilllink.model.enums.ClientType;
import com.skilllink.model.enums.VerificationStatus;
import java.io.Serializable;

public class UserProfileView implements Serializable {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private Long userId;
    private String fullName;
    private Integer roleId;
    private String roleName;

    private String email;
    private String phone;
    private String addressLine;
    private String bio;
    private VerificationStatus verificationStatus;

    // Worker extras
    private Long jobCategoryId;
    private String workerJobCategory;
    private Integer experienceYears;

    // Client extras
    private ClientType clientType;

    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }
    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    public Integer getRoleId() { return roleId; }
    public void setRoleId(Integer roleId) { this.roleId = roleId; }
    public String getRoleName() { return roleName; }
    public void setRoleName(String roleName) { this.roleName = roleName; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public String getAddressLine() { return addressLine; }
    public void setAddressLine(String addressLine) { this.addressLine = addressLine; }
    public String getBio() { return bio; }
    public void setBio(String bio) { this.bio = bio; }
    public VerificationStatus getVerificationStatus() { return verificationStatus; }
    public void setVerificationStatus(VerificationStatus verificationStatus) { this.verificationStatus = verificationStatus; }
    public Long getJobCategoryId() { return jobCategoryId; }
    public void setJobCategoryId(Long jobCategoryId) { this.jobCategoryId = jobCategoryId; }
    public String getWorkerJobCategory() { return workerJobCategory; }
    public void setWorkerJobCategory(String workerJobCategory) { this.workerJobCategory = workerJobCategory; }
    public Integer getExperienceYears() { return experienceYears; }
    public void setExperienceYears(Integer experienceYears) { this.experienceYears = experienceYears; }
    public ClientType getClientType() { return clientType; }
    public void setClientType(ClientType clientType) { this.clientType = clientType; }
}
