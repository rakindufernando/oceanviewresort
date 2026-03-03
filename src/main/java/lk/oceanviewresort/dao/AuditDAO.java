package lk.oceanviewresort.dao;

import lk.oceanviewresort.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

public class AuditDAO {

    public void log(int userId, String action, String details) {
        String entityType = guessEntityType(action);
        Integer entityId = guessEntityId(details);
        log(userId, action, entityType, entityId, details);
    }

    public void log(int userId, String action, String entityType, Integer entityId, String details) {

        String type = entityType;
        if (type == null || type.trim().isEmpty()) type = "SYSTEM";

        int id = 0;
        if (entityId != null && entityId > 0) id = entityId;

        String det = details;
        if (det == null) det = "";

        String sql = "INSERT INTO audit_logs(user_id, action, entity_type, entity_id, details, created_at) VALUES(?,?,?,?,?, NOW())";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setString(2, safe(action));
            ps.setString(3, type);
            ps.setInt(4, id);
            ps.setString(5, det);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<String[]> listLogs(Integer userId, Date fromDate, Date toDate, String keyword, int limit) {

        List<String[]> list = new ArrayList<>();

        int rows = limit;
        if (rows <= 0) rows = 200;
        if (rows > 500) rows = 500;

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT a.created_at, u.username, u.full_name, r.role_name, ");
        sql.append("a.action, a.entity_type, a.entity_id, a.details ");
        sql.append("FROM audit_logs a ");
        sql.append("JOIN users u ON a.user_id = u.user_id ");
        sql.append("JOIN roles r ON u.role_id = r.role_id ");
        sql.append("WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        if (userId != null) {
            sql.append("AND a.user_id = ? ");
            params.add(userId);
        }

        if (fromDate != null) {
            sql.append("AND a.created_at >= ? ");
            params.add(startOfDay(fromDate));
        }

        if (toDate != null) {
            sql.append("AND a.created_at < ? ");
            params.add(nextDayStart(toDate));
        }

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (a.action LIKE ? OR a.details LIKE ? OR a.entity_type LIKE ?) ");
            String k = "%" + keyword.trim() + "%";
            params.add(k);
            params.add(k);
            params.add(k);
        }

        sql.append("ORDER BY a.log_id DESC ");
        sql.append("LIMIT ? ");
        params.add(rows);

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH mm");

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                Object p = params.get(i);
                int idx = i + 1;

                if (p instanceof Timestamp) ps.setTimestamp(idx, (Timestamp) p);
                else ps.setObject(idx, p);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {

                    Timestamp ts = rs.getTimestamp(1);
                    String t = "";
                    if (ts != null) t = sdf.format(ts);

                    String entityIdStr = "";
                    Object obj = rs.getObject(7);
                    if (obj != null) entityIdStr = String.valueOf(obj);

                    list.add(new String[] {
                            safe(t),
                            safe(rs.getString(2)),
                            safe(rs.getString(3)),
                            safe(rs.getString(4)),
                            safe(rs.getString(5)),
                            safe(rs.getString(6)),
                            safe(entityIdStr),
                            safe(rs.getString(8))
                    });
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    private Timestamp startOfDay(Date d) {
        Calendar c = Calendar.getInstance();
        c.setTime(d);
        c.set(Calendar.HOUR_OF_DAY, 0);
        c.set(Calendar.MINUTE, 0);
        c.set(Calendar.SECOND, 0);
        c.set(Calendar.MILLISECOND, 0);
        return new Timestamp(c.getTimeInMillis());
    }

    private Timestamp nextDayStart(Date d) {
        Calendar c = Calendar.getInstance();
        c.setTime(d);
        c.set(Calendar.HOUR_OF_DAY, 0);
        c.set(Calendar.MINUTE, 0);
        c.set(Calendar.SECOND, 0);
        c.set(Calendar.MILLISECOND, 0);
        c.add(Calendar.DATE, 1);
        return new Timestamp(c.getTimeInMillis());
    }

    private String guessEntityType(String action) {
        if (action == null) return "SYSTEM";
        String a = action.toUpperCase();

        if (a.contains("GUEST")) return "GUEST";
        if (a.contains("RESERVATION")) return "RESERVATION";
        if (a.contains("PAYMENT") || a.contains("BILL")) return "PAYMENT";
        if (a.contains("USER") || a.contains("PASSWORD")) return "USER";
        if (a.contains("ROOM")) return "ROOM";
        if (a.contains("CHECKOUT")) return "RESERVATION";

        return "SYSTEM";
    }

    private Integer guessEntityId(String details) {
        if (details == null) return null;

        String[] keys = new String[] {
                "GuestId=",
                "ReservationId=",
                "ResId=",
                "UserId="
        };

        for (int i = 0; i < keys.length; i++) {
            String k = keys[i];
            int p = details.indexOf(k);
            if (p >= 0) {
                int start = p + k.length();
                String num = readDigits(details, start);
                if (!num.isEmpty()) {
                    try {
                        return Integer.parseInt(num);
                    } catch (Exception e) {
                        return null;
                    }
                }
            }
        }

        return null;
    }

    private String readDigits(String s, int start) {
        StringBuilder b = new StringBuilder();
        for (int i = start; i < s.length(); i++) {
            char ch = s.charAt(i);
            if (ch >= '0' && ch <= '9') b.append(ch);
            else break;
        }
        return b.toString();
    }

    private String safe(String s) {
        if (s == null) return "";
        return s;
    }
}