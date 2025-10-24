package com.health.dao;

import com.health.model.Matching;
import org.apache.ibatis.annotations.*;

import java.util.List;

@Mapper
public interface MatchingDao {
    
    @Insert("INSERT INTO matchings (user_id, trainer_id, status, start_date, end_date) " +
            "VALUES (#{userId}, #{trainerId}, #{status}, #{startDate}, #{endDate})")
    @Options(useGeneratedKeys = true, keyProperty = "matchingId")
    int insertMatching(Matching matching);
    
    @Select("SELECT * FROM matchings WHERE matching_id = #{matchingId}")
    Matching selectMatchingById(Long matchingId);
    
    @Select("SELECT m.*, u.name as userName, t.name as trainerName " +
            "FROM matchings m " +
            "JOIN users u ON m.user_id = u.user_id " +
            "JOIN trainers t ON m.trainer_id = t.trainer_id " +
            "WHERE m.user_id = #{userId}")
    List<Matching> selectMatchingsByUserId(Long userId);
    
    @Select("SELECT m.*, u.name as userName, t.name as trainerName " +
            "FROM matchings m " +
            "JOIN users u ON m.user_id = u.user_id " +
            "JOIN trainers t ON m.trainer_id = t.trainer_id " +
            "WHERE m.trainer_id = #{trainerId}")
    List<Matching> selectMatchingsByTrainerId(Long trainerId);
    
    @Select("SELECT m.*, u.name as userName, t.name as trainerName " +
            "FROM matchings m " +
            "JOIN users u ON m.user_id = u.user_id " +
            "JOIN trainers t ON m.trainer_id = t.trainer_id " +
            "WHERE m.user_id = #{userId} AND m.trainer_id = #{trainerId} AND m.status = 'ACCEPTED'")
    Matching selectActiveMatchingByUserAndTrainer(@Param("userId") Long userId, @Param("trainerId") Long trainerId);
    
    @Update("UPDATE matchings SET status = #{status}, start_date = #{startDate}, " +
            "end_date = #{endDate} WHERE matching_id = #{matchingId}")
    int updateMatching(Matching matching);
    
    @Update("UPDATE matchings SET status = #{status} WHERE matching_id = #{matchingId}")
    int updateMatchingStatus(@Param("matchingId") Long matchingId, @Param("status") String status);
    
    @Delete("DELETE FROM matchings WHERE matching_id = #{matchingId}")
    int deleteMatching(Long matchingId);
}
