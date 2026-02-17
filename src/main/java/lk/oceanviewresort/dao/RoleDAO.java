package lk.oceanviewresort.dao;

import lk.oceanviewresort.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class RoleDAO {

    public List<String[]> listRoles() {
        List<String[]> list = new ArrayList<>();
        String sql = "SELECT role_id, role_name FROM roles ORDER BY role_name";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(new String[] { String.valueOf(rs.getInt(1)), rs.getString(2) });
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}
