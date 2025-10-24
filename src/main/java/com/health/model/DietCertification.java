package com.health.model;

import java.sql.Timestamp;

public class DietCertification {
    private Long certId;
    private Long dietId;
    private Long userId;
    private String imagePath;
    private String comment;
    private Timestamp completedAt;
    private String trainerFeedback;
    private Timestamp feedbackAt;
    
    // Constructors
    public DietCertification() {}
    
    public DietCertification(Long dietId, Long userId, String imagePath) {
        this.dietId = dietId;
        this.userId = userId;
        this.imagePath = imagePath;
    }
    
    // Getters and Setters
    public Long getCertId() { return certId; }
    public void setCertId(Long certId) { this.certId = certId; }
    
    public Long getDietId() { return dietId; }
    public void setDietId(Long dietId) { this.dietId = dietId; }
    
    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }
    
    public String getImagePath() { return imagePath; }
    public void setImagePath(String imagePath) { this.imagePath = imagePath; }
    
    public String getComment() { return comment; }
    public void setComment(String comment) { this.comment = comment; }
    
    public Timestamp getCompletedAt() { return completedAt; }
    public void setCompletedAt(Timestamp completedAt) { this.completedAt = completedAt; }
    
    public String getTrainerFeedback() { return trainerFeedback; }
    public void setTrainerFeedback(String trainerFeedback) { this.trainerFeedback = trainerFeedback; }
    
    public Timestamp getFeedbackAt() { return feedbackAt; }
    public void setFeedbackAt(Timestamp feedbackAt) { this.feedbackAt = feedbackAt; }
}
