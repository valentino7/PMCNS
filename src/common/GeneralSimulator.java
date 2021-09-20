package common;

import static common.Config.*;

import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.util.ArrayList;
import java.util.Locale;

import entity.AwsEc2;
import entity.EventState;
import entity.GlobalStatistics;
import entity.ServerFarm;
import entity.SystemClock;


public abstract class GeneralSimulator {

    public double exponential(double m, Rngs r) {
        return (-m * Math.log(1.0 - r.random()));
    }
    public double getArrival(double lambda, Rngs r) {
        r.selectStream(0);
        return exponential(1.0 / lambda, r);
    }

    public double hyperExponential(double mu, Rngs r) {
        double p = 0.2;
        double m1 = 2 * p * mu;
        double m2 = 2 * (1 - p) * mu;
        r.selectStream(3);
        double random = r.random();
        r.selectStream(4);
        if (random < p) {
            return exponential(1 / m1, r);
        } else {
            return exponential(1 / m2, r);
        }
    }

    public int getTaskType(Rngs r) {
        double p1 = lambda1 / lambda;
        r.selectStream(5);
        double random = r.random();
        if (random <= p1) {
            //è stato generato un task1
            return 1;
        } else
            //è stato generato un task2
            return 2;
    }

    public double getServiceServerFarm(double mu, Rngs r) {
        return (hyperExponential(mu, r));
    }

    public double getServiceAwsEc2(double mu, Rngs r) {
        r.selectStream(1);
        return (exponential(1 / mu, r));
    }

    public int nextEvent(ArrayList<EventState> list_events) {
        int min_event;
        int i = 0;

        while (list_events.get(i).getType() == 0)
            i++;
        min_event = i;
        while (i < list_events.size() - 1) {
            i++;
            if ((list_events.get(i).getType() > 0) &&
                    (list_events.get(i).getTemp() < list_events.get(min_event).getTemp()))
                min_event = i;
        }
        return (min_event);
    }

    public boolean check_system_servers(ArrayList<EventState> system_events) {

        for (EventState e : system_events) {
            if (e.getType() != 0) {
                return false;
            }
        }
        return true;
    }

    public int findOneIstance(ArrayList<EventState> system_events) {

        // se non ci sono serventi liberi nel awsec2, ne creo uno nuovo
        int i = SERVERS + 1;
        if (system_events.size() == SERVERS) {
            system_events.add(new EventState());
            return i;

        } else {
            for (; i < system_events.size(); i++) {
                if (system_events.get(i).getType() == 0) {
                    return i;
                }
            }
            system_events.add(new EventState());
            return i;
        }
    }

    public int findOneServer(ArrayList<EventState> listNode) {

        int server;
        int i = 1;

        while (listNode.get(i).getType() == 1)          /* find the index of the first available */
            i++;                                        /* (idle) server                         */
        server = i;
        while (i < SERVERS) {                           /* now, check the others to find which   */
            i++;                                        /* has been idle longest                 */
            if ((listNode.get(i).getType() == 0) &&
                    (listNode.get(i).getTemp() < listNode.get(server).getTemp()))
                server = i;
        }
        return (server);
    }

    public void printTranResults(GlobalStatistics global_node, ServerFarm serverfarm, AwsEc2 awsEc2, SystemClock clock, double STOP){
        DecimalFormat f = new DecimalFormat("###0.000000");
        f.setGroupingUsed(false);
        f.setDecimalFormatSymbols(new DecimalFormatSymbols(Locale.ENGLISH));

        //stampo i risultati sul terminale
        System.out.println("\n\n------------------------Results obtained from this stop value: "+ STOP +" ------------------------\n");

        System.out.println("n1_serverfarm: "+serverfarm.getProcessed_task1()
                +"\t\tn2_serverfarm: "+serverfarm.getProcessed_task2()+"\n"
                +"n1_awsEc2: "+awsEc2.getProcessed_task1()
                +"\t\tn2_awsEc2 "+awsEc2.getProcessed_task2()+"\n");

        double lambdaToT = global_node.getTotalTask() / clock.getCurrent();
        double lambda1 = (serverfarm.getProcessed_task1() + awsEc2.getProcessed_task1()) / clock.getCurrent();
        double lambda2 = (serverfarm.getProcessed_task2() + awsEc2.getProcessed_task2()) / clock.getCurrent();

        double lambdaFarm = (serverfarm.getProcessed_task1() + serverfarm.getProcessed_task2()) / clock.getCurrent();
        double lambdaServerFarm_task1 = serverfarm.getProcessed_task1() / clock.getCurrent();
        double lambdaServerFarm_task2 = serverfarm.getProcessed_task2() / clock.getCurrent();

        double lambdaAWS = (awsEc2.getProcessed_task1() + awsEc2.getProcessed_task2()) / clock.getCurrent();
        double lambdaAWS_task1 = awsEc2.getProcessed_task1() / clock.getCurrent();
        double lambdaAWS_task2 = awsEc2.getProcessed_task2() / clock.getCurrent();

        double pq = lambdaAWS / lambdaToT;
        double pq_1 = lambdaAWS_task1 / lambda1;
        double pq_2 = lambdaAWS_task2 / lambda2;

        System.out.println("estimated lambda "+f.format(lambdaToT));
        System.out.println("estimated lambda task 1 "+f.format(lambda1));
        System.out.println("estimated lambda task 2 "+f.format(lambda2)+"\n");

        System.out.println("average tasks number in serverfarm "+f.format(global_node.getComplete_time_serverfarm()/clock.getCurrent()));
        System.out.println("average task1 number in serverfarm "+f.format(serverfarm.getArea_task1()/clock.getCurrent()));
        System.out.println("average task2 number in serverfarm "+f.format(serverfarm.getArea_task2()/clock.getCurrent())+"\n");

        System.out.println("average tasks number in aws awsec2 "+f.format(global_node.getComplete_time_aws()/clock.getCurrent()));
        System.out.println("average task1 number in aws awsec2 "+f.format(awsEc2.getArea_task1()/clock.getCurrent()));
        System.out.println("average task2 number in aws awsec2 "+f.format(awsEc2.getArea_task2()/clock.getCurrent())+"\n");

        System.out.println("average system tasks "+f.format(global_node.getComplete_time_system()/clock.getCurrent()));
        System.out.println("average system tasks1 "+f.format(global_node.getComplete_time_task1()/clock.getCurrent()));
        System.out.println("average system tasks2 "+f.format(global_node.getComplete_time_task2()/clock.getCurrent())+"\n");

        System.out.println("Serverfarm's throughput "+f.format(lambdaFarm));
        System.out.println("Serverfarm's task1 throughput "+f.format(lambdaServerFarm_task1 ));
        System.out.println("Serverfarm's task2 throughput "+f.format(lambdaServerFarm_task2 )+"\n");

        System.out.println("Aws Ec2 throughput "+f.format(lambdaAWS) );
        System.out.println("Aws Ec2 throughput task1 "+f.format(lambdaAWS_task1));
        System.out.println("Aws Ec2 throughput task2 "+f.format(lambdaAWS_task2)+"\n");

        System.out.println("System throughput " + global_node.getTotalTask() / clock.getCurrent() );
        System.out.println("System task1 throughput " + (serverfarm.getProcessed_task1() + awsEc2.getProcessed_task1()) / clock.getCurrent() );
        System.out.println("System task2 throughput " + (serverfarm.getProcessed_task2() + awsEc2.getProcessed_task2()) / clock.getCurrent() );

        System.out.println("pq "+f.format(pq) );
        System.out.println("pq_1 "+f.format(pq_1) );
        System.out.println("pq_2 "+f.format(pq_2)+ "\n" );

        double serverF = global_node.getComplete_time_serverfarm()/(serverfarm.getProcessed_task1()+serverfarm.getProcessed_task2());
        double awsCl = global_node.getComplete_time_aws()/(awsEc2.getProcessed_task1()+awsEc2.getProcessed_task2());

        System.out.println("Serverfarm response time "+f.format(serverF));
        System.out.println("Serverfarm task1 response time "+f.format(serverfarm.getArea_task1()/(serverfarm.getProcessed_task1() )));
        System.out.println("Serverfarm task2 response time "+f.format(serverfarm.getArea_task2()/(serverfarm.getProcessed_task2() ))+"\n");

        System.out.println("Aws Ec2 response time "+f.format(awsCl));
        System.out.println("Aws Ec2 task1 response time "+f.format(awsEc2.getArea_task1()/ (awsEc2.getProcessed_task1())));
        System.out.println("Aws Ec2 task2 response time "+f.format(awsEc2.getArea_task2()/ (awsEc2.getProcessed_task2()))+"\n");

        System.out.println("Average system response time "+f.format((1-pq)*serverF + pq*awsCl));
        System.out.println("Average task1 system response time "+f.format(
                (1-pq_1)*(global_node.getComplete_time_task1()/(serverfarm.getProcessed_task1()+serverfarm.getProcessed_task2()))  +
                pq_1*(global_node.getComplete_time_task1()/ (awsEc2.getProcessed_task1()+ awsEc2.getProcessed_task2()) ) ));

        System.out.println("Average task2 system response time "+f.format(
                (1-pq_2)*(global_node.getComplete_time_task2()/(serverfarm.getProcessed_task1()+serverfarm.getProcessed_task2() ))  +
                pq_2*(global_node.getComplete_time_task2()/ (awsEc2.getProcessed_task1()+ awsEc2.getProcessed_task2()) ) )+"\n");


        System.out.println("server"+"\t"+"utilization"+"\t"+"Task1Processed"+"\t"+"Task2Processed"+"\n");
        for(int s=1; s <=SERVERS;s++){
            System.out.print(s + "\t\t" +
                    f.format(serverfarm.getServers().get(s).getTotal_service() / clock.getCurrent()) + "\t\t" +
                    serverfarm.getServers().get(s).getProcessed_task1() + "\t\t" + serverfarm.getServers().get(s).getProcessed_task2() + "\n");
        }
        System.out.println("\n\n");
    }
}
