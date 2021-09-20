package trans;
import static common.Config.*;
import static common.Util.*;
import static common.Util.closeFile;

import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.util.Scanner;

import common.Rngs;
import common.Util;
import statistics.Estimate;
import statistics.Statistics;


public class StartTran {

    public static void main(String[] args) {

        if(!Util.createDirectoriesTree("transient")){
            System.out.println("Error creating folders to store results.");
            System.exit(1);
        };

        while (true) {
        	//pianta un nuovo seme
            Rngs r = new Rngs();
            r.plantSeeds(Long.parseLong(seed));
            
            int selected_algorithm = choose_algorithm();

            

            for(int j=0; j<STOP_T.length; j++){

                PrintWriter estimateTempiWriter = null;
                PrintWriter estimateTaskWriter = null;
                PrintWriter estimateThroughputWriter = null;

                Statistics statistics = new Statistics();

                for (int i = 0; i < transient_replications; i++) {

                    switch (selected_algorithm) {

                        case 1: {

                            estimateTempiWriter = Util.createFiles(ROOTTRA1 , "estimateTempi\\estimateTempi" +  String.valueOf(j) + "Alg" + selected_algorithm + ".csv");
                            estimateTaskWriter = Util.createFiles(ROOTTRA1 , "estimateTask\\estimateTaskFile" + String.valueOf(j) + "Alg" + selected_algorithm + ".csv");
                            estimateThroughputWriter = Util.createFiles(ROOTTRA1 , "estimateThroughput\\estimateThroughputFile" + String.valueOf(j) + "Alg" + selected_algorithm + ".csv");


                            Transient_simulator_1 s_algorith1 = new Transient_simulator_1();
                            s_algorith1.RunSimulation(r, STOP_T[j], Long.toString(r.getSeed()), statistics);

                            break;
                        }
                        case 2: {

                            estimateTempiWriter = Util.createFiles(ROOTTRA2 , "estimateTempi\\estimateTempiFile" +  String.valueOf(j)  + "Alg" + selected_algorithm + ".csv");
                            estimateTaskWriter = Util.createFiles(ROOTTRA2 , "estimateTask\\estimateTaskFile" + String.valueOf(j) + "Alg" + selected_algorithm + ".csv");
                            estimateThroughputWriter = Util.createFiles(ROOTTRA2 , "estimateThroughput\\estimateThroughputFile" + String.valueOf(j) + "Alg" + selected_algorithm + ".csv");

                            Transient_simulator_2 s_algorith2 = new Transient_simulator_2();
                            s_algorith2.RunSimulation(r, STOP_T[j], Long.toString(r.getSeed()), statistics);

                            break;
                        }
                        default:
                            System.out.print("Insert a significant value!\n\n ");
                            System.exit(1);
                            break;

                    }
                    r.plantSeeds(r.getSeed());
                }

                Estimate e = new Estimate();
                //intervallo di confidenza dei tempi
                e.calcolateConfidenceByArrays(statistics.getEstimateTempi(), "Average response time",  String.valueOf(j) , estimateTempiWriter);
                //intervallo di confidenza dei task
                e.calcolateConfidenceByArrays(statistics.getEstimateTask(), "Average tasks number",  String.valueOf(j) , estimateTaskWriter);
                //intervallo di confidenza dei thoughtput
                e.calcolateConfidenceByArrays(statistics.getEstimateThroughput(),"Throughput ",  String.valueOf(j) , estimateThroughputWriter);

                System.out.flush();

                close_files(estimateTempiWriter, estimateTaskWriter, estimateThroughputWriter);

            }
        }
    }
    
	public static int choose_algorithm() {

	    int selected = 0;
	
	    System.out.print("\n\t\t\tWelcome to the transient simulation.\nWhich simulator do you want to execute? [1 or 2] \t (Insert 0 to quit): ");
	    Scanner reader = new Scanner(new InputStreamReader(System.in));
	    try {
	        selected = reader.nextInt();
	    } catch (Exception e) {
	        System.out.print("Insert one of the above mentioned values!\n\n");
	        System.exit(1);
	    }
	    if (selected == 0) {
	        System.exit(0);
	    }
	    return selected;
	}
    
	public static void close_files(PrintWriter timesWriter, PrintWriter taskWriter, PrintWriter throughputWriter ) {
        closeFile(timesWriter);
        closeFile(taskWriter);
        closeFile(throughputWriter);
	}
}
