package model;

public class Product {
    private int id;
    private String name;
    private String description;
    private String imageUrl;
    private float price;
    private int sold;
    private String type; // "DISH" hoặc "COMBO"

    public Product() {
    }

    public Product(String name, String description, float price, String type) {
        this.name = name;
        this.description = description;
        this.price = price;
        this.type = type;
        this.sold = 0;  // Default value
    }

    public Product(String name, String description, float price, int sold, String type) {
        this.name = name;
        this.description = description;
        this.price = price;
        this.sold = sold;
        this.type = type;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public float getPrice() {
        return price;
    }

    public void setPrice(float price) {
        this.price = price;
    }

    public int getSold() {
        return sold;
    }

    public void setSold(int sold) {
        this.sold = sold;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }
}
