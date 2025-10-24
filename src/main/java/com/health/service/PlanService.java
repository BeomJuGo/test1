package com.health.service;

import com.health.dao.PlanDao;
import com.health.model.DietPlan;
import com.health.model.ExercisePlan;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.sql.Date;
import java.util.List;

@Service
@Transactional
public class PlanService {
    
    @Autowired
    private PlanDao planDao;
    
    // Exercise Plan Methods
    public ExercisePlan createExercisePlan(ExercisePlan plan) {
        planDao.insertExercisePlan(plan);
        return plan;
    }
    
    public List<ExercisePlan> getExercisePlansByMatchingAndDate(Long matchingId, Date date) {
        return planDao.selectExercisePlansByMatchingAndDate(matchingId, date);
    }
    
    public ExercisePlan getExercisePlanById(Long planId) {
        return planDao.selectExercisePlanById(planId);
    }
    
    public void updateExercisePlan(ExercisePlan plan) {
        planDao.updateExercisePlan(plan);
    }
    
    public void deleteExercisePlan(Long planId) {
        planDao.deleteExercisePlan(planId);
    }
    
    // Diet Plan Methods
    public DietPlan createDietPlan(DietPlan plan) {
        planDao.insertDietPlan(plan);
        return plan;
    }
    
    public List<DietPlan> getDietPlansByMatchingAndDate(Long matchingId, Date date) {
        return planDao.selectDietPlansByMatchingAndDate(matchingId, date);
    }
    
    public DietPlan getDietPlanById(Long dietId) {
        return planDao.selectDietPlanById(dietId);
    }
    
    public void updateDietPlan(DietPlan plan) {
        planDao.updateDietPlan(plan);
    }
    
    public void deleteDietPlan(Long dietId) {
        planDao.deleteDietPlan(dietId);
    }
}
