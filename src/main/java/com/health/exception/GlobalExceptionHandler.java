package com.health.exception;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.multipart.MaxUploadSizeExceededException;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

/**
 * 전역 예외 처리 핸들러
 */
@ControllerAdvice
public class GlobalExceptionHandler {

  private static final Logger logger = LoggerFactory.getLogger(GlobalExceptionHandler.class);

  /**
   * 파일 업로드 크기 초과 예외 처리
   */
  @ExceptionHandler(MaxUploadSizeExceededException.class)
  public String handleMaxUploadSizeExceeded(MaxUploadSizeExceededException ex,
      RedirectAttributes redirectAttributes) {
    logger.error("파일 업로드 크기 초과: {}", ex.getMessage());
    redirectAttributes.addFlashAttribute("error", "파일 크기가 너무 큽니다. 최대 10MB까지 업로드 가능합니다.");
    return "redirect:/error";
  }

  /**
   * 파일 업로드 예외 처리
   */
  @ExceptionHandler(FileUploadException.class)
  public ResponseEntity<Map<String, Object>> handleFileUploadException(FileUploadException ex) {
    logger.error("파일 업로드 오류: {}", ex.getMessage());

    Map<String, Object> response = new HashMap<>();
    response.put("success", false);
    response.put("message", ex.getMessage());
    response.put("errorCode", "FILE_UPLOAD_ERROR");

    return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
  }

  /**
   * 데이터베이스 예외 처리
   */
  @ExceptionHandler(DatabaseException.class)
  public ResponseEntity<Map<String, Object>> handleDatabaseException(DatabaseException ex) {
    logger.error("데이터베이스 오류: {}", ex.getMessage());

    Map<String, Object> response = new HashMap<>();
    response.put("success", false);
    response.put("message", "데이터베이스 처리 중 오류가 발생했습니다.");
    response.put("errorCode", "DATABASE_ERROR");

    return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
  }

  /**
   * 인증 예외 처리
   */
  @ExceptionHandler(AuthenticationException.class)
  public ResponseEntity<Map<String, Object>> handleAuthenticationException(AuthenticationException ex) {
    logger.error("인증 오류: {}", ex.getMessage());

    Map<String, Object> response = new HashMap<>();
    response.put("success", false);
    response.put("message", ex.getMessage());
    response.put("errorCode", "AUTHENTICATION_ERROR");

    return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
  }

  /**
   * 비즈니스 로직 예외 처리
   */
  @ExceptionHandler(BusinessException.class)
  public ResponseEntity<Map<String, Object>> handleBusinessException(BusinessException ex) {
    logger.error("비즈니스 로직 오류: {}", ex.getMessage());

    Map<String, Object> response = new HashMap<>();
    response.put("success", false);
    response.put("message", ex.getMessage());
    response.put("errorCode", ex.getErrorCode());

    return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
  }

  /**
   * 일반적인 예외 처리
   */
  @ExceptionHandler(Exception.class)
  public ResponseEntity<Map<String, Object>> handleGenericException(Exception ex, HttpServletRequest request) {
    logger.error("예상치 못한 오류 발생: {} - URL: {}", ex.getMessage(), request.getRequestURL());

    Map<String, Object> response = new HashMap<>();
    response.put("success", false);
    response.put("message", "서버 내부 오류가 발생했습니다.");
    response.put("errorCode", "INTERNAL_SERVER_ERROR");

    return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
  }
}
