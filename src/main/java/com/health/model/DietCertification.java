package com.health.model;

import javax.persistence.*;
import java.sql.Timestamp;

@Entity
@Table(name = "diet_certifications")
public class DietCertification {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "cert_id")
    private Long certId;

    @Column(name = "diet_id", nullable = false)
    private Long dietId;

    @Column(name = "user_id", nullable = false)
    private Long userId;

    @Column(name = "image_path", nullable = false)
    private String imagePath;

    @Column(name = "comment", columnDefinition = "TEXT")
    private String comment;

    @Column(name = "completed_at")
    private Timestamp completedAt;

    @Column(name = "trainer_feedback", columnDefinition = "TEXT")
    private String trainerFeedback;

    @Column(name = "feedback_at")
    private Timestamp feedbackAt;

    // Constructors
    public DietCertification() {
    }

    public DietCertification(Long dietId, Long userId, String imagePath) {
        this.dietId = dietId;
        this.userId = userId;
        this.imagePath = imagePath;
    }

    // Getters and Setters
    public Long getCertId() {
        return certId;
    }

    public void setCertId(Long certId) {
        this.certId = certId;
    }

    public Long getDietId() {
        return dietId;
    }

    public void setDietId(Long dietId) {
        this.dietId = dietId;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public String getImagePath() {
        return imagePath;
    }

    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public Timestamp getCompletedAt() {
        return completedAt;
    }

    public void setCompletedAt(Timestamp completedAt) {
        this.completedAt = completedAt;
    }

    public String getTrainerFeedback() {
        return trainerFeedback;
    }

    public void setTrainerFeedback(String trainerFeedback) {
        this.trainerFeedback = trainerFeedback;
    }

    public Timestamp getFeedbackAt() {
        return feedbackAt;
    }

    public void setFeedbackAt(Timestamp feedbackAt) {
        this.feedbackAt = feedbackAt;
    }
}
