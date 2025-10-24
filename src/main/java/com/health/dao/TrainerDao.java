package com.health.dao;

import com.health.model.Trainer;
import org.apache.ibatis.annotations.*;

import java.util.List;

@Mapper
public interface TrainerDao {
    
    @Insert("INSERT INTO trainers (username, password, name, email, phone, specialization, " +
            "experience_years, certification, profile_image, introduction, rating) " +
            "VALUES (#{username}, #{password}, #{name}, #{email}, #{phone}, #{specialization}, " +
            "#{experienceYears}, #{certification}, #{profileImage}, #{introduction}, #{rating})")
    @Options(useGeneratedKeys = true, keyProperty = "trainerId")
    int insertTrainer(Trainer trainer);
    
    @Select("SELECT * FROM trainers WHERE trainer_id = #{trainerId}")
    Trainer selectTrainerById(Long trainerId);
    
    @Select("SELECT * FROM trainers WHERE username = #{username}")
    Trainer selectTrainerByUsername(String username);
    
    @Select("SELECT * FROM trainers WHERE email = #{email}")
    Trainer selectTrainerByEmail(String email);
    
    @Select("SELECT * FROM trainers ORDER BY rating DESC")
    List<Trainer> selectAllTrainers();
    
    @Update("UPDATE trainers SET name = #{name}, email = #{email}, phone = #{phone}, " +
            "specialization = #{specialization}, experience_years = #{experienceYears}, " +
            "certification = #{certification}, profile_image = #{profileImage}, " +
            "introduction = #{introduction}, rating = #{rating} WHERE trainer_id = #{trainerId}")
    int updateTrainer(Trainer trainer);
    
    @Update("UPDATE trainers SET password = #{password} WHERE trainer_id = #{trainerId}")
    int updatePassword(@Param("trainerId") Long trainerId, @Param("password") String password);
    
    @Delete("DELETE FROM trainers WHERE trainer_id = #{trainerId}")
    int deleteTrainer(Long trainerId);
}
