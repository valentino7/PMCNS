package statistics;

import java.util.ArrayList;

import entity.AwsEc2;
import entity.GlobalStatistics;
import entity.ServerFarm;
import entity.SystemClock;

public class Statistics {

    private ArrayList<ArrayList<Double>> estimateTempi;
    private ArrayList<ArrayList<Double>> estimateTask;
    private ArrayList<ArrayList<Double>> estimateThroughput;

    public Statistics(){
        this.estimateTempi = initArrayList();
        this.estimateTask = initArrayList();
        this.estimateThroughput = initArrayList();
    }

    private ArrayList<ArrayList<Double>> initArrayList() {
        ArrayList<ArrayList<Double>>array= new ArrayList<>();
        for (int i=0; i<9; i++){
            array.add(new ArrayList<>());
        }
        return array;
    }

    public ArrayList<ArrayList<Double>> getEstimateTempi() {
        return estimateTempi;
    }

    public void setEstimateTempi(ArrayList<ArrayList<Double>> estimateTempi) {
        this.estimateTempi = estimateTempi;
    }

    public ArrayList<ArrayList<Double>> getEstimateTask() {
        return estimateTask;
    }

    public void setEstimateTask(ArrayList<ArrayList<Double>> estimateTask) {
        this.estimateTask = estimateTask;
    }

    public ArrayList<ArrayList<Double>> getEstimateThroughput() {
        return estimateThroughput;
    }

    public void setEstimateThroughput(ArrayList<ArrayList<Double>> estimateThroughput) {
        this.estimateThroughput = estimateThroughput;
    }

    public void saveTempiValues(GlobalStatistics global_node, ServerFarm serverfarm, AwsEc2 istances) {

        this.estimateTempi.get(0).add(global_node.getComplete_time_serverfarm() / (serverfarm.getProcessed_task1() + serverfarm.getProcessed_task2()) );
        this.estimateTempi.get(1).add(serverfarm.getArea_task1() / serverfarm.getProcessed_task1());
        this.estimateTempi.get(2).add(serverfarm.getArea_task2() / serverfarm.getProcessed_task2());

        this.estimateTempi.get(3).add(global_node.getComplete_time_aws() / (istances.getProcessed_task1() + istances.getProcessed_task2()) );
        this.estimateTempi.get(4).add(istances.getArea_task1() / istances.getProcessed_task1());
        this.estimateTempi.get(5).add(istances.getArea_task2() / istances.getProcessed_task2());

        this.estimateTempi.get(6).add(global_node.getComplete_time_system() / global_node.getTotalTask());
        this.estimateTempi.get(7).add(global_node.getComplete_time_task1() / (serverfarm.getProcessed_task1() + istances.getProcessed_task1()));
        this.estimateTempi.get(8).add(global_node.getComplete_time_task2() / (serverfarm.getProcessed_task2() + istances.getProcessed_task2()));

    }

    public void saveTaskValues(GlobalStatistics global_node, ServerFarm serverfarm, AwsEc2 istances, SystemClock clock) {

        this.estimateTask.get(0).add( global_node.getComplete_time_serverfarm()/clock.getCurrent() );
        this.estimateTask.get(1).add( serverfarm.getArea_task1()/clock.getCurrent() );
        this.estimateTask.get(2).add( serverfarm.getArea_task2()/clock.getCurrent() );

        this.estimateTask.get(3).add( global_node.getComplete_time_aws()/clock.getCurrent() );
        this.estimateTask.get(4).add( istances.getArea_task1()/clock.getCurrent() );
        this.estimateTask.get(5).add( istances.getArea_task2()/clock.getCurrent() );

        this.estimateTask.get(6).add( global_node.getComplete_time_system()/clock.getCurrent() );
        this.estimateTask.get(7).add( global_node.getComplete_time_task1()/clock.getCurrent() );
        this.estimateTask.get(8).add( global_node.getComplete_time_task2()/clock.getCurrent() );

    }

    public void saveThroughput(GlobalStatistics global_node, ServerFarm serverfarm, AwsEc2 istances, SystemClock clock) {
        this.estimateThroughput.get(0).add( (serverfarm.getProcessed_task1() + serverfarm.getProcessed_task2()) / clock.getCurrent() );
        this.estimateThroughput.get(1).add( serverfarm.getProcessed_task1() / clock.getCurrent() );
        this.estimateThroughput.get(2).add( serverfarm.getProcessed_task2() / clock.getCurrent() );

        this.estimateThroughput.get(3).add( (istances.getProcessed_task1() + istances.getProcessed_task2()) / clock.getCurrent() );
        this.estimateThroughput.get(4).add( istances.getProcessed_task1() / clock.getCurrent() );
        this.estimateThroughput.get(5).add( istances.getProcessed_task2() / clock.getCurrent() );

        this.estimateThroughput.get(6).add( global_node.getTotalTask() / clock.getCurrent() );
        this.estimateThroughput.get(7).add( (serverfarm.getProcessed_task1() + istances.getProcessed_task1()) / clock.getCurrent() );
        this.estimateThroughput.get(8).add( (serverfarm.getProcessed_task2() + istances.getProcessed_task2()) / clock.getCurrent() );

    }
}
