package model;

import java.time.LocalDateTime;

public class Membercard {
    private int id;
    private int point;
    private LocalDateTime issueDate;

    public Membercard(){
    }

    public Membercard(int id, int point, LocalDateTime issueDate){
        this.id = id;
        this.point = point;
        this.issueDate = issueDate;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getPoint() {
        return point;
    }

    public void setPoint(int point) {
        this.point = point;
    }

    public LocalDateTime getIssueDate() {
        return issueDate;
    }

    public void setIssueDate(LocalDateTime issueDate) {
        this.issueDate = issueDate;
    }
}
