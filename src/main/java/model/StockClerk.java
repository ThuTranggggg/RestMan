package model;

public class StockClerk extends Staff {

    public StockClerk() {
        super();
    }

    public StockClerk(User user, String position) {
        super(user, position);
    }

    @Override
    public String toString() {
        return "StockClerk{" +
                "user=" + this.getUser() +
                ", position='" + this.getPosition() + '\'' +
                '}';
    }
}
