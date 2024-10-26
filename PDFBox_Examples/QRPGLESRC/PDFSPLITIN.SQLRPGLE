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

// Save the file
DCL-PR j_SaveFile  EXTPROC(*JAVA : 'org.apache.pdfbox.pdmodel.PDDocument' :
               'save' );
  arg0 OBJECT(*JAVA : 'java.io.File' );
END-PR ;

// Main logic of the program
DCL-PROC Main;

  // Convert Java String to Text
  DCL-PR getBytes VARCHAR(65535) EXTPROC(*JAVA : 'java.lang.String'
                  : 'getBytes' );
  END-PR ;

  // Load PDF File
  DCL-PR j_LoadPdfFile OBJECT(*JAVA : 'org.apache.pdfbox.pdmodel.PDDocument' )
          EXTPROC(*JAVA : 'org.apache.pdfbox.pdmodel.PDDocument' : 'load' )
          STATIC;
    arg0 OBJECT(*JAVA : 'java.io.File' );
  END-PR ;

  // Text Stipper Java Object Constructor  
  DCL-PR j_PDFTextStripperObjCtor OBJECT(*JAVA : 'org.apache.pdfbox.text.+
              PDFTextStripper' ) EXTPROC(*JAVA : 'org.apache.pdfbox.text.PDF+
              TextStripper' : *CONSTRUCTOR);
  END-PR ;

  // Set the start page to strip the text
  DCL-PR j_setTextStripperStartPage  EXTPROC(*JAVA : 'org.apache.pdfbox.text.PDFTextS+
              tripper' : 'setStartPage' );
    arg0 INT(10) VALUE;
  END-PR ;

  // Set the end page to strip the text
  DCL-PR j_setTextStripperEndPage  EXTPROC(*JAVA : 'org.apache.pdfbox.text.PDFTextS+
              tripper' : 'setEndPage' );
    arg0 INT(10) VALUE;
  END-PR ;

  // Get the number of pages
  DCL-PR j_GetNumberOfPDFPages INT(10) EXTPROC(*JAVA : 'org.apache.pdfbox.pd+
         model.PDDocument' : 'getNumberOfPages' );
  END-PR ;

  // Get the text from the PDF document
  DCL-PR j_TextStripperGetText OBJECT(*JAVA : 'java.lang.String' ) 
              EXTPROC(*JAVA : 'org.apache.pdfbox.text.PDFTextStripper' : 'ge+
              tText' );
    arg0 OBJECT(*JAVA : 'org.apache.pdfbox.pdmodel.PDDocument' );
  END-PR ;

  // QCMDEXEC to run IBMi commands
  DCL-PR QCmdExc ExtPgm('QCMDEXC');
    *N CHAR(2000) Const;
    *N PACKED(15:5) Const;
  END-PR;

  // Java variables
  DCL-S j_NewFile OBJECT(*JAVA : 'java.io.File' );
  DCL-S j_NewString OBJECT(*JAVA : 'java.lang.String');
  DCL-S j_PdfDocument OBJECT(*JAVA : 'org.apache.pdfbox.pdmodel.PDDocument' );
  DCL-S j_PDFTextStripperObj OBJECT(*JAVA: 'org.apache.pdfbox.text.PDFTextStripper' );
  DCL-S j_getTextRet OBJECT(*JAVA : 'java.lang.String' );

  // Variables
  DCL-S vNumberOfPages INT(10);
  DCL-S vIndex INT(10);
  DCL-S vStartPage INT(10);
  DCL-S vEndPage INT(10);
  DCL-S vCmdString CHAR(2000);
  DCL-S vString VARCHAR(65535);
  DCL-S vPdfFilePathAndName CHAR(5000);
  DCL-S vSaveInvoiceNumber CHAR(20);
  DCL-S vInvoiceNumber CHAR(20);
  DCL-S vFirstTime IND INZ(*On);
  DCL-S vSaveStartPage INT(10);

  // Constants  
  DCL-C TICK '''';

  // Set Classpath or Change Classpath
  vCmdString = 'ADDENVVAR (CLASSPATH) VALUE(' + TICK +
      '/home/rthompson/pdfbox2/pdfbox-app-2.0.27.jar' + TICK +
      ')';
  Monitor;
    QCmdExc(vCmdString : %len(%trim(vCmdString)));
  On-Error;
    If psds.MsgID = 'CPFA980';
      vCmdString = 'CHGENVVAR (CLASSPATH) VALUE(' + TICK +
        '/home/rthompson/pdfbox2/pdfbox-app-2.0.27.jar' + TICK +
        ')';
      Monitor;
        QCmdExc(vCmdString : %len(%trim(vCmdString)));
      On-Error;
        *INLR = *On;
        Return;
      EndMon;
    EndIf;
  EndMon;

  // Path and PDF File name
  vPdfFilePathAndName = '/home/rthompson/pdfSplit/Sample_Invoice.pdf';
  j_NewString = j_String(%trim(vPdfFilePathAndName));
  // Load the File
  j_NewFile = j_File(j_NewString);

  // Load the File into a PDDocument
  j_PdfDocument = j_LoadPdfFile(j_NewFile);

  // Get the total number of pages
  vNumberOfPages = j_GetNumberOfPDFPages( j_PdfDocument );

  // Split each page into it's own pdf
  For vIndex = 1 to vNumberOfPages;

    // start and end page will be the same as we are looking at 1 page at a time
    vStartPage = vIndex;
    vEndPage = vIndex;

    // Create the PDFTextStripper Object
    j_PDFTextStripperObj = j_PDFTextStripperObjCtor();

    // Set the Start and End Page    
    j_setTextStripperStartPage(j_PDFTextStripperObj : vStartPage);
    j_setTextStripperEndPage(j_PDFTextStripperObj : vEndPage);

    // Get the text from the PDF Document    
    j_getTextRet =  j_TextStripperGetText(j_PDFTextStripperObj : j_PdfDocument);

    // Convert the text to a VARCHAR    
    vString = getBytes(j_getTextRet);
    
    // Go find the invoice number from the PDF document
    vInvoiceNumber = GetInvoiceNumber(vString);
    
    // First Time Only Processing save the invoice number and the starting page.
    If vFirstTime;
      vSaveInvoiceNumber = vInvoiceNumber;
      vSaveStartPage = vStartPage;
      vFirstTime = *Off;
    EndIf;
    
    // If the invoice number is different and the end page is greater than 1 split 
    // the invoice pages.
    If vInvoiceNumber <> vSaveInvoiceNumber and vEndPage > 1;
      SplitPDF(j_PdfDocument 
          : vSaveStartPage  
          : vEndPage - 1
          : vSaveInvoiceNumber);
      // Save the Invoice Number and Start Page for the next cycle    
      vSaveInvoiceNumber = vInvoiceNumber;          
      vSaveStartPage = vEndPage;
    EndIf;

  Endfor;

  // Split the last invoice
  SplitPDF(j_PdfDocument 
          : vSaveStartPage  
          : vEndPage
          : vSaveInvoiceNumber);

END-PROC;

// Get the Invoice Number
DCL-PROC GetInvoiceNumber;
  DCL-PI *N CHAR(20);
    pString VARCHAR(65535) const;  
  END-PI;

  DCL-S vStartPosition INT(10);
  DCL-S vEndPosition INT(10);
  DCL-S vWrkString CHAR(20);
  
  // Find the starting position of invoice number
  vStartPosition =  %scan('Invoice Number: ' : pString);       

  // If the Invoice Number: string found scan for the space after the :  
  If vStartPosition > 0;                                       
    vStartPosition = %scan(':' : pString : vStartPosition) + 1;
    vEndPosition = %scan(' ' : pString : vStartPosition + 1);  

    // If the end position not found return blank for the invoice number
    If vEndPosition = 0;                                       
      Return ' ';                 
    EndIf;                                                     

    // If the Invoice Number is found substring the text and pull it out.                                                         
    If vEndPosition <> 0;                                      
      vWrkString = %trim(%subst(pString                        
    : vStartPosition                                         
    : vEndPosition - vStartPosition)) ;                      
    EndIf;                                                     
                                                             
  EndIf;
  
  // Return the invoice number
  Return vWrkString;

END-PROC;

// Split the PDF document into separate invoices
DCL-PROC SplitPDF;
  DCL-PI *N;
    p_PdfDocument OBJECT(*JAVA : 'org.apache.pdfbox.pdmodel.PDDocument' );
    p_StartPage INT(10) const;
    p_EndPage INT(10) const;
    p_FileName CHAR(20) const;
  END-PI;

  // Splitter Object Constructor
  DCL-PR j_SplitterObjCtor Object(*java 
            : 'org.apache.pdfbox.multipdf.Splitter' )
            Extproc(*java : 'org.apache.pdfbox.multipdf.Splitter' 
            : *CONSTRUCTOR);
  END-PR ;

  // PDDocument Constructor to hold the PDF File
  DCL-PR j_PDFDocumentObjCtor Object(*java : 
              'org.apache.pdfbox.pdmodel.PDDocument' ) 
              Extproc(*java : 'org.apache.pdfbox.pdmodel.PDDocument' :
              *CONSTRUCTOR);
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

  // Set the Split at Page
  DCL-PR j_SetSplitPDFAtPage EXTPROC(*JAVA : 'org.apache.pdfbox.multipdf.Sp+
              litter' : 'setSplitAtPage' );
    arg0 INT(10) VALUE;
  END-PR ;

  // Get Object from List
  DCL-PR j_GetList OBJECT(*JAVA : 'java.lang.Object' )
         EXTPROC(*JAVA : 'java.util.List' : 'get');
    arg0 INT(10) VALUE;
  END-PR;

  // Java Variables  
  DCL-S j_PartialNewFile OBJECT(*JAVA : 'java.io.File' );  // after split
  DCL-S j_SplitterObj Object(*JAVA : 'org.apache.pdfbox.multipdf.Splitter' );
  DCL-S j_SplitRet OBJECT(*JAVA : 'java.util.List' );
  DCL-S j_PdfPartialDocument OBJECT(*JAVA : 'org.apache.pdfbox.pdmodel.PDDocument' ); // after split
  DCL-S j_NewString OBJECT(*JAVA : 'java.lang.String');

  // Variables
  DCL-S vPdfFilePathAndName CHAR(5000);

  // Create a Splitter Object
  j_SplitterObj = j_SplitterObjCtor();
  // Set the page split start and end and split the pdf document
  j_SetPDFStartPage( j_SplitterObj : p_StartPage );
  j_SetPDFEndPage( j_SplitterObj : p_EndPage );

  // Split the PDF  
  j_SetSplitPDFAtPage( j_SplitterObj : p_EndPage - p_StartPage + 1);
  j_SplitRet = j_SplitPDF( j_SplitterObj : p_PdfDocument );

  // Create the Split PDDocument to hold the split PDF
  j_PdfPartialDocument = j_PDFDocumentObjCtor();
  // Get the Split Pages and put them into a document 
  j_PdfPartialDocument = j_GetList(j_SplitRet : 0);

  // Create new PDF file and save
  vPdfFilePathAndName = '/home/rthompson/pdfSplit/INV_' + %trim(p_FileName) + '.pdf';

  j_NewString = j_String(%trim(vPdfFilePathAndName));
  j_PartialNewFile = j_File(j_NewString);

  // Save the new PDF document  
  j_SaveFile( j_PdfPartialDocument : j_PartialNewFile );

END-PROC;