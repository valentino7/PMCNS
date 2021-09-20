package entity;

public class GlobalStatistics {

    private double complete_time_aws = 0;
    private double complete_time_serverfarm = 0;
    private double complete_time_system = 0;

    private double complete_time_task1 = 0;
    private double complete_time_task2 = 0;

    private int totalTask;

    public GlobalStatistics(double time_serverfarm, double time_aws) {
        this.complete_time_serverfarm = time_serverfarm;
        this.complete_time_aws = time_aws;
        this.complete_time_system = time_serverfarm + time_aws;
        this.totalTask = 0;
    }

    public double getComplete_time_task1() {
        return complete_time_task1;
    }

    public void setComplete_time_task1(double complete_time_task1) {
        this.complete_time_task1 = complete_time_task1;
    }

    public double getComplete_time_task2() {
        return complete_time_task2;
    }

    public void setComplete_time_task2(double complete_time_task2) {
        this.complete_time_task2 = complete_time_task2;
    }

    public double getComplete_time_system() {
        return complete_time_system;
    }

    public void setComplete_time_system(double complete_time_system) { this.complete_time_system = complete_time_system;  }

    public double getComplete_time_serverfarm() {
        return complete_time_serverfarm;
    }

    public void setComplete_time_serverfarm(double complete_time_serverfarm) { this.complete_time_serverfarm = complete_time_serverfarm; }

    public double getComplete_time_aws() {
        return complete_time_aws;
    }

    public void setComplete_time_aws(double complete_time_aws) {
        this.complete_time_aws = complete_time_aws;
    }

    public int getTotalTask() {
        return totalTask;
    }

    public void setTotalTask(int totalTask) {
        this.totalTask = totalTask;
    }

    public void setEmpty() {

        this.complete_time_aws = 0.0;
        this.complete_time_serverfarm = 0.0;
        this.complete_time_system = 0.0;

        this.complete_time_task1 = 0.0;
        this.complete_time_task2 = 0.0;

        this.totalTask = 0;
    }
}
