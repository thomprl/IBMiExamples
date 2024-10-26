**free

CTL-OPT ACTGRP(*NEW);

// --------------------------------------------------
// Declaration for Java object of class PDFMergerUtility
// in package org.apache.pdfbox.multipdf
// --------------------------------------------------
DCL-S pDFMergerUtilityObj Object(*java:
              'org.apache.pdfbox.multipdf.PDFMergerUtility' );

// -------------------------------------------------------------
// Parameter field declarations for Java method:
//     addSource in class PDFMergerUtility
// -------------------------------------------------------------

// Parameter field declaration for Java type: String
DCL-S j_addSourceParam0 OBJECT(*JAVA : 'java.lang.String' );
// -------------------------------------------------------------
// Prototype for Java constructor in class
//     PDFMergerUtility in package org.apache.pdfbox.multipdf
// -------------------------------------------------------------
DCL-PR pDFMergerUtilityObjCtor
              Object(*java : 'org.apache.pdfbox.multipdf.PDFMergerUtility' )
              Extproc(*java : 'org.apache.pdfbox.multipdf.PDFMergerUtility' :
              *CONSTRUCTOR);
END-PR ;

DCL-PR newString OBJECT(*JAVA : 'java.lang.String')
              EXTPROC(*JAVA : 'java.lang.String' :
              *CONSTRUCTOR);
  bytes VARCHAR(65535) Const;
END-PR;

// -------------------------------------------------------------
// Prototype for Java method:
//     addSource in class PDFMergerUtility
//       in package org.apache.pdfbox.multipdf
// -------------------------------------------------------------
DCL-PR addSource  EXTPROC(*JAVA :
              'org.apache.pdfbox.multipdf.PDFMergerUtility' :
              'addSource' );
  // Parameter prototype declaration for Java type: String
  arg0 OBJECT(*JAVA : 'java.lang.String' );
END-PR ;

// -------------------------------------------------------------
// Prototype for Java method:
//     mergeDocuments in class PDFMergerUtility
//       in package org.apache.pdfbox.multipdf
// -------------------------------------------------------------
DCL-PR mergeDocuments  EXTPROC(*JAVA :
              'org.apache.pdfbox.multipdf.PDFMergerUtility' :
              'mergeDocuments' );
END-PR ;

// -------------------------------------------------------------
// Parameter field declarations for Java method:
//     setDestinationFileName in class PDFMergerUtility
// -------------------------------------------------------------
// Parameter field declaration for Java type: String
DCL-S j_setDestinationFileNameParam0 OBJECT(*JAVA : 'java.lang.String' );

// -------------------------------------------------------------
// Prototype for Java method:
//     setDestinationFileName in class PDFMergerUtility
//       in package org.apache.pdfbox.multipdf
// -------------------------------------------------------------
DCL-PR setDestinationFileName  EXTPROC(*JAVA : 'org.apache.pdfbox.mul+
              tipdf.PDFMergerUtility' : 'setDestinationFileName' );
  // Parameter prototype declaration for Java type: String
  arg0 OBJECT(*JAVA : 'java.lang.String' );
END-PR ;

// QCMDEXEC to run IBMi commands
DCL-PR QCmdExc ExtPgm('QCMDEXC');
  *N CHAR(2000) Const;
  *N PACKED(15:5) Const;
END-PR;

DCL-S cmdString CHAR(2000);
DCL-C TICK '''';
DCL-S vIfsPathAndFileName CHAR(2000);

DCL-DS psds psds;
  MsgID CHAR(7) POS(40);
  ExceptData CHAR(80) POS(91);
END-DS;

// Set Classpath or Change Classpath
cmdString = 'ADDENVVAR (CLASSPATH) VALUE(' + tick +
         '/home/rthompson/pdfbox2/pdfbox-app-2.0.27.jar' + tick +
         ')';

Monitor;
  QCmdExc(cmdString : %len(%trim(cmdString)));
On-Error;
  If MsgID = 'CPFA980';
    cmdString = 'CHGENVVAR (CLASSPATH) VALUE(' + tick +
             '/home/rthompson/pdfbox2/pdfbox-app-2.0.27.jar' + tick +
             ')';
    Monitor;
      QCmdExc(cmdString : %len(%trim(cmdString)));
    On-Error;
      *INLR = *On;
      Return;
    EndMon;
  EndIf;
EndMon;

pDFMergerUtilityObj = pDFMergerUtilityObjCtor();

// --------------------------------------------------------
// Call Java method:
//      setDestinationFileName in class PDFMergerUtility
// --------------------------------------------------------
j_setDestinationFileNameParam0 =
                              newString('/home/rthompson/pdfmerge/combine.pdf');
setDestinationFileName( pDFMergerUtilityObj :
               j_setDestinationFileNameParam0 );

Exec Sql
         Declare IfsFilesCsr cursor for
         Select PATH_NAME
           FROM TABLE(QSYS2.IFS_OBJECT_STATISTICS('/home/rthompson/pdfmerge'
                ,'YES','*ALLSTMF'))
           WHERE UPPER(PATH_NAME) LIKE('%.PDF')
             AND UPPER(PATH_NAME) NOT LIKE ('%COMBINE%');

Exec Sql
         Open IfsFilesCsr;

If sqlcod = -502;
  Exec Sql
           Close IfsFilesCsr;
  Exec Sql
           Open IfsFilesCsr;
EndIf;

DoW 1=1;

  Exec Sql
           Fetch Next
           From IfsFilesCsr
           Into :vIfsPathAndFileName;

  If Sqlcod <> 0;
    Leave;
  EndIf;

  If %trim(vIfsPathAndFileName) = ' ';
    Iter;
  EndIf;

  // --------------------------------------------------------
  // Call Java method:
  //      addSource in class PDFMergerUtility
  // --------------------------------------------------------
  j_addSourceParam0 = newString(%trim(vIfsPathAndFileName));
  addSource( pDFMergerUtilityObj : j_addSourceParam0 );
EndDo;

// ------------------------------------------------
// Call Java method:
//      mergeDocuments in class PDFMergerUtility
// ------------------------------------------------
mergeDocuments( pDFMergerUtilityObj );

Exec Sql
         Close IfsFilesCsr;

*INLR = *On;