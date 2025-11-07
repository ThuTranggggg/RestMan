package model;

public class StockClerk extends Staff {

    public StockClerk() {
        super();
    }

    public StockClerk(int id, String fullName, String phone, String email, String username, String password, String role, String position) {
        super(id, fullName, phone, email, username, password, role, position);
    }

    @Override
    public String toString() {
        return "StockClerk{" +
                "id=" + this.getId() +
                ", fullName='" + this.getFullName() + '\'' +
                ", position='" + this.getPosition() + '\'' +
                '}';
    }
}
