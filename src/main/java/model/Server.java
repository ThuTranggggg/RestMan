package model;

public class Server {
    private Staff staff;  // FK tới Staff

    public Server() {
    }

    public Server(Staff staff) {
        this.staff = staff;
    }

    public Staff getStaff() {
        return staff;
    }

    public void setStaff(Staff staff) {
        this.staff = staff;
    }

    @Override
    public String toString() {
        return "Server{" +
                "staff=" + staff +
                '}';
    }
}
