      * Utility routines for working with HSSF to create Excel                                      
      * spreadsheets from ILE RPG.                                                                  
      *                                                                                             
      *  To compile:                                                                                
      *                                                                                             
      *  CRTRPGMOD QTEMP/HSSFR4 SRCFILE(mylib/QRPGLESRC) DBGVIEW(*LIST)                            
      *                                                                                             
      *  CRTSRVPGM SRVPGM(mylib/HSSFR4) MODULE(QTEMP/HSSFR4)                                       
      *        SRCFILE(mylib/QBNDSRC) ACTGRP(HSSFR4)                                               
      *        TEXT('Utilties for creating Excel spreadsheets')                                     
      *                                                                                             
      *  CRTBNDDIR BNDDIR(mylib/HSSF)                                                               
      *  ADDBNDDIRE BNDDIR(mylib/HSSF) OBJ((mylib/HSSFR4 *SRVPGM))                                  
      *                                                                                             
                                                                                                    
     H NOMAIN OPTION(*NODEBUGIO: *SRCSTMT)                                                          
     H THREAD(*SERIALIZE)                                                                           
                                                                                                    
     D start_jvm       PR              *                                                            
     D attach_jvm      PR              *                                                            
                                                                                                    
     D String_getBytes...                                                                           
     D                 pr          1024A   varying                                                  
     D                                     extproc(*JAVA:                                           
     D                                     'java.lang.String':                                      
     D                                     'getBytes')                                              
                                                                                                    
      /copy qrpglesrc,hssf_h                                                                        
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      *  hssf_NewSheet():   Shortcut to adding a new HSSFSheet object                               
      *        to an existing HSSFWorkbook object.                                                  
      *        (Wrapper around HSSFWorkbook_createSheet() method)                                   
      *                                                                                             
      *  In other words, add a new sheet to a workbook :)                                           
      *                                                                                             
      *      peBook = workbook to add sheet to                                                      
      *      peName = name of new sheet.                                                            
      *                                                                                             
      *  Returns the new sheet                                                                      
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     P hssf_NewSheet   B                   EXPORT                                                   
     D hssf_NewSheet   PI                  like(HSSFSheet)                                          
     D   peBook                            like(HSSFWorkbook)                                       
     D   peName                    1024A   const varying                                            
                                                                                                    
     D wwStr           s                   like(jString)                                            
     D wwSheet         s                   like(HSSFSheet)                                          
      /free                                                                                         
         wwStr = new_String(peName);                                                                
         wwSheet = HSSFWorkbook_createSheet(peBook: wwStr);                                         
         hssf_freeLocalRef(wwStr);                                                                  
         return wwSheet;                                                                            
      /end-free                                                                                     
     P                 E                                                                            
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      *  hssf_save():   Save HSSF Workbook to disk                                                  
      *      (Wrapper around HSSFWorkbook_write() method)                                           
      *                                                                                             
      *      peBook = workbook to add sheet to                                                      
      *      peFile = IFS path/filename to save workbook as                                         
      *                                                                                             
      *  Returns the new sheet                                                                      
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     P hssf_save       B                   EXPORT                                                   
     D hssf_save       PI                                                                           
     D   peBook                            like(HSSFWorkbook)                                       
     D   peFilename                1024A   const varying                                            
                                                                                                    
     D wwStr           s                   like(jString)                                            
     D wwFile          s                   like(jFileOutputStream)                                  
      /free                                                                                         
         wwStr = new_String(peFilename);                                                            
         wwFile = new_FileOutputStream(wwStr);                                                      
         HSSFWorkbook_write(peBook: wwFile);                                                        
         FileOutputStream_close(wwFile);                                                            
         hssf_freeLocalRef(wwFile);                                                                 
         hssf_freeLocalRef(wwStr);                                                                  
      /end-free                                                                                     
     P                 E                                                                            
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      *  hssf_merge(): Merge cells on a sheet                                                       
      *      (Wrapper around HSSFSheet_addMergedRegion() method)                                    
      *                                                                                             
      *      peBook = workbook to add sheet to                                                      
      *      peFile = IFS path/filename to save workbook as                                         
      *                                                                                             
      *  Returns the new sheet                                                                      
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     P hssf_merge      B                   EXPORT                                                   
     D hssf_merge      PI                                                                           
     D   peSheet                           like(HSSFSheet)                                          
     D   peRowFrom                         like(jint) value                                         
     D   peColFrom                         like(jshort) value                                       
     D   peRowTo                           like(jint) value                                         
     D   peColTo                           like(jshort) value                                       
                                                                                                    
     D wwRegion        s                   like(Region)                                             
                                                                                                    
      /free                                                                                         
         wwRegion = new_Region(peRowFrom: peColFrom: peRowTo: peColTo);                             
         HSSFSheet_addMergedRegion(peSheet: wwRegion);                                              
         hssf_freeLocalRef(wwRegion);                                                               
      /end-free                                                                                     
     P                 E                                                                            
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      *  hssf_text():  Shortcut for inserting a new cell that contains                              
      *        a string value into a given row of a sheet                                           
      *                                                                                             
      *    peRow = Row object that cell should be created in                                        
      *    peCol = column number of new cell                                                        
      * peString = string to place in cell                                                          
      *  peStyle = cell style object to associate with cell                                         
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     P hssf_text       B                   EXPORT                                                   
     D hssf_text       PI                                                                           
     D   peRow                             like(HSSFRow)                                            
     D   peCol                        5I 0 value                                                    
     D   peString                  1024A   varying const                                            
     D   peStyle                           like(HSSFCellStyle)                                      
                                                                                                    
     D wwStr           s                   like(jString)                                            
     D wwCell          s                   like(HSSFCell)                                           
                                                                                                    
      /free                                                                                         
         wwCell = HSSFRow_createCell(peRow: peCol);                                                 
         HSSFCell_setCellType(wwCell: CELL_TYPE_STRING);                                            
         wwStr = new_String(peString);                                                              
         HSSFCell_setCellValueStr(wwCell: wwStr);                                                   
         HSSFCell_setCellStyle(wwCell: peStyle);                                                    
         hssf_freeLocalRef(wwStr);                                                                  
         hssf_freeLocalRef(wwCell);                                                                 
      /end-free                                                                                     
     P                 E                                                                            
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      *  hssf_num():  Shortcut for inserting a new cell that contains                               
      *        a numeric value into a given row of a sheet                                          
      *                                                                                             
      *    peRow = Row object that cell should be created in                                        
      *    peCol = column number of new cell                                                        
      * peNumber = numeric value to place in cell                                                   
      *  peStyle = cell style object to associate with cell                                         
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     P hssf_num        B                   EXPORT                                                   
     D hssf_num        PI                                                                           
     D   peRow                             like(HSSFRow)                                            
     D   peCol                        5I 0 value                                                    
     D   peNumber                     8F   value                                                    
     D   peStyle                           like(HSSFCellStyle)                                      
                                                                                                    
     D wwCell          s                   like(HSSFCell)                                           
                                                                                                    
      /free                                                                                         
         wwCell = HSSFRow_createCell(peRow: peCol);                                                 
         HSSFCell_setCellType(wwCell: CELL_TYPE_NUMERIC);                                           
         HSSFCell_setCellValueD(wwCell: peNumber);                                                  
         HSSFCell_setCellStyle(wwCell: peStyle);                                                    
         hssf_freeLocalRef(wwCell);                                                                 
      /end-free                                                                                     
     P                 E                                                                            
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      *  hssf_date():  Shortcut for inserting a new cell that contains                              
      *        a date value into a given row of a sheet                                             
      *                                                                                             
      *    This is just a wrapper around the hssf_date2xls() and                                    
      *    hssf_num() routines.  (Dates in Excel are simply double                                  
      *    precision floating point numbers)                                                        
      *                                                                                             
      *    peRow = Row object that cell should be created in                                        
      *    peCol = column number of new cell                                                        
      * peNumber = numeric value to place in cell                                                   
      *  peStyle = cell style object to associate with cell                                         
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     P hssf_date       B                   EXPORT                                                   
     D hssf_date       PI                                                                           
     D   peRow                             like(HSSFRow)                                            
     D   peCol                        5I 0 value                                                    
     D   peDate                        D   value                                                    
     D   peStyle                           like(HSSFCellStyle)                                      
                                                                                                    
     D wwDate          s                   like(jDouble)                                            
                                                                                                    
      /free                                                                                         
         wwDate = hssf_date2xls(peDate);                                                            
         hssf_num(peRow: peCol: wwDate: peStyle);                                                   
      /end-free                                                                                     
     P                 E                                                                            
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      *  hssf_date2xls():                                                                           
      *    service program utility to convert an RPG date to a                                      
      *    number that can be formatted as a date in Excel                                          
      *                                                                                             
      *    peDate = RPG date to convert                                                             
      *                                                                                             
      *  returns the date formatted for Excel                                                       
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     P hssf_date2xls   B                   EXPORT                                                   
     D hssf_date2xls   PI                  like(jdouble)                                            
     D   peDate                        D   value                                                    
                                                                                                    
     D wwStrDate       s               d   inz(d'1900-01-01')                                       
     D wwDays          s                   like(jdouble)                                            
                                                                                                    
      ** Dates in Excel are simply double-precision floating point                                  
      ** numbers that represent the number of days since Jan 1, 1900                                
      ** with a few quirks:                                                                         
      **     1)  Jan 1st 1900 is considered day #1, not 0.                                          
      **     2)  1900 is counted as a leap year (despite that it wasn't)                            
      **     3)  Any fraction is considered a time of day.  For example,                            
      **              1.5 would be noon on Jan 1st, 1900.                                           
      **                                                                                            
                                                                                                    
      /free                                                                                         
                                                                                                    
         wwDays = %diff(peDate: wwStrDate: *DAYS) + 1;                                              
                                                                                                    
         // Excel incorrectly thinks that 1900-02-29 is                                             
         //  a valid date.                                                                          
                                                                                                    
         if (peDate > d'1900-02-28');                                                               
              wwDays = wwDays + 1;                                                                  
         endif;                                                                                     
                                                                                                    
         return wwDays;                                                                             
                                                                                                    
      /end-free                                                                                     
                                                                                                    
     P                 E                                                                            
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      *  hssf_xls2date():                                                                           
      *    service program utility to convert an Excel date to                                      
      *    an RPG date field                                                                        
      *                                                                                             
      *    peXls = Number used as a date in Excel                                                   
      *                                                                                             
      *  returns the RPG date                                                                       
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     P hssf_xls2date   B                   EXPORT                                                   
     D hssf_xls2date   PI              D                                                            
     D   peXls                             like(jdouble) value                                      
                                                                                                    
     D wwStrDate       s               d   inz(d'1900-01-01')                                       
     D wwDate          s               d                                                            
                                                                                                    
      **                                                                                            
      ** See hssf_date2xls for comments on how the Excel date format works                          
      **                                                                                            
      /free                                                                                         
                                                                                                    
         wwDate = wwStrDate + %days(%int(peXls) - 1);                                               
                                                                                                    
         // Excel incorrectly thinks that 1900-02-29 is                                             
         //  a valid date.                                                                          
                                                                                                    
         if (wwDate > d'1900-02-28');                                                               
              wwDate = wwDate - %days(1);                                                           
         endif;                                                                                     
                                                                                                    
         return wwDate;                                                                             
                                                                                                    
      /end-free                                                                                     
     P                 E                                                                            
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      *  hssf_formula(): Shortcut for inserting a new cell that contains                            
      *        a formla into a given row of a sheet                                                 
      *                                                                                             
      *     peRow = Row object that cell should be created in                                       
      *     peCol = column number of new cell                                                       
      * peFormula = formula to place in cell                                                        
      *   peStyle = cell style object to associate with cell                                        
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     P hssf_formula    B                   EXPORT                                                   
     D hssf_formula    PI                                                                           
     D   peRow                             like(HSSFRow)                                            
     D   peCol                        5I 0 value                                                    
     D   peFormula                 1024A   varying const                                            
     D   peStyle                           like(HSSFCellStyle)                                      
                                                                                                    
     D wwStr           s                   like(jString)                                            
     D wwCell          s                   like(HSSFCell)                                           
                                                                                                    
      /free                                                                                         
         wwCell = HSSFRow_createCell(peRow: peCol);                                                 
         HSSFCell_setCellType(wwCell: CELL_TYPE_FORMULA);                                           
         wwStr = new_String(peFormula);                                                             
         HSSFCell_setCellFormula(wwCell: wwStr);                                                    
         HSSFCell_setCellStyle(wwCell: peStyle);                                                    
         hssf_freeLocalRef(wwStr);                                                                  
         hssf_freeLocalRef(wwCell);                                                                 
      /end-free                                                                                     
     P                 E                                                                            
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      *  hssf_cellName(): Convert HSSF y,x coordinates into a cell name                             
      *     (example: 0,0 becomes A1, 110,24 becomes Y111)                                          
      *                                                                                             
      *        peRow = row number (A=0, B=1, etc)                                                   
      *        peCol = column number                                                                
      *                                                                                             
      *  Returns the alphanumeric cellname                                                          
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     P hssf_cellName   B                   EXPORT                                                   
     D hssf_cellName   PI            10A   varying                                                  
     D  peRow                         5I 0 value                                                    
     D  peCol                         5I 0 value                                                    
                                                                                                    
     D dsAlphabet      ds                  qualified static                                         
     D   whole                       26A   inz('ABCDEFGHIJKLMNOPQRSTUVWXYZ')                        
     D   letter                       1A   dim(26) overlay(whole)                                   
                                                                                                    
     D wwRem           s              5I 0                                                          
     D wwCN            s             10A   varying                                                  
                                                                                                    
      /free                                                                                         
                                                                                                    
         peRow = peRow + 1;                                                                         
         peCol = peCol + 1;                                                                         
                                                                                                    
         wwCN = '';                                                                                 
         dou peCol = 0;                                                                             
            wwRem = %rem(peCol: 26);                                                                
            peCol = %div(peCol: 26);                                                                
            if (wwRem = 0);                                                                         
                wwRem = 26;                                                                         
                peCol = peCol - 1;                                                                  
            endif;                                                                                  
            wwCN = dsAlphabet.letter(wwRem) + wwCN;                                                 
         enddo;                                                                                     
                                                                                                    
         wwCN = wwCN + %char(peRow);                                                                
         return wwCN;                                                                               
                                                                                                    
      /end-free                                                                                     
     P                 E                                                                            
                                                                                                    
                                                                                                    
      *-----------------------------------------------------------------                            
      *  hssf_get_jni_env():                                                                        
      *                                                                                             
      *  Service program utility to get a pointer to the JNI environment                            
      *  you'll need this pointer in order to call many of the JNI                                  
      *  routines.                                                                                  
      *                                                                                             
      *  returns the pointer, or *NULL upon error                                                   
      *-----------------------------------------------------------------                            
     P hssf_get_jni_env...                                                                          
     P                 B                   EXPORT                                                   
     D hssf_get_jni_env...                                                                          
     D                 PI              *                                                            
                                                                                                    
     D wwEnv           s               *                                                            
                                                                                                    
      /free                                                                                         
        wwEnv = attach_jvm();                                                                       
        if (wwEnv = *NULL);                                                                         
           wwEnv = start_jvm();                                                                     
        endif;                                                                                      
                                                                                                    
        return wwEnv;                                                                               
      /end-free                                                                                     
     P                 E                                                                            
                                                                                                    
                                                                                                    
      *-----------------------------------------------------------------                            
      *  hssf_freeLocalRef(Ref)                                                                     
      *                                                                                             
      *  Service program utility to free a local reference.                                         
      *                                                                                             
      *  Normally, when you call Java constructors from within Java,                                
      *  the JVM knows when they are no longer needed, and cleans                                   
      *  them up appropriately.   But, from within RPG, the JVM has                                 
      *  no way to know this.                                                                       
      *                                                                                             
      *  This utility routine will tell the JVM that you're done with                               
      *  an object, so that the cleanup routines will remove it.                                    
      *                                                                                             
      *      Usage:                                                                                 
      *               callp  freeLocalRef(ObjectName)                                               
      *                                                                                             
      *      for example, if you create a String, use it to create                                  
      *        an output stream, and then don't need the string anymore,                            
      *        you might do something like this:                                                    
      *                                                                                             
      *               eval   Blah = new_String('/path/to/myfile.txt')                               
      *               eval   File = new_FileOutputStream(Blah)                                      
      *               callp  freeLocalRef(Blah)                                                     
      *-----------------------------------------------------------------                            
     P hssf_freeLocalRef...                                                                         
     P                 B                   EXPORT                                                   
     D hssf_freeLocalRef...                                                                         
     D                 PI                                                                           
     D    peRef                            like(jobject)                                            
     D wwEnv           s               *   static inz(*null)                                        
                                                                                                    
      /free                                                                                         
                                                                                                    
          if (wwEnv = *NULL);                                                                       
              wwEnv = hssf_get_jni_env();                                                           
          endif;                                                                                    
                                                                                                    
          JNIENV_P = wwEnv;                                                                         
          DeleteLocalRef(wwEnv: peRef);                                                             
                                                                                                    
      /end-free                                                                                     
     P                 E                                                                            
                                                                                                    
                                                                                                    
      *-----------------------------------------------------------------                            
      * hssf_begin_object_group():  Start a new group of objects                                    
      *    which will all be freed when hssf_end_object_group()                                     
      *    gets called.                                                                             
      *                                                                                             
      *   peCapacity = maximum number of objects that can be                                        
      *        referenced within this object group.                                                 
      *                                                                                             
      *  NOTE: According to the 1.2 JNI Spec, you can create more                                   
      *        objects in the new frame than peCapacity allows.  The                                
      *        peCapacity is the guarenteed number.   When no object                                
      *        groups are used, 16 references are guarenteed, so if                                 
      *        you specify 16 here, that would be comparable to a                                   
      *        "default value".                                                                     
      *                                                                                             
      * Returns 0 if successful, or -1 upon error                                                   
      *-----------------------------------------------------------------                            
     P hssf_begin_object_group...                                                                   
     P                 B                   EXPORT                                                   
     D hssf_begin_object_group...                                                                   
     D                 PI            10I 0                                                          
     D    peCapacity                 10I 0 value                                                    
                                                                                                    
     D wwEnv           s               *                                                            
     D wwRC            s             10I 0                                                          
                                                                                                    
      /free                                                                                         
                                                                                                    
       wwEnv = hssf_get_jni_env();                                                                  
       if (wwEnv = *NULL);                                                                          
           return -1;                                                                               
       endif;                                                                                       
                                                                                                    
       JNIENV_P = wwEnv;                                                                            
                                                                                                    
       if  ( PushLocalFrame (wwEnv: peCapacity) <> JNI_OK );                                        
           return -1;                                                                               
       else;                                                                                        
           return 0;                                                                                
       endif;                                                                                       
                                                                                                    
      /end-free                                                                                     
     P                 E                                                                            
                                                                                                    
                                                                                                    
      *-----------------------------------------------------------------                            
      * hssf_end_object_group():  Frees all Java objects that                                       
      *    have been created since calling hssf_begin_object_group()                                
      *                                                                                             
      *        peOldObj = (see below)                                                               
      *        peNewObj = Sometimes it's desirable to preserve one                                  
      *            object by moving it from the current object group                                
      *            to the parent group.   These parameters allow you                                
      *            to make that move.                                                               
      *                                                                                             
      * Returns 0 if successful, or -1 upon error                                                   
      *-----------------------------------------------------------------                            
     P hssf_end_object_group...                                                                     
     P                 B                   EXPORT                                                   
     D hssf_end_object_group...                                                                     
     D                 PI            10I 0                                                          
     D   peOldObj                          like(jObject) const                                      
     D                                     options(*nopass)                                         
     D   peNewObj                          like(jObject)                                            
     D                                     options(*nopass)                                         
                                                                                                    
     D wwOld           s                   like(jObject) inz(*NULL)                                 
     D wwNew           s                   like(jObject)                                            
                                                                                                    
      /free                                                                                         
                                                                                                    
          JNIENV_p = hssf_get_jni_env();                                                            
          if (JNIENV_p = *NULL);                                                                    
              return -1;                                                                            
          endif;                                                                                    
                                                                                                    
          if %parms >= 2;                                                                           
              wwOld = peOldObj;                                                                     
          endif;                                                                                    
                                                                                                    
          wwNew = PopLocalFrame (JNIENV_p: wwOld);                                                  
                                                                                                    
          if %parms >= 2;                                                                           
              peNewObj = wwNew;                                                                     
          endif;                                                                                    
                                                                                                    
          return 0;                                                                                 
                                                                                                    
      /end-free                                                                                     
     P                 E                                                                            
                                                                                                    
                                                                                                    
      *-----------------------------------------------------------------                            
      * hssf_createDataFormat():  Shortcut routine to create a data fmt                             
      *                                                                                             
      *        peBook = (input) workbook to create the format in                                    
      *      peFormat = (input) string represending the data format                                 
      *                                                                                             
      * returns the data format's index in the workbook                                             
      *-----------------------------------------------------------------                            
     P hssf_CreateDataFormat...                                                                     
     P                 B                   EXPORT                                                   
     D hssf_CreateDataFormat...                                                                     
     D                 PI             5I 0                                                          
     D   peBook                            like(HSSFWorkbook) const                                 
     D   peFormat                   100A   varying const                                            
                                                                                                    
     D retval          s              5I 0                                                          
     D df              s                   like(HSSFDataFormat)                                     
     D TempStr         s                   like(jString)                                            
      /free                                                                                         
                                                                                                    
         df = HSSFWorkbook_createDataFormat(peBook);                                                
                                                                                                    
         TempStr = new_String(peFormat);                                                            
         retval = HSSFDataFormat_getFormat(df: TempStr);                                            
         hssf_freelocalref(TempStr);                                                                
                                                                                                    
         hssf_freelocalref(df);                                                                     
         return retval;                                                                             
                                                                                                    
      /end-free                                                                                     
     P                 E                                                                            
                                                                                                    
                                                                                                    
      *-----------------------------------------------------------------                            
      * hssf_createFont():  Shortcut routine to create a font                                       
      *                                                                                             
      *        peBook = (input) workbook to create the format in                                    
      *        peName = (input/omit) name of font to create                                         
      *   pePointSize = (input/omit) point size of font                                             
      *        peBold = (input/omit) bold weight of font                                            
      *   peUnderline = (input/omit) underline style                                                
      *      peItalic = (input/omit) set italic on/off                                              
      *   peStrikeout = (input/omit) set strikeout on/off                                           
      *       peColor = (input/omit) set font color                                                 
      *  peTypeOffset = (input/omit) set super/sub script                                           
      *                                                                                             
      * returns a new HSSFFont object                                                               
      *-----------------------------------------------------------------                            
     P hssf_CreateFont...                                                                           
     P                 B                   EXPORT                                                   
     D hssf_CreateFont...                                                                           
     D                 PI                  like(HSSFFont)                                           
     D   peBook                            like(HSSFWorkbook) const                                 
     D   peName                     100A   varying const options(*omit)                             
     D   pePointSize                  5I 0 const options(*omit)                                     
     D   peBold                       5I 0 const options(*omit)                                     
     D   peUnderline                  1A   const options(*omit)                                     
     D   peItalic                     1N   const options(*omit)                                     
     D   peStrikeout                  1N   const options(*omit)                                     
     D   peColor                      5I 0 const options(*omit)                                     
     D   peTypeOffset                 5I 0 const options(*omit)                                     
                                                                                                    
     D TempStr         s                   like(jString)                                            
     D f               s                   like(HSSFFont)                                           
      /free                                                                                         
                                                                                                    
         f = HSSFWorkbook_createFont(peBook);                                                       
                                                                                                    
         if (%addr(peName) <> *NULL);                                                               
            TempStr = new_String(peName);                                                           
            HSSFFont_setFontName(f: TempStr);                                                       
            hssf_freelocalref(TempStr);                                                             
         endif;                                                                                     
                                                                                                    
         if (%addr(pePointSize) <> *NULL);                                                          
             HSSFFont_setFontHeightInPoints(f: pePointSize);                                        
         endif;                                                                                     
                                                                                                    
         if (%addr(peBold) <> *NULL);                                                               
             HSSFFont_setBoldweight(f: peBold);                                                     
         endif;                                                                                     
                                                                                                    
         if (%addr(peUnderline) <> *NULL);                                                          
             HSSFFont_setUnderline(f: peUnderLine);                                                 
         endif;                                                                                     
                                                                                                    
         if (%addr(peItalic) <> *NULL);                                                             
             HSSFFont_setItalic(f: peItalic);                                                       
         endif;                                                                                     
                                                                                                    
         if (%addr(peStrikeout) <> *NULL);                                                          
             HSSFFont_setStrikeout(f: peStrikeout);                                                 
         endif;                                                                                     
                                                                                                    
         if (%addr(peColor) <> *NULL);                                                              
             HSSFFont_setColor(f: peColor);                                                         
         endif;                                                                                     
                                                                                                    
         if (%addr(peTypeOffset) <> *NULL);                                                         
             HSSFFont_setTypeOffset(f: peTypeOffset);                                               
         endif;                                                                                     
                                                                                                    
         return f;                                                                                  
                                                                                                    
      /end-free                                                                                     
     P                 E                                                                            
                                                                                                    
                                                                                                    
      *-----------------------------------------------------------------                            
      *  start_jvm():   Start the Java Virtual Machine (JVM)                                        
      *                                                                                             
      *  NOTE: Originally, this called JNI routines to start a new JVM,                             
      *        but that meant that a classpath and other options needed                             
      *        to be set manually in the JNI invocation.                                            
      *                                                                                             
      *        I decided that it would be better to reduce the complexity                           
      *        and let RPG start the JVM, so I merely create & destroy                              
      *        a string here so that RPG will automatically start the                               
      *        JVM for me.                                                                          
      *                                                                                             
      *  returns a pointer to the JNI environment                                                   
      *          or *NULL upon failure.                                                             
      *-----------------------------------------------------------------                            
     P start_jvm       B                                                                            
     D start_jvm       PI              *                                                            
                                                                                                    
     D wwStr           s                   like(jString)                                            
                                                                                                    
      /free                                                                                         
         wwStr = new_String('Temp String');                                                         
         hssf_freeLocalRef(wwStr);                                                                  
                                                                                                    
         return attach_jvm();                                                                       
        /end-free                                                                                   
     P                 E                                                                            
                                                                                                    
                                                                                                    
      *-----------------------------------------------------------------                            
      * attach_jvm():  Attach to JVM if it's running                                                
      *                                                                                             
      * Returns a pointer to the JNI environment, or *NULL upon error                               
      *-----------------------------------------------------------------                            
     P attach_jvm      B                                                                            
     D attach_jvm      PI              *                                                            
                                                                                                    
     D dsAtt           ds                  likeds(JavaVMAttachArgs)                                 
     D wwJVM           s                   like(JavaVM_p) dim(1)                                    
     D wwJVMc          s                   like(jSize)                                              
     D wwEnv           s               *   inz(*null)                                               
     D wwRC            s             10I 0                                                          
      /free                                                                                         
                                                                                                    
        monitor;                                                                                    
           wwRC = JNI_GetCreatedJavaVMs(wwJVM: 1: wwJVMc);                                          
                                                                                                    
           if (wwRC <> JNI_OK  or  wwJVMc = 0);                                                     
               return *NULL;                                                                        
           endif;                                                                                   
                                                                                                    
           JavaVM_P = wwJVM(1);                                                                     
           dsAtt = *ALLx'00';                                                                       
           dsAtt.version = JNI_VERSION_1_2;                                                         
                                                                                                    
           wwRC = AttachCurrentThread (wwJVM(1): wwEnv: %addr(dsAtt));                              
           if (wwRC <> JNI_OK);                                                                     
               wwEnv = *NULL;                                                                       
           endif;                                                                                   
                                                                                                    
        on-error;                                                                                   
           wwEnv = *NULL;                                                                           
        endmon;                                                                                     
                                                                                                    
        return wwEnv;                                                                               
                                                                                                    
      /end-free                                                                                     
     P                 E                                                                            
                                                                                                    
                                                                                                    
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
      * HSSF_header_setLeft(): Wrapper around the Java routine                                      
      *                        for HSSFHeader_setLeft()                                             
      *                                                                                             
      *     hdr = (input) header to set the left string for                                         
      *  string = (input) string to set                                                             
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
     P HSSF_header_setLeft...                                                                       
     P                 B                   export                                                   
     D HSSF_header_setLeft...                                                                       
     D                 PI                                                                           
     D    sheet                            like(HSSFSheet) const                                    
     D    string                   1024A   const varying options(*varsize)                          
     D tempHdr         s                   like(HSSFHeader)                                         
     D tempStr         s                   like(jString)                                            
      /free                                                                                         
          tempHdr = HSSFSheet_getHeader(sheet);                                                     
          tempStr = new_String(string);                                                             
          HSSFHeader_setLeft(tempHdr: tempStr);                                                     
          hssf_freelocalref(tempStr);                                                               
          hssf_freelocalref(tempHdr);                                                               
      /end-free                                                                                     
     P                 E                                                                            
                                                                                                    
                                                                                                    
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
      * HSSF_header_setCenter(): Wrapper around the Java routine                                    
      *                          for HSSFHeader_setCenter()                                         
      *                                                                                             
      *     hdr = (input) header to set the center string for                                       
      *  string = (input) string to set                                                             
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
     P HSSF_header_setCenter...                                                                     
     P                 B                   export                                                   
     D HSSF_header_setCenter...                                                                     
     D                 PI                                                                           
     D    sheet                            like(HSSFSheet) const                                    
     D    string                   1024A   const varying options(*varsize)                          
     D tempHdr         s                   like(HSSFHeader)                                         
     D tempStr         s                   like(jString)                                            
      /free                                                                                         
          tempHdr = HSSFSheet_getHeader(sheet);                                                     
          tempStr = new_String(string);                                                             
          HSSFHeader_setCenter(tempHdr: tempStr);                                                   
          hssf_freelocalref(tempStr);                                                               
          hssf_freelocalref(tempHdr);                                                               
      /end-free                                                                                     
     P                 E                                                                            
                                                                                                    
                                                                                                    
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
      * HSSF_header_setRight(): Wrapper around the Java routine                                     
      *                         for HSSFHeader_setRight()                                           
      *                                                                                             
      *     hdr = (input) header to set the right string for                                        
      *  string = (input) string to set                                                             
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
     P HSSF_header_setRight...                                                                      
     P                 B                   export                                                   
     D HSSF_header_setRight...                                                                      
     D                 PI                                                                           
     D    sheet                            like(HSSFSheet) const                                    
     D    string                   1024A   const varying options(*varsize)                          
     D tempHdr         s                   like(HSSFHeader)                                         
     D tempStr         s                   like(jString)                                            
      /free                                                                                         
          tempHdr = HSSFSheet_getHeader(sheet);                                                     
          tempStr = new_String(string);                                                             
          HSSFHeader_setRight(tempHdr: tempStr);                                                    
          hssf_freelocalref(tempStr);                                                               
          hssf_freelocalref(tempHdr);                                                               
      /end-free                                                                                     
     P                 E                                                                            
                                                                                                    
                                                                                                    
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
      * HSSF_header_date(): Retrieve special characters that                                        
      *                     indicate the current date in a                                          
      *                     header string                                                           
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
     P HSSF_header_date...                                                                          
     P                 B                   export                                                   
     D HSSF_header_date...                                                                          
     D                 PI          1024A   varying                                                  
      /free                                                                                         
          return String_getBytes(HSSFHeader_date());                                                
      /end-free                                                                                     
     P                 E                                                                            
                                                                                                    
                                                                                                    
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
      * HSSF_header_file(): Retrieve special characters that                                        
      *                     indicate the current filename in                                        
      *                     a header string                                                         
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
     P HSSF_header_file...                                                                          
     P                 B                   export                                                   
     D HSSF_header_file...                                                                          
     D                 PI          1024A   varying                                                  
      /free                                                                                         
          return String_getBytes(HSSFHeader_file());                                                
      /end-free                                                                                     
     P                 E                                                                            
                                                                                                    
                                                                                                    
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
      * HSSF_header_font(): Retrieve special characters that                                        
      *                     indicate a font of a particular                                         
      *                     name & style in a header string                                         
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
     P HSSF_header_font...                                                                          
     P                 B                   export                                                   
     D HSSF_header_font...                                                                          
     D                 PI          1024A   varying                                                  
     D    font                     1024A   varying const                                            
     D    style                    1024A   varying const                                            
     D f               s                   like(jString)                                            
     D s               s                   like(jString)                                            
     D retval          s           1024A   varying                                                  
      /free                                                                                         
          f = new_String(font);                                                                     
          s = new_String(style);                                                                    
          retval = String_getBytes(HSSFHeader_font(f:s));                                           
          hssf_freeLocalRef(f);                                                                     
          hssf_freeLocalRef(s);                                                                     
          return retval;                                                                            
      /end-free                                                                                     
     P                 E                                                                            
                                                                                                    
                                                                                                    
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
      * HSSF_header_fontSize(): Retrieve special characters                                         
      *                         that set the font size in a                                         
      *                         header string                                                       
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
     P HSSF_header_fontSize...                                                                      
     P                 B                   export                                                   
     D HSSF_header_fontSize...                                                                      
     D                 PI          1024A   varying                                                  
     D    size                        5U 0 value                                                    
      /free                                                                                         
          return String_getBytes(HSSFHeader_fontSize(size));                                        
      /end-free                                                                                     
     P                 E                                                                            
                                                                                                    
                                                                                                    
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
      * HSSF_header_numPages(): Retrieve special characters                                         
      *                         that insert the number of pages                                     
      *                         in the doc into a header string                                     
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
     P HSSF_header_numPages...                                                                      
     P                 B                   export                                                   
     D HSSF_header_numPages...                                                                      
     D                 PI          1024A   varying                                                  
      /free                                                                                         
          return String_getBytes(HSSFHeader_numPages());                                            
      /end-free                                                                                     
     P                 E                                                                            
                                                                                                    
                                                                                                    
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
      * HSSF_header_page(): Retrieve special characters                                             
      *                     that insert the current page                                            
      *                     number into a header string                                             
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
     P HSSF_header_page...                                                                          
     P                 B                   export                                                   
     D HSSF_header_page...                                                                          
     D                 PI          1024A   varying                                                  
      /free                                                                                         
          return String_getBytes(HSSFHeader_page());                                                
      /end-free                                                                                     
     P                 E                                                                            
                                                                                                    
                                                                                                    
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
      * HSSF_header_sheetName(): Retrieve special characters                                        
      *                          that insert the current sheet                                      
      *                          name (or "tab name") into a                                        
      *                          header string                                                      
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
     P HSSF_header_sheetName...                                                                     
     P                 B                   export                                                   
     D HSSF_header_sheetName...                                                                     
     D                 PI          1024A   varying                                                  
      /free                                                                                         
          return String_getBytes(HSSFHeader_sheetName());                                           
      /end-free                                                                                     
     P                 E                                                                            
                                                                                                    
                                                                                                    
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
      * HSSF_header_time(): Retrieve special characters                                             
      *                     that insert the current time                                            
      *                     into a header string.                                                   
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
     P HSSF_header_time...                                                                          
     P                 B                   export                                                   
     D HSSF_header_time...                                                                          
     D                 PI          1024A   varying                                                  
      /free                                                                                         
          return String_getBytes(HSSFHeader_time());                                                
      /end-free                                                                                     
     P                 E                                                                            
                                                                                                    
                                                                                                    
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
      * HSSF_footer_setLeft(): Wrapper around the Java routine                                      
      *                        for HSSFFooter_setLeft()                                             
      *                                                                                             
      *     hdr = (input) header to set the left string for                                         
      *  string = (input) string to set                                                             
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
     P HSSF_footer_setLeft...                                                                       
     P                 B                   export                                                   
     D HSSF_footer_setLeft...                                                                       
     D                 PI                                                                           
     D    sheet                            like(HSSFSheet) const                                    
     D    string                   1024A   const varying options(*varsize)                          
     D tempFtr         s                   like(HSSFFooter)                                         
     D tempStr         s                   like(jString)                                            
      /free                                                                                         
          tempFtr = HSSFSheet_getFooter(sheet);                                                     
          tempStr = new_String(string);                                                             
          HSSFFooter_setLeft(tempFtr: tempStr);                                                     
          hssf_freelocalref(tempStr);                                                               
          hssf_freelocalref(tempFtr);                                                               
      /end-free                                                                                     
     P                 E                                                                            
                                                                                                    
                                                                                                    
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
      * HSSF_footer_setCenter(): Wrapper around the Java routine                                    
      *                          for HSSFFooter_setCenter()                                         
      *                                                                                             
      *     hdr = (input) header to set the center string for                                       
      *  string = (input) string to set                                                             
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
     P HSSF_footer_setCenter...                                                                     
     P                 B                   export                                                   
     D HSSF_footer_setCenter...                                                                     
     D                 PI                                                                           
     D    sheet                            like(HSSFSheet) const                                    
     D    string                   1024A   const varying options(*varsize)                          
     D tempFtr         s                   like(HSSFFooter)                                         
     D tempStr         s                   like(jString)                                            
      /free                                                                                         
          tempFtr = HSSFSheet_getFooter(sheet);                                                     
          tempStr = new_String(string);                                                             
          HSSFFooter_setCenter(tempFtr: tempStr);                                                   
          hssf_freelocalref(tempStr);                                                               
          hssf_freelocalref(tempFtr);                                                               
      /end-free                                                                                     
     P                 E                                                                            
                                                                                                    
                                                                                                    
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
      * HSSF_footer_setRight(): Wrapper around the Java routine                                     
      *                         for HSSFFooter_setRight()                                           
      *                                                                                             
      *     hdr = (input) header to set the right string for                                        
      *  string = (input) string to set                                                             
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
     P HSSF_footer_setRight...                                                                      
     P                 B                   export                                                   
     D HSSF_footer_setRight...                                                                      
     D                 PI                                                                           
     D    sheet                            like(HSSFSheet) const                                    
     D    string                   1024A   const varying options(*varsize)                          
     D tempFtr         s                   like(HSSFFooter)                                         
     D tempStr         s                   like(jString)                                            
      /free                                                                                         
          tempFtr = HSSFSheet_getFooter(sheet);                                                     
          tempStr = new_String(string);                                                             
          HSSFFooter_setRight(tempFtr: tempStr);                                                    
          hssf_freelocalref(tempStr);                                                               
          hssf_freelocalref(tempFtr);                                                               
      /end-free                                                                                     
     P                 E                                                                            
                                                                                                    
                                                                                                    
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
      * HSSF_footer_date(): Retrieve special characters that                                        
      *                     indicate the current date in a                                          
      *                     header string                                                           
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
     P HSSF_footer_date...                                                                          
     P                 B                   export                                                   
     D HSSF_footer_date...                                                                          
     D                 PI          1024A   varying                                                  
      /free                                                                                         
          return String_getBytes(HSSFFooter_date());                                                
      /end-free                                                                                     
     P                 E                                                                            
                                                                                                    
                                                                                                    
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
      * HSSF_footer_file(): Retrieve special characters that                                        
      *                     indicate the current filename in                                        
      *                     a header string                                                         
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
     P HSSF_footer_file...                                                                          
     P                 B                   export                                                   
     D HSSF_footer_file...                                                                          
     D                 PI          1024A   varying                                                  
      /free                                                                                         
          return String_getBytes(HSSFFooter_file());                                                
      /end-free                                                                                     
     P                 E                                                                            
                                                                                                    
                                                                                                    
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
      * HSSF_footer_font(): Retrieve special characters that                                        
      *                     indicate a font of a particular                                         
      *                     name & style in a header string                                         
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
     P HSSF_footer_font...                                                                          
     P                 B                   export                                                   
     D HSSF_footer_font...                                                                          
     D                 PI          1024A   varying                                                  
     D    font                     1024A   varying const                                            
     D    style                    1024A   varying const                                            
     D f               s                   like(jString)                                            
     D s               s                   like(jString)                                            
     D retval          s           1024A   varying                                                  
      /free                                                                                         
          f = new_String(font);                                                                     
          s = new_String(style);                                                                    
          retval = String_getBytes(HSSFFooter_font(f:s));                                           
          hssf_freeLocalRef(f);                                                                     
          hssf_freeLocalRef(s);                                                                     
          return retval;                                                                            
      /end-free                                                                                     
     P                 E                                                                            
                                                                                                    
                                                                                                    
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
      * HSSF_footer_fontSize(): Retrieve special characters                                         
      *                         that set the font size in a                                         
      *                         header string                                                       
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
     P HSSF_footer_fontSize...                                                                      
     P                 B                   export                                                   
     D HSSF_footer_fontSize...                                                                      
     D                 PI          1024A   varying                                                  
     D    size                        5U 0 value                                                    
      /free                                                                                         
          return String_getBytes(HSSFFooter_fontSize(size));                                        
      /end-free                                                                                     
     P                 E                                                                            
                                                                                                    
                                                                                                    
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
      * HSSF_footer_numPages(): Retrieve special characters                                         
      *                         that insert the number of pages                                     
      *                         in the doc into a header string                                     
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
     P HSSF_footer_numPages...                                                                      
     P                 B                   export                                                   
     D HSSF_footer_numPages...                                                                      
     D                 PI          1024A   varying                                                  
      /free                                                                                         
          return String_getBytes(HSSFFooter_numPages());                                            
      /end-free                                                                                     
     P                 E                                                                            
                                                                                                    
                                                                                                    
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
      * HSSF_footer_page(): Retrieve special characters                                             
      *                     that insert the current page                                            
      *                     number into a header string                                             
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
     P HSSF_footer_page...                                                                          
     P                 B                   export                                                   
     D HSSF_footer_page...                                                                          
     D                 PI          1024A   varying                                                  
      /free                                                                                         
          return String_getBytes(HSSFFooter_page());                                                
      /end-free                                                                                     
     P                 E                                                                            
                                                                                                    
                                                                                                    
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
      * HSSF_footer_sheetName(): Retrieve special characters                                        
      *                          that insert the current sheet                                      
      *                          name (or "tab name") into a                                        
      *                          header string                                                      
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
     P HSSF_footer_sheetName...                                                                     
     P                 B                   export                                                   
     D HSSF_footer_sheetName...                                                                     
     D                 PI          1024A   varying                                                  
      /free                                                                                         
          return String_getBytes(HSSFFooter_sheetName());                                           
      /end-free                                                                                     
     P                 E                                                                            
                                                                                                    
                                                                                                    
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
      * HSSF_footer_time(): Retrieve special characters                                             
      *                     that insert the current time                                            
      *                     into a header string.                                                   
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
     P HSSF_footer_time...                                                                          
     P                 B                   export                                                   
     D HSSF_footer_time...                                                                          
     D                 PI          1024A   varying                                                  
      /free                                                                                         
          return String_getBytes(HSSFFooter_time());                                                
      /end-free                                                                                     
     P                 E                                                                            
                                                                                                    
                                                                                                    
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
      * HSSF_find_sheet(): Returns the index of a given sheet                                       
      *                                                                                             
      *      workbook = (input) workbook object to search                                           
      *         sheet = (input) sheet to get index of                                               
      *                                                                                             
      * Returns the index number or -1 if sheet is not                                              
      *         part of this workbook.                                                              
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
     P HSSF_find_sheet...                                                                           
     P                 B                   export                                                   
     D HSSF_find_sheet...                                                                           
     D                 PI            10I 0                                                          
     D   workbook                          like(HSSFWorkbook) const                                 
     D   sheet                             like(HSSFSheet) const                                    
                                                                                                    
     D getSheetAt      PR                  like(HSSFSheet)                                          
     D                                     ExtProc(*JAVA:                                           
     D                                     'org.apache.poi.hssf.-                                   
     D                                     usermodel.HSSFWorkbook':                                 
     D                                     'getSheetAt')                                            
     D   sheetIndex                        like(jint) value                                         
                                                                                                    
     D getNumberOfSheets...                                                                         
     D                 PR            10I 0                                                          
     D                                     ExtProc(*JAVA:                                           
     D                                     'org.apache.poi.hssf.-                                   
     D                                     usermodel.HSSFWorkbook':                                 
     D                                     'getNumberOfSheets')                                     
                                                                                                    
     D testEqual       PR             1N   ExtProc(*JAVA:                                           
     D                                     'java.lang.Object':                                      
     D                                     'equals')                                                
     D   object                        O   CLASS(*JAVA:'java.lang.Object')                          
     D                                     const                                                    
                                                                                                    
     D count           s             10I 0                                                          
     D x               s             10I 0                                                          
     D testsheet       s                   like(HSSFSheet)                                          
      /free                                                                                         
                                                                                                    
          count = getNumberOfSheets(workbook);                                                      
                                                                                                    
          for x = 0 to (count - 1);                                                                 
             testsheet = getSheetAt(workbook: x);                                                   
             if testEqual(testsheet: sheet);                                                        
                return x;                                                                           
             endif;                                                                                 
          endfor;                                                                                   
                                                                                                    
          return -1;                                                                                
                                                                                                    
      /end-free                                                                                     
     P                 E                                                                            
                                                                                                    
                                                                                                    
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
      * HSSF_setRepeating():  set the repeating rows & columns                                      
      *                                                                                             
      *      workbook = (input) workbook object to search                                           
      *         sheet = (input) sheet to get index of                                               
      *      startcol = (input) starting column to repeat                                           
      *        endcol = (input) ending column to repeat                                             
      *      startrow = (input) starting row to repeat                                              
      *        endrow = (input) ending row to repeat                                                
      *                                                                                             
      * NOTE: any of the above can be set to -1 to mean                                             
      *       "no change"                                                                           
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
     P HSSF_setRepeating...                                                                         
     P                 B                   export                                                   
     D HSSF_setRepeating...                                                                         
     D                 PI                                                                           
     D   workbook                          like(HSSFWorkbook) const                                 
     D   sheet                             like(HSSFSheet) const                                    
     D   startcol                    10I 0 value                                                    
     D   endcol                      10I 0 value                                                    
     D   startrow                    10I 0 value                                                    
     D   endrow                      10I 0 value                                                    
                                                                                                    
     D sheetno         s             10I 0                                                          
      /free                                                                                         
                                                                                                    
         sheetno = hssf_find_sheet(workbook: sheet);                                                
         if (sheetno = -1);                                                                         
            return;                                                                                 
         endif;                                                                                     
                                                                                                    
         HSSFWorkbook_setRepeatingRowsAndColumns( workbook                                          
                                                : sheetno                                           
                                                : startcol                                          
                                                : endcol                                            
                                                : startrow                                          
                                                : endrow );                                         
      /end-free                                                                                     
     P                 E                                                                            
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      *  hssf_open():  Open an existing HSSF Workbook                                               
      *                                                                                             
      *     peFilename = IFS path/filename of workbook to open                                      
      *                                                                                             
      *  Returns the HSSFWorkbook object opened                                                     
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     P hssf_open       B                   EXPORT                                                   
     D hssf_open       PI                  like(HSSFWorkbook)                                       
     D   peFilename                1024A   const varying                                            
                                                                                                    
     D jFileInputStream...                                                                          
     D                 S               O   CLASS(*JAVA                                              
     D                                     : 'java.io.FileInputStream')                             
                                                                                                    
     D jInputStream...                                                                              
     D                 S               O   CLASS(*JAVA                                              
     D                                     : 'java.io.InputStream')                                 
                                                                                                    
     D POIFSFilesystem...                                                                           
     D                 S               O   CLASS(*JAVA                                              
     D                                     : 'org.apache.poi.poifs-                                 
     D                                     .filesystem.POIFSFileSystem')                            
                                                                                                    
     D new_FileInputStream...                                                                       
     D                 pr              O   extproc(*JAVA                                            
     D                                     :'java.io.FileInputStream'                               
     D                                     : *CONSTRUCTOR)                                          
     D  filename                           like(jString) const                                      
                                                                                                    
     D new_POIFSFileSystem...                                                                       
     D                 pr              O   extproc(*JAVA                                            
     D                                     :'org.apache.poi.poifs-                                  
     D                                     .filesystem.POIFSFileSystem'                             
     D                                     : *CONSTRUCTOR)                                          
     D  stream                             like(jInputStream)                                       
                                                                                                    
     D new_HSSFWorkbookFromPOIFS...                                                                 
     D                 PR                  like(HSSFWorkbook)                                       
     D                                     ExtProc(*JAVA:                                           
     D                                     'org.apache.poi.hssf.usermodel-                          
     D                                     .HSSFWorkbook':                                          
     D                                     *CONSTRUCTOR)                                            
     D  poifs                              like(POIFSFileSystem)                                    
                                                                                                    
     D closeFile       PR                  EXTPROC(*JAVA                                            
     D                                     :'java.io.FileInputStream'                               
     D                                     :'close')                                                
                                                                                                    
     D wwStr           s                   like(jString)                                            
     D wwFile          s                   like(jFileOutputStream)                                  
     D wwPOIFS         s                   like(POIFSFileSystem)                                    
     D wwBook          s                   like(HSSFWorkbook)                                       
                                                                                                    
      /free                                                                                         
       monitor;                                                                                     
         wwStr   = new_String(peFilename);                                                          
         wwFile  = new_FileInputStream(wwStr);                                                      
         wwPOIFS = new_POIFSFileSystem(wwFile);                                                     
         wwBook  = new_HSSFWorkbookFromPOIFS(wwPOIFS);                                              
                                                                                                    
         closeFile(wwFile);                                                                         
                                                                                                    
       on-error;                                                                                    
         wwStr   = new_String(peFilename);                                                          
         wwFile  = new_FileInputStream(wwStr);                                                      
         wwPOIFS = new_POIFSFileSystem(wwFile);                                                     
         wwBook  = new_HSSFWorkbookFromPOIFS(wwPOIFS);                                              
                                                                                                    
         closeFile(wwFile);                                                                         
       endmon;                                                                                      
                                                                                                    
         hssf_freeLocalRef(wwPOIFS);                                                                
         hssf_freeLocalRef(wwFile);                                                                 
         hssf_freeLocalRef(wwStr);                                                                  
                                                                                                    
         return wwBook;                                                                             
      /end-free                                                                                     
     P                 E                                                                            
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      * hssf_getSheet(): Get the sheet object from a workbook                                       
      *                                                                                             
      *        peBook = workbook to retrieve sheet from                                             
      *   peSheetName = worksheet name to retrieve                                                  
      *                                                                                             
      * Returns the HSSFSheet object                                                                
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     P hssf_getSheet   B                   EXPORT                                                   
     D hssf_getSheet   PI                  like(HSSFSheet)                                          
     D   peBook                            like(HSSFWorkbook)                                       
     D   peSheetName               1024A   varying const                                            
                                                                                                    
     D wwStr           s                   like(jString)                                            
     D wwSheet         s                   like(HSSFSheet)                                          
      /free                                                                                         
                                                                                                    
         wwStr = new_String(peSheetName);                                                           
         wwSheet = HSSFWorkbook_getSheet(peBook: wwStr);                                            
                                                                                                    
         hssf_freeLocalRef(wwStr);                                                                  
                                                                                                    
         return wwSheet;                                                                            
      /end-free                                                                                     
     P                 E                                                                            
