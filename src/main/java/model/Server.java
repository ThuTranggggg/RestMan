package model;

public class Server extends Staff {

    public Server() {
        super();
    }

    public Server(User user, String position) {
        super(user, position);
    }

    @Override
    public String toString() {
        return "Server{" +
                "user=" + this.getUser() +
                ", position='" + this.getPosition() + '\'' +
                '}';
    }
}
