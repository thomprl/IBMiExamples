**free
// https://stackoverflow.com/questions/40221977/
//      pdfbox-split-pdf-in-multi-files-with-different-page-ranges-and-filenames
// https://stackoverflow.com/questions/16445181/
//      access-the-page-of-a-pdf-i-load-using-pdfbox-and-im-using-rpg
//

CTL-OPT ACTGRP(*NEW) Main(Main);

// Program Data Structure
DCL-DS psds psds qualified;
  MsgID CHAR(7) POS(40);
  ExceptData CHAR(80) POS(91);
END-DS;

DCL-PROC Main;

  // Java String Object
  DCL-PR j_String Object(*JAVA:'java.lang.String')
                   ExtProc(*JAVA:'java.lang.String':*CONSTRUCTOR);
    *N Varchar(65535) Const;
  END-PR;

  // Java File Object
  DCL-PR j_File Object(*JAVA:'java.io.File')
                 ExtProc(*JAVA:'java.io.File':*CONSTRUCTOR);
    *N Object(*Java:'java.lang.String');
  END-PR;

  // Get Object from List
  DCL-PR j_GetList OBJECT(*JAVA : 'java.lang.Object' )
         EXTPROC(*JAVA : 'java.util.List' : 'get');
    arg0 INT(10) VALUE;
  END-PR;

  // Load PDF File
  DCL-PR j_LoadPdfFile OBJECT(*JAVA : 'org.apache.pdfbox.pdmodel.PDDocument' )
          EXTPROC(*JAVA : 'org.apache.pdfbox.pdmodel.PDDocument' : 'load' )
          STATIC;
    arg0 OBJECT(*JAVA : 'java.io.File' );
  END-PR ;

  // Splitter Object Constructor  
  DCL-PR j_SplitterObjCtor Object(*java :
            'org.apache.pdfbox.multipdf.Splitter' )
            Extproc(*java : 'org.apache.pdfbox.multipdf.Splitter' : *CONSTRUCTOR);

  END-PR ;

  // Split PDF
  DCL-PR j_SplitPDF OBJECT(*JAVA : 'java.util.List' ) EXTPROC(*JAVA : 'org.a+
         pache.pdfbox.multipdf.Splitter' : 'split' );
    arg0 OBJECT(*JAVA : 'org.apache.pdfbox.pdmodel.PDDocument' );
  END-PR ;

  // Set the Start Split Page 
  DCL-PR j_SetPDFStartPage EXTPROC(*JAVA : 'org.apache.pdfbox.multipdf.Spli+
         tter' : 'setStartPage' );
    arg0 INT(10) VALUE;
  END-PR ;

  // Set the End Split Page
  DCL-PR j_SetPDFEndPage EXTPROC(*JAVA : 'org.apache.pdfbox.multipdf.Spli+
         tter' : 'setEndPage' );
    arg0 INT(10) VALUE;
  END-PR;

  // PDDocument Constructor to hold the PDF File
  DCL-PR j_PDFDocumentObjCtor Object(*java : 'org.apache.pdfbox.pdmodel.PD+
              Document' ) Extproc(*java : 'org.apache.pdfbox.pdmodel.PDDocum+
              ent' : *CONSTRUCTOR);
  END-PR ;

  // Save the file
  DCL-PR j_SaveFile  EXTPROC(*JAVA : 'org.apache.pdfbox.pdmodel.PDDocument' :
               'save' );
    arg0 OBJECT(*JAVA : 'java.io.File' );
  END-PR ;

  // Set the Split at Page
  DCL-PR j_SetSplitPDFAtPage EXTPROC(*JAVA : 'org.apache.pdfbox.multipdf.Sp+
              litter' : 'setSplitAtPage' );
    arg0 INT(10) VALUE;
  END-PR ;

  // Get the number of pages
  DCL-PR j_GetNumberOfPDFPages INT(10) EXTPROC(*JAVA : 'org.apache.pdfbox.pd+
         model.PDDocument' : 'getNumberOfPages' );
  END-PR ;

  // Java variables
  DCL-S j_NewFile OBJECT(*JAVA : 'java.io.File' );
  DCL-S j_PartialNewFile OBJECT(*JAVA : 'java.io.File' );  // after split
  DCL-S j_SplitterObj Object(*JAVA : 'org.apache.pdfbox.multipdf.Splitter' );
  DCL-S j_SplitRet OBJECT(*JAVA : 'java.util.List' );
  DCL-S j_NewString OBJECT(*JAVA : 'java.lang.String');
  DCL-S j_PdfDocument OBJECT(*JAVA : 'org.apache.pdfbox.pdmodel.PDDocument' );
  DCL-S j_PdfPartialDocument OBJECT(*JAVA : 'org.apache.pdfbox.pdmodel.PDDocument' ); // after split

  // Variables
  DCL-S vPdfFilePathAndName CHAR(5000);
  DCL-S vStartPage INT(10) INZ(1);
  DCL-S vEndPage INT(10) INZ(2);
  DCL-S vNumberOfPages INT(10);
  DCL-S vIndex INT(10);
  DCL-S vCmdString CHAR(2000);


  // QCMDEXEC to run IBMi commands
  DCL-PR QCmdExc ExtPgm('QCMDEXC');
    *N CHAR(2000) Const;
    *N PACKED(15:5) Const;
  END-PR;

  DCL-C TICK '''';

  // Set Classpath or Change Classpath
  vCmdString = 'ADDENVVAR (CLASSPATH) VALUE(' + TICK +
      '/home/rthompson/pdfSplit/pdfbox-app-2.0.27.jar' + TICK +
      ')';
  Monitor;
    QCmdExc(vCmdString : %len(%trim(vCmdString)));
  On-Error;
    If psds.MsgID = 'CPFA980';
      vCmdString = 'CHGENVVAR (CLASSPATH) VALUE(' + TICK +
        '/home/rthompson/pdfSplit/pdfbox-app-2.0.27.jar' + TICK +
        ')';
      Monitor;
        QCmdExc(vCmdString : %len(%trim(vCmdString)));
      On-Error;
        *INLR = *On;
        Return;
      EndMon;
    EndIf;
  EndMon;

  vPdfFilePathAndName = '/home/rthompson/pdfSplit/my_pdf.pdf';
  j_NewString = j_String(%trim(vPdfFilePathAndName));
  // Load the File
  j_NewFile = j_File(j_NewString);

  // Load the File into a PDDocument
  j_PdfDocument = j_LoadPdfFile(j_NewFile);

  // Get the total number of pages
  vNumberOfPages = j_GetNumberOfPDFPages( j_PdfDocument );

  // Split each page into it's own pdf
  For vIndex = 1 to vNumberOfPages;
    
    // Create a Splitter Object
    j_SplitterObj = j_SplitterObjCtor();

    // start and end page will be the same since we are splitting each page.
    vStartPage = vIndex;
    vEndPage = vIndex;
    
    // Set the page split start and end and split the pdf document
    j_SetPDFStartPage( j_SplitterObj : vStartPage );
    j_SetPDFEndPage( j_SplitterObj : vEndPage );
    j_SetSplitPDFAtPage( j_SplitterObj : vEndPage - vStartPage + 1);
    j_SplitRet = j_SplitPDF( j_SplitterObj : j_PdfDocument );

    // Create the Split PDDocument to hold the split PDF
    j_PdfPartialDocument = j_PDFDocumentObjCtor();
    // Get the first document in from the Java List (index: 0)
    j_PdfPartialDocument = j_GetList(j_SplitRet : 0);

    // Create new PDF file and save
    vPdfFilePathAndName = '/home/rthompson/pdfSplit/my_split_' + %trim(%editc(vIndex:'Z')) + '.pdf';
    j_NewString = j_String(%trim(vPdfFilePathAndName));
    j_PartialNewFile = j_File(j_NewString);
    j_SaveFile( j_PdfPartialDocument : j_PartialNewFile );
    
  Endfor;

END-PROC;