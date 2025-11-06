package model;

import java.io.Serializable;

public class OrderDetail implements Serializable {
    private int id;
    private int quantity;
    private String status;  // PENDING, COMPLETED, etc.
    private Product product;  // FK tới Product (Dish hoặc Combo)
    private Order order;  // FK tới Order

    public OrderDetail() {
    }

    public OrderDetail(int quantity, String status, Product product, Order order) {
        this.quantity = quantity;
        this.status = status;
        this.product = product;
        this.order = order;
    }

    public OrderDetail(int id, int quantity, String status, Product product, Order order) {
        this.id = id;
        this.quantity = quantity;
        this.status = status;
        this.product = product;
        this.order = order;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    public Order getOrder() {
        return order;
    }

    public void setOrder(Order order) {
        this.order = order;
    }

    @Override
    public String toString() {
        return "OrderDetail{" +
                "id=" + id +
                ", quantity=" + quantity +
                ", status='" + status + '\'' +
                ", product=" + product +
                ", order=" + order +
                '}';
    }
}
