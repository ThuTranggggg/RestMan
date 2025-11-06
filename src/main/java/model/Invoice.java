package model;

import java.time.LocalDateTime;
import java.io.Serializable;

public class Invoice implements Serializable {
    private int id;
    private LocalDateTime datetime;
    private int bonusPoint;
    private Order order;  // FK tới Order
    private Server server;  // FK tới Server (người lập hoá đơn)
    private Staff staff;  // FK tới Staff (nhân viên bán hàng)

    public Invoice() {
    }

    public Invoice(LocalDateTime datetime, int bonusPoint, Order order, Server server) {
        this.datetime = datetime;
        this.bonusPoint = bonusPoint;
        this.order = order;
        this.server = server;
    }

    public Invoice(int id, LocalDateTime datetime, int bonusPoint, Order order, Server server) {
        this.id = id;
        this.datetime = datetime;
        this.bonusPoint = bonusPoint;
        this.order = order;
        this.server = server;
    }

    public Invoice(int id, LocalDateTime datetime, int bonusPoint, Order order, Staff staff) {
        this.id = id;
        this.datetime = datetime;
        this.bonusPoint = bonusPoint;
        this.order = order;
        this.staff = staff;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public LocalDateTime getDatetime() {
        return datetime;
    }

    public void setDatetime(LocalDateTime datetime) {
        this.datetime = datetime;
    }

    public int getBonusPoint() {
        return bonusPoint;
    }

    public void setBonusPoint(int bonusPoint) {
        this.bonusPoint = bonusPoint;
    }

    public Order getOrder() {
        return order;
    }

    public void setOrder(Order order) {
        this.order = order;
    }

    public Server getServer() {
        return server;
    }

    public void setServer(Server server) {
        this.server = server;
    }

    public Staff getStaff() {
        return staff;
    }

    public void setStaff(Staff staff) {
        this.staff = staff;
    }

    @Override
    public String toString() {
        return "Invoice{" +
                "id=" + id +
                ", datetime=" + datetime +
                ", bonusPoint=" + bonusPoint +
                ", order=" + order +
                ", server=" + server +
                ", staff=" + staff +
                '}';
    }
}
