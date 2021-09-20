package trans;

import static common.Config.*;

import java.io.PrintWriter;
import java.util.ArrayList;

import common.GeneralSimulator;
import common.Rngs;
import common.Util;
import entity.*;
import statistics.Statistics;

public class Transient_simulator_2 extends GeneralSimulator {

    private ArrayList<EventState> system_events;
    private SystemClock clock;
    private GlobalStatistics global_statistics;
    private ServerFarm serverfarm;
    private AwsEc2 awsEc2;

    //init delle strutture caratteristiche del simulatore
    Transient_simulator_2() {

        this.system_events = new ArrayList<>();
        for (int i = 0; i < SERVERS + 1; i++) {
            system_events.add(new EventState(START, 0));
        }
        this.clock = new SystemClock(START, START);
        this.global_statistics = new GlobalStatistics(START, START);

        this.serverfarm = new ServerFarm();
        this.serverfarm.setServers(new ArrayList<>());
        for (int i = 0; i < SERVERS + 1; i++) {
            this.serverfarm.getServers().add(new Server());
        }
        this.awsEc2 = new AwsEc2();
    }

    public void RunSimulation(Rngs r, double STOP, String selected_seed, Statistics statistics){


        PrintWriter instant_writer = Util.createFiles("Matlab\\transient\\","Alg2-"+ selected_seed + ".csv");
        Util.print_on_file(instant_writer, new String[]{"current", "serverfarm", "awsEc2", "system"});

        // primo arrivo
        system_events.get(0).setTemp(getArrival(lambda, r) + clock.getCurrent());
        system_events.get(0).setType(getTaskType(r));          // devo decidere se il primo arrivo è di tipo A o B

        while (system_events.get(0).getType() != 0) {

            if (system_events.get(0).getTemp() > STOP) {
                if (check_system_servers(this.system_events)) {
                    break;
                }
            }

            //selezione del prossimo evento in base alla next-event simulation e avanzamento del clock
            int e = nextEvent(system_events);
            clock.setNext(system_events.get(e).getTemp());
            double instant = clock.getNext() - clock.getCurrent();

            // calcola il tempo istantaneo di attraversamento del serverfarm
            global_statistics.setComplete_time_serverfarm(global_statistics.getComplete_time_serverfarm() + instant * (serverfarm.getWorking_task1() + serverfarm.getWorking_task2()));
            // calcola il tempo istantaneo di attraversamento del awsec2
            global_statistics.setComplete_time_aws(global_statistics.getComplete_time_aws() + instant * (awsEc2.getWorking_task1() + awsEc2.getWorking_task2()));
            // calcola il tempo istantaneo di attraversamento del sistema
            global_statistics.setComplete_time_system(global_statistics.getComplete_time_system() + instant *
                    (serverfarm.getWorking_task1() + serverfarm.getWorking_task2() + awsEc2.getWorking_task1() + awsEc2.getWorking_task2()));

            //calcola il tempo di attraversamento nel sistema per un task di tipo 1
            global_statistics.setComplete_time_task1(global_statistics.getComplete_time_task1() + instant * (serverfarm.getWorking_task1() + awsEc2.getWorking_task1()));
            //calcola il tempo di attraversamento nel sistema per un task di tipo 2
            global_statistics.setComplete_time_task2(global_statistics.getComplete_time_task2() + instant * (serverfarm.getWorking_task2() + awsEc2.getWorking_task2()));

            //calcola il tempo di attraversamento nel serverfarm per un task di tipo 1
            serverfarm.setArea_task1(serverfarm.getArea_task1() + instant * serverfarm.getWorking_task1());
            //calcola il tempo di attraversamento nel serverfarm per un task di tipo 2
            serverfarm.setArea_task2(serverfarm.getArea_task2() + instant * serverfarm.getWorking_task2());

            //calcola il tempo di attraversamento nel awsec2 per un task di tipo 1
            awsEc2.setArea_task1(awsEc2.getArea_task1() + instant * awsEc2.getWorking_task1());
            //calcola il tempo di attraversamento nel awsec2 per un task di tipo 2
            awsEc2.setArea_task2(awsEc2.getArea_task2() + instant * awsEc2.getWorking_task2());

            global_statistics.setTotalTask( serverfarm.getProcessed_task1() + serverfarm.getProcessed_task2() + awsEc2.getProcessed_task1() + awsEc2.getProcessed_task2() );

            Util.print_on_file(instant_writer, new String[]{String.valueOf(clock.getCurrent()),
                    String.valueOf(global_statistics.getComplete_time_serverfarm() / ( serverfarm.getProcessed_task1() + serverfarm.getProcessed_task2() ) ),
                    String.valueOf(global_statistics.getComplete_time_aws()/ ( awsEc2.getProcessed_task1() + awsEc2.getProcessed_task2() )  ),
                    String.valueOf(global_statistics.getComplete_time_system() / global_statistics.getTotalTask() ) });

            clock.setCurrent(clock.getNext());

            if (e == 0) { // processo un arrivo

                int temp_task = serverfarm.getWorking_task1() + serverfarm.getWorking_task2();
                if ( (temp_task < SERVERS) && (( temp_task < LIMIT ) || (system_events.get(e).getType() == 1) )) {

                    //trovo il server libero da più tempo inattivo
                    int serverfarm_server_selected = findOneServer(system_events);

                    double service = 0;
                    if (system_events.get(e).getType() == 1) {
                        serverfarm.setWorking_task1(serverfarm.getWorking_task1() + 1);
                        service = getServiceServerFarm(mu1_serverfarm, r);

                    } else {
                        serverfarm.setWorking_task2(serverfarm.getWorking_task2() + 1);
                        service = getServiceServerFarm(mu2_serverfarm, r);
                    }


                    double temp = serverfarm.getServers().get(serverfarm_server_selected).getTotal_service() + service;
                    serverfarm.getServers().get(serverfarm_server_selected).setTotal_service(temp);

                    // aggiorno il server i-esimo ( indice ) con i nuovi valori di tempo e type
                    system_events.get(serverfarm_server_selected).setTemp(clock.getCurrent() + service);
                    system_events.get(serverfarm_server_selected).setType(system_events.get(e).getType());


                } else {
                    int awsec2_server_selected = findOneIstance(system_events);
                    int typeawsec2 = system_events.get(e).getType();


                    double service = 0;
                    if (system_events.get(e).getType() == 1) {
                        awsEc2.setWorking_task1(awsEc2.getWorking_task1() + 1);

                        // genero un servizio secondo la distribuzione del tempo di servizio per  task A
                        service = this.getServiceAwsEc2(mu1_awsec2, r);
                    } else {
                        awsEc2.setWorking_task2(awsEc2.getWorking_task2() + 1);

                        // genero un servizio secondo la distribuzione del tempo di servizio per  task B
                        service = this.getServiceAwsEc2(mu2_awsec2, r);
                    }

                    system_events.get(awsec2_server_selected).setTemp(clock.getCurrent() + service);
                    system_events.get(awsec2_server_selected).setType(typeawsec2);
                }
                if (system_events.get(0).getTemp() <= STOP) {
                    system_events.get(0).setTemp(getArrival(lambda, r) + clock.getCurrent());
                    system_events.get(0).setType(getTaskType(r));
                }
                else {
                    system_events.get(0).setType(0);
                }
            } else { //partenze

                if (e <= SERVERS) { // processo una partenza serverfarm

                    if (system_events.get(e).getType() == 1) {
                        serverfarm.setWorking_task1(serverfarm.getWorking_task1() - 1);
                        serverfarm.setProcessed_task1(serverfarm.getProcessed_task1() + 1);

                        serverfarm.getServers().get(e).setProcessed_task1(serverfarm.getServers().get(e).getProcessed_task1() + 1 );


                    } else if (system_events.get(e).getType() == 2) {
                        serverfarm.setWorking_task2(serverfarm.getWorking_task2() - 1);
                        serverfarm.setProcessed_task2(serverfarm.getProcessed_task2() + 1);

                        serverfarm.getServers().get(e).setProcessed_task2(serverfarm.getServers().get(e).getProcessed_task2() + 1 );
                    }

                    system_events.get(e).setType(0);

                } else { //processo una partenza del awsec2

                    if (system_events.get(e).getType() == 1) {
                        awsEc2.setWorking_task1(awsEc2.getWorking_task1() - 1);
                        awsEc2.setProcessed_task1(awsEc2.getProcessed_task1() + 1);

                    } else if (system_events.get(e).getType() == 2) {
                        awsEc2.setWorking_task2(awsEc2.getWorking_task2() - 1);
                        awsEc2.setProcessed_task2(awsEc2.getProcessed_task2() + 1);
                    }
                    system_events.get(e).setType(0);
                }
            }
        }
        //Salvo tutti i numeri per calcolare l'intervallo di confidenza in Estimate()
        statistics.saveTempiValues(global_statistics, serverfarm, awsEc2);
        statistics.saveTaskValues(global_statistics, serverfarm, awsEc2, clock);
        statistics.saveThroughput(global_statistics, serverfarm, awsEc2, clock);

        //stampo i valori sul terminale
        printTranResults( global_statistics,  serverfarm,  awsEc2,  clock, STOP);

        assert (instant_writer!=null);
        instant_writer.close();
    }
}
