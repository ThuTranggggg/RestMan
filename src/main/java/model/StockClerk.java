package model;

public class StockClerk {
    private Staff staff;  // FK tới Staff

    public StockClerk() {
    }

    public StockClerk(Staff staff) {
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
        return "StockClerk{" +
                "staff=" + staff +
                '}';
    }
}
