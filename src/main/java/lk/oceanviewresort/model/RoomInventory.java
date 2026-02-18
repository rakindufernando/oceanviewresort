package lk.oceanviewresort.model;

public class RoomInventory {
    private String roomType;
    private int totalRooms;
    private double ratePerNight;
    private boolean active;

    public String getRoomType() { return roomType; }
    public void setRoomType(String roomType) { this.roomType = roomType; }

    public int getTotalRooms() { return totalRooms; }
    public void setTotalRooms(int totalRooms) { this.totalRooms = totalRooms; }

    public double getRatePerNight() { return ratePerNight; }
    public void setRatePerNight(double ratePerNight) { this.ratePerNight = ratePerNight; }

    // not used in older pages, but useful for manager CRUD page
    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }
}
