package model;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.io.Serializable;

public class Order implements Serializable {
    private int id;
    private Customer customer;
    private Table table;
    private LocalDateTime created_at;
    private List<Product> products; // Danh sách sản phẩm (Dish hoặc Combo)

    public Order(){
        this.products = new ArrayList<>();
    }

    public Order(Table table, Customer customer, LocalDateTime created_at){
        this.table = table;
        this.customer = customer;
        this.created_at = created_at;
        this.products = new ArrayList<>();
    }

    public Order(int id, Table table, Customer customer, LocalDateTime created_at){
        this.id = id;
        this.table = table;
        this.customer = customer;
        this.created_at = created_at;
        this.products = new ArrayList<>();
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Customer getCustomer() {
        return customer;
    }

    public void setCustomer(Customer customer) {
        this.customer = customer;
    }

    public Table getTable() {
        return table;
    }

    public void setTable(Table table) {
        this.table = table;
    }

    public LocalDateTime getCreated_at() {
        return created_at;
    }

    public void setCreated_at(LocalDateTime created_at) {
        this.created_at = created_at;
    }

    public List<Product> getProducts() {
        return products;
    }

    public void setProducts(List<Product> products) {
        this.products = products;
    }

    public void addProduct(Product product) {
        this.products.add(product);
    }

    public void removeProduct(Product product) {
        this.products.remove(product);
    }
}
