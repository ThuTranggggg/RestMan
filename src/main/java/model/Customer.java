package model;

public class Customer extends User {
    private Membercard membercard;

    public Customer(){
        super();
    }

    public Customer(Membercard membercard){
        this.membercard = membercard;
    }

    public Customer(int id, String fullName, String phone, String email, 
                   String username, String password, String role, 
                   Membercard membercard){
        super(id, fullName, phone, email, username, password, role);
        this.membercard = membercard;
    }

    public Membercard getMembercard() {
        return membercard;
    }

    public void setMembercard(Membercard membercard) {
        this.membercard = membercard;
    }

    @Override
    public String toString() {
        return "Customer{" +
                "id=" + this.getId() +
                ", fullName='" + this.getFullName() + '\'' +
                ", phone='" + this.getPhone() + '\'' +
                ", email='" + this.getEmail() + '\'' +
                ", username='" + this.getUsername() + '\'' +
                ", membercard=" + membercard +
                '}';
    }
}
