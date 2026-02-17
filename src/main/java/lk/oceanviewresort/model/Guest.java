package lk.oceanviewresort.model;

public class Guest {
    private int guestId;
    private String fullName;
    private String address;
    private String mobile;
    private String nicPassport;
    private String email;

    public int getGuestId() { return guestId; }
    public void setGuestId(int guestId) { this.guestId = guestId; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getMobile() { return mobile; }
    public void setMobile(String mobile) { this.mobile = mobile; }

    public String getNicPassport() { return nicPassport; }
    public void setNicPassport(String nicPassport) { this.nicPassport = nicPassport; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
}
