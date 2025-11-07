package model;

public class Server extends Staff {

    public Server() {
        super();
    }

    public Server(int id, String fullName, String phone, String email, String username, String password, String role, String position) {
        super(id, fullName, phone, email, username, password, role, position);
    }

    @Override
    public String toString() {
        return "Server{" +
                "id=" + this.getId() +
                ", fullName='" + this.getFullName() + '\'' +
                ", position='" + this.getPosition() + '\'' +
                '}';
    }
}
