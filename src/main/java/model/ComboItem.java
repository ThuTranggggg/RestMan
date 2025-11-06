package model;

public class ComboItem {
    private int id;
    private int quantity;
    private Product dish;  // FK tới Product (loại Dish)
    private Product combo;  // FK tới Product (loại Combo)

    public ComboItem() {
    }

    public ComboItem(int quantity, Product dish, Product combo) {
        this.quantity = quantity;
        this.dish = dish;
        this.combo = combo;
    }

    public ComboItem(int id, int quantity, Product dish, Product combo) {
        this.id = id;
        this.quantity = quantity;
        this.dish = dish;
        this.combo = combo;
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

    public Product getDish() {
        return dish;
    }

    public void setDish(Product dish) {
        this.dish = dish;
    }

    public Product getCombo() {
        return combo;
    }

    public void setCombo(Product combo) {
        this.combo = combo;
    }

    @Override
    public String toString() {
        return "ComboItem{" +
                "id=" + id +
                ", quantity=" + quantity +
                ", dish=" + dish +
                ", combo=" + combo +
                '}';
    }
}
