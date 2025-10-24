package com.health.service;

import com.health.model.Trainer;
import com.health.repository.TrainerRepository;
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
public class TrainerService {

    @Autowired
    private TrainerRepository trainerRepository;

    public Trainer registerTrainer(Trainer trainer) {
        // Check if username already exists
        if (trainerRepository.existsByUsername(trainer.getUsername())) {
            throw new RuntimeException("Username already exists");
        }
        // Check if email already exists
        if (trainerRepository.existsByEmail(trainer.getEmail())) {
            throw new RuntimeException("Email already exists");
        }
        // Encrypt password
        trainer.setPassword(PasswordUtil.hashPassword(trainer.getPassword()));
        // Set timestamps
        Timestamp now = Timestamp.valueOf(LocalDateTime.now());
        trainer.setCreatedAt(now);
        trainer.setUpdatedAt(now);
        return trainerRepository.save(trainer);
    }

    public boolean register(Trainer trainer) {
        try {
            registerTrainer(trainer);
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    public Trainer loginTrainer(String username, String password) {
        Optional<Trainer> trainerOpt = trainerRepository.findByUsername(username);
        if (trainerOpt.isEmpty()) {
            throw new RuntimeException("Invalid username or password");
        }
        Trainer trainer = trainerOpt.get();
        if (!PasswordUtil.checkPassword(password, trainer.getPassword())) {
            throw new RuntimeException("Invalid username or password");
        }
        return trainer;
    }

    public Trainer login(String username, String password) {
        return loginTrainer(username, password);
    }

    public Trainer getTrainerById(Long trainerId) {
        return trainerRepository.findById(trainerId).orElse(null);
    }

    public Trainer getTrainerByUsername(String username) {
        return trainerRepository.findByUsername(username).orElse(null);
    }

    public List<Trainer> getAllTrainers() {
        return trainerRepository.findAll();
    }

    public boolean updateTrainer(Trainer trainer) {
        try {
            trainer.setUpdatedAt(Timestamp.valueOf(LocalDateTime.now()));
            trainerRepository.save(trainer);
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    public void updatePassword(Long trainerId, String newPassword) {
        Optional<Trainer> trainerOpt = trainerRepository.findById(trainerId);
        if (trainerOpt.isPresent()) {
            Trainer trainer = trainerOpt.get();
            trainer.setPassword(PasswordUtil.hashPassword(newPassword));
            trainer.setUpdatedAt(Timestamp.valueOf(LocalDateTime.now()));
            trainerRepository.save(trainer);
        }
    }

    public void deleteTrainer(Long trainerId) {
        trainerRepository.deleteById(trainerId);
    }

    /**
     * 모든 트레이너의 비밀번호를 BCrypt 해시로 업데이트 (테스트용)
     * 평문 또는 잘못된 해시 비밀번호를 'password123'의 BCrypt 해시로 변경
     */
    public int fixAllPasswordsWithBCrypt() {
        List<Trainer> allTrainers = trainerRepository.findAll();
        String correctHash = PasswordUtil.hashPassword("password123");
        int count = 0;

        for (Trainer trainer : allTrainers) {
            // BCrypt 해시가 아니거나 길이가 맞지 않으면 업데이트
            String currentPassword = trainer.getPassword();
            if (currentPassword == null || !currentPassword.startsWith("$2a$") || currentPassword.length() != 60) {
                trainer.setPassword(correctHash);
                trainer.setUpdatedAt(Timestamp.valueOf(LocalDateTime.now()));
                trainerRepository.save(trainer);
                count++;
                System.out.println("Updated password for trainer: " + trainer.getUsername());
            }
        }

        return count;
    }
}
