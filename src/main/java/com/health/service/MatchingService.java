package com.health.service;

import com.health.dao.MatchingDao;
import com.health.model.Matching;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class MatchingService {
    
    @Autowired
    private MatchingDao matchingDao;
    
    public Matching createMatching(Matching matching) {
        matching.setStatus("PENDING");
        matchingDao.insertMatching(matching);
        return matching;
    }
    
    public Matching getMatchingById(Long matchingId) {
        return matchingDao.selectMatchingById(matchingId);
    }
    
    public List<Matching> getMatchingsByUserId(Long userId) {
        return matchingDao.selectMatchingsByUserId(userId);
    }
    
    public List<Matching> getMatchingsByTrainerId(Long trainerId) {
        return matchingDao.selectMatchingsByTrainerId(trainerId);
    }
    
    public Matching getActiveMatchingByUserAndTrainer(Long userId, Long trainerId) {
        return matchingDao.selectActiveMatchingByUserAndTrainer(userId, trainerId);
    }
    
    public void acceptMatching(Long matchingId) {
        matchingDao.updateMatchingStatus(matchingId, "ACCEPTED");
    }
    
    public void rejectMatching(Long matchingId) {
        matchingDao.updateMatchingStatus(matchingId, "REJECTED");
    }
    
    public void completeMatching(Long matchingId) {
        matchingDao.updateMatchingStatus(matchingId, "COMPLETED");
    }
    
    public void updateMatching(Matching matching) {
        matchingDao.updateMatching(matching);
    }
    
    public void deleteMatching(Long matchingId) {
        matchingDao.deleteMatching(matchingId);
    }
}
