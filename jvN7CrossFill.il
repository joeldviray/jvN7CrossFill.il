/* jvN7CrossFill.il
 *
 *
 * Author       Joel Viray
 * Language     SKILL
 * Date         Nov 20, 2018
 *
 * Auto delete cross fills around inductor. 
 * Auto delete dummy fills from M5-M9.
 *
 *  
 */


procedure(abGetOverlapShape(overlap)
  if(listp(overlap) then
      abGetOverlapShape(cadr(overlap))
  else
      overlap
  );if
);procedure


procedure( jvN7CrossFill()

    command="jvN7CrossFill"
    jvLog()

    cv=geGetEditCellView()

    foreach(cf geGetSelSet()

        cfbbox=cf~>bBox

        x1bbox=xCoord(lowerLeft(cfbbox))
		y1bbox=yCoord(lowerLeft(cfbbox))
        x2bbox=xCoord(upperRight(cfbbox))
		y2bbox=yCoord(upperRight(cfbbox))

        increased_cfbbox=list(x1bbox-0.5:y1bbox-0.5 x2bbox+0.5:y2bbox+0.5)

                
        m14_overlaps=dbProduceOverlap(cv increased_cfbbox 32 list("M14" "drawing"))


        flattened_m14_overlaps=foreach(mapcar overlap m14_overlaps
                              srcShape=abGetOverlapShape(overlap)
                              );foreach


        if(length(flattened_m14_overlaps)>=1
            then
            dbDeleteObject(cf)
        );if


             
        

    );foreach


);procedure

procedure( jvN7DummyFill()

    command="jvN7DummyFill"
    jvLog()

    cv=geGetEditCellView()

    foreach(df geGetSelSet()

        dfbbox=df~>bBox

        x1bbox=xCoord(lowerLeft(dfbbox))
		y1bbox=yCoord(lowerLeft(dfbbox))
        x2bbox=xCoord(upperRight(dfbbox))
		y2bbox=yCoord(upperRight(dfbbox))

        increased_dfbbox=list(x1bbox-0.5:y1bbox-0.5 x2bbox+0.5:y2bbox+0.5)

                
        m5_overlaps=dbProduceOverlap(cv increased_dfbbox 32 list("M5" "drawing"))
        m6_overlaps=dbProduceOverlap(cv increased_dfbbox 32 list("M6" "drawing"))
        m7_overlaps=dbProduceOverlap(cv increased_dfbbox 32 list("M7" "drawing"))
        m8_overlaps=dbProduceOverlap(cv increased_dfbbox 32 list("M8" "drawing"))
        m9_overlaps=dbProduceOverlap(cv increased_dfbbox 32 list("M9" "drawing"))



        flattened_m5_overlaps=foreach(mapcar overlap m5_overlaps
                              srcShape=abGetOverlapShape(overlap)
                              );foreach

        flattened_m6_overlaps=foreach(mapcar overlap m6_overlaps
                              srcShape=abGetOverlapShape(overlap)
                              );foreach

        flattened_m7_overlaps=foreach(mapcar overlap m7_overlaps
                              srcShape=abGetOverlapShape(overlap)
                              );foreach

        flattened_m8_overlaps=foreach(mapcar overlap m8_overlaps
                              srcShape=abGetOverlapShape(overlap)
                              );foreach

        flattened_m9_overlaps=foreach(mapcar overlap m9_overlaps
                              srcShape=abGetOverlapShape(overlap)
                              );foreach
                           


        if(length(flattened_m5_overlaps)>=1&&df~>layerName=="M5"
            then
            dbDeleteObject(df)
        );if

        if(length(flattened_m6_overlaps)>=1&&df~>layerName=="M6"
            then
            dbDeleteObject(df)
        );if

        if(length(flattened_m7_overlaps)>=1&&df~>layerName=="M7"
            then
            dbDeleteObject(df)
        );if

        if(length(flattened_m8_overlaps)>=1&&df~>layerName=="M8"
            then
            dbDeleteObject(df)
        );if

        if(length(flattened_m9_overlaps)>=1&&df~>layerName=="M9"
            then
            dbDeleteObject(df)
        );if
            
        

    );foreach


);procedure



procedure( jvLog()

x=geGetEditCellView()
;command="test"
time=getCurrentTime()
;pwd
library=x~>libName
cell=x~>cellName
view=x~>viewName

procedure( jvWhoAmI()
system("whoami > myName")
      let(( inPort nextLine)
        inPort = infile( "./myName")
        when( inPort
          while( gets( nextLine inPort)
         printf("%s" nextLine)

	 myName=nextLine	

          )
      close( inPort)
          )
         )
     )

procedure( jvPwd()
system("pwd > myPath")
      let(( inPort nextLine)
        inPort = infile( "./myPath")
        when( inPort
          while( gets( nextLine inPort)
         printf("%s" nextLine)

	 myPath=nextLine	

          )
      close( inPort)
          )
         )
     )
jvWhoAmI()
jvPwd()


newChar=pcreCompile("\n")
colon=pcreCompile(":")
space=pcreCompile(" ")
myName=pcreReplace(newChar myName "" 0) ;remove the newChar
myPath=pcreReplace(newChar myPath "" 0) ;remove the newChar
myTime=pcreReplace(colon time "" 0) ;remove the colon in time
myTime2=pcreReplace(space myTime "" 0) ;remove the spaces in time

myFile = strcat(command "_" myTime2 "_" myName)
myPort = outfile(strcat("/home/jviray/tmp/" myFile))
fprintf(myPort "************************************************************\n\n")
fprintf(myPort strcat(myName "\n"))
fprintf(myPort strcat(myPath "\n"))
fprintf(myPort strcat(time "\n"))
fprintf(myPort strcat(command "\n"))
fprintf(myPort strcat(library "\n"))
fprintf(myPort strcat(cell "\n"))
fprintf(myPort strcat(view "\n"))
fprintf(myPort strcat(" " "\n"))
close(myPort)

)


procedure(jvWarningMessage()
        hiDisplayAppDBox(
                ?name `test
                ?dialogType hicMessageDialog
                ?dboxBanner "Reminder"
                ?dboxText strcat("Warning! No cell has been selected.")
                ?buttonLayout `Close
        );hiDisplayAppDBox
);procedure




