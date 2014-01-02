You can use the following script

SELECT DISTINCT HARPACKAGE.PACKAGENAME 
FROM HARVEST.HARPACKAGE, HARVEST.HARVERSIONS
WHERE HARVERSIONS.PACKAGEOBJID = HARPACKAGE.PACKAGEOBJID
AND   HARPACKAGE.PACKAGENAME<>'BASE'

To filter on Package Creation Time add the following
AND   HARPACKAGE.CREATIONTIME> TO_DATE('04/07/2002','dd/mm/yyyy')

To filter on Version Creation Time add the following

AND   HARVERSIONS.CREATIONTIME> TO_DATE('11/07/2002','dd/mm/yyyy')

You could see the output log or, better, build a html page and display it in your browser

I hope this helps you,
Carlos
