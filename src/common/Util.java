package common;

import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Arrays;


public class Util {


    public static final String ROOTBATCH1 = "Matlab\\batch\\batch1\\";
    public static final String ROOTBATCH2 = "Matlab\\batch\\batch2\\";
    public static final String ROOTTRA1 = "Matlab\\transient\\transient1\\";
    public static final String ROOTTRA2 = "Matlab\\transient\\transient2\\";

    public static boolean createDirectoriesTree(String dir){
        try {
            Path path = Paths.get("..\\pmcsn_Moroni_Perrone\\Matlab\\"+ dir);
            Files.createDirectories(path);

            Path pathFigure = Paths.get("..\\pmcsn_Moroni_Perrone\\Matlab\\img");
            Files.createDirectories(pathFigure);

            for (int i=1; i<3; i++){
                Path subPathFigure = Paths.get("..\\pmcsn_Moroni_Perrone\\Matlab\\figure\\Alg"+i);
                Files.createDirectories(subPathFigure);
            }
            for(int i=1; i<3;i++){
                Path alg = Paths.get("..\\pmcsn_Moroni_Perrone\\pmcsn_Moroni_Perrone\\Matlab\\"+dir+"\\"+dir+i);
                Files.createDirectories(alg);
                Path pathEstimateTempi = Paths.get("..\\pmcsn_Moroni_Perrone\\Matlab\\"+dir+"\\"+dir+i+"\\estimateTempi");
                Path pathEstimateTask = Paths.get("..\\pmcsn_Moroni_Perrone\\Matlab\\"+dir+"\\"+dir+i+"\\estimateTask");
                Path pathEstimateThroughput = Paths.get("..\\pmcsn_Moroni_Perrone\\Matlab\\"+dir+"\\"+dir+i+"\\estimateThroughput");
                Files.createDirectories(pathEstimateTempi);
                Files.createDirectories(pathEstimateTask);
                Files.createDirectories(pathEstimateThroughput);
            }
        } catch (IOException e) {
            e.printStackTrace();
            System.out.print("Error during folder creation!\n");
            return false;
        }
        return true;
    }

    public static String[] titlesTran = new String[]{"serverfarm", "serverfarm_task1", "serverfarm_task2",
            "awsEc2", "awsEc2_task1", "awsEc2_task2",
            "system", "system_task1", "system_task2"};

    public static String[] titlesEstimate = new String[]{"serverfarm", "+/-", "serverfarm_task1", "+/-", "serverfarm_task2", "+/-",
            "awsEc2", "+/-", "awsEc2_task1", "+/-", "awsEc2_task2", "+/-",
            "system", "+/-", "system_task1", "+/-", "system_task2", "+/-"};

    public static PrintWriter createFiles(String path, String filename){

        PrintWriter newWriter = null;
        try {
            newWriter = new PrintWriter(new FileWriter(path + filename));
            Util.print_on_file(newWriter, Util.titlesEstimate);

        } catch (IOException e) {
            System.out.print("Error creating file!\n");
            System.exit(1);

        }
        return newWriter;
    }

    public static void print_on_file(PrintWriter writer, String[] row) {

        for (String s : row) {
            writer.write(s);
            writer.write(';');
        }
        writer.write(System.getProperty("line.separator"));
    }

    public static void print_on_file_column(PrintWriter writer, String[] row) {

        for (String s : row) {
            writer.write(s);
            writer.write(';');
            writer.write(System.getProperty("line.separator"));
        }
    }

    public static String[] convertArrayList(ArrayList<String>arrayList) {
        Object[] temp = arrayList.toArray();
        return Arrays.copyOf(temp,
                temp.length,
                String[].class);
    }

    public static void closeFile(PrintWriter writer){
        assert (writer!= null);
        writer.close();

    }
}
