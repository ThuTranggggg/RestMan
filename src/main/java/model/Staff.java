package model;

public class Staff extends User {
    private String position;

    public Staff() {
        super();
    }

    public Staff(int id, String fullName, String phone, String email, String username, String password, String role, String position) {
        super(id, fullName, phone, email, username, password, role);
        this.position = position;
    }

    public String getPosition() {
        return position;
    }

    public void setPosition(String position) {
        this.position = position;
    }

    @Override
    public String toString() {
        return "Staff{" +
                "id=" + this.getId() +
                ", fullName='" + this.getFullName() + '\'' +
                ", phone='" + this.getPhone() + '\'' +
                ", email='" + this.getEmail() + '\'' +
                ", username='" + this.getUsername() + '\'' +
                ", password='" + this.getPassword() + '\'' +
                ", role='" + this.getRole() + '\'' +
                ", position='" + position + '\'' +
                '}';
    }
}
