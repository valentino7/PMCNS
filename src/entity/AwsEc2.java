package entity;

public class AwsEc2 {

    private double area_task1 = 0;
    private double area_task2 = 0;

    //numero di tasks contenuti attualmente nel awsec2
    private int working_task1 = 0;
    private int working_task2 = 0;

    //numero di tasks processati in totale dal awsec2 per tipo
    private int processed_task1 = 0;
    private int processed_task2 = 0;

    public double getArea_task1() { return area_task1; }

    public void setArea_task1(double area_task1) {
        this.area_task1 = area_task1;
    }

    public double getArea_task2() {
        return area_task2;
    }

    public void setArea_task2(double area_task2) {
        this.area_task2 = area_task2;
    }

    public int getWorking_task1() {
        return working_task1;
    }

    public void setWorking_task1(int working_task1) {
        this.working_task1 = working_task1;
    }

    public int getWorking_task2() {
        return working_task2;
    }

    public void setWorking_task2(int working_task2) {
        this.working_task2 = working_task2;
    }

    public int getProcessed_task1() { return processed_task1; }

    public void setProcessed_task1(int processed_task1) {
        this.processed_task1 = processed_task1;
    }

    public int getProcessed_task2() {
        return processed_task2;
    }

    public void setProcessed_task2(int processed_task2) {
        this.processed_task2 = processed_task2;
    }

    public void resetAwsec2() {
        this.area_task1 = 0.0;
        this.area_task2 = 0.0;

        this.processed_task1 = 0;
        this.processed_task2 = 0;
    }
}
