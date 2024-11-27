      /if not defined(HSSF_H)                                                                       
                                                                                                    
      /define OS400_JVM_12                                                                          
      /copy QSYSINC/QRPGLESRC,JNI                                                                   
                                                                                                    
      *-----------------------------------------------------------------                            
      *  jFileOutputStream = the Java FileOutputStream class                                        
      *-----------------------------------------------------------------                            
     D jFileOutputStream...                                                                         
     D                 S               O   CLASS(*JAVA                                              
     D                                     :'java.io.FileOutputStream')                             
                                                                                                    
      *-----------------------------------------------------------------                            
      *  jOutputStream = the Java OutputStream class                                                
      *-----------------------------------------------------------------                            
     D jOutputStream   S               O   CLASS(*JAVA                                              
     D                                     :'java.io.OutputStream')                                 
                                                                                                    
      *-----------------------------------------------------------------                            
      *  new String(byte[] chars)                                                                   
      *  Constructor for Java String object                                                         
      *                                                                                             
      *  Routine from the Java Runtime Environment.                                                 
      *-----------------------------------------------------------------                            
     D new_String      PR                  like(jString)                                            
     D                                     EXTPROC(*JAVA                                            
     D                                     :'java.lang.String'                                      
     D                                     :*CONSTRUCTOR)                                           
     D create_from                 1024A   VARYING const                                            
                                                                                                    
                                                                                                    
      *-----------------------------------------------------------------                            
      *  new FileOutputStream(String filename)                                                      
      *                                                                                             
      *  Constructor for Java FileOutputStream class which is used                                  
      *  to write new stream files.                                                                 
      *                                                                                             
      *  Routine from the Java Runtime Environment.                                                 
      *                                                                                             
      *  filename = the file to create (IFS format)                                                 
      *-----------------------------------------------------------------                            
     D new_FileOutputStream...                                                                      
     D                 PR                  like(jFileOutputStream)                                  
     D                                     EXTPROC(*JAVA                                            
     D                                     :'java.io.FileOutputStream'                              
     D                                     :*CONSTRUCTOR)                                           
     D filename                            like(jString)                                            
                                                                                                    
                                                                                                    
      *-----------------------------------------------------------------                            
      * FileOutputStream_close():  Close a stream file that was opened                              
      *            for output.                                                                      
      *-----------------------------------------------------------------                            
     D FileOutputStream_close...                                                                    
     D                 pr                  EXTPROC(*JAVA                                            
     D                                     :'java.io.FileOutputStream'                              
     D                                     :'close')                                                
                                                                                                    
                                                                                                    
      ******************************************************************                            
      *  HSSF Data Types                                                                            
      ******************************************************************                            
     D HSSFWorkbook    S               O   CLASS(*JAVA                                              
     D                                     :'org.apache.poi.hssf.usermodel-                         
     D                                     .HSSFWorkbook')                                          
     D HSSFSheet       S               O   CLASS(*JAVA                                              
     D                                     :'org.apache.poi.hssf.usermodel-                         
     D                                     .HSSFSheet')                                             
     D HSSFRow         S               O   CLASS(*JAVA                                              
     D                                     :'org.apache.poi.hssf.usermodel-                         
     D                                     .HSSFRow')                                               
     D HSSFCell        S               O   CLASS(*JAVA                                              
     D                                     :'org.apache.poi.hssf.usermodel-                         
     D                                     .HSSFCell')                                              
     D HSSFFont        S               O   CLASS(*JAVA                                              
     D                                     :'org.apache.poi.hssf.usermodel-                         
     D                                     .HSSFFont')                                              
     D HSSFCellStyle   S               O   CLASS(*JAVA                                              
     D                                     :'org.apache.poi.hssf.usermodel-                         
     D                                     .HSSFCellStyle')                                         
     D HSSFDataFormat  S               O   CLASS(*JAVA                                              
     D                                     :'org.apache.poi.hssf.usermodel-                         
     D                                     .HSSFDataFormat')                                        
     D Region          S               O   CLASS(*JAVA                                              
     D                                     :'org.apache.poi.hssf.util.Region')                      
     D HSSFHeader      S               O   CLASS(*JAVA                                              
     D                                     :'org.apache.poi.hssf.usermodel-                         
     D                                     .HSSFHeader')                                            
     D HSSFFooter      S               O   CLASS(*JAVA                                              
     D                                     :'org.apache.poi.hssf.usermodel-                         
     D                                     .HSSFFooter')                                            
     D HSSFPrintSetup  S               O   CLASS(*JAVA                                              
     D                                     :'org.apache.poi.hssf.usermodel-                         
     D                                     .HSSFPrintSetup')                                        
                                                                                                    
                                                                                                    
      *-----------------------------------------------------------------                            
      *  hssf_get_jni_env(): Get pointer to JNI Environment                                         
      *                                                                                             
      *  (Routine from the HSSFR4 service program)                                                  
      *  Used by many of the other JNI routines.                                                    
      *                                                                                             
      *  returns the pointer, or *NULL upon error                                                   
      *-----------------------------------------------------------------                            
     D hssf_get_jni_env...                                                                          
     D                 PR              *                                                            
                                                                                                    
                                                                                                    
      *-----------------------------------------------------------------                            
      *  httf_freeLocalRef(Ref)                                                                     
      *                                                                                             
      *  Utility routine in the HSSFR4 service program.                                             
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
     D hssf_freeLocalRef...                                                                         
     D                 PR                                                                           
     D    peRef                            like(jobject)                                            
                                                                                                    
                                                                                                    
      *-----------------------------------------------------------------                            
      * hssf_begin_object_group():  Start a new group of objects                                    
      *    which will all be freed when hssf_end_object_group()                                     
      *    gets called.                                                                             
      *                                                                                             
      *  Utility routine in the HSSFR4 service program.                                             
      *                                                                                             
      *   peCapacity = maximum number of objects that can be                                        
      *        referenced within this object group.                                                 
      *                                                                                             
      *  NOTE: According to the 1.2 JNI Spec, you can create more                                   
      *        objects in the new frame than peCapacity allows.  The                                
      *        peCapacity is the guarenteed number. When no object                                  
      *        groups are used, 16 references are guarenteed, so if                                 
      *        you specify 16 here, that would be comparable to a                                   
      *        "default value".                                                                     
      *                                                                                             
      * Returns 0 if successful, or -1 upon error                                                   
      *-----------------------------------------------------------------                            
     D HSSF_DFT_GROUP_CAPACITY...                                                                   
     D                 C                   CONST(16)                                                
     D hssf_begin_object_group...                                                                   
     D                 PR            10I 0                                                          
     D    peCapacity                 10I 0 value                                                    
                                                                                                    
                                                                                                    
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
     D hssf_end_object_group...                                                                     
     D                 PR            10I 0                                                          
     D   peOldObj                          like(jObject) const                                      
     D                                     options(*nopass)                                         
     D   peNewObj                          like(jObject)                                            
     D                                     options(*nopass)                                         
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      *  new_HSSFWorkbook()                                                                         
      *      Create a new HSSF (Excel) workbook                                                     
      *                                                                                             
      *   Returns the new HSSFWorkbook object                                                       
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D new_HSSFWorkbook...                                                                          
     D                 PR                  like(HSSFWorkbook)                                       
     D                                     ExtProc(*JAVA:                                           
     D                                     'org.apache.poi.hssf.usermodel-                          
     D                                     .HSSFWorkbook':                                          
     D                                     *CONSTRUCTOR)                                            
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      *  new_Region()                                                                               
      *    Creates a new Region object, identifying a section of                                    
      *    the spreadsheet                                                                          
      *                                                                                             
      *    rowFrom = starting row number. (The rows are numbered from 0,                            
      *            so they're always one less than they appear in Excel)                            
      *    colFrom = starting column num. (The cols are numbered from 0,                            
      *            so col A = 0, Col B = 1, etc)                                                    
      *    rowTo   = ending row number                                                              
      *    colTo   = ending column number                                                           
      *                                                                                             
      *  returns new Region object                                                                  
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D new_Region...                                                                                
     D                 PR                  like(Region)                                             
     D                                     ExtProc(*JAVA                                            
     D                                     :'org.apache.poi.hssf.util.Region'                       
     D                                     :*CONSTRUCTOR)                                           
     D   rowFrom                           like(jint)   value                                       
     D   colFrom                           like(jshort) value                                       
     D   rowTo                             like(jint)   value                                       
     D   colTo                             like(jshort) value                                       
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      *  HSSFWorkbook_write():  write workbook to output stream                                     
      *                                                                                             
      *     output_stream = FileOutputStream object to write the                                    
      *            workbook to.                                                                     
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D HSSFWorkbook_write...                                                                        
     D                 PR                  EXTPROC(*JAVA                                            
     D                                     :'org.apache.poi.hssf.usermodel-                         
     D                                     .HSSFWorkbook'                                           
     D                                     :'write')                                                
     D output_stream                       like(jOutputStream)                                      
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      *  HSSFWorkbook_createSheet():                                                                
      *    create new sheet in a workbook                                                           
      *                                                                                             
      *    sheetname = name of sheet to create                                                      
      *                                                                                             
      *  Returns the HSSFSheet object                                                               
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D HSSFWorkbook_createSheet...                                                                  
     D                 PR                  like(HSSFSheet)                                          
     D                                     EXTPROC(*JAVA                                            
     D                                     :'org.apache.poi.hssf.usermodel-                         
     D                                     .HSSFWorkbook'                                           
     D                                     :'createSheet')                                          
     D  sheetname                          like(jString)                                            
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      * HSSFPrintSetup_SetLandscape...                                                              
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D HSSFPrintSetup_setLandscape...                                                               
     D                 PR                  EXTPROC(*JAVA                                            
     D                                     :'org.apache.poi.hssf.usermodel-                         
     D                                     .HSSFPrintSetup'                                         
     D                                     :'setLandscape')                                         
     D   LandScape                     N   value                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      * HSSFPrintSetup_SetScale...                                                                  
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D HSSFPrintSetup_setScale...                                                                   
     D                 PR                  EXTPROC(*JAVA                                            
     D                                     :'org.apache.poi.hssf.usermodel-                         
     D                                     .HSSFPrintSetup'                                         
     D                                     :'setScale')                                             
     D   Scale                             like(jshort) value                                       
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      * HSSFPrintSetup_SetFitWidth...                                                               
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D HSSFPrintSetup_SetFitWidth...                                                                
     D                 PR                  EXTPROC(*JAVA                                            
     D                                     :'org.apache.poi.hssf.usermodel-                         
     D                                     .HSSFPrintSetup'                                         
     D                                     :'setFitWidth')                                          
     D   SetFitWidth                       like(jshort) value                                       
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      * HSSFPrintSetup_SetFitHeight...                                                              
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D HSSFPrintSetup_SetFitHeight...                                                               
     D                 PR                  EXTPROC(*JAVA                                            
     D                                     :'org.apache.poi.hssf.usermodel-                         
     D                                     .HSSFPrintSetup'                                         
     D                                     :'setFitHeight')                                         
     D   SetFitHeight                       like(jshort) value                                      
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      * HSSFSheet_SetAutobreaks...                                                                  
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D HSSFSheet_setAutobreaks...                                                                   
     D                 PR                  EXTPROC(*JAVA                                            
     D                                     :'org.apache.poi.hssf.usermodel-                         
     D                                     .HSSFSheet'                                              
     D                                     :'setAutobreaks')                                        
     D   Autobreaks                    N   value                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      * HSSFSheet_createFreezePane...                                                               
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D HSSFSheet_createFreezePane...                                                                
     D                 PR                  EXTPROC(*JAVA                                            
     D                                     :'org.apache.poi.hssf.usermodel-                         
     D                                     .HSSFSheet'                                              
     D                                     :'createFreezePane')                                     
     D   xtopfrz                           like(jint) value                                         
     D   ytopfrz                           like(jint) value                                         
     D   xbottomfrz                        like(jint) value                                         
     D   ybottomfrz                        like(jint) value                                         
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      * HSSFSheet_groupColumn...                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D HSSFSheet_groupColumn...                                                                     
     D                 PR                  EXTPROC(*JAVA                                            
     D                                     :'org.apache.poi.hssf.usermodel-                         
     D                                     .HSSFSheet'                                              
     D                                     :'groupColumn')                                          
     D   xfromcolumn                       like(jshort) value                                       
     D   ytocolumn                         like(jshort) value                                       
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      * HSSFSheet_groupRow...                                                                       
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D HSSFSheet_groupRow...                                                                        
     D                 PR                  EXTPROC(*JAVA                                            
     D                                     :'org.apache.poi.hssf.usermodel-                         
     D                                     .HSSFSheet'                                              
     D                                     :'groupRow')                                             
     D   xfromrow                          like(jint) value                                         
     D   ytorow                            like(jint) value                                         
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      *  HSSFWorkbook_createDataFormat():                                                           
      *   Create a dataformat object, which can be used to translate                                
      *   from string representations of Excel data formats to                                      
      *   the internal representations required by the CellStyle object                             
      *                                                                                             
      *  Returns the HSSFDataFormat object                                                          
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D HSSFWorkbook_createDataFormat...                                                             
     D                 PR                  like(HSSFDataFormat)                                     
     D                                     EXTPROC(*JAVA                                            
     D                                     :'org.apache.poi.hssf.usermodel-                         
     D                                     .HSSFWorkbook'                                           
     D                                     :'createDataFormat')                                     
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      *  HSSFWorkbook_createCellStyle():                                                            
      *    Creates an HSSFCellStyle object which can then be used                                   
      *    to format the way text is displayed in one or more cells                                 
      *                                                                                             
      *  Returns a new HSSFCellStyle object                                                         
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D HSSFWorkbook_createCellStyle...                                                              
     D                 PR                  like(HSSFCellStyle)                                      
     D                                     EXTPROC(*JAVA                                            
     D                                     :'org.apache.poi.hssf.usermodel-                         
     D                                     .HSSFWorkbook'                                           
     D                                     :'createCellStyle')                                      
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      *  HSSFWorkbook_createFont():                                                                 
      *     create a new HSSFFont object, which can be used to change                               
      *     the way text is displayed in an HSSFCellStyle object                                    
      *                                                                                             
      *  Returns the HSSFFont object                                                                
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D HSSFWorkbook_createFont...                                                                   
     D                 PR                  like(HSSFFont)                                           
     D                                     EXTPROC(*JAVA                                            
     D                                     :'org.apache.poi.hssf.usermodel-                         
     D                                     .HSSFWorkbook'                                           
     D                                     :'createFont')                                           
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      *  HSSFWorkbook_setSheetName():                                                               
      *     set the name of a sheet in the workbook                                                 
      *                                                                                             
      *     sheet = ordinal number that specifies the sheet to rename                               
      *      name = new name of sheet                                                               
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D HSSFWorkbook_setSheetName...                                                                 
     D                 PR                  EXTPROC(*JAVA                                            
     D                                     :'org.apache.poi.hssf.usermodel-                         
     D                                     .HSSFWorkbook'                                           
     D                                     :'setSheetName')                                         
     D  sheet                              like(jint)    value                                      
     D  name                               like(jString)                                            
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      *  HSSFWorkbook_setRepeatingRowsAndColumns()                                                  
      *     mark a range of rows & columns to repeat on each page                                   
      *     of a printed report.                                                                    
      *                                                                                             
      *   sheetno = (input) ordinal number specifying the sheet                                     
      *  startcol = (input) starting col number to repeat (or -1)                                   
      *    endcol = (input) ending col number to repeat (or -1)                                     
      *  startrow = (input) startng row number to repeat (or -1)                                    
      *    endrow = (input) ending row number to repeat (or -1)                                     
      *                                                                                             
      * When a row/column is set to -1, that value does not get                                     
      * changed.                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D HSSFWorkbook_setRepeatingRowsAndColumns...                                                   
     D                 PR                  EXTPROC(*JAVA                                            
     D                                     :'org.apache.poi.hssf.usermodel-                         
     D                                     .HSSFWorkbook'                                           
     D                                     :'setRepeatingRowsAndColumns')                           
     D  sheetno                            like(jint) value                                         
     D  startcol                           like(jint) value                                         
     D  endcol                             like(jint) value                                         
     D  startrow                           like(jint) value                                         
     D  endrow                             like(jint) value                                         
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      *  HSSFSheet_createRow()                                                                      
      *     create a new row of cells in an HSSFSheet                                               
      *                                                                                             
      *    row_number = the number of the row to create.  Rows are                                  
      *         numbered starting at 0... so a row that shows up as                                 
      *         Row 5 in Excel will be Row 4 here.                                                  
      *                                                                                             
      *  returns the new HSSFRow object                                                             
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D HSSFSheet_createRow...                                                                       
     D                 PR                  like(HSSFRow)                                            
     D                                     EXTPROC(*JAVA                                            
     D                                     :'org.apache.poi.hssf.usermodel-                         
     D                                     .HSSFSheet'                                              
     D                                     :'createRow')                                            
     D row_number                          like(jint) value                                         
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      *  HSSFSheet_setColumnWidth():                                                                
      *     Set the width of a column in an HSSFSheet object                                        
      *                                                                                             
      *   column = column number.  Columns are numbered starting with 0,                            
      *         so Excel Column A is 0, Col B is 1, etc.                                            
      *    width = width of column in 1/256th of a character.                                       
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D HSSFSheet_setColumnWidth...                                                                  
     D                 PR                  EXTPROC(*JAVA                                            
     D                                     :'org.apache.poi.hssf.usermodel-                         
     D                                     .HSSFSheet'                                              
     D                                     :'setColumnWidth')                                       
     D column                              like(jshort) value                                       
     D width                               like(jshort) value                                       
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      * HSSFSheet_addMergedRegion():                                                                
      *   Merges all of the cells in a Region of a HSSFSheet                                        
      *                                                                                             
      *    merge_region = Region object representing the cells to merge                             
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D HSSFSheet_addMergedRegion...                                                                 
     D                 PR                  like(jint)                                               
     D                                     EXTPROC(*JAVA                                            
     D                                     :'org.apache.poi.hssf.usermodel-                         
     D                                     .HSSFSheet'                                              
     D                                     :'addMergedRegion')                                      
     D   merge_region                      like(Region)                                             
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      * HSSFSheet_getHeader(): Retrieve the header from an HSSFSheet                                
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D HSSFSheet_getHeader...                                                                       
     D                 PR                  like(HSSFHeader)                                         
     D                                     EXTPROC(*JAVA                                            
     D                                     :'org.apache.poi.hssf.usermodel-                         
     D                                     .HSSFSheet'                                              
     D                                     :'getHeader')                                            
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      * HSSFPrintSetup_getPrintSetup():Retrieve the print setup                                     
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D HSSFSheet_getPrintSetup...                                                                   
     D                 PR                  Like(HSSFPrintSetup)                                     
     D                                     EXTPROC(*JAVA                                            
     D                                     :'org.apache.poi.hssf.usermodel-                         
     D                                     .HSSFSheet'                                              
     D                                     :'getPrintSetup')                                        
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      * HSSFSheet_getFooter(): Retrieve the footer from an HSSFSheet                                
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D HSSFSheet_getFooter...                                                                       
     D                 PR                  like(HSSFFooter)                                         
     D                                     EXTPROC(*JAVA                                            
     D                                     :'org.apache.poi.hssf.usermodel-                         
     D                                     .HSSFSheet'                                              
     D                                     :'getFooter')                                            
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      * HSSFRow_createCell()                                                                        
      *   Create a new cell in a given HSSFRow                                                      
      *                                                                                             
      *   column_number = number of column within the row that the                                  
      *        cell should be created as.   Columns are numbered from                               
      *        0, so column A is 0, col B is 1, etc.                                                
      *                                                                                             
      * Returns a new HSSFCell object                                                               
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D HSSFRow_createCell...                                                                        
     D                 PR                  like(HSSFCell)                                           
     D                                     EXTPROC(*JAVA                                            
     D                                     :'org.apache.poi.hssf.usermodel-                         
     D                                     .HSSFRow'                                                
     D                                     :'createCell')                                           
     D column_number                       like(jshort) value                                       
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      * HSSFRow_setHeight()                                                                         
      *   Set the height of a row.                                                                  
      *                                                                                             
      *     height = new height in twips (1/20" of a point)                                         
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D HSSFRow_setHeight...                                                                         
     D                 PR                  EXTPROC(*JAVA                                            
     D                                     :'org.apache.poi.hssf.usermodel-                         
     D                                     .HSSFRow'                                                
     D                                     :'setHeight')                                            
     D height                              like(jshort) value                                       
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      * HSSFRow_setHeightInPoints()                                                                 
      *   Set the height of a row                                                                   
      *                                                                                             
      *     height = new height in points.  (can be fractional)                                     
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D HSSFRow_setHeightInPoints...                                                                 
     D                 PR                  EXTPROC(*JAVA                                            
     D                                     :'org.apache.poi.hssf.usermodel-                         
     D                                     .HSSFRow'                                                
     D                                     :'setHeightInPoints')                                    
     D height                              like(jfloat) value                                       
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      *  HSSFCell_setCellType():                                                                    
      *    Set the data type for a given cell                                                       
      *                                                                                             
      *    cell_type = type of cell.   See the CELL_TYPE_XXX constants                              
      *            below for possible values                                                        
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D HSSFCell_setCellType...                                                                      
     D                 PR                  EXTPROC(*JAVA                                            
     D                                     :'org.apache.poi.hssf.usermodel-                         
     D                                     .HSSFCell'                                               
     D                                     :'setCellType')                                          
     D cell_type                           like(jint) value                                         
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      *   HSSFCell_setCellStyle():                                                                  
      *     Associate a HSSFCellStyle object with a given Cell                                      
      *     so that the cell will be displayed using the attributes                                 
      *     of the Cell Style.                                                                      
      *                                                                                             
      *   cell_style = cell style object to associate with this cell                                
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D HSSFCell_setCellStyle...                                                                     
     D                 PR                  EXTPROC(*JAVA                                            
     D                                     :'org.apache.poi.hssf.usermodel-                         
     D                                     .HSSFCell'                                               
     D                                     :'setCellStyle')                                         
     D cell_style                          like(HSSFCellStyle)                                      
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      * HSSFCell_setCellValue()                                                                     
      *    Set the value of a cell.                                                                 
      *    (use setCellValueStr() to set a string object, or                                        
      *         setCellValueD() to set a double/numeric object)                                     
      *                                                                                             
      *   cell_value = new value of cell.                                                           
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D HSSFCell_setCellValueStr...                                                                  
     D                 PR                  EXTPROC(*JAVA                                            
     D                                     :'org.apache.poi.hssf.usermodel-                         
     D                                     .HSSFCell'                                               
     D                                     :'setCellValue')                                         
     D cell_value                          like(jString)                                            
     D HSSFCell_setCellValueD...                                                                    
     D                 PR                  EXTPROC(*JAVA                                            
     D                                     :'org.apache.poi.hssf.usermodel-                         
     D                                     .HSSFCell'                                               
     D                                     :'setCellValue')                                         
     D cell_value                          like(jdouble) value                                      
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      * HSSFCell_setCellFormula()                                                                   
      *    Set the formula to be placed in a cell                                                   
      *                                                                                             
      *   cell_formula = new formula for cell.                                                      
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D HSSFCell_setCellFormula...                                                                   
     D                 PR                  EXTPROC(*JAVA                                            
     D                                     :'org.apache.poi.hssf.usermodel-                         
     D                                     .HSSFCell'                                               
     D                                     :'setCellFormula')                                       
     D cell_formula                        like(jString)                                            
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      * HSSFCellStyle_setFont()                                                                     
      *    Associate a given HSSFFont object with a HSSFCellStyle object                            
      *                                                                                             
      *   font = HSSFFont object to associate with this cell style                                  
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D HSSFCellStyle_setFont...                                                                     
     D                 PR                  EXTPROC(*JAVA                                            
     D                                     :'org.apache.poi.hssf.usermodel-                         
     D                                     .HSSFCellStyle'                                          
     D                                     :'setFont')                                              
     D   font                              like(HSSFFont)                                           
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      * HSSFCellStyle_setFillBackgroundColor...                                                     
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D HSSFCellStyle_setFillBackgroundColor...                                                      
     D                 PR                  EXTPROC(*JAVA                                            
     D                                     :'org.apache.poi.hssf.usermodel-                         
     D                                     .HSSFCellStyle'                                          
     D                                     :'setFillBackgroundColor')                               
     D   BackGround                        like(jshort) value                                       
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      * HSSFCellStyle_setFillBackgroundColor...                                                     
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D HSSFCellStyle_setFillForegroundColor...                                                      
     D                 PR                  EXTPROC(*JAVA                                            
     D                                     :'org.apache.poi.hssf.usermodel-                         
     D                                     .HSSFCellStyle'                                          
     D                                     :'setFillForegroundColor')                               
     D   ForeGround                        like(jshort) value                                       
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      * HSSFCellStyle_setFillPattern...                                                             
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D HSSFCellStyle_setFillPattern...                                                              
     D                 PR                  EXTPROC(*JAVA                                            
     D                                     :'org.apache.poi.hssf.usermodel-                         
     D                                     .HSSFCellStyle'                                          
     D                                     :'setFillPattern')                                       
     D   FillPattern                       like(jshort) value                                       
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      * HSSFCellStyle_setDataFormat():                                                              
      *   Set the data format of this cell (i.e. how numbers or dates                               
      *      or etc are formatted when displayed)                                                   
      *                                                                                             
      *   dataformat = internal numeric representation of data format.                              
      *       Use HSSFDataFormat object to get this internal rep.                                   
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D HSSFCellStyle_setDataFormat...                                                               
     D                 PR                  EXTPROC(*JAVA                                            
     D                                     :'org.apache.poi.hssf.usermodel-                         
     D                                     .HSSFCellStyle'                                          
     D                                     :'setDataFormat')                                        
     D   dataformat                        like(jshort) value                                       
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      *  HSSFCellStyle_setAlignment()                                                               
      *     Choose how text is aligned for a given cell style                                       
      *                                                                                             
      *   align = alignment of this cell style.  See the ALIGN_XXX                                  
      *       constants below for possible values                                                   
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D HSSFCellStyle_setAlignment...                                                                
     D                 PR                  EXTPROC(*JAVA                                            
     D                                     :'org.apache.poi.hssf.usermodel-                         
     D                                     .HSSFCellStyle'                                          
     D                                     :'setAlignment')                                         
     D   align                             like(jshort) value                                       
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      * HSSFCellStyle_setBorderBottom()                                                             
      *    Set the type of border to be used at the bottom of cells                                 
      *    that use this cell style                                                                 
      *                                                                                             
      *  border = border style to use.   See the BORDER_XXX constants                               
      *      below for possible values                                                              
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D HSSFCellStyle_setBorderBottom...                                                             
     D                 PR                  EXTPROC(*JAVA                                            
     D                                     :'org.apache.poi.hssf.usermodel-                         
     D                                     .HSSFCellStyle'                                          
     D                                     :'setBorderBottom')                                      
     D   border                            like(jshort) value                                       
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      * HSSFCellStyle_setBorderTop()                                                                
      *    Set the type of border to be used at the top of cells                                    
      *    that use this cell style                                                                 
      *                                                                                             
      *  border = border style to use.   See the BORDER_XXX constants                               
      *      below for possible values                                                              
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D HSSFCellStyle_setBorderTop...                                                                
     D                 PR                  EXTPROC(*JAVA                                            
     D                                     :'org.apache.poi.hssf.usermodel-                         
     D                                     .HSSFCellStyle'                                          
     D                                     :'setBorderTop')                                         
     D   border                            like(jshort) value                                       
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      * HSSFCellStyle_setBorderLeft()                                                               
      *    Set the type of border to be used on the left of cells                                   
      *    that use this cell style                                                                 
      *                                                                                             
      *  border = border style to use.   See the BORDER_XXX constants                               
      *      below for possible values                                                              
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D HSSFCellStyle_setBorderLeft...                                                               
     D                 PR                  EXTPROC(*JAVA                                            
     D                                     :'org.apache.poi.hssf.usermodel-                         
     D                                     .HSSFCellStyle'                                          
     D                                     :'setBorderLeft')                                        
     D   border                            like(jshort) value                                       
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      * HSSFCellStyle_setBorderRight()                                                              
      *    Set the type of border to be used on the right of cells                                  
      *    that use this cell style                                                                 
      *                                                                                             
      *  border = border style to use.   See the BORDER_XXX constants                               
      *      below for possible values                                                              
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D HSSFCellStyle_setBorderRight...                                                              
     D                 PR                  EXTPROC(*JAVA                                            
     D                                     :'org.apache.poi.hssf.usermodel-                         
     D                                     .HSSFCellStyle'                                          
     D                                     :'setBorderRight')                                       
     D   border                            like(jshort) value                                       
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      * HSSFCellStyle_setWrapText()  Turn text wrapping on/off                                      
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D HSSFCellStyle_setWrapText...                                                                 
     D                 PR                  EXTPROC(*JAVA                                            
     D                                     :'org.apache.poi.hssf.usermodel-                         
     D                                     .HSSFCellStyle'                                          
     D                                     :'setWrapText')                                          
     D   wrapped                       N   value                                                    
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      *  HSSFFont_setBoldweight()                                                                   
      *      Set the boldweight ("boldness") of a font.                                             
      *                                                                                             
      *   boldweight = bold weight to use.   See BOLDWEIGHT_XXX                                     
      *       constants below for possible values                                                   
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D HSSFFont_setBoldweight...                                                                    
     D                 PR                  EXTPROC(*JAVA                                            
     D                                     :'org.apache.poi.hssf.usermodel-                         
     D                                     .HSSFFont'                                               
     D                                     :'setBoldweight')                                        
     D   boldweight                        like(jshort) value                                       
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      *  HSSFFont_setFontHeightInPoints()                                                           
      *      Set the height of a font                                                               
      *                                                                                             
      *       height = height of font (in points)                                                   
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D HSSFFont_setFontHeightInPoints...                                                            
     D                 PR                  EXTPROC(*JAVA                                            
     D                                     :'org.apache.poi.hssf.usermodel-                         
     D                                     .HSSFFont'                                               
     D                                     :'setFontHeightInPoints')                                
     D   height                            like(jshort) value                                       
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      *  HSSFDataFormat_getFormat()                                                                 
      *    look up the internal representation of a data format                                     
      *                                                                                             
      *  format = format to look up.  (example: '#,##0.00')                                         
      *                                                                                             
      *  returns the internal represenation of the format, for                                      
      *      use in calling the HSSFCellStyle_setDataFormat() method                                
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D HSSFDataFormat_getFormat...                                                                  
     D                 PR                  like(jshort)                                             
     D                                     EXTPROC(*JAVA                                            
     D                                     :'org.apache.poi.hssf.usermodel-                         
     D                                     .HSSFDataFormat'                                         
     D                                     :'getFormat')                                            
     D   format                            like(jString)                                            
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      * HSSFFont_setFontName():  Set a font face by name                                            
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D HSSFFont_setFontName...                                                                      
     D                 PR                  extproc(*JAVA:                                           
     D                                     'org.apache.poi.hssf.-                                   
     D                                     usermodel.HSSFFont'                                      
     D                                     :'setFontName')                                          
     D   name                              like(jString)                                            
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      * HSSFFont_setColor():  Set a font's color                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D HSSFFont_setColor...                                                                         
     D                 PR                  extproc(*JAVA:                                           
     D                                     'org.apache.poi.hssf.-                                   
     D                                     usermodel.HSSFFont'                                      
     D                                     :'setColor')                                             
     D   color                        5I 0 value                                                    
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      * HSSFFont_setItalic(): Set italic on/off                                                     
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D HSSFFont_setItalic...                                                                        
     D                 PR                  extproc(*JAVA:                                           
     D                                     'org.apache.poi.hssf.-                                   
     D                                     usermodel.HSSFFont'                                      
     D                                     :'setItalic')                                            
     D   italic                       1N   value                                                    
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      * HSSFFont_setStrikeout(): Set strikeout on/off                                               
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D HSSFFont_setStrikeout...                                                                     
     D                 PR                  extproc(*JAVA:                                           
     D                                     'org.apache.poi.hssf.-                                   
     D                                     usermodel.HSSFFont'                                      
     D                                     :'setStrikeout')                                         
     D   strikeout                    1N   value                                                    
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      * HSSFFont_setTypeOffset(): Set typeoffset (super/subscript)                                  
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D HSSFFont_setTypeOffset...                                                                    
     D                 PR                  extproc(*JAVA:                                           
     D                                     'org.apache.poi.hssf.-                                   
     D                                     usermodel.HSSFFont'                                      
     D                                     :'setTypeOffset')                                        
     D   typeoffset                   5I 0 value                                                    
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      * HSSFFont_setUnderline(): Set underline style                                                
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D HSSFFont_setUnderline...                                                                     
     D                 PR                  extproc(*JAVA:                                           
     D                                     'org.apache.poi.hssf.-                                   
     D                                     usermodel.HSSFFont'                                      
     D                                     :'setUnderline')                                         
     D   underline                    1A   value                                                    
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      * HSSFHeader_setLeft(): Set header string for left-hand side                                  
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D HSSFHeader_setLeft...                                                                        
     D                 PR                  extproc(*JAVA:                                           
     D                                     'org.apache.poi.hssf.-                                   
     D                                     usermodel.HSSFHeader'                                    
     D                                     :'setLeft')                                              
     D   newLeft                           like(jString)                                            
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      * HSSFHeader_setCenter(): Set header string to go in center                                   
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D HSSFHeader_setCenter...                                                                      
     D                 PR                  extproc(*JAVA:                                           
     D                                     'org.apache.poi.hssf.-                                   
     D                                     usermodel.HSSFHeader'                                    
     D                                     :'setCenter')                                            
     D   newCenter                         like(jString)                                            
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      * HSSFHeader_setRight(): Set header string to go on right-hand side                           
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D HSSFHeader_setRight...                                                                       
     D                 PR                  extproc(*JAVA:                                           
     D                                     'org.apache.poi.hssf.-                                   
     D                                     usermodel.HSSFHeader'                                    
     D                                     :'setRight')                                             
     D   newRight                          like(jString)                                            
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      * HSSFHeader_date(): Get special "current date" chars for header                              
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D HSSFHeader_date...                                                                           
     D                 PR                  static                                                   
     D                                     extproc(*JAVA:                                           
     D                                     'org.apache.poi.hssf.-                                   
     D                                     usermodel.HSSFHeader'                                    
     D                                     :'date')                                                 
     D                                     like(jString)                                            
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      * HSSFHeader_file(): Get special "current filename" chars for hdr                             
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D HSSFHeader_file...                                                                           
     D                 PR                  static                                                   
     D                                     extproc(*JAVA:                                           
     D                                     'org.apache.poi.hssf.-                                   
     D                                     usermodel.HSSFHeader'                                    
     D                                     :'file')                                                 
     D                                     like(jString)                                            
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      * HSSFHeader_numPages(): Get special "num of pages" chars for hdr                             
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D HSSFHeader_numPages...                                                                       
     D                 PR                  static                                                   
     D                                     extproc(*JAVA:                                           
     D                                     'org.apache.poi.hssf.-                                   
     D                                     usermodel.HSSFHeader'                                    
     D                                     :'numPages')                                             
     D                                     like(jString)                                            
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      * HSSFHeader_page(): Get special "current page no" char for header                            
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D HSSFHeader_page...                                                                           
     D                 PR                  static                                                   
     D                                     extproc(*JAVA:                                           
     D                                     'org.apache.poi.hssf.-                                   
     D                                     usermodel.HSSFHeader'                                    
     D                                     :'page')                                                 
     D                                     like(jString)                                            
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      * HSSFHeader_sheetName(): Get special "current tab (sheet) name"                              
      *                         characters for the header                                           
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D HSSFHeader_sheetName...                                                                      
     D                 PR                  static                                                   
     D                                     extproc(*JAVA:                                           
     D                                     'org.apache.poi.hssf.-                                   
     D                                     usermodel.HSSFHeader'                                    
     D                                     :'tab')                                                  
     D                                     like(jString)                                            
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      * HSSFHeader_time(): Get special "current time" characters for hdr                            
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D HSSFHeader_time...                                                                           
     D                 PR                  static                                                   
     D                                     extproc(*JAVA:                                           
     D                                     'org.apache.poi.hssf.-                                   
     D                                     usermodel.HSSFHeader'                                    
     D                                     :'time')                                                 
     D                                     like(jString)                                            
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      * HSSFHeader_font(): Get special chars that represent a font chg                              
      *                    in the header of a document                                              
      *                                                                                             
      *       font = (input) the new font to set                                                    
      *      style = (input) the fonts style to set                                                 
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D HSSFHeader_font...                                                                           
     D                 PR                  static                                                   
     D                                     extproc(*JAVA:                                           
     D                                     'org.apache.poi.hssf.-                                   
     D                                     usermodel.HSSFHeader'                                    
     D                                     :'font')                                                 
     D                                     like(jString)                                            
     D    font                             like(jString)                                            
     D    style                            like(jString)                                            
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      * HSSFHeader_fontSize(): Get special chars that represent a font                              
      *                    size change in the header of a document                                  
      *                                                                                             
      *       size = (input) new font size                                                          
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D HSSFHeader_fontSize...                                                                       
     D                 PR                  static                                                   
     D                                     extproc(*JAVA:                                           
     D                                     'org.apache.poi.hssf.-                                   
     D                                     usermodel.HSSFHeader'                                    
     D                                     :'fontSize')                                             
     D                                     like(jString)                                            
     D    size                        5I 0 value                                                    
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      * HSSFFooter_setLeft(): Set header string for left-hand side                                  
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D HSSFFooter_setLeft...                                                                        
     D                 PR                  extproc(*JAVA:                                           
     D                                     'org.apache.poi.hssf.-                                   
     D                                     usermodel.HSSFFooter'                                    
     D                                     :'setLeft')                                              
     D   newLeft                           like(jString)                                            
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      * HSSFFooter_setCenter(): Set header string to go in center                                   
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D HSSFFooter_setCenter...                                                                      
     D                 PR                  extproc(*JAVA:                                           
     D                                     'org.apache.poi.hssf.-                                   
     D                                     usermodel.HSSFFooter'                                    
     D                                     :'setCenter')                                            
     D   newCenter                         like(jString)                                            
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      * HSSFFooter_setRight(): Set header string to go on right-hand side                           
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D HSSFFooter_setRight...                                                                       
     D                 PR                  extproc(*JAVA:                                           
     D                                     'org.apache.poi.hssf.-                                   
     D                                     usermodel.HSSFFooter'                                    
     D                                     :'setRight')                                             
     D   newRight                          like(jString)                                            
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      * HSSFFooter_date(): Get special "current date" chars for header                              
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D HSSFFooter_date...                                                                           
     D                 PR                  static                                                   
     D                                     extproc(*JAVA:                                           
     D                                     'org.apache.poi.hssf.-                                   
     D                                     usermodel.HSSFFooter'                                    
     D                                     :'date')                                                 
     D                                     like(jString)                                            
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      * HSSFFooter_file(): Get special "current filename" chars for hdr                             
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D HSSFFooter_file...                                                                           
     D                 PR                  static                                                   
     D                                     extproc(*JAVA:                                           
     D                                     'org.apache.poi.hssf.-                                   
     D                                     usermodel.HSSFFooter'                                    
     D                                     :'file')                                                 
     D                                     like(jString)                                            
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      * HSSFFooter_numPages(): Get special "num of pages" chars for hdr                             
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D HSSFFooter_numPages...                                                                       
     D                 PR                  static                                                   
     D                                     extproc(*JAVA:                                           
     D                                     'org.apache.poi.hssf.-                                   
     D                                     usermodel.HSSFFooter'                                    
     D                                     :'numPages')                                             
     D                                     like(jString)                                            
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      * HSSFFooter_page(): Get special "current page no" char for header                            
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D HSSFFooter_page...                                                                           
     D                 PR                  static                                                   
     D                                     extproc(*JAVA:                                           
     D                                     'org.apache.poi.hssf.-                                   
     D                                     usermodel.HSSFFooter'                                    
     D                                     :'page')                                                 
     D                                     like(jString)                                            
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      * HSSFFooter_sheetName(): Get special "current tab (sheet) name"                              
      *                         characters for the header                                           
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D HSSFFooter_sheetName...                                                                      
     D                 PR                  static                                                   
     D                                     extproc(*JAVA:                                           
     D                                     'org.apache.poi.hssf.-                                   
     D                                     usermodel.HSSFFooter'                                    
     D                                     :'tab')                                                  
     D                                     like(jString)                                            
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      * HSSFFooter_time(): Get special "current time" characters for hdr                            
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D HSSFFooter_time...                                                                           
     D                 PR                  static                                                   
     D                                     extproc(*JAVA:                                           
     D                                     'org.apache.poi.hssf.-                                   
     D                                     usermodel.HSSFFooter'                                    
     D                                     :'time')                                                 
     D                                     like(jString)                                            
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      * HSSFFooter_font(): Get special chars that represent a font chg                              
      *                    in the header of a document                                              
      *                                                                                             
      *       font = (input) the new font to set                                                    
      *      style = (input) the fonts style to set                                                 
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D HSSFFooter_font...                                                                           
     D                 PR                  static                                                   
     D                                     extproc(*JAVA:                                           
     D                                     'org.apache.poi.hssf.-                                   
     D                                     usermodel.HSSFFooter'                                    
     D                                     :'font')                                                 
     D                                     like(jString)                                            
     D    font                             like(jString)                                            
     D    style                            like(jString)                                            
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      * HSSFFooter_fontSize(): Get special chars that represent a font                              
      *                    size change in the header of a document                                  
      *                                                                                             
      *       size = (input) new font size                                                          
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D HSSFFooter_fontSize...                                                                       
     D                 PR                  static                                                   
     D                                     extproc(*JAVA:                                           
     D                                     'org.apache.poi.hssf.-                                   
     D                                     usermodel.HSSFFooter'                                    
     D                                     :'fontSize')                                             
     D                                     like(jString)                                            
     D    size                        5I 0 value                                                    
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      * HSSFWorkbook_getSheet(): Retrieve a sheet from a workbook                                   
      *                                                                                             
      *     SheetName = (input) name of sheet to retrieve                                           
      *                                                                                             
      * Returns the HSSFWorkbook object                                                             
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D HSSFWorkbook_getSheet...                                                                     
     D                 PR                  like(HSSFSheet)                                          
     D                                     ExtProc(*JAVA                                            
     D                                     :'org.apache.poi.hssf-                                   
     D                                     .usermodel.HSSFWorkbook'                                 
     D                                     :'getSheet')                                             
     D  SheetName                          like(jString)                                            
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      * HSSFWorkbook_getRow(): Retrieve an HSSFRow object from a sheet                              
      *                                                                                             
      *     RowNo = (input) Row number of the row to retrieve                                       
      *                                                                                             
      * Returns the HSSFRow object                                                                  
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D HSSFSheet_getRow...                                                                          
     D                 PR                  like(HSSFRow)                                            
     D                                     ExtProc(*JAVA                                            
     D                                     :'org.apache.poi.hssf-                                   
     D                                     .usermodel.HSSFSheet'                                    
     D                                     :'getRow')                                               
     D  RowNo                              like(jInt) value                                         
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      * HSSFRow_getCell():  Retrieve an HSSFCell object from an                                     
      *                      existing HSSFRow object                                                
      *                                                                                             
      *      ColNo = (input) Column number of cell to retrieve                                      
      *                                                                                             
      * returns an HSSFCell object                                                                  
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D HSSFRow_getCell...                                                                           
     D                 PR                  like(HSSFCell)                                           
     D                                     ExtProc(*JAVA                                            
     D                                     :'org.apache.poi.hssf-                                   
     D                                     .usermodel.HSSFRow'                                      
     D                                     :'getCell')                                              
     D  ColNo                              like(jShort) value                                       
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      * HSSFCell_getCellType(): Determine the type of data in an                                    
      *                         HSSFCell object.                                                    
      *                                                                                             
      * returns an integer that corresponds to a CELL_TYPE_xxx                                      
      *        constant.                                                                            
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D HSSFCell_getCellType...                                                                      
     D                 PR                  like(jInt)                                               
     D                                     ExtProc(*JAVA                                            
     D                                     :'org.apache.poi.hssf-                                   
     D                                     .usermodel.HSSFCell'                                     
     D                                     :'getCellType')                                          
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      * HSSFCell_getCellFormula(): Retrieve the formula stored in an                                
      *                            HSSFCell object.                                                 
      *                                                                                             
      * returns a Java string containing the formula                                                
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D HSSFCell_getCellFormula...                                                                   
     D                 PR                  like(jString)                                            
     D                                     ExtProc(*JAVA                                            
     D                                     :'org.apache.poi.hssf-                                   
     D                                     .usermodel.HSSFCell'                                     
     D                                     :'getCellFormula')                                       
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      * HSSFCell_getNumericCellValue(): Retrieve the number stored in an                            
      *                                 HSSFCell object.                                            
      *                                                                                             
      * returns the numeric value of the cell                                                       
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D HSSFCell_getNumericCellValue...                                                              
     D                 PR                  like(jDouble)                                            
     D                                     ExtProc(*JAVA                                            
     D                                     :'org.apache.poi.hssf-                                   
     D                                     .usermodel.HSSFCell'                                     
     D                                     :'getNumericCellValue')                                  
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      * HSSFCell_getStringCellValue(): Retrieve the String stored in an                             
      *                                HSSFCell object.                                             
      *                                                                                             
      * returns a Java string containing the value                                                  
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D HSSFCell_getStringCellValue...                                                               
     D                 PR                  like(jString)                                            
     D                                     ExtProc(*JAVA                                            
     D                                     :'org.apache.poi.hssf-                                   
     D                                     .usermodel.HSSFCell'                                     
     D                                     :'getStringCellValue')                                   
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      * HSSFCell_getCellStyle(): Retrieve the Cell Style associated                                 
      *                          with an HSSFCell object.                                           
      *                                                                                             
      * returns an HSSFCellStyle object                                                             
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D HSSFCell_getCellStyle...                                                                     
     D                 PR                  like(HSSFCellStyle)                                      
     D                                     ExtProc(*JAVA                                            
     D                                     :'org.apache.poi.hssf-                                   
     D                                     .usermodel.HSSFCell'                                     
     D                                     :'getCellStyle')                                         
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      * BOLDWEIGHT_XXX constants for calling HSSFFont_setBoldweight()                               
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D BOLDWEIGHT_NORMAL...                                                                         
     D                 C                   190                                                      
     D BOLDWEIGHT_BOLD...                                                                           
     D                 C                   700                                                      
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      * CELL_TYPE_XXX constants for calling HSSFCell_setCellType()                                  
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D CELL_TYPE_NUMERIC...                                                                         
     D                 C                   0                                                        
     D CELL_TYPE_STRING...                                                                          
     D                 C                   1                                                        
     D CELL_TYPE_FORMULA...                                                                         
     D                 C                   2                                                        
     D CELL_TYPE_BLANK...                                                                           
     D                 C                   3                                                        
     D CELL_TYPE_BOOLEAN...                                                                         
     D                 C                   4                                                        
     D CELL_TYPE_ERROR...                                                                           
     D                 C                   5                                                        
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      * ALIGN_XXX constants for calling HSSFCellStyle_setAlignment()                                
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D ALIGN_CENTER...                                                                              
     D                 C                   2                                                        
     D ALIGN_CENTER_SELECTION...                                                                    
     D                 C                   6                                                        
     D ALIGN_FILL...                                                                                
     D                 C                   4                                                        
     D ALIGN_GENERAL...                                                                             
     D                 C                   0                                                        
     D ALIGN_JUSTIFY...                                                                             
     D                 C                   5                                                        
     D ALIGN_LEFT...                                                                                
     D                 C                   1                                                        
     D ALIGN_RIGHT...                                                                               
     D                 C                   3                                                        
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      * BORDER_XXX constants for calling HSSFCellStyle_setBorderBottom()                            
      *                               or HSSFCellStyle_setBorderTop()                               
      *                               or HSSFCellStyle_setBorderLeft()                              
      *                               or HSSFCellStyle_setBorderRight()                             
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D BORDER_DASH_DOT...                                                                           
     D                 C                   9                                                        
     D BORDER_DASH_DOT_DOT...                                                                       
     D                 C                   11                                                       
     D BORDER_DASHED...                                                                             
     D                 C                   3                                                        
     D BORDER_DOTTED...                                                                             
     D                 C                   7                                                        
     D BORDER_DOUBLE...                                                                             
     D                 C                   6                                                        
     D BORDER_HAIR...                                                                               
     D                 C                   4                                                        
     D BORDER_MEDIUM...                                                                             
     D                 C                   2                                                        
     D BORDER_MEDIUM_DASH_DOT...                                                                    
     D                 C                   10                                                       
     D BORDER_MEDIUM_DASH_DOT_DOT...                                                                
     D                 C                   12                                                       
     D BORDER_MEDIUM_DASHED...                                                                      
     D                 C                   8                                                        
     D BORDER_THIN...                                                                               
     D                 C                   1                                                        
     D BORDER_NONE...                                                                               
     D                 C                   0                                                        
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      * Set font color... currently only RED and NORMAL are allowed                                 
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D COLOR_RED...                                                                                 
     D                 C                   10                                                       
     D COLOR_NORMAL...                                                                              
     D                 C                   32767                                                    
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      * type offsets for superscript, subscript and normal                                          
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D SS_NONE...                                                                                   
     D                 C                   0                                                        
     D SS_SUPER...                                                                                  
     D                 C                   1                                                        
     D SS_SUB...                                                                                    
     D                 C                   2                                                        
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      * underline styles                                                                            
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D U_NONE...                                                                                    
     D                 C                   x'00'                                                    
     D U_SINGLE...                                                                                  
     D                 C                   x'01'                                                    
     D U_DOUBLE...                                                                                  
     D                 C                   x'02'                                                    
     D U_SINGLE_ACCOUNTING...                                                                       
     D                 C                   x'21'                                                    
     D U_DOUBLE_ACCOUNTING...                                                                       
     D                 C                   x'22'                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      * fills and colors                                                                            
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D BIG_SPOTS...                                                                                 
     D                 C                   9                                                        
     D SOLID_FOREGROUND...                                                                          
     D                 C                   1                                                        
     D NO_FILL...                                                                                   
     D                 C                   0                                                        
     D HSSFCOLOR_AQUA...                                                                            
     D                 C                   49                                                       
     D HSSFCOLOR_BLACK...                                                                           
     D                 C                   8                                                        
     D HSSFCOLOR_BLUE...                                                                            
     D                 C                   12                                                       
     D HSSFCOLOR_BLUE_GRAY...                                                                       
     D                 C                   54                                                       
     D HSSFCOLOR_BRIGHT_GREEN...                                                                    
     D                 C                   11                                                       
     D HSSFCOLOR_BROWN...                                                                           
     D                 C                   60                                                       
     D HSSFCOLOR_CORAL...                                                                           
     D                 C                   29                                                       
     D HSSFCOLOR_CORNFLOWER_BLUE...                                                                 
     D                 C                   24                                                       
     D HSSFCOLOR_DARK_BLUE...                                                                       
     D                 C                   18                                                       
     D HSSFCOLOR_DARK_TEAL...                                                                       
     D                 C                   56                                                       
     D HSSFCOLOR_DARK_YELLOW...                                                                     
     D                 C                   19                                                       
     D HSSFCOLOR_GOLD...                                                                            
     D                 C                   51                                                       
     D HSSFCOLOR_GREEN...                                                                           
     D                 C                   17                                                       
     D HSSFCOLOR_GRAY_25_PERCENT...                                                                 
     D                 C                   22                                                       
     D HSSFCOLOR_GRAY_40_PERCENT...                                                                 
     D                 C                   55                                                       
     D HSSFCOLOR_GRAY_50_PERCENT...                                                                 
     D                 C                   23                                                       
     D HSSFCOLOR_GRAY_80_PERCENT...                                                                 
     D                 C                   63                                                       
     D HSSFCOLOR_INDIGO...                                                                          
     D                 C                   62                                                       
     D HSSFCOLOR_LAVENDER...                                                                        
     D                 C                   46                                                       
     D HSSFCOLOR_LEMON_CHIFFON...                                                                   
     D                 C                   26                                                       
     D HSSFCOLOR_LIGHT_BLUE...                                                                      
     D                 C                   48                                                       
     D HSSFCOLOR_LIGHT_CORNFLOWER_BLUE...                                                           
     D                 C                   31                                                       
     D HSSFCOLOR_LIGHT_GREEN...                                                                     
     D                 C                   42                                                       
     D HSSFCOLOR_LIGHT_ORANGE...                                                                    
     D                 C                   52                                                       
     D HSSFCOLOR_LIGHT_TURQUOISE...                                                                 
     D                 C                   41                                                       
     D HSSFCOLOR_LIGHT_YELLOW...                                                                    
     D                 C                   43                                                       
     D HSSFCOLOR_LIME...                                                                            
     D                 C                   50                                                       
     D HSSFCOLOR_MAROON...                                                                          
     D                 C                   25                                                       
     D HSSFCOLOR_OLIVE_GREEN...                                                                     
     D                 C                   59                                                       
     D HSSFCOLOR_ORANGE...                                                                          
     D                 C                   53                                                       
     D HSSFCOLOR_ORCHID...                                                                          
     D                 C                   28                                                       
     D HSSFCOLOR_PALE_BLUE...                                                                       
     D                 C                   44                                                       
     D HSSFCOLOR_PINK...                                                                            
     D                 C                   14                                                       
     D HSSFCOLOR_PLUM...                                                                            
     D                 C                   61                                                       
     D HSSFCOLOR_RED...                                                                             
     D                 C                   10                                                       
     D HSSFCOLOR_ROSE...                                                                            
     D                 C                   45                                                       
     D HSSFCOLOR_ROYAL_BLUE...                                                                      
     D                 C                   30                                                       
     D HSSFCOLOR_SEA_GREEN...                                                                       
     D                 C                   57                                                       
     D HSSFCOLOR_SKY_BLUE...                                                                        
     D                 C                   40                                                       
     D HSSFCOLOR_TAN...                                                                             
     D                 C                   47                                                       
     D HSSFCOLOR_TEAL...                                                                            
     D                 C                   21                                                       
     D HSSFCOLOR_TURQUOISE...                                                                       
     D                 C                   15                                                       
     D HSSFCOLOR_VIOLET...                                                                          
     D                 C                   20                                                       
     D HSSFCOLOR_WHITE...                                                                           
     D                 C                   9                                                        
     D HSSFCOLOR_YELLOW...                                                                          
     D                 C                   13                                                       
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      * common used constants                                                                       
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D True            C                   '1'                                                      
     D False           C                   '0'                                                      
                                                                                                    
     D book            s                   like(HSSFWorkbook)                                       
     D sheet           s                   like(HSSFSheet)                                          
     D row             s                   like(HSSFRow)                                            
     D style           s                   like(HSSFCellStyle)                                      
     D font            s                   like(HSSFFont)                                           
     D printsetup      s                   like(HSSFPrintSetup)                                     
     D LgHeading       s                   like(HSSFCellStyle)                                      
     D LgHeading2      s                   like(HSSFCellStyle)                                      
     D SmHeading       s                   like(HSSFCellStyle)                                      
     D ColHeading      s                   like(HSSFCellStyle)                                      
     D Numeric         s                   like(HSSFCellStyle)                                      
     D Text            s                   like(HSSFCellStyle)                                      
     D Dates           s                   like(HSSFCellStyle)                                      
     D NumericND       s                   like(HSSFCellStyle)                                      
     D NumericNDYellow...                                                                           
     D                 s                   like(HSSFCellStyle)                                      
     D NumericNDOrange...                                                                           
     D                 s                   like(HSSFCellStyle)                                      
     D NumericNDLTBlue...                                                                           
     D                 s                   like(HSSFCellStyle)                                      
     D TextLTBlue...                                                                                
     D                 s                   like(HSSFCellStyle)                                      
     D TextYellow...                                                                                
     D                 s                   like(HSSFCellStyle)                                      
     D TextOrange...                                                                                
     D                 s                   like(HSSFCellStyle)                                      
                                                                                                    
                                                                                                    
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
     D hssf_NewSheet   PR                  like(HSSFSheet)                                          
     D   peBook                            like(HSSFWorkbook)                                       
     D   peName                    1024A   const varying                                            
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      *  hssf_save():   Save HSSF Workbook to disk                                                  
      *      (Wrapper around HSSFWorkbook_write() method)                                           
      *                                                                                             
      *      peBook = workbook to add sheet to                                                      
      *      peFile = IFS path/filename to save workbook as                                         
      *                                                                                             
      *  Returns the new sheet                                                                      
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D hssf_save       PR                                                                           
     D   peBook                            like(HSSFWorkbook)                                       
     D   peFilename                1024A   const varying                                            
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      *  hssf_merge(): Merge cells on a sheet                                                       
      *      (Wrapper around HSSFSheet_addMergedRegion() method)                                    
      *                                                                                             
      *      peBook = workbook to add sheet to                                                      
      *      peFile = IFS path/filename to save workbook as                                         
      *                                                                                             
      *  Returns the new sheet                                                                      
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D hssf_merge      PR                                                                           
     D   peSheet                           like(HSSFSheet)                                          
     D   peRowFrom                         like(jint) value                                         
     D   peColFrom                         like(jshort) value                                       
     D   peRowTo                           like(jint) value                                         
     D   peColTo                           like(jshort) value                                       
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      *  hssf_date2xls():                                                                           
      *    service program utility to convert an RPG date to a                                      
      *    number that can be formatted as a date in Excel                                          
      *                                                                                             
      *    peDate = RPG date to convert                                                             
      *                                                                                             
      *  returns the date formatted for Excel                                                       
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D hssf_date2xls   PR                  like(jdouble)                                            
     D   peDate                        D   value                                                    
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      *  hssf_xls2date():                                                                           
      *    service program utility to convert an Excel date to                                      
      *    an RPG date field                                                                        
      *                                                                                             
      *    peXls = Number used as a date in Excel                                                   
      *                                                                                             
      *  returns the RPG date                                                                       
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D hssf_xls2date   PR              D                                                            
     D   peXls                             like(jdouble) value                                      
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      *  hssf_cellName(): Convert HSSF y,x coordinates into a cell name                             
      *     (example: 0,0 becomes A1, 110,24 becomes Y111)                                          
      *                                                                                             
      *        peRow = row number (A=0, B=1, etc)                                                   
      *        peCol = column number                                                                
      *                                                                                             
      *  Returns the alphanumeric cellname                                                          
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D hssf_cellName   PR            10A   varying                                                  
     D  peRow                         5I 0 value                                                    
     D  peCol                         5I 0 value                                                    
      /if defined(HSSF_CELLNAME_SHORTCUT)                                                           
     D cn              PR            10A   varying extproc('HSSF_CELLNAME')                         
     D  peRow                         5I 0 value                                                    
     D  peCol                         5I 0 value                                                    
      /endif                                                                                        
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      *  hssf_text():  Shortcut for inserting a new cell that contains                              
      *        a string value into a given row of a sheet                                           
      *                                                                                             
      *    peRow = Row object that cell should be created in                                        
      *    peCol = column number of new cell                                                        
      * peString = string to place in cell                                                          
      *  peStyle = cell style object to associate with cell                                         
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D hssf_text       PR                                                                           
     D   peRow                             like(HSSFRow)                                            
     D   peCol                             like(jshort) value                                       
     D   peString                  1024A   varying const                                            
     D   peStyle                           like(HSSFCellStyle)                                      
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      *  hssf_num():  Shortcut for inserting a new cell that contains                               
      *        a numeric value into a given row of a sheet                                          
      *                                                                                             
      *    peRow = Row object that cell should be created in                                        
      *    peCol = column number of new cell                                                        
      * peNumber = numeric value to place in cell                                                   
      *  peStyle = cell style object to associate with cell                                         
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D hssf_num        PR                                                                           
     D   peRow                             like(HSSFRow)                                            
     D   peCol                             like(jshort) value                                       
     D   peNumber                          like(jdouble) value                                      
     D   peStyle                           like(HSSFCellStyle)                                      
                                                                                                    
                                                                                                    
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
     D hssf_date       PR                                                                           
     D   peRow                             like(HSSFRow)                                            
     D   peCol                        5I 0 value                                                    
     D   peDate                        D   value                                                    
     D   peStyle                           like(HSSFCellStyle)                                      
                                                                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      *  hssf_formula(): Shortcut for inserting a new cell that contains                            
      *        a formla into a given row of a sheet                                                 
      *                                                                                             
      *     peRow = Row object that cell should be created in                                       
      *     peCol = column number of new cell                                                       
      * peFormula = formula to place in cell                                                        
      *   peStyle = cell style object to associate with cell                                        
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D hssf_formula    PR                                                                           
     D   peRow                             like(HSSFRow)                                            
     D   peCol                        5I 0 value                                                    
     D   peFormula                 1024A   varying const                                            
     D   peStyle                           like(HSSFCellStyle)                                      
                                                                                                    
                                                                                                    
      *-----------------------------------------------------------------                            
      * hssf_createDataFormat():  Shortcut routine to create a data fmt                             
      *                                                                                             
      *        peBook = (input) workbook to create the format in                                    
      *      peFormat = (input) string represending the data format                                 
      *                                                                                             
      * returns the data format's index in the workbook                                             
      *-----------------------------------------------------------------                            
     D hssf_CreateDataFormat...                                                                     
     D                 PR             5I 0                                                          
     D   peBook                            like(HSSFWorkbook) const                                 
     D   peFormat                   100A   varying const                                            
                                                                                                    
                                                                                                    
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
     D hssf_CreateFont...                                                                           
     D                 PR                  like(HSSFFont)                                           
     D   peBook                            like(HSSFWorkbook) const                                 
     D   peName                     100A   varying const options(*omit)                             
     D   pePointSize                  5I 0 const options(*omit)                                     
     D   peBold                       5I 0 const options(*omit)                                     
     D   peUnderline                  1A   const options(*omit)                                     
     D   peItalic                     1N   const options(*omit)                                     
     D   peStrikeout                  1N   const options(*omit)                                     
     D   peColor                      5I 0 const options(*omit)                                     
     D   peTypeOffset                 5I 0 const options(*omit)                                     
                                                                                                    
                                                                                                    
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
      * HSSF_header_setLeft(): Wrapper around the Java routine                                      
      *                        for HSSFHeader_setLeft()                                             
      *                                                                                             
      *   sheet = (input) worksheet to set the left string for                                      
      *  string = (input) string to set                                                             
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
     D HSSF_header_setLeft...                                                                       
     D                 PR                                                                           
     D    sheet                            like(HSSFSheet) const                                    
     D    string                   1024A   const varying options(*varsize)                          
                                                                                                    
                                                                                                    
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
      * HSSF_header_setCenter(): Wrapper around the Java routine                                    
      *                          for HSSFHeader_setCenter()                                         
      *                                                                                             
      *   sheet = (input) worksheet to set the center string for                                    
      *  string = (input) string to set                                                             
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
     D HSSF_header_setCenter...                                                                     
     D                 PR                                                                           
     D    sheet                            like(HSSFSheet) const                                    
     D    string                   1024A   const varying options(*varsize)                          
                                                                                                    
                                                                                                    
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
      * HSSF_header_setRight(): Wrapper around the Java routine                                     
      *                         for HSSFHeader_setRight()                                           
      *                                                                                             
      *   sheet = (input) worksheet to set the right string for                                     
      *  string = (input) string to set                                                             
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
     D HSSF_header_setRight...                                                                      
     D                 PR                                                                           
     D    sheet                            like(HSSFSheet) const                                    
     D    string                   1024A   const varying options(*varsize)                          
                                                                                                    
                                                                                                    
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
      * HSSF_header_date(): Retrieve special characters that                                        
      *                     indicate the current date in a                                          
      *                     header string                                                           
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
     D HSSF_header_date...                                                                          
     D                 PR          1024A   varying                                                  
                                                                                                    
                                                                                                    
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
      * HSSF_header_file(): Retrieve special characters that                                        
      *                     indicate the current filename in                                        
      *                     a header string                                                         
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
     D HSSF_header_file...                                                                          
     D                 PR          1024A   varying                                                  
                                                                                                    
                                                                                                    
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
      * HSSF_header_font(): Retrieve special characters that                                        
      *                     indicate a font of a particular                                         
      *                     name & style in a header string                                         
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
     D HSSF_header_font...                                                                          
     D                 PR          1024A   varying                                                  
     D    font                     1024A   varying const                                            
     D    style                    1024A   varying const                                            
                                                                                                    
                                                                                                    
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
      * HSSF_header_fontSize(): Retrieve special characters                                         
      *                         that set the font size in a                                         
      *                         header string                                                       
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
     D HSSF_header_fontSize...                                                                      
     D                 PR          1024A   varying                                                  
     D    size                        5U 0 value                                                    
                                                                                                    
                                                                                                    
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
      * HSSF_header_numPages(): Retrieve special characters                                         
      *                         that insert the number of pages                                     
      *                         in the doc into a header string                                     
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
     D HSSF_header_numPages...                                                                      
     D                 PR          1024A   varying                                                  
                                                                                                    
                                                                                                    
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
      * HSSF_header_page(): Retrieve special characters                                             
      *                     that insert the current page                                            
      *                     number into a header string                                             
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
     D HSSF_header_page...                                                                          
     D                 PR          1024A   varying                                                  
                                                                                                    
                                                                                                    
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
      * HSSF_header_sheetName(): Retrieve special characters                                        
      *                          that insert the current sheet                                      
      *                          name (or "tab name") into a                                        
      *                          header string                                                      
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
     D HSSF_header_sheetName...                                                                     
     D                 PR          1024A   varying                                                  
                                                                                                    
                                                                                                    
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
      * HSSF_header_time(): Retrieve special characters                                             
      *                     that insert the current time                                            
      *                     into a header string.                                                   
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
     D HSSF_header_time...                                                                          
     D                 PR          1024A   varying                                                  
                                                                                                    
                                                                                                    
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
      * HSSF_footer_setLeft(): Wrapper around the Java routine                                      
      *                        for HSSFFooter_setLeft()                                             
      *                                                                                             
      *   sheet = (input) worksheet to set the left string for                                      
      *  string = (input) string to set                                                             
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
     D HSSF_footer_setLeft...                                                                       
     D                 PR                                                                           
     D    sheet                            like(HSSFSheet) const                                    
     D    string                   1024A   const varying options(*varsize)                          
                                                                                                    
                                                                                                    
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
      * HSSF_footer_setCenter(): Wrapper around the Java routine                                    
      *                          for HSSFFooter_setCenter()                                         
      *                                                                                             
      *   sheet = (input) worksheet to set the center string for                                    
      *  string = (input) string to set                                                             
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
     D HSSF_footer_setCenter...                                                                     
     D                 PR                                                                           
     D    sheet                            like(HSSFSheet) const                                    
     D    string                   1024A   const varying options(*varsize)                          
                                                                                                    
                                                                                                    
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
      * HSSF_footer_setRight(): Wrapper around the Java routine                                     
      *                         for HSSFFooter_setRight()                                           
      *                                                                                             
      *   sheet = (input) worksheet to set the right string for                                     
      *  string = (input) string to set                                                             
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
     D HSSF_footer_setRight...                                                                      
     D                 PR                                                                           
     D    sheet                            like(HSSFSheet) const                                    
     D    string                   1024A   const varying options(*varsize)                          
                                                                                                    
                                                                                                    
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
      * HSSF_footer_date(): Retrieve special characters that                                        
      *                     indicate the current date in a                                          
      *                     header string                                                           
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
     D HSSF_footer_date...                                                                          
     D                 PR          1024A   varying                                                  
                                                                                                    
                                                                                                    
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
      * HSSF_footer_file(): Retrieve special characters that                                        
      *                     indicate the current filename in                                        
      *                     a header string                                                         
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
     D HSSF_footer_file...                                                                          
     D                 PR          1024A   varying                                                  
                                                                                                    
                                                                                                    
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
      * HSSF_footer_font(): Retrieve special characters that                                        
      *                     indicate a font of a particular                                         
      *                     name & style in a header string                                         
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
     D HSSF_footer_font...                                                                          
     D                 PR          1024A   varying                                                  
     D    font                     1024A   varying const                                            
     D    style                    1024A   varying const                                            
                                                                                                    
                                                                                                    
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
      * HSSF_footer_fontSize(): Retrieve special characters                                         
      *                         that set the font size in a                                         
      *                         header string                                                       
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
     D HSSF_footer_fontSize...                                                                      
     D                 PR          1024A   varying                                                  
     D    size                        5U 0 value                                                    
                                                                                                    
                                                                                                    
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
      * HSSF_footer_numPages(): Retrieve special characters                                         
      *                         that insert the number of pages                                     
      *                         in the doc into a header string                                     
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
     D HSSF_footer_numPages...                                                                      
     D                 PR          1024A   varying                                                  
                                                                                                    
                                                                                                    
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
      * HSSF_footer_page(): Retrieve special characters                                             
      *                     that insert the current page                                            
      *                     number into a header string                                             
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
     D HSSF_footer_page...                                                                          
     D                 PR          1024A   varying                                                  
                                                                                                    
                                                                                                    
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
      * HSSF_footer_sheetName(): Retrieve special characters                                        
      *                          that insert the current sheet                                      
      *                          name (or "tab name") into a                                        
      *                          header string                                                      
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
     D HSSF_footer_sheetName...                                                                     
     D                 PR          1024A   varying                                                  
                                                                                                    
                                                                                                    
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
      * HSSF_footer_time(): Retrieve special characters                                             
      *                     that insert the current time                                            
      *                     into a header string.                                                   
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
     D HSSF_footer_time...                                                                          
     D                 PR          1024A   varying                                                  
                                                                                                    
                                                                                                    
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
      * HSSF_find_sheet(): Returns the index of a given sheet                                       
      *                                                                                             
      *      workbook = (input) workbook object to search                                           
      *         sheet = (input) sheet to get index of                                               
      *                                                                                             
      * Returns the index number or -1 if sheet is not                                              
      *         part of this workbook.                                                              
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                     
     D HSSF_find_sheet...                                                                           
     D                 PR            10I 0                                                          
     D   workbook                          like(HSSFWorkbook) const                                 
     D   sheet                             like(HSSFSheet) const                                    
                                                                                                    
                                                                                                    
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
     D HSSF_setRepeating...                                                                         
     D                 PR                                                                           
     D   workbook                          like(HSSFWorkbook) const                                 
     D   sheet                             like(HSSFSheet) const                                    
     D   startcol                    10I 0 value                                                    
     D   endcol                      10I 0 value                                                    
     D   startrow                    10I 0 value                                                    
     D   endrow                      10I 0 value                                                    
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      *  hssf_open():  Open an existing HSSF Workbook                                               
      *                                                                                             
      *     peFilename = IFS path/filename of workbook to open                                      
      *                                                                                             
      *  Returns the HSSFWorkbook object opened                                                     
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D hssf_open       PR                  like(HSSFWorkbook)                                       
     D   peFilename                1024A   const varying                                            
                                                                                                    
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
      * hssf_getSheet(): Get the sheet object from a workbook                                       
      *                                                                                             
      *        peBook = workbook to retrieve sheet from                                             
      *   peSheetName = worksheet name to retrieve                                                  
      *                                                                                             
      * Returns the HSSFSheet object                                                                
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                            
     D hssf_getSheet   PR                  like(HSSFSheet)                                          
     D   peBook                            like(HSSFWorkbook)                                       
     D   peSheetName               1024A   varying const                                            
                                                                                                    
      /define HSSF_H                                                                                
      /endif                                                                                        
