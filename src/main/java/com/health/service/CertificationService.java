package com.health.service;

import com.health.dao.CertificationDao;
import com.health.model.DietCertification;
import com.health.model.ExerciseCertification;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class CertificationService {
    
    @Autowired
    private CertificationDao certificationDao;
    
    // Exercise Certification Methods
    public ExerciseCertification createExerciseCertification(ExerciseCertification cert) {
        certificationDao.insertExerciseCertification(cert);
        return cert;
    }
    
    public ExerciseCertification getExerciseCertificationById(Long certId) {
        return certificationDao.selectExerciseCertificationById(certId);
    }
    
    public ExerciseCertification getExerciseCertificationByPlanId(Long planId) {
        return certificationDao.selectExerciseCertificationByPlanId(planId);
    }
    
    public List<ExerciseCertification> getExerciseCertificationsByTrainerId(Long trainerId) {
        return certificationDao.selectExerciseCertificationsByTrainerId(trainerId);
    }
    
    public void addExerciseFeedback(Long certId, String feedback) {
        certificationDao.updateExerciseCertificationFeedback(certId, feedback);
    }
    
    public void deleteExerciseCertification(Long certId) {
        certificationDao.deleteExerciseCertification(certId);
    }
    
    // Diet Certification Methods
    public DietCertification createDietCertification(DietCertification cert) {
        certificationDao.insertDietCertification(cert);
        return cert;
    }
    
    public DietCertification getDietCertificationById(Long certId) {
        return certificationDao.selectDietCertificationById(certId);
    }
    
    public DietCertification getDietCertificationByDietId(Long dietId) {
        return certificationDao.selectDietCertificationByDietId(dietId);
    }
    
    public List<DietCertification> getDietCertificationsByTrainerId(Long trainerId) {
        return certificationDao.selectDietCertificationsByTrainerId(trainerId);
    }
    
    public void addDietFeedback(Long certId, String feedback) {
        certificationDao.updateDietCertificationFeedback(certId, feedback);
    }
    
    public void deleteDietCertification(Long certId) {
        certificationDao.deleteDietCertification(certId);
    }
}
