package statistics;/* ----------------------------------------------------------------------
 * This program reads a data sample from a text file in the format
 *                         one data point per line
 * and calculates an interval estimate for the mean of that (unknown) much
 * larger set of data from which this sample was drawn.  The data can be
 * either discrete or continuous.  A compiled version of this program
 * supports redirection and can used just like program uvs.c.
 *
 * Name              : Estimate.java (Interval Estimation)
 * Authors           : Steve Park & Dave Geyer
 * Translated By     : Richard Dutton & Jun Wang
 * Language          : Java
 * Latest Revision   : 6-16-06
 * ----------------------------------------------------------------------
 */


import static common.Config.LOC;

import java.io.*;
import java.util.ArrayList;

import common.Rvms;
import common.Util;



public class Estimate {

	public Estimate() {}


	public void calcolateConfidenceByArrays(ArrayList<ArrayList<Double>> simulatorDatas, String tipo, String titolo, PrintWriter estimateWriter) {

		Rvms rvms = new Rvms();
		ArrayList<Double> confidences = new ArrayList<>();
		ArrayList<Double> width = new ArrayList<>();


		for (ArrayList<Double> line : simulatorDatas) {

			long n = 0;                        /* counts data points */
			double sum = 0.0;
			double mean = 0.0;
			double stdev;
			double u, t, w;
			double diff;


			for (Double elem : line) {         /* use Welford's one-pass method */
				n++;                           /* and standard deviation        */
				diff = elem - mean;
				sum += diff * diff * (n - 1.0) / n;
				mean += diff / n;

			}

			stdev = Math.sqrt(sum / n);

			if (n > 1) {
				u = 1.0 - 0.5 * (1.0 - LOC);                  /* interval parameter  */
				t = rvms.idfStudent(n - 1, u);             /* critical value of t */
				w = t * stdev / Math.sqrt(n - 1);             /* interval half width */

				confidences.add(mean);
				width.add(w);
			} else
				System.out.print("ERROR - insufficient data\n");

		}

		ArrayList<String> temp = new ArrayList<>();
		for (int i=0; i<9; i++){
			temp.add(String.valueOf(confidences.get(i)));
			temp.add(String.valueOf(width.get(i)));
		}
		Util.print_on_file(estimateWriter, Util.convertArrayList(temp));


		System.out.println("\n\n------------------------Confidence Intervals generated from: " + titolo + " ------------------------");

		System.out.println("\nUsing a sample of elements and a " + (int) (100.0 * LOC + 0.5) + "% of confidence " +
				"the values of the confidence intervals are:\n");

		System.out.printf(tipo + " of the serverfarm %.6f +/- %.6f\n", confidences.get(0), width.get(0));
		System.out.printf(tipo + " of the serverfarm for task1 %.6f +/- %.6f\n", confidences.get(1), width.get(1));
		System.out.printf(tipo + " of the serverfarm for task2 %.6f +/- %.6f\n\n", confidences.get(2), width.get(2));

		System.out.printf(tipo + " of the aws ec2 %.6f +/- %.6f\n", confidences.get(3), width.get(3));
		System.out.printf(tipo + " of the aws ec2 for task1 %.6f +/- %.6f\n", confidences.get(4), width.get(4));
		System.out.printf(tipo + " of the aws ec2 for task2 %.6f +/- %.6f\n\n", confidences.get(5), width.get(5));

		System.out.printf(tipo + " of the system %.6f +/- %.6f\n", confidences.get(6), width.get(6));
		System.out.printf(tipo + " of the system for task1 %.6f +/- %.6f\n", confidences.get(7), width.get(7));
		System.out.printf(tipo + " of the system for task2 %.6f +/- %.6f\n\n", confidences.get(8), width.get(8));

	}

}
