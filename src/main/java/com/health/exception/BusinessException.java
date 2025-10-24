package com.health.exception;

/**
 * 비즈니스 로직 관련 예외
 */
public class BusinessException extends RuntimeException {

  private String errorCode;

  public BusinessException(String message) {
    super(message);
  }

  public BusinessException(String message, String errorCode) {
    super(message);
    this.errorCode = errorCode;
  }

  public BusinessException(String message, Throwable cause) {
    super(message, cause);
  }

  public BusinessException(String message, String errorCode, Throwable cause) {
    super(message, cause);
    this.errorCode = errorCode;
  }

  public String getErrorCode() {
    return errorCode;
  }
}
