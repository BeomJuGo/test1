package com.health.service;

import com.health.dao.TrainerDao;
import com.health.model.Trainer;
import com.health.util.PasswordUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class TrainerService {
    
    @Autowired
    private TrainerDao trainerDao;
    
    public Trainer registerTrainer(Trainer trainer) {
        // Check if username already exists
        if (trainerDao.selectTrainerByUsername(trainer.getUsername()) != null) {
            throw new RuntimeException("Username already exists");
        }
        // Check if email already exists
        if (trainerDao.selectTrainerByEmail(trainer.getEmail()) != null) {
            throw new RuntimeException("Email already exists");
        }
        // Encrypt password
        trainer.setPassword(PasswordUtil.hashPassword(trainer.getPassword()));
        trainerDao.insertTrainer(trainer);
        return trainer;
    }
    
    public Trainer loginTrainer(String username, String password) {
        Trainer trainer = trainerDao.selectTrainerByUsername(username);
        if (trainer == null) {
            throw new RuntimeException("Invalid username or password");
        }
        if (!PasswordUtil.checkPassword(password, trainer.getPassword())) {
            throw new RuntimeException("Invalid username or password");
        }
        return trainer;
    }
    
    public Trainer getTrainerById(Long trainerId) {
        return trainerDao.selectTrainerById(trainerId);
    }
    
    public Trainer getTrainerByUsername(String username) {
        return trainerDao.selectTrainerByUsername(username);
    }
    
    public List<Trainer> getAllTrainers() {
        return trainerDao.selectAllTrainers();
    }
    
    public void updateTrainer(Trainer trainer) {
        trainerDao.updateTrainer(trainer);
    }
    
    public void updatePassword(Long trainerId, String newPassword) {
        String hashedPassword = PasswordUtil.hashPassword(newPassword);
        trainerDao.updatePassword(trainerId, hashedPassword);
    }
    
    public void deleteTrainer(Long trainerId) {
        trainerDao.deleteTrainer(trainerId);
    }
}
