/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

package model;

import java.util.Date;

public class UserAccount {

    private String userID;
    private String username;
    private String fullName;
    private String email;
    private String password;
    private String role;
    private Date registrationDate;
    private String profilePicture;
    private String phone;
    private Date birthDate;
    private String sessionId;
    private String otp;
    private Date otpExpiry;
    private String resetToken;
    private Date resetTokenExpiry;
    private int courseCount;
    private Boolean isActive;
    private String coverPhoto;      // Ảnh bìa
    private String bio;             // Tiểu sử
    private int followerCount;      // Số người theo dõi
    private int followingCount;     // Số người đang theo dõi

    // Constructors
    public UserAccount() {
    }

    public UserAccount(String userID, String username, String email, String password, String role) {
        this.userID = userID;
        this.username = username;
        this.email = email;
        this.password = password;
        this.role = role;
        this.isActive = true; // Default to active
    }

    public UserAccount( String userID, String username, String fullName, String email, String password,
            String role, Date registrationDate, String profilePicture, String phone, Date birthDate) {
        this.userID = userID;
        this.username = username;
        this.fullName = fullName;
        this.email = email;
        this.password = password;
        this.role = role;
        this.registrationDate = registrationDate;
        this.profilePicture = profilePicture;
        this.phone = phone;
        this.birthDate = birthDate;
    }
    
    // Getters and Setters
    public String getUserID() {
        return userID;
    }

    public void setUserID(String userID) {
        this.userID = userID;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public Date getRegistrationDate() {
        return registrationDate;
    }

    public void setRegistrationDate(Date registrationDate) {
        this.registrationDate = registrationDate;
    }

    public String getProfilePicture() {
        return profilePicture;
    }

    public void setProfilePicture(String profilePicture) {
        this.profilePicture = profilePicture;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public Date getBirthDate() {
        return birthDate;
    }

    public void setBirthDate(Date birthDate) {
        this.birthDate = birthDate;
    }

    public String getOtp() {
        return otp;
    }

    public void setOtp(String otp) {
        this.otp = otp;
    }

    public Date getOtpExpiry() {
        return otpExpiry;
    }

    public void setOtpExpiry(Date otpExpiry) {
        this.otpExpiry = otpExpiry;
    }

    public String getResetToken() {
        return resetToken;
    }

    public void setResetToken(String resetToken) {
        this.resetToken = resetToken;
    }

    public Date getResetTokenExpiry() {
        return resetTokenExpiry;
    }

    public void setResetTokenExpiry(Date resetTokenExpiry) {
        this.resetTokenExpiry = resetTokenExpiry;
    }

    public int getCourseCount() {
        return courseCount;
    }

    public void setCourseCount(int courseCount) {
        this.courseCount = courseCount;
    }

    public Boolean getIsActive() {
        return isActive;
    }

    public void setIsActive(Boolean isActive) {
        this.isActive = isActive;
    }

    public String getSessionId() {
        return sessionId;
    }

    public void setSessionId(String sessionId) {
        this.sessionId = sessionId;
    }

    // Getters & Setters
    public String getCoverPhoto() { return coverPhoto; }
    public void setCoverPhoto(String coverPhoto) { this.coverPhoto = coverPhoto; }

    public String getBio() { return bio; }
    public void setBio(String bio) { this.bio = bio; }

    public int getFollowerCount() { return followerCount; }
    public void setFollowerCount(int followerCount) { this.followerCount = followerCount; }

    public int getFollowingCount() { return followingCount; }
    public void setFollowingCount(int followingCount) { this.followingCount = followingCount; }
}
