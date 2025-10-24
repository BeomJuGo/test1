package com.health.service;

// import com.health.dao.MatchingDao; // Removed - using JPA Repository now
import com.health.model.Matching;
import com.health.model.MatchingStatus;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

@Service
@Transactional
public class MatchingService {

    // @Autowired
    // private MatchingDao matchingDao; // Removed - using JPA Repository now

    public Matching createMatching(Matching matching) {
        matching.setStatus(MatchingStatus.PENDING);
        // TODO: Implement with JPA Repository
        return matching;
    }

    public Matching getMatchingById(Long matchingId) {
        // TODO: Implement with JPA Repository
        return null;
    }

    public List<Matching> getMatchingsByUserId(Long userId) {
        // TODO: Implement with JPA Repository
        return new ArrayList<>();
    }

    public void updateMatchingStatus(Long matchingId, String status) {
        // TODO: Implement with JPA Repository
    }

    public List<Matching> getMatchingsByTrainerId(Long trainerId) {
        // TODO: Implement with JPA Repository
        return new ArrayList<>();
    }

    public Matching getActiveMatchingByUserAndTrainer(Long userId, Long trainerId) {
        // TODO: Implement with JPA Repository
        return null;
    }

    public void acceptMatching(Long matchingId) {
        // TODO: Implement with JPA Repository
    }

    public void rejectMatching(Long matchingId) {
        // TODO: Implement with JPA Repository
    }

    public void completeMatching(Long matchingId) {
        // TODO: Implement with JPA Repository
    }

    public void updateMatching(Matching matching) {
        // TODO: Implement with JPA Repository
    }

    public void deleteMatching(Long matchingId) {
        // TODO: Implement with JPA Repository
    }
}
