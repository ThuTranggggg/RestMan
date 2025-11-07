package model;

import java.time.LocalDateTime;

public class Invoice extends Order {
    private int orderId;  // ID của Order gốc
    private Server server;
    private int bonusPoint;
    private LocalDateTime datetime;

    public Invoice() {
        super();
    }

    public Invoice(Table table, Customer customer, Server server, int bonusPoint) {
        super(table, customer);
        this.server = server;
        this.bonusPoint = bonusPoint;
        this.datetime = LocalDateTime.now();
    }

    public Invoice(int id, Table table, Customer customer, Server server, int bonusPoint) {
        super(id, table, customer);
        this.server = server;
        this.bonusPoint = bonusPoint;
        this.datetime = LocalDateTime.now();
    }

    public Invoice(int id, Table table, Customer customer, Server server, int bonusPoint, LocalDateTime datetime) {
        super(id, table, customer);
        this.server = server;
        this.bonusPoint = bonusPoint;
        this.datetime = datetime;
    }

    public Server getServer() {
        return server;
    }

    public void setServer(Server server) {
        this.server = server;
    }

    public int getBonusPoint() {
        return bonusPoint;
    }

    public void setBonusPoint(int bonusPoint) {
        this.bonusPoint = bonusPoint;
    }

    public LocalDateTime getDatetime() {
        return datetime;
    }

    public void setDatetime(LocalDateTime datetime) {
        this.datetime = datetime;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    @Override
    public String toString() {
        return "Invoice{" +
                "id=" + this.getId() +
                ", customer=" + this.getCustomer() +
                ", table=" + this.getTable() +
                ", datetime=" + datetime +
                ", bonusPoint=" + bonusPoint +
                ", server=" + server +
                '}';
    }
}
