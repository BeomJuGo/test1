package com.health.dao;

import com.health.model.DietPlan;
import com.health.model.ExercisePlan;
import org.apache.ibatis.annotations.*;

import java.sql.Date;
import java.util.List;

@Mapper
public interface PlanDao {
    
    // Exercise Plan Methods
    @Insert("INSERT INTO exercise_plans (matching_id, plan_date, exercise_name, sets, reps, duration, calories, description) " +
            "VALUES (#{matchingId}, #{planDate}, #{exerciseName}, #{sets}, #{reps}, #{duration}, #{calories}, #{description})")
    @Options(useGeneratedKeys = true, keyProperty = "planId")
    int insertExercisePlan(ExercisePlan plan);
    
    @Select("SELECT ep.*, " +
            "CASE WHEN ec.cert_id IS NOT NULL THEN 1 ELSE 0 END as certified, " +
            "ec.image_path as certificationImage " +
            "FROM exercise_plans ep " +
            "LEFT JOIN exercise_certifications ec ON ep.plan_id = ec.plan_id " +
            "WHERE ep.matching_id = #{matchingId} AND ep.plan_date = #{planDate}")
    List<ExercisePlan> selectExercisePlansByMatchingAndDate(@Param("matchingId") Long matchingId, @Param("planDate") Date planDate);
    
    @Select("SELECT * FROM exercise_plans WHERE plan_id = #{planId}")
    ExercisePlan selectExercisePlanById(Long planId);
    
    @Update("UPDATE exercise_plans SET exercise_name = #{exerciseName}, sets = #{sets}, " +
            "reps = #{reps}, duration = #{duration}, calories = #{calories}, " +
            "description = #{description} WHERE plan_id = #{planId}")
    int updateExercisePlan(ExercisePlan plan);
    
    @Delete("DELETE FROM exercise_plans WHERE plan_id = #{planId}")
    int deleteExercisePlan(Long planId);
    
    // Diet Plan Methods
    @Insert("INSERT INTO diet_plans (matching_id, plan_date, meal_type, meal_name, calories, protein, carbs, fat, description) " +
            "VALUES (#{matchingId}, #{planDate}, #{mealType}, #{mealName}, #{calories}, #{protein}, #{carbs}, #{fat}, #{description})")
    @Options(useGeneratedKeys = true, keyProperty = "dietId")
    int insertDietPlan(DietPlan plan);
    
    @Select("SELECT dp.*, " +
            "CASE WHEN dc.cert_id IS NOT NULL THEN 1 ELSE 0 END as certified, " +
            "dc.image_path as certificationImage " +
            "FROM diet_plans dp " +
            "LEFT JOIN diet_certifications dc ON dp.diet_id = dc.diet_id " +
            "WHERE dp.matching_id = #{matchingId} AND dp.plan_date = #{planDate}")
    List<DietPlan> selectDietPlansByMatchingAndDate(@Param("matchingId") Long matchingId, @Param("planDate") Date planDate);
    
    @Select("SELECT * FROM diet_plans WHERE diet_id = #{dietId}")
    DietPlan selectDietPlanById(Long dietId);
    
    @Update("UPDATE diet_plans SET meal_type = #{mealType}, meal_name = #{mealName}, " +
            "calories = #{calories}, protein = #{protein}, carbs = #{carbs}, fat = #{fat}, " +
            "description = #{description} WHERE diet_id = #{dietId}")
    int updateDietPlan(DietPlan plan);
    
    @Delete("DELETE FROM diet_plans WHERE diet_id = #{dietId}")
    int deleteDietPlan(Long dietId);
}
