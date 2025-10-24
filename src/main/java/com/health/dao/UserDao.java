package com.health.dao;

import com.health.model.User;
import org.apache.ibatis.annotations.*;

import java.util.List;

@Mapper
public interface UserDao {
    
    @Insert("INSERT INTO users (username, password, name, email, phone, weight, height, birth_date, gender, profile_image) " +
            "VALUES (#{username}, #{password}, #{name}, #{email}, #{phone}, #{weight}, #{height}, #{birthDate}, #{gender}, #{profileImage})")
    @Options(useGeneratedKeys = true, keyProperty = "userId")
    int insertUser(User user);
    
    @Select("SELECT * FROM users WHERE user_id = #{userId}")
    User selectUserById(Long userId);
    
    @Select("SELECT * FROM users WHERE username = #{username}")
    User selectUserByUsername(String username);
    
    @Select("SELECT * FROM users WHERE email = #{email}")
    User selectUserByEmail(String email);
    
    @Select("SELECT * FROM users")
    List<User> selectAllUsers();
    
    @Update("UPDATE users SET name = #{name}, email = #{email}, phone = #{phone}, " +
            "weight = #{weight}, height = #{height}, birth_date = #{birthDate}, gender = #{gender}, " +
            "profile_image = #{profileImage} WHERE user_id = #{userId}")
    int updateUser(User user);
    
    @Update("UPDATE users SET password = #{password} WHERE user_id = #{userId}")
    int updatePassword(@Param("userId") Long userId, @Param("password") String password);
    
    @Delete("DELETE FROM users WHERE user_id = #{userId}")
    int deleteUser(Long userId);
}
