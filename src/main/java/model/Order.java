package model;

import java.util.ArrayList;
import java.util.List;
import java.io.Serializable;

public class Order implements Serializable {
    private int id;
    private Customer customer;
    private Table table;
    private List<Product> products; // Danh sách sản phẩm (Dish hoặc Combo)

    public Order(){
        this.products = new ArrayList<>();
    }

    public Order(Table table, Customer customer){
        this.table = table;
        this.customer = customer;
        this.products = new ArrayList<>();
    }

    public Order(int id, Table table, Customer customer){
        this.id = id;
        this.table = table;
        this.customer = customer;
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
