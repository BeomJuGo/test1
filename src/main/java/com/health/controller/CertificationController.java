package com.health.controller;

import java.io.File;
import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.health.exception.FileUploadException;
import com.health.exception.BusinessException;
import com.health.model.DietCertification;
import com.health.model.ExerciseCertification;
import com.health.model.User;
import com.health.service.CertificationService;
import com.health.util.FileUploadUtil;

/**
 * 인증 사진 업로드 컨트롤러
 * 운동 및 식단 인증 사진 업로드, 조회, 피드백 처리
 */
// @Controller
// @RequestMapping("/certification")
public class CertificationController {

    private static final Logger logger = LoggerFactory.getLogger(CertificationController.class);

    @Autowired
    private CertificationService certificationService;

    @Autowired
    private FileUploadUtil fileUploadUtil;

    /**
     * 운동 인증 업로드 페이지
     */
    @GetMapping("/exercise/upload/{planId}")
    public String exerciseUploadForm(@PathVariable("planId") Long planId,
            Model model,
            HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login";
        }

        model.addAttribute("planId", planId);
        model.addAttribute("type", "exercise");
        return "certification/upload";
    }

    /**
     * 운동 인증 업로드 처리
     */
    @PostMapping("/exercise/upload")
    public String uploadExerciseCertification(@RequestParam("planId") Long planId,
            @RequestParam("image") MultipartFile image,
            @RequestParam(value = "comment", required = false) String comment,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login";
        }

        try {
            // 파일 업로드
            String imagePath = fileUploadUtil.saveFile(image, "certifications");

            // 인증 정보 저장
            ExerciseCertification certification = new ExerciseCertification();
            certification.setPlanId(planId);
            certification.setUserId(user.getUserId());
            certification.setImagePath(imagePath);
            certification.setComment(comment);

            certificationService.createExerciseCertification(certification);
            redirectAttributes.addFlashAttribute("message", "운동 인증이 완료되었습니다.");
            return "redirect:/plan/daily";
        } catch (FileUploadException e) {
            logger.error("파일 업로드 오류: {}", e.getMessage());
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/certification/exercise/upload/" + planId;
        } catch (BusinessException e) {
            logger.error("비즈니스 로직 오류: {}", e.getMessage());
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/certification/exercise/upload/" + planId;
        } catch (Exception e) {
            logger.error("예상치 못한 오류: {}", e.getMessage(), e);
            redirectAttributes.addFlashAttribute("error", "인증 업로드 중 오류가 발생했습니다.");
            return "redirect:/certification/exercise/upload/" + planId;
        }
    }

    /**
     * 식단 인증 업로드 페이지
     */
    @GetMapping("/diet/upload/{dietId}")
    public String dietUploadForm(@PathVariable("dietId") Long dietId,
            Model model,
            HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login";
        }

        model.addAttribute("dietId", dietId);
        model.addAttribute("type", "diet");
        return "certification/upload";
    }

    /**
     * 식단 인증 업로드 처리
     */
    @PostMapping("/diet/upload")
    public String uploadDietCertification(@RequestParam("dietId") Long dietId,
            @RequestParam("image") MultipartFile image,
            @RequestParam(value = "comment", required = false) String comment,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login";
        }

        try {
            // 파일 업로드
            String imagePath = fileUploadUtil.saveFile(image, "certifications");

            // 인증 정보 저장
            DietCertification certification = new DietCertification();
            certification.setDietId(dietId);
            certification.setUserId(user.getUserId());
            certification.setImagePath(imagePath);
            certification.setComment(comment);

            certificationService.createDietCertification(certification);
            redirectAttributes.addFlashAttribute("message", "식단 인증이 완료되었습니다.");
            return "redirect:/plan/daily";
        } catch (FileUploadException e) {
            logger.error("파일 업로드 오류: {}", e.getMessage());
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/certification/diet/upload/" + dietId;
        } catch (BusinessException e) {
            logger.error("비즈니스 로직 오류: {}", e.getMessage());
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/certification/diet/upload/" + dietId;
        } catch (Exception e) {
            logger.error("예상치 못한 오류: {}", e.getMessage(), e);
            redirectAttributes.addFlashAttribute("error", "인증 업로드 중 오류가 발생했습니다.");
            return "redirect:/certification/diet/upload/" + dietId;
        }
    }

    /**
     * 운동 인증 목록 조회
     */
    @GetMapping("/exercise/list")
    public String exerciseCertificationList(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login";
        }

        try {
            List<ExerciseCertification> certifications = certificationService
                    .getExerciseCertificationsByUserId(user.getUserId());
            model.addAttribute("certifications", certifications);
            model.addAttribute("type", "exercise");
            return "certification/list";
        } catch (Exception e) {
            logger.error("운동 인증 목록 조회 오류: {}", e.getMessage());
            model.addAttribute("error", "인증 목록을 불러오는 중 오류가 발생했습니다.");
            return "certification/list";
        }
    }

    /**
     * 식단 인증 목록 조회
     */
    @GetMapping("/diet/list")
    public String dietCertificationList(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login";
        }

        try {
            List<DietCertification> certifications = certificationService
                    .getDietCertificationsByUserId(user.getUserId());
            model.addAttribute("certifications", certifications);
            model.addAttribute("type", "diet");
            return "certification/list";
        } catch (Exception e) {
            logger.error("식단 인증 목록 조회 오류: {}", e.getMessage());
            model.addAttribute("error", "인증 목록을 불러오는 중 오류가 발생했습니다.");
            return "certification/list";
        }
    }

    /**
     * 트레이너 피드백 추가
     */
    @PostMapping("/feedback/exercise/{certId}")
    public String addExerciseFeedback(@PathVariable("certId") Long certId,
            @RequestParam("feedback") String feedback,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        if (session.getAttribute("trainer") == null) {
            return "redirect:/trainer/login";
        }

        try {
            if (feedback == null || feedback.trim().isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "피드백 내용을 입력해주세요.");
                return "redirect:/trainer/dashboard";
            }

            certificationService.addExerciseFeedback(certId, feedback.trim());
            redirectAttributes.addFlashAttribute("message", "피드백이 등록되었습니다.");
        } catch (BusinessException e) {
            logger.error("피드백 등록 비즈니스 오류: {}", e.getMessage());
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        } catch (Exception e) {
            logger.error("피드백 등록 오류: {}", e.getMessage());
            redirectAttributes.addFlashAttribute("error", "피드백 등록 중 오류가 발생했습니다.");
        }

        return "redirect:/trainer/dashboard";
    }

    /**
     * 트레이너 피드백 추가 (식단)
     */
    @PostMapping("/feedback/diet/{certId}")
    public String addDietFeedback(@PathVariable("certId") Long certId,
            @RequestParam("feedback") String feedback,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        if (session.getAttribute("trainer") == null) {
            return "redirect:/trainer/login";
        }

        try {
            if (feedback == null || feedback.trim().isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "피드백 내용을 입력해주세요.");
                return "redirect:/trainer/dashboard";
            }

            certificationService.addDietFeedback(certId, feedback.trim());
            redirectAttributes.addFlashAttribute("message", "피드백이 등록되었습니다.");
        } catch (BusinessException e) {
            logger.error("피드백 등록 비즈니스 오류: {}", e.getMessage());
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        } catch (Exception e) {
            logger.error("피드백 등록 오류: {}", e.getMessage());
            redirectAttributes.addFlashAttribute("error", "피드백 등록 중 오류가 발생했습니다.");
        }

        return "redirect:/trainer/dashboard";
    }
}
