package com.health.model;

import java.sql.Date;
import java.sql.Timestamp;

public class DietPlan {
    private Long dietId;
    private Long matchingId;
    private Date planDate;
    private String mealType; // BREAKFAST, LUNCH, DINNER, SNACK
    private String mealName;
    private Integer calories;
    private Double protein;
    private Double carbs;
    private Double fat;
    private String description;
    private Timestamp createdAt;
    
    // For joined data
    private boolean certified;
    private String certificationImage;
    
    // Constructors
    public DietPlan() {}
    
    public DietPlan(Long matchingId, Date planDate, String mealType, String mealName) {
        this.matchingId = matchingId;
        this.planDate = planDate;
        this.mealType = mealType;
        this.mealName = mealName;
    }
    
    // Getters and Setters
    public Long getDietId() { return dietId; }
    public void setDietId(Long dietId) { this.dietId = dietId; }
    
    public Long getMatchingId() { return matchingId; }
    public void setMatchingId(Long matchingId) { this.matchingId = matchingId; }
    
    public Date getPlanDate() { return planDate; }
    public void setPlanDate(Date planDate) { this.planDate = planDate; }
    
    public String getMealType() { return mealType; }
    public void setMealType(String mealType) { this.mealType = mealType; }
    
    public String getMealName() { return mealName; }
    public void setMealName(String mealName) { this.mealName = mealName; }
    
    public Integer getCalories() { return calories; }
    public void setCalories(Integer calories) { this.calories = calories; }
    
    public Double getProtein() { return protein; }
    public void setProtein(Double protein) { this.protein = protein; }
    
    public Double getCarbs() { return carbs; }
    public void setCarbs(Double carbs) { this.carbs = carbs; }
    
    public Double getFat() { return fat; }
    public void setFat(Double fat) { this.fat = fat; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    
    public boolean isCertified() { return certified; }
    public void setCertified(boolean certified) { this.certified = certified; }
    
    public String getCertificationImage() { return certificationImage; }
    public void setCertificationImage(String certificationImage) { this.certificationImage = certificationImage; }
}
