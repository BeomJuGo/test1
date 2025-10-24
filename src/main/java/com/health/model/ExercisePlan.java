package com.health.model;

import java.sql.Date;
import java.sql.Timestamp;

public class ExercisePlan {
    private Long planId;
    private Long matchingId;
    private Date planDate;
    private String exerciseName;
    private Integer sets;
    private Integer reps;
    private Integer duration; // minutes
    private Integer calories;
    private String description;
    private Timestamp createdAt;
    
    // For joined data
    private boolean certified;
    private String certificationImage;
    
    // Constructors
    public ExercisePlan() {}
    
    public ExercisePlan(Long matchingId, Date planDate, String exerciseName) {
        this.matchingId = matchingId;
        this.planDate = planDate;
        this.exerciseName = exerciseName;
    }
    
    // Getters and Setters
    public Long getPlanId() { return planId; }
    public void setPlanId(Long planId) { this.planId = planId; }
    
    public Long getMatchingId() { return matchingId; }
    public void setMatchingId(Long matchingId) { this.matchingId = matchingId; }
    
    public Date getPlanDate() { return planDate; }
    public void setPlanDate(Date planDate) { this.planDate = planDate; }
    
    public String getExerciseName() { return exerciseName; }
    public void setExerciseName(String exerciseName) { this.exerciseName = exerciseName; }
    
    public Integer getSets() { return sets; }
    public void setSets(Integer sets) { this.sets = sets; }
    
    public Integer getReps() { return reps; }
    public void setReps(Integer reps) { this.reps = reps; }
    
    public Integer getDuration() { return duration; }
    public void setDuration(Integer duration) { this.duration = duration; }
    
    public Integer getCalories() { return calories; }
    public void setCalories(Integer calories) { this.calories = calories; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    
    public boolean isCertified() { return certified; }
    public void setCertified(boolean certified) { this.certified = certified; }
    
    public String getCertificationImage() { return certificationImage; }
    public void setCertificationImage(String certificationImage) { this.certificationImage = certificationImage; }
}
