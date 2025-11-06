package model;

public class Staff {
    private User user;  // FK tới User
    private String position;

    public Staff() {
    }

    public Staff(User user, String position) {
        this.user = user;
        this.position = position;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
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
                "user=" + user +
                ", position='" + position + '\'' +
                '}';
    }
}
