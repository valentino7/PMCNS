package entity;

public class EventState {

    private double temp;
    private int type;

    public EventState(){}

    public EventState(double t, int x){
        this.temp = t;
        this.type = x;
    }

    public double getTemp() {
        return temp;
    }

    public void setTemp(double temp) {
        this.temp = temp;
    }

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

    @Override
    public String toString() {
        return "', type: '" + this.type ;
    }
}
