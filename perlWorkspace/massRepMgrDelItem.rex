/********************************************************************/
/* GENERATE, AS NEEDED, A SERIES OF HREPMNGR ITEM DELETIONS         */
/* starting with an input file generated from the Workbench GUI's   */
/* Find Versions tool and using the "Save List to File" function    */
/*                                                                  */
/* A series of batch files are generated frOM The versions list     */
/* when more than 10,000 items are involved in the deletions        */
/*                                                                  */
/* Originally conceived for BlowTorch repository cleanup            */
/*                                                                  */
/********************************************************************/
bfn = 'applPathDeletes'                             /* base file name */
in_file = 'applpathDeletes.bat'              /* expected input file name  */
                                     /* series of output file names */
out_file.1 = bfn || '01.bat'
out_file.2 = bfn || '02.bat'
out_file.3 = bfn || '03.bat'
out_file.4 = bfn || '04.bat'
out_file.5 = bfn || '05.bat'
out_file.6 = bfn || '06.bat'
out_file.7 = bfn || '07.bat'
out_file.8 = bfn || '08.bat'
out_file.9 = bfn || '09.bat'
out_file.10 = bfn || '10.bat'
out_file.11 = bfn || '11.bat'
out_file.12 = bfn || '12.bat'
out_file.13 = bfn || '13.bat'
out_file.14 = bfn || '14.bat'
out_file.15 = bfn || '15.bat'
out_file.16 = bfn || '16.bat'
out_file.17 = bfn || '17.bat'
out_file.18 = bfn || '18.bat'
out_file.19 = bfn || '19.bat'
out_file.20 = bfn || '20.bat'
out_file.21 = bfn || '21.bat'
out_file.22 = bfn || '22.bat'

icounterfile=3

out_file.icounterfile = bfn || icounterfile || '.bat'


do while lines(in_file) > 0                   /* Process the full file list        */
	icounterloop=1
	do while icounterloop < 10001

         line = linein(in_file)               /* Read a line from file list      */
         
             out_line = line
             rc = lineout(out_file.icounterfile, out_line)
             icounterloop = icounterloop + 1
             if lines(in_file) = 0 then leave

	end
	
	rc = lineout(out_file.icounterfile)
	icounterfile = icounterfile + 1
	out_file.icounterfile = bfn || icounterfile || '.bat'
       
end

exit 0
         