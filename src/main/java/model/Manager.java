package model;

public class Manager extends Staff {

    public Manager() {
        super();
    }

    public Manager(int id, String fullName, String phone, String email, String username, String password, String role, String position) {
        super(id, fullName, phone, email, username, password, role, position);
    }

    @Override
    public String toString() {
        return "Manager{" +
                "id=" + this.getId() +
                ", fullName='" + this.getFullName() + '\'' +
                ", position='" + this.getPosition() + '\'' +
                '}';
    }
}
