package common;

public class Config {

    public static double mu1_serverfarm = 0.2;
    public static double mu2_serverfarm = 0.15;
    public static double mu1_awsec2 = 0.11;
    public static double mu2_awsec2 = 0.08;
    public static double lambda = 3.3;
    public static double lambda1 = 1.5;
    public static double lambda2 = 1.8;

    //Seed testati per capire quale usare
    //public static String[] seeds_collection={"124506","137010","129771","439202", "349582", "015678", "444444"};
    public static String seed = "12345";

    public static int transient_replications = 5;
    public static int batch_interval = 10000;


    public static double START   = 0.0;
    public static double STOP_BATCH = 1000000;
    public static double STOP_SEED = 1000000;
    public static double[] STOP_T = {5.00,10.00,50.00,100.00,500.00,1000.00,2000.00, 5000.00, 10000.00};
    //Valore di clock per la generazione dello stazionario
    //public static double[] STOP_T = {10000.00};
    public static int    SERVERS = 10;
    public static int    LIMIT = 8;

    public static double LOC = 0.95;

}