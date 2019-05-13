// Brian Kim, 5/13/2019, created File

//This java program renames individual acquisition folders using the data in Visu pars, under VisuAcquisitionProtocol
//Pre: Set root folder as experiment folder
//Post: all experiement folders will be renamed

import java.io.*;
import java.util.Scanner;

public class renameScript {
    public static void main(String[] args) throws FileNotFoundException{
        File root = new File("/Volumes/SAMSUNG_T5/02_DOD_grant/09_Cardiac_imaging/00_raw_data/01_Epitope_experiment/");
        String[] rootList = root.list();
        for (String ls : rootList) {
            String FileName = "/Volumes/SAMSUNG_T5/02_DOD_grant/09_Cardiac_imaging/00_raw_data/01_Epitope_experiment/" + ls + "/";
            for (int i = 1; i <= 40; i++) {
                try {
                    File file = new File(FileName + i + "/pdata/1/visu_pars");
                    String use = findFileTag(file);
                    File parentFolder = new File(FileName + i);
                    File rename = new File(FileName + i + "_" + use);
                    parentFolder.renameTo(rename);
                }
                catch (FileNotFoundException e) {
                    System.out.println("could not find file at" + i);
                }
            }

        }
    }

    //given text file find the tag needed to rename
    public static String findFileTag(File file) throws FileNotFoundException{
        Scanner scan= new Scanner(file);
        String findThis = "VisuAcquisitionProtocol";
        char[] checkThis = findThis.toCharArray();
        while(scan.hasNextLine()) {
            String line = scan.nextLine();
            if (line.length() > 2 && line.substring(0, 3).equals("##$")) {
                char[] lineText = line.substring(3, line.length()-3).toCharArray();
                if (isCharMatch(checkThis, lineText)) {
                    String toReturn = scan.nextLine();
                    return toReturn.substring(1, toReturn.length() -1);
                }
            }

        }
        return "undefined";




    }


    //checks given look for, textline
    public static boolean isCharMatch(char[] array1, char[] array2) {
        int i = 0;
        for (char c: array1) {
            if (c != array2[i]) {
                return false;
            }
            i++;

        }
        return true;
    }


}
