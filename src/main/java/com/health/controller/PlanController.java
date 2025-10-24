package com.health.controller;

import com.health.exception.BusinessException;
import com.health.exception.DatabaseException;
import com.health.model.DietPlan;
import com.health.model.ExercisePlan;
import com.health.model.User;
import com.health.service.PlanService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Plan Controller - 운동 및 식단 계획 요청 처리
 */
// @Controller
// @RequestMapping("/plan")
public class PlanController {

    private static final Logger logger = LoggerFactory.getLogger(PlanController.class);

    @Autowired
    private PlanService planService;

    /**
     * 특정 날짜의 계획 조회 (운동 + 식단)
     * 캘린더에서 날짜 클릭 시 사용
     */
    @GetMapping("/daily")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getDailyPlan(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.put("success", false);
            response.put("message", "로그인이 필요합니다.");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
        }

        try {
            // 세션에서 현재 매칭 ID 가져오기
            Long matchingId = (Long) session.getAttribute("currentMatchingId");
            if (matchingId == null) {
                response.put("success", false);
                response.put("message", "활성화된 매칭이 없습니다.");
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
            }

            List<ExercisePlan> dailyPlans = planService.getDailyPlans(matchingId, date);

            response.put("success", true);
            response.put("data", dailyPlans);
            return ResponseEntity.ok(response);

        } catch (BusinessException e) {
            logger.error("비즈니스 로직 오류: {}", e.getMessage());
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
        } catch (DatabaseException e) {
            logger.error("데이터베이스 오류: {}", e.getMessage());
            response.put("success", false);
            response.put("message", "데이터베이스 처리 중 오류가 발생했습니다.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        } catch (Exception e) {
            logger.error("예상치 못한 오류: {}", e.getMessage(), e);
            response.put("success", false);
            response.put("message", "서버 내부 오류가 발생했습니다.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /**
     * 캘린더용 계획 목록 조회 (기간별)
     */
    @GetMapping("/calendar")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getPlansForCalendar(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.put("success", false);
            response.put("message", "로그인이 필요합니다.");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
        }

        try {
            // 세션에서 현재 매칭 ID 가져오기
            Long matchingId = (Long) session.getAttribute("currentMatchingId");
            if (matchingId == null) {
                response.put("success", false);
                response.put("message", "활성화된 매칭이 없습니다.");
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
            }

            List<ExercisePlan> plans = planService.getPlansForCalendar(matchingId, startDate, endDate);

            // FullCalendar 형식으로 변환
            List<Map<String, Object>> calendarEvents = convertToCalendarEvents(plans);

            response.put("success", true);
            response.put("events", calendarEvents);
            return ResponseEntity.ok(response);

        } catch (BusinessException e) {
            logger.error("비즈니스 로직 오류: {}", e.getMessage());
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
        } catch (DatabaseException e) {
            logger.error("데이터베이스 오류: {}", e.getMessage());
            response.put("success", false);
            response.put("message", "데이터베이스 처리 중 오류가 발생했습니다.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        } catch (Exception e) {
            logger.error("예상치 못한 오류: {}", e.getMessage(), e);
            response.put("success", false);
            response.put("message", "서버 내부 오류가 발생했습니다.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /**
     * 운동 계획 생성 (트레이너용)
     */
    @PostMapping("/exercise")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> createExercisePlan(
            @RequestBody ExercisePlan plan,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();

        try {
            ExercisePlan createdPlan = planService.createExercisePlan(plan);
            Long planId = createdPlan.getPlanId();
            response.put("success", true);
            response.put("message", "운동 계획이 생성되었습니다.");
            response.put("planId", planId);
            return ResponseEntity.ok(response);

        } catch (BusinessException e) {
            logger.error("비즈니스 로직 오류: {}", e.getMessage());
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
        } catch (DatabaseException e) {
            logger.error("데이터베이스 오류: {}", e.getMessage());
            response.put("success", false);
            response.put("message", "데이터베이스 처리 중 오류가 발생했습니다.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        } catch (Exception e) {
            logger.error("예상치 못한 오류: {}", e.getMessage(), e);
            response.put("success", false);
            response.put("message", "서버 내부 오류가 발생했습니다.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /**
     * 식단 계획 생성 (트레이너용)
     */
    @PostMapping("/diet")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> createDietPlan(
            @RequestBody DietPlan plan,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();

        try {
            DietPlan createdPlan = planService.createDietPlan(plan);
            Long dietId = createdPlan.getDietId();
            response.put("success", true);
            response.put("message", "식단 계획이 생성되었습니다.");
            response.put("dietId", dietId);
            return ResponseEntity.ok(response);

        } catch (BusinessException e) {
            logger.error("비즈니스 로직 오류: {}", e.getMessage());
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
        } catch (DatabaseException e) {
            logger.error("데이터베이스 오류: {}", e.getMessage());
            response.put("success", false);
            response.put("message", "데이터베이스 처리 중 오류가 발생했습니다.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        } catch (Exception e) {
            logger.error("예상치 못한 오류: {}", e.getMessage(), e);
            response.put("success", false);
            response.put("message", "서버 내부 오류가 발생했습니다.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /**
     * 운동 계획 삭제
     */
    @DeleteMapping("/exercise/{planId}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> deleteExercisePlan(
            @PathVariable Long planId,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();

        try {
            planService.deleteExercisePlan(planId);
            boolean deleted = true; // 성공적으로 실행되면 true
            response.put("success", deleted);
            response.put("message", deleted ? "삭제되었습니다." : "삭제 실패");
            return ResponseEntity.ok(response);

        } catch (BusinessException e) {
            logger.error("비즈니스 로직 오류: {}", e.getMessage());
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
        } catch (DatabaseException e) {
            logger.error("데이터베이스 오류: {}", e.getMessage());
            response.put("success", false);
            response.put("message", "데이터베이스 처리 중 오류가 발생했습니다.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        } catch (Exception e) {
            logger.error("예상치 못한 오류: {}", e.getMessage(), e);
            response.put("success", false);
            response.put("message", "서버 내부 오류가 발생했습니다.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /**
     * 식단 계획 삭제
     */
    @DeleteMapping("/diet/{dietId}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> deleteDietPlan(
            @PathVariable Long dietId,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();

        try {
            planService.deleteDietPlan(dietId);
            boolean deleted = true; // 성공적으로 실행되면 true
            response.put("success", deleted);
            response.put("message", deleted ? "삭제되었습니다." : "삭제 실패");
            return ResponseEntity.ok(response);

        } catch (BusinessException e) {
            logger.error("비즈니스 로직 오류: {}", e.getMessage());
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
        } catch (DatabaseException e) {
            logger.error("데이터베이스 오류: {}", e.getMessage());
            response.put("success", false);
            response.put("message", "데이터베이스 처리 중 오류가 발생했습니다.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        } catch (Exception e) {
            logger.error("예상치 못한 오류: {}", e.getMessage(), e);
            response.put("success", false);
            response.put("message", "서버 내부 오류가 발생했습니다.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /**
     * 계획 데이터를 FullCalendar 이벤트 형식으로 변환
     */
    private List<Map<String, Object>> convertToCalendarEvents(List<ExercisePlan> plans) {
        List<Map<String, Object>> events = new java.util.ArrayList<>();

        // 운동 계획 변환
        if (plans != null) {
            for (ExercisePlan plan : plans) {
                Map<String, Object> event = new HashMap<>();
                event.put("id", "exercise-" + plan.getPlanId());
                event.put("title", "🏃 " + plan.getExerciseName());
                event.put("start", plan.getPlanDate().toString());
                event.put("color", "#10b981");
                event.put("extendedProps", Map.of(
                        "type", "exercise",
                        "planId", plan.getPlanId(),
                        "sets", plan.getSets(),
                        "reps", plan.getReps(),
                        "duration", plan.getDuration(),
                        "calories", plan.getCalories()));
                events.add(event);
            }
        }

        // TODO: 식단 계획 변환은 별도 메서드로 분리 필요
        // 현재는 운동 계획만 처리

        return events;
    }

    /**
     * 식사 타입에 따른 이모지 반환
     */
    private String getMealEmoji(String mealType) {
        switch (mealType) {
            case "BREAKFAST":
                return "🍳";
            case "LUNCH":
                return "🍱";
            case "DINNER":
                return "🍽️";
            case "SNACK":
                return "🍪";
            default:
                return "🥗";
        }
    }
}