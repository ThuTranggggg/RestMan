package model;

import java.io.Serializable;

public class Order implements Serializable {
    private int id;
    private Customer customer;
    private Table table;

    public Order(){
    }

    public Order(Table table, Customer customer){
        this.table = table;
        this.customer = customer;
    }

    public Order(int id, Table table, Customer customer){
        this.id = id;
        this.table = table;
        this.customer = customer;
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
}
