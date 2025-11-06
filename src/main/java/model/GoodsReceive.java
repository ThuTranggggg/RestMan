package model;

import java.time.LocalDate;

public class GoodsReceive {
    private int id;
    private LocalDate date;
    private int quantity;
    private double price;
    private StockClerk stockClerk;  // FK tới StockClerk
    private Supplier supplier;  // FK tới Supplier
    private Ingredient ingredient;  // FK tới Ingredient

    public GoodsReceive() {
    }

    public GoodsReceive(LocalDate date, int quantity, double price, StockClerk stockClerk, 
                        Supplier supplier, Ingredient ingredient) {
        this.date = date;
        this.quantity = quantity;
        this.price = price;
        this.stockClerk = stockClerk;
        this.supplier = supplier;
        this.ingredient = ingredient;
    }

    public GoodsReceive(int id, LocalDate date, int quantity, double price, StockClerk stockClerk,
                        Supplier supplier, Ingredient ingredient) {
        this.id = id;
        this.date = date;
        this.quantity = quantity;
        this.price = price;
        this.stockClerk = stockClerk;
        this.supplier = supplier;
        this.ingredient = ingredient;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public LocalDate getDate() {
        return date;
    }

    public void setDate(LocalDate date) {
        this.date = date;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public StockClerk getStockClerk() {
        return stockClerk;
    }

    public void setStockClerk(StockClerk stockClerk) {
        this.stockClerk = stockClerk;
    }

    public Supplier getSupplier() {
        return supplier;
    }

    public void setSupplier(Supplier supplier) {
        this.supplier = supplier;
    }

    public Ingredient getIngredient() {
        return ingredient;
    }

    public void setIngredient(Ingredient ingredient) {
        this.ingredient = ingredient;
    }

    @Override
    public String toString() {
        return "GoodsReceive{" +
                "id=" + id +
                ", date=" + date +
                ", quantity=" + quantity +
                ", price=" + price +
                ", stockClerk=" + stockClerk +
                ", supplier=" + supplier +
                ", ingredient=" + ingredient +
                '}';
    }
}
