package model;

public class Customer extends User{
    private User user;
    private Membercard membercard;

    public Customer(){
    }

    public Customer(User user, Membercard membercard){
        this.user = user;
        this.membercard = membercard;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Membercard getMembercard() {
        return membercard;
    }

    public void setMembercard(Membercard membercard) {
        this.membercard = membercard;
    }
}
