package model;

public class Manager extends Staff {

    public Manager() {
        super();
    }

    public Manager(User user, String position) {
        super(user, position);
    }

    @Override
    public String toString() {
        return "Manager{" +
                "user=" + this.getUser() +
                ", position='" + this.getPosition() + '\'' +
                '}';
    }
}
