package com.health.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.health.model.Matching;
import com.health.model.MatchingStatus;
import com.health.model.Trainer;
import com.health.model.User;
import com.health.service.MatchingService;
import com.health.service.TrainerService;

/**
 * 매칭 관련 컨트롤러
 * 유저-트레이너 매칭 요청, 수락, 거절 등을 처리
 */
// @Controller
// @RequestMapping("/matching")
public class MatchingController {

    @Autowired
    private MatchingService matchingService;

    @Autowired
    private TrainerService trainerService;

    /**
     * 트레이너 목록 조회
     */
    @GetMapping("/trainers")
    public String trainerList(Model model) {
        List<Trainer> trainers = trainerService.getAllTrainers();
        model.addAttribute("trainers", trainers);
        return "matching/trainer-list";
    }

    /**
     * 매칭 요청 페이지
     */
    @GetMapping("/request/{trainerId}")
    public String requestForm(@PathVariable("trainerId") Long trainerId,
            Model model,
            HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login";
        }

        Trainer trainer = trainerService.getTrainerById(trainerId);
        model.addAttribute("trainer", trainer);
        return "matching/request";
    }

    /**
     * 매칭 요청 처리
     */
    @PostMapping("/request")
    public String createMatching(@RequestParam("trainerId") Long trainerId,
            @RequestParam("startDate") String startDate,
            @RequestParam("endDate") String endDate,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login";
        }

        try {
            Matching matching = new Matching();
            matching.setUserId(user.getUserId());
            matching.setTrainerId(trainerId);
            matching.setStartDate(java.sql.Date.valueOf(startDate));
            matching.setEndDate(java.sql.Date.valueOf(endDate));
            matching.setStatus(MatchingStatus.PENDING);

            matchingService.createMatching(matching);
            redirectAttributes.addFlashAttribute("message", "매칭 요청이 완료되었습니다.");
            return "redirect:/user/dashboard";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "매칭 요청 중 오류가 발생했습니다.");
            return "redirect:/matching/trainers";
        }
    }

    /**
     * 매칭 요청 수락 (트레이너)
     */
    @PostMapping("/accept/{matchingId}")
    public String acceptMatching(@PathVariable("matchingId") Long matchingId,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        Trainer trainer = (Trainer) session.getAttribute("trainer");
        if (trainer == null) {
            return "redirect:/trainer/login";
        }

        try {
            matchingService.updateMatchingStatus(matchingId, "ACCEPTED");
            redirectAttributes.addFlashAttribute("message", "매칭을 수락했습니다.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "매칭 수락 중 오류가 발생했습니다.");
        }

        return "redirect:/trainer/dashboard";
    }

    /**
     * 매칭 요청 거절 (트레이너)
     */
    @PostMapping("/reject/{matchingId}")
    public String rejectMatching(@PathVariable("matchingId") Long matchingId,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        Trainer trainer = (Trainer) session.getAttribute("trainer");
        if (trainer == null) {
            return "redirect:/trainer/login";
        }

        try {
            matchingService.updateMatchingStatus(matchingId, "REJECTED");
            redirectAttributes.addFlashAttribute("message", "매칭을 거절했습니다.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "매칭 거절 중 오류가 발생했습니다.");
        }

        return "redirect:/trainer/dashboard";
    }

    /**
     * 매칭 완료 처리
     */
    @PostMapping("/complete/{matchingId}")
    public String completeMatching(@PathVariable("matchingId") Long matchingId,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        Trainer trainer = (Trainer) session.getAttribute("trainer");
        if (trainer == null) {
            return "redirect:/trainer/login";
        }

        try {
            matchingService.updateMatchingStatus(matchingId, "COMPLETED");
            redirectAttributes.addFlashAttribute("message", "매칭이 완료되었습니다.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "매칭 완료 처리 중 오류가 발생했습니다.");
        }

        return "redirect:/trainer/dashboard";
    }

    /**
     * 사용자의 매칭 목록 조회
     */
    @GetMapping("/my-matchings")
    public String myMatchings(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login";
        }

        List<Matching> matchings = matchingService.getMatchingsByUserId(user.getUserId());
        model.addAttribute("matchings", matchings);
        return "matching/my-list";
    }
}
