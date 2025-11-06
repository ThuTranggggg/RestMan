package model;

public class Manager {
    private Staff staff;  // FK tới Staff

    public Manager() {
    }

    public Manager(Staff staff) {
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
        return "Manager{" +
                "staff=" + staff +
                '}';
    }
}
