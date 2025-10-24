package com.health.dao;

import com.health.model.DietCertification;
import com.health.model.ExerciseCertification;
import org.apache.ibatis.annotations.*;

import java.util.List;

@Mapper
public interface CertificationDao {
    
    // Exercise Certification Methods
    @Insert("INSERT INTO exercise_certifications (plan_id, user_id, image_path, comment) " +
            "VALUES (#{planId}, #{userId}, #{imagePath}, #{comment})")
    @Options(useGeneratedKeys = true, keyProperty = "certId")
    int insertExerciseCertification(ExerciseCertification cert);
    
    @Select("SELECT * FROM exercise_certifications WHERE cert_id = #{certId}")
    ExerciseCertification selectExerciseCertificationById(Long certId);
    
    @Select("SELECT * FROM exercise_certifications WHERE plan_id = #{planId}")
    ExerciseCertification selectExerciseCertificationByPlanId(Long planId);
    
    @Select("SELECT ec.* FROM exercise_certifications ec " +
            "JOIN exercise_plans ep ON ec.plan_id = ep.plan_id " +
            "JOIN matchings m ON ep.matching_id = m.matching_id " +
            "WHERE m.trainer_id = #{trainerId} " +
            "ORDER BY ec.completed_at DESC")
    List<ExerciseCertification> selectExerciseCertificationsByTrainerId(Long trainerId);
    
    @Update("UPDATE exercise_certifications SET trainer_feedback = #{trainerFeedback}, " +
            "feedback_at = CURRENT_TIMESTAMP WHERE cert_id = #{certId}")
    int updateExerciseCertificationFeedback(@Param("certId") Long certId, @Param("trainerFeedback") String trainerFeedback);
    
    @Delete("DELETE FROM exercise_certifications WHERE cert_id = #{certId}")
    int deleteExerciseCertification(Long certId);
    
    // Diet Certification Methods
    @Insert("INSERT INTO diet_certifications (diet_id, user_id, image_path, comment) " +
            "VALUES (#{dietId}, #{userId}, #{imagePath}, #{comment})")
    @Options(useGeneratedKeys = true, keyProperty = "certId")
    int insertDietCertification(DietCertification cert);
    
    @Select("SELECT * FROM diet_certifications WHERE cert_id = #{certId}")
    DietCertification selectDietCertificationById(Long certId);
    
    @Select("SELECT * FROM diet_certifications WHERE diet_id = #{dietId}")
    DietCertification selectDietCertificationByDietId(Long dietId);
    
    @Select("SELECT dc.* FROM diet_certifications dc " +
            "JOIN diet_plans dp ON dc.diet_id = dp.diet_id " +
            "JOIN matchings m ON dp.matching_id = m.matching_id " +
            "WHERE m.trainer_id = #{trainerId} " +
            "ORDER BY dc.completed_at DESC")
    List<DietCertification> selectDietCertificationsByTrainerId(Long trainerId);
    
    @Update("UPDATE diet_certifications SET trainer_feedback = #{trainerFeedback}, " +
            "feedback_at = CURRENT_TIMESTAMP WHERE cert_id = #{certId}")
    int updateDietCertificationFeedback(@Param("certId") Long certId, @Param("trainerFeedback") String trainerFeedback);
    
    @Delete("DELETE FROM diet_certifications WHERE cert_id = #{certId}")
    int deleteDietCertification(Long certId);
}
