package entity;

public class SystemClock {

    private double current;
    private double next;

    public SystemClock(double c, double n){
        this.current = c;
        this.next = n;
    }

    public double getCurrent() {
        return current;
    }

    public void setCurrent(double current) {
        this.current = current;
    }

    public double getNext() {
        return next;
    }

    public void setNext(double next) {
        this.next = next;
    }

    public void setEmpty() {
        this.current = 0.0;
        this.next = 0.0;
    }
}
