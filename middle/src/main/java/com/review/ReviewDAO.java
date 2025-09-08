package com.review;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import com.db.DBManager; // 프로젝트에 맞게 import

public class ReviewDAO {

    private ReviewDAO() {}
    private static final ReviewDAO instance = new ReviewDAO();
    public static ReviewDAO getInstance() { return instance; }

    // 공통: ResultSet -> DTO 매핑
    private ReviewDTO mapRow(ResultSet rs) throws SQLException {
        ReviewDTO dto = new ReviewDTO();
        dto.setReviewId(rs.getInt("review_id"));
        dto.setUserId(rs.getString("user_id"));
        dto.setStoreName(rs.getString("store_name"));
        dto.setContent(rs.getString("content"));
        double r = rs.getDouble("rating");
        if (!rs.wasNull()) dto.setRating(r);
        dto.setReviewImg(rs.getString("review_img"));
        Timestamp ts = rs.getTimestamp("created_at");
        if (ts != null) dto.setCreatedAt(new java.util.Date(ts.getTime()));
        return dto;
    }

    /* ==================== C(INSERT) ==================== */
    public int insert(ReviewDTO dto) {
        String sql = "INSERT INTO review " +
                "(review_id, user_id, store_name, content, rating, review_img) " +
                "VALUES (review_seq.NEXTVAL, ?, ?, ?, ?, ?)";
        try (Connection conn = DBManager.conn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, dto.getUserId());
            ps.setString(2, dto.getStoreName());
            ps.setString(3, dto.getContent());
            if (dto.getRating() == null) ps.setNull(4, Types.NUMERIC);
            else ps.setDouble(4, dto.getRating());
            ps.setString(5, dto.getReviewImg());

            return ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    /* ==================== R(SELECT) ==================== */
    public ReviewDTO findById(int reviewId) {
        String sql = "SELECT * FROM review WHERE review_id = ?";
        try (Connection conn = DBManager.conn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, reviewId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    public List<ReviewDTO> findAll() {
        String sql = "SELECT * FROM review ORDER BY review_id DESC";
        List<ReviewDTO> list = new ArrayList<>();
        try (Connection conn = DBManager.conn();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<ReviewDTO> findByStore(String storeName) {
        String sql = "SELECT * FROM review WHERE store_name = ? ORDER BY review_id DESC";
        List<ReviewDTO> list = new ArrayList<>();
        try (Connection conn = DBManager.conn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, storeName);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<ReviewDTO> findByUser(String userId) {
        String sql = "SELECT * FROM review WHERE user_id = ? ORDER BY review_id DESC";
        List<ReviewDTO> list = new ArrayList<>();
        try (Connection conn = DBManager.conn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // 페이징 (Oracle 12c+)
    public List<ReviewDTO> findByStorePaged(String storeName, int page, int pageSize) {
        String sql =
            "SELECT * FROM (" +
            "  SELECT r.*, ROW_NUMBER() OVER (ORDER BY r.review_id DESC) rn " +
            "  FROM review r WHERE r.store_name = ?" +
            ") WHERE rn BETWEEN ? AND ?";
        int start = (page - 1) * pageSize + 1;
        int end   = page * pageSize;

        List<ReviewDTO> list = new ArrayList<>();
        try (Connection conn = DBManager.conn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, storeName);
            ps.setInt(2, start);
            ps.setInt(3, end);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public double avgRatingByStore(String storeName) {
        String sql = "SELECT NVL(ROUND(AVG(rating),1), 0) AS avg_rating FROM review WHERE store_name = ?";
        try (Connection conn = DBManager.conn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, storeName);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getDouble("avg_rating");
            }
        } catch (Exception e) { e.printStackTrace(); }
        return 0.0;
    }

    public int countByStore(String storeName) {
        String sql = "SELECT COUNT(*) FROM review WHERE store_name = ?";
        try (Connection conn = DBManager.conn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, storeName);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    /* ==================== U(UPDATE) ==================== */
    public int update(ReviewDTO dto) {
        String sql = "UPDATE review " +
                     "SET content = ?, rating = ?, review_img = ? " +
                     "WHERE review_id = ?";
        try (Connection conn = DBManager.conn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, dto.getContent());
            if (dto.getRating() == null) ps.setNull(2, Types.NUMERIC);
            else ps.setDouble(2, dto.getRating());
            ps.setString(3, dto.getReviewImg());
            ps.setInt(4, dto.getReviewId());
            return ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    /* ==================== D(DELETE) ==================== */
    public int delete(int reviewId) {
        String sql = "DELETE FROM review WHERE review_id = ?";
        try (Connection conn = DBManager.conn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, reviewId);
            return ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }
}
