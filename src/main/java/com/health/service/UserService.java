package com.health.service;

import com.health.dao.UserDao;
import com.health.model.User;
import com.health.util.PasswordUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class UserService {
    
    @Autowired
    private UserDao userDao;
    
    public User registerUser(User user) {
        // Check if username already exists
        if (userDao.selectUserByUsername(user.getUsername()) != null) {
            throw new RuntimeException("Username already exists");
        }
        // Check if email already exists
        if (userDao.selectUserByEmail(user.getEmail()) != null) {
            throw new RuntimeException("Email already exists");
        }
        // Encrypt password
        user.setPassword(PasswordUtil.hashPassword(user.getPassword()));
        userDao.insertUser(user);
        return user;
    }
    
    public User loginUser(String username, String password) {
        User user = userDao.selectUserByUsername(username);
        if (user == null) {
            throw new RuntimeException("Invalid username or password");
        }
        if (!PasswordUtil.checkPassword(password, user.getPassword())) {
            throw new RuntimeException("Invalid username or password");
        }
        return user;
    }
    
    public User getUserById(Long userId) {
        return userDao.selectUserById(userId);
    }
    
    public User getUserByUsername(String username) {
        return userDao.selectUserByUsername(username);
    }
    
    public List<User> getAllUsers() {
        return userDao.selectAllUsers();
    }
    
    public void updateUser(User user) {
        userDao.updateUser(user);
    }
    
    public void updatePassword(Long userId, String newPassword) {
        String hashedPassword = PasswordUtil.hashPassword(newPassword);
        userDao.updatePassword(userId, hashedPassword);
    }
    
    public void deleteUser(Long userId) {
        userDao.deleteUser(userId);
    }
}
