package com.health.service;

import com.health.model.User;
import com.health.repository.UserRepository;
import com.health.util.PasswordUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class UserService {

    @Autowired
    private UserRepository userRepository;

    public User registerUser(User user) {
        try {
            // Check if username already exists
            if (userRepository.existsByUsername(user.getUsername())) {
                throw new RuntimeException("Username already exists");
            }
            // Check if email already exists
            if (userRepository.existsByEmail(user.getEmail())) {
                throw new RuntimeException("Email already exists");
            }
            // Encrypt password
            user.setPassword(PasswordUtil.hashPassword(user.getPassword()));
            // Set timestamps
            Timestamp now = Timestamp.valueOf(LocalDateTime.now());
            user.setCreatedAt(now);
            user.setUpdatedAt(now);
            return userRepository.save(user);
        } catch (Exception e) {
            System.out.println("Register user error: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }

    public boolean register(User user) {
        try {
            registerUser(user);
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    public User loginUser(String username, String password) {
        System.out.println("=== UserService.loginUser ===");
        System.out.println("Looking for username: " + username);

        try {
            // 모든 사용자 조회하여 디버깅
            List<User> allUsers = userRepository.findAll();
            System.out.println("Total users in database: " + allUsers.size());
            for (User u : allUsers) {
                System.out.println("User in DB: " + u.getUsername() + " (ID: " + u.getUserId() + ")");
            }

            Optional<User> userOpt = userRepository.findByUsername(username);
            if (userOpt.isEmpty()) {
                System.out.println("User not found: " + username);
                throw new RuntimeException("Invalid username or password");
            }

            User user = userOpt.get();
            System.out.println("User found: " + user.getUsername());
            System.out.println("Stored password hash: " + user.getPassword());
            System.out.println("Input password: " + password);

            // 비밀번호 해시 테스트
            String testHash = PasswordUtil.hashPassword(password);
            System.out.println("Test hash for input password: " + testHash);

            boolean passwordMatch = PasswordUtil.checkPassword(password, user.getPassword());
            System.out.println("Password match: " + passwordMatch);

            if (!passwordMatch) {
                System.out.println("Password mismatch");
                throw new RuntimeException("Invalid username or password");
            }

            System.out.println("Login successful for user: " + username);
            return user;
        } catch (Exception e) {
            System.out.println("Exception in loginUser: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }

    public User login(String username, String password) {
        return loginUser(username, password);
    }

    public User getUserById(Long userId) {
        return userRepository.findById(userId).orElse(null);
    }

    public User getUserByUsername(String username) {
        return userRepository.findByUsername(username).orElse(null);
    }

    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    public boolean updateUser(User user) {
        try {
            user.setUpdatedAt(Timestamp.valueOf(LocalDateTime.now()));
            userRepository.save(user);
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    public void updatePassword(Long userId, String newPassword) {
        Optional<User> userOpt = userRepository.findById(userId);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            user.setPassword(PasswordUtil.hashPassword(newPassword));
            user.setUpdatedAt(Timestamp.valueOf(LocalDateTime.now()));
            userRepository.save(user);
        }
    }

    public void deleteUser(Long userId) {
        userRepository.deleteById(userId);
    }

    /**
     * 특정 사용자의 비밀번호를 password123으로 리셋 (테스트용)
     */
    public void resetPasswordForTesting(String username) {
        Optional<User> userOpt = userRepository.findByUsername(username);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            user.setPassword(PasswordUtil.hashPassword("password123"));
            user.setUpdatedAt(Timestamp.valueOf(LocalDateTime.now()));
            userRepository.save(user);
            System.out.println("Password reset for user: " + username);
        }
    }

    /**
     * 모든 사용자의 비밀번호를 BCrypt 해시로 업데이트 (테스트용)
     * 평문 또는 잘못된 해시 비밀번호를 'password123'의 BCrypt 해시로 변경
     */
    public int fixAllPasswordsWithBCrypt() {
        List<User> allUsers = userRepository.findAll();
        String correctHash = PasswordUtil.hashPassword("password123");
        int count = 0;

        for (User user : allUsers) {
            // BCrypt 해시가 아니거나 길이가 맞지 않으면 업데이트
            String currentPassword = user.getPassword();
            if (currentPassword == null || !currentPassword.startsWith("$2a$") || currentPassword.length() != 60) {
                user.setPassword(correctHash);
                user.setUpdatedAt(Timestamp.valueOf(LocalDateTime.now()));
                userRepository.save(user);
                count++;
                System.out.println("Updated password for user: " + user.getUsername());
            }
        }

        return count;
    }
}
