package com.health.model;

import javax.persistence.*;
import java.sql.Date;
import java.sql.Timestamp;

@Entity
@Table(name = "diet_plans")
public class DietPlan {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "diet_id")
    private Long dietId;

    @Column(name = "matching_id", nullable = false)
    private Long matchingId;

    @Column(name = "plan_date", nullable = false)
    private Date planDate;

    @Enumerated(EnumType.STRING)
    @Column(name = "meal_type")
    private MealType mealType; // BREAKFAST, LUNCH, DINNER, SNACK

    @Column(name = "meal_name", nullable = false)
    private String mealName;

    @Column(name = "calories")
    private Integer calories;

    @Column(name = "protein", precision = 5, scale = 2)
    private Double protein;

    @Column(name = "carbs", precision = 5, scale = 2)
    private Double carbs;

    @Column(name = "fat", precision = 5, scale = 2)
    private Double fat;

    @Column(name = "description", columnDefinition = "TEXT")
    private String description;

    @Column(name = "created_at")
    private Timestamp createdAt;

    // For joined data
    private boolean certified;
    private String certificationImage;

    // Constructors
    public DietPlan() {
    }

    public DietPlan(Long matchingId, Date planDate, MealType mealType, String mealName) {
        this.matchingId = matchingId;
        this.planDate = planDate;
        this.mealType = mealType;
        this.mealName = mealName;
    }

    // Getters and Setters
    public Long getDietId() {
        return dietId;
    }

    public void setDietId(Long dietId) {
        this.dietId = dietId;
    }

    public Long getMatchingId() {
        return matchingId;
    }

    public void setMatchingId(Long matchingId) {
        this.matchingId = matchingId;
    }

    public Date getPlanDate() {
        return planDate;
    }

    public void setPlanDate(Date planDate) {
        this.planDate = planDate;
    }

    public MealType getMealType() {
        return mealType;
    }

    public void setMealType(MealType mealType) {
        this.mealType = mealType;
    }

    public String getMealName() {
        return mealName;
    }

    public void setMealName(String mealName) {
        this.mealName = mealName;
    }

    public Integer getCalories() {
        return calories;
    }

    public void setCalories(Integer calories) {
        this.calories = calories;
    }

    public Double getProtein() {
        return protein;
    }

    public void setProtein(Double protein) {
        this.protein = protein;
    }

    public Double getCarbs() {
        return carbs;
    }

    public void setCarbs(Double carbs) {
        this.carbs = carbs;
    }

    public Double getFat() {
        return fat;
    }

    public void setFat(Double fat) {
        this.fat = fat;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public boolean isCertified() {
        return certified;
    }

    public void setCertified(boolean certified) {
        this.certified = certified;
    }

    public String getCertificationImage() {
        return certificationImage;
    }

    public void setCertificationImage(String certificationImage) {
        this.certificationImage = certificationImage;
    }
}
