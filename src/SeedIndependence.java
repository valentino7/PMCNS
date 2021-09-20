package pmcsn;

import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import static pmcsn.Configuration.*;
import StruttureDiSistema.*;


public class SeedIndependence {

    public static void main(String[] args) {
    	

        Path path = Paths.get("Matlab\\seeds");
        try {
            Files.createDirectories(path);
        } catch (IOException e) {
            System.out.print("C'è stato un errore durante la creazione della cartella\n");
            System.exit(1);
        }
        String[] seeds_c={
//        		"12345", "1283049252", "1929196386", "1077625752", "1067702217"};
//        		"546913154", "2088972377", "1662279066", "1382849245", "1725244441"};
//        		"690481516", "1643117837", "1190922489", "2073592862", "1639462171"};
//        		"1364544990", "2072646824", "2036115201", "1748920395", "2053376678"}; 
//        		"1347898897", "1800741986", "738214608", "2145397869", "995635270"};
//        		"1230313434", "1043381122", "1616230035", "534811869", "1890902852"}; 
//        		"1243687011", "2125579384", "2107758977", "1704303408", "1943235451"};
//        		"543400068", "1556211787", "1403245561", "980108135", "1774832437"};
        		"1202331895", "1994218610", "2060527362", "1808600557", "2139392116"};

        
        

        for (String s: seeds_c){
            Rngs r = new Rngs();
            r.plantSeeds(Long.parseLong(s));
            PrintWriter writer=null;
            try {
                writer= new PrintWriter(new FileWriter("Matlab\\seeds\\" + "SeedStream" + s +  ".csv"));
            } catch (IOException e) {
                e.printStackTrace();
            }
            ArrayList<String> streamValues = new ArrayList<>();
            for (int i=0; i<STOP_SEED
                    ; i++) {
                streamValues.add(Double.toString(r.random()));
            }
            assert writer!=null;
            Util.print_on_file_column(writer, Util.convertArrayList(streamValues));
            writer.close();
        }

    }

}
