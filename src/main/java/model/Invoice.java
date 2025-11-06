package model;

import java.time.LocalDateTime;

public class Invoice extends Order {
    private int invoiceId;  // Invoice ID từ tblInvoice
    private float total;
    private Server server;  // FK tới Server (nhân viên phục vụ)
    private int bonusPoint;
    private LocalDateTime datetime;  // Thời gian tạo hóa đơn (khi nhân viên xác nhận)

    public Invoice() {
        super();
    }

    public Invoice(Table table, Customer customer, float total, Server server, int bonusPoint) {
        super(table, customer);
        this.total = total;
        this.server = server;
        this.bonusPoint = bonusPoint;
        this.datetime = LocalDateTime.now();
    }

    public Invoice(int id, Table table, Customer customer, float total, Server server, int bonusPoint) {
        super(id, table, customer);
        this.total = total;
        this.server = server;
        this.bonusPoint = bonusPoint;
        this.datetime = LocalDateTime.now();
    }

    public Invoice(int id, Table table, Customer customer, float total, Server server, int bonusPoint, LocalDateTime datetime) {
        super(id, table, customer);
        this.total = total;
        this.server = server;
        this.bonusPoint = bonusPoint;
        this.datetime = datetime;
    }

    public int getInvoiceId() {
        return invoiceId;
    }

    public void setInvoiceId(int invoiceId) {
        this.invoiceId = invoiceId;
    }

    public float getTotal() {
        return total;
    }

    public void setTotal(float total) {
        this.total = total;
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

    @Override
    public String toString() {
        return "Invoice{" +
                "id=" + this.getId() +
                ", customer=" + this.getCustomer() +
                ", table=" + this.getTable() +
                ", datetime=" + datetime +
                ", total=" + total +
                ", bonusPoint=" + bonusPoint +
                ", server=" + server +
                '}';
    }
}
