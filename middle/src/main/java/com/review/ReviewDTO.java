package com.review;

import java.util.Date;

public class ReviewDTO {
    private int reviewId;        // PK
    private String userId;       // FK -> userinfo(id)
    private String storeName;    // FK -> store(name)
    private String content;
    private Double rating;       // NUMBER(2,1) -> Double
    private String reviewImg;    // 이미지 경로
    private Date createdAt;      // 작성일

    public ReviewDTO() {}

    public ReviewDTO(int reviewId, String userId, String storeName,
                     String content, Double rating, String reviewImg, Date createdAt) {
        this.reviewId = reviewId;
        this.userId = userId;
        this.storeName = storeName;
        this.content = content;
        this.rating = rating;
        this.reviewImg = reviewImg;
        this.createdAt = createdAt;
    }

    public int getReviewId() { return reviewId; }
    public void setReviewId(int reviewId) { this.reviewId = reviewId; }

    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }

    public String getStoreName() { return storeName; }
    public void setStoreName(String storeName) { this.storeName = storeName; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public Double getRating() { return rating; }
    public void setRating(Double rating) { this.rating = rating; }

    public String getReviewImg() { return reviewImg; }
    public void setReviewImg(String reviewImg) { this.reviewImg = reviewImg; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }

    @Override
    public String toString() {
        return "ReviewDTO{" +
                "reviewId=" + reviewId +
                ", userId='" + userId + '\'' +
                ", storeName='" + storeName + '\'' +
                ", rating=" + rating +
                ", createdAt=" + createdAt +
                '}';
    }
}
