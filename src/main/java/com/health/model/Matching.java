package com.health.model;

import java.sql.Date;
import java.sql.Timestamp;

public class Matching {
    private Long matchingId;
    private Long userId;
    private Long trainerId;
    private String status; // PENDING, ACCEPTED, REJECTED, COMPLETED
    private Date startDate;
    private Date endDate;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    // Additional fields for joined data
    private String userName;
    private String trainerName;
    
    // Constructors
    public Matching() {}
    
    public Matching(Long userId, Long trainerId) {
        this.userId = userId;
        this.trainerId = trainerId;
        this.status = "PENDING";
    }
    
    // Getters and Setters
    public Long getMatchingId() { return matchingId; }
    public void setMatchingId(Long matchingId) { this.matchingId = matchingId; }
    
    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }
    
    public Long getTrainerId() { return trainerId; }
    public void setTrainerId(Long trainerId) { this.trainerId = trainerId; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public Date getStartDate() { return startDate; }
    public void setStartDate(Date startDate) { this.startDate = startDate; }
    
    public Date getEndDate() { return endDate; }
    public void setEndDate(Date endDate) { this.endDate = endDate; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    
    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
    
    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }
    
    public String getTrainerName() { return trainerName; }
    public void setTrainerName(String trainerName) { this.trainerName = trainerName; }
}
