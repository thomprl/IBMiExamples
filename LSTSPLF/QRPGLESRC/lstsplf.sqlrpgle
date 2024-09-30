      * Program: LSTSPLF
      * Written By: Ricky Thompson
      * Date: 06/01/99
      * Purpose: To allow the additions of options to the spool file display
      * We needed a way like PDM to add user defined options to the WRKSPLF
      * command for e-mailing and faxing.
      *
       CTL-OPT DFTACTGRP(*NO);
       DCL-F LSTSPLFFM WORKSTN(*EXT) USAGE(*INPUT:*OUTPUT)
             SFILE(LSTSPLFSF:SFLRRN) INFDS(DSPDS)
             SFILE(CUSTOMSF:SFLRRN2);
       DCL-F LSTSPLFP KEYED USAGE(*INPUT:*OUTPUT:*UPDATE:*DELETE);

       // Error Code  parameter include

      /COPY QSYSINC/QRPGLESRC,QUSEC

       //*ENTRY Interface for Main Procedure
       DCL-PI LSTSPLF;
         #LstUsr CHAR(10);
         #LstOutq CHAR(10);
         #QualJob CHAR(26) OPTIONS(*NOPASS);
       END-PI;

       DCL-DS *N PSDS;
         @PGMID *PROC;
         @WSID CHAR(10) POS(244);
         @USRID CHAR(10) POS(254);
       END-DS;

       DCL-DS DSPDS;
         CURSOR BINDEC(4) POS(370);
         LRRN BINDEC(4) POS(378);
       END-DS;

       // Used to clear the program message queue.
       DCL-S ClStkEntry CHAR(10) INZ( '*' );
       DCL-S ClStkCounter UNS(10) INZ( 0 );
       DCL-S MsgKey CHAR(4) INZ( *BLANK );
       DCL-S MsgsToRmv CHAR(10) INZ( '*ALL' );

       // RRN Number for Subfile
       DCL-S SFLRRN PACKED(4);
       DCL-S SFLRRN2 PACKED(4);
       DCL-S LstOutq2 CHAR(20);

       // Program var
       DCL-S Command CHAR(256);
       DCL-S CmdKey CHAR(4);
       DCL-S Pos1 PACKED(3);
       DCL-S Pos2 PACKED(3);
       DCL-S Pos3 PACKED(3);
       DCL-S SavRRN PACKED(4);
       DCL-S NewCmd CHAR(256);
       DCL-S WrkCmd CHAR(256);
       DCL-S OptFld CHAR(2);

       // User Space Name, Size
       DCL-S SPC_NAME CHAR(20) INZ('SPCNAME   QTEMP     ');
       DCL-S SPC_SIZE BINDEC(9) INZ(2000);
       DCL-S SPC_INIT CHAR(1) INZ(X'00');

       DCL-S LSTPTR POINTER;
       DCL-S LSTPTR2 POINTER;
       DCL-S SPCPTR POINTER;
       DCL-S ARR CHAR(1) BASED(LSTPTR) DIM(32767);

       DCL-DS QualJobDs Qualified;
         #QualJob;
         vJobName CHAR(10) Overlay(#QualJob);
         vJobUser CHAR(10) Overlay(#QualJob:*Next);
         vJobNbr CHAR(6) Overlay(#QualJob:*Next);

       End-Ds;

       // Pages
       DCL-DS *N;
         PAGES# BINDEC(9);
         PAGESA CHAR(4) OVERLAY(PAGES#);
       END-DS;

       // Total Pages
       DCL-DS *N;
         TOTPG# BINDEC(9);
         TOTPGA CHAR(4) OVERLAY(TOTPG#);
       END-DS;

       // Current Page
       DCL-DS *N;
         CURPG# BINDEC(9);
         CURPGA CHAR(4) OVERLAY(CURPG#);
       END-DS;

       // Copies Left
       DCL-DS *N;
         COPLF# BINDEC(9);
         COPLFA CHAR(4) OVERLAY(COPLF#);
       END-DS;

       DCL-DS *N;
         SPLFL# BINDEC(9);
         SPLFLA CHAR(4) OVERLAY(SPLFL#);
       END-DS;

       DCL-DS KEYS;
         *N BINDEC(9) INZ(201);
         *N BINDEC(9) INZ(202);
         *N BINDEC(9) INZ(203);
         *N BINDEC(9) INZ(204);
         *N BINDEC(9) INZ(205);
         *N BINDEC(9) INZ(206);
         *N BINDEC(9) INZ(207);
         *N BINDEC(9) INZ(208);
         *N BINDEC(9) INZ(209);
         *N BINDEC(9) INZ(210);
         *N BINDEC(9) INZ(211);
         *N BINDEC(9) INZ(212);
         *N BINDEC(9) INZ(213);
         *N BINDEC(9) INZ(214);
         *N BINDEC(9) INZ(215);
         *N BINDEC(9) INZ(216);
         KEY# BINDEC(9) INZ(16);
       END-DS;

       DCL-DS QUSH0100 BASED(SPCPTR);
         QUSUA CHAR(64);
         QUSSGH BINDEC(9);
         QUSSRL CHAR(4);
         QUSFN CHAR(8);
         QUSAU CHAR(10);
         QUSDTC CHAR(13);
         QUSIS CHAR(1);
         QUSSUS BINDEC(9);
         QUSOIP BINDEC(9);
         QUSSIP BINDEC(9);
         QUSOHS BINDEC(9);
         QUSSHS BINDEC(9);
         QUSOLD BINDEC(9);
         QUSSLD BINDEC(9);
         QUSNBRLE BINDEC(9);
         QUSSEE BINDEC(9);
         QUSSIDLE BINDEC(9);
         QUSCID CHAR(2);
         QUSLID CHAR(3);
         QUSSLI CHAR(1);
         QUSERVED00 CHAR(42);
       END-DS;

       DCL-C QUSLSPL 'QUSLSPL';

       DCL-DS QUSSPLKI BASED(LSTPTR2);
         QUSLFIR02 BINDEC(9);
         QUSKFFFR00 BINDEC(9);
         QUSTOD02 CHAR(1);
         QUSR300 CHAR(3);
         QUSDL02 BINDEC(9);
         QUSDATA08 CHAR(1);
         QUSERVED34 CHAR(21);
       END-DS;

       DCL-DS QUSF0200 BASED(LSTPTR);
         QUSNBRFR00 BINDEC(9);
       END-DS;


       //Prototype for 'QUSCRTUS'
       DCL-PR QUSCRTUS EXTPGM('QUSCRTUS');
         SPC_NAME_ LIKE(SPC_NAME);
         EXT_ATTR_ LIKE(EXT_ATTR);
         SPC_SIZE_ LIKE(SPC_SIZE);
         SPC_INIT_ LIKE(SPC_INIT);
         SPC_AUT_ LIKE(SPC_AUT);
         SPC_TEXT_ LIKE(SPC_TEXT);
         SPC_REPLAC_ LIKE(SPC_REPLAC);
         QUSEC_ LIKEDS(QUSEC);
         SPC_DOMAIN_ LIKE(SPC_DOMAIN);
       END-PR;

       //Prototype for 'QUSLSPL'
       DCL-PR QUSLSPL_001 EXTPGM('QUSLSPL');
         SPC_NAME_ LIKE(SPC_NAME);
         FORMAT_ LIKE(FORMAT);
         //                  Parm      '*CURRENT'    USR_PRF          10
         USR_PRF_ LIKE(USR_PRF);
         //                   Parm      '*ALL'        OUTQ             20
         OUTQ_ LIKE(OUTQ);
         FORMTYP_ LIKE(FORMTYP);
         USRDTA_ LIKE(USRDTA);
         QUSEC_ LIKEDS(QUSEC);
         JOBNAM_ LIKE(JOBNAM);
         KEYS_ LIKEDS(KEYS);
         KEY#_ LIKE(KEY#);
       END-PR;

       //Prototype for 'QUSPTRUS'
       DCL-PR QUSPTRUS EXTPGM('QUSPTRUS');
         SPC_NAME_ LIKE(SPC_NAME);
         SPCPTR_ LIKE(SPCPTR);
         QUSEC_ LIKEDS(QUSEC);
       END-PR;

       //Prototype for 'QMHRMVPM'
       DCL-PR QMHRMVPM EXTPGM('QMHRMVPM');
         ClStkEntry_ LIKE(ClStkEntry);
         ClStkCounter_ LIKE(ClStkCounter);
         MsgKey_ LIKE(MsgKey);
         MsgsToRmv_ LIKE(MsgsToRmv);
         ApiErr_ LIKE(ApiErr);
       END-PR;

       //Prototype for 'QUSCMDLN'
       DCL-PR QUSCMDLN EXTPGM('QUSCMDLN');
       END-PR;

       //Prototype for 'QCMDEXC'
       DCL-PR QCMDEXC EXTPGM('QCMDEXC');
         NewCmd_ LIKE(NewCmd);
         CmdLen15_ LIKE(CmdLen15);
       END-PR;

       // --------------------------------------------------------------------
       // Stand Alone Fields - TOP
       // --------------------------------------------------------------------
       DCL-S ApiErr CHAR(1);
       DCL-S CmdLen PACKED(5);
       DCL-S CmdLen15 PACKED(15:5);
       DCL-S DEVICE CHAR(10);
       DCL-S DO_X1 PACKED(7);
       DCL-S DO_X2 PACKED(7);
       DCL-S EXT_ATTR CHAR(10);
       DCL-S FORMAT CHAR(8);
       DCL-S FORMTY CHAR(10);
       DCL-S FORMTYP CHAR(10);
       DCL-S JOBNAM CHAR(26);
       DCL-S JOBNBR CHAR(6);
       DCL-S JOBNM CHAR(10);
       DCL-S OPNDAT CHAR(7);
       DCL-S OUTQ CHAR(20);
       DCL-S OUTQLI CHAR(10);
       DCL-S OUTQNM CHAR(10);
       DCL-S PRIOR CHAR(2);
       DCL-S PRTFIL CHAR(10);
       DCL-S SPC_AUT CHAR(10);
       DCL-S SPC_DOMAIN CHAR(10);
       DCL-S SPC_REPLAC CHAR(10);
       DCL-S SPC_TEXT CHAR(50);
       DCL-S SPLFLC CHAR(4);
       DCL-S SPLFLN PACKED(4);
       DCL-S STAT CHAR(10);
       DCL-S USR_PRF CHAR(10);
       DCL-S USRDTA CHAR(10);
       DCL-S USRNAM CHAR(10);
       DCL-S X PACKED(9);
       // --------------------------------------------------------------------
       // Stand Alone Fields - BOTTOM
       // --------------------------------------------------------------------
       // If no user name was passed in use *CURRENT as the User Name
       QualJobDs.#Qualjob = #QualJob;
       If QualJobDs.vJobUser <> ' ';
         #LstUsr = QualJobDs.vJobUser;
       EndIf;
       If #LstUsr = *Blanks;
         LstUsr = '*CURRENT';
       Else;
         LstUsr = #LstUsr;
       EndIf;
       // If no user name was passed in use *CURRENT as the User Name
       If #LstOutq = *Blanks;
         LstOutq = '*ALL';
       Else;
         LstOutq = #LstOutq;
       EndIf;

       QualJobDs.#QualJob = #Qualjob;

       Hide = 1;
       DoW 1 = 1;
         If LstOutq <> '*ALL';
           LstOutq2 = LstOutq + '*LIBL';
         Else;
           LstOutq2 = LstOutq;
         Endif;
         // Set Error Code structure to use exceptions
         QUSBPRV = 0;
         // Create a user space for the list generated by QUSLSPL
         EXT_ATTR = 'QUSLSPL   ';
         SPC_AUT = '*ALL';
         SPC_TEXT = *BLANKS;
         SPC_REPLAC = '*YES';
         SPC_DOMAIN = '*USER';
         QUSCRTUS ( SPC_NAME : EXT_ATTR :
         SPC_SIZE : SPC_INIT : SPC_AUT : SPC_TEXT
         : SPC_REPLAC : QUSEC : SPC_DOMAIN );
         // Call QUSLSPL to get all spooled files for *CURRENT User
         FORMAT = 'SPLF0200';
         USR_PRF = LSTUSR;
         OUTQ = LstOutq2;
         FORMTYP = '*ALL';
         USRDTA = '*ALL';
         QUSLSPL_001 ( SPC_NAME : FORMAT :
         USR_PRF : OUTQ : FORMTYP : USRDTA :
         QUSEC : JOBNAM : KEYS : KEY# );
         // Get a resolved pointer to the User Space for performance
         QUSPTRUS ( SPC_NAME : SPCPTR : QUSEC );
         // If valid information was returned
         IF QUSSRL = '0100';
           IF QUSIS = 'C'
             OR QUSIS = 'P';
             // and list entries were found
             IF QUSNBRLE > 0;
               // set LSTPTR to the first byte of the User Space
               LSTPTR = SPCPTR;
               // increment LSTPTR to the first list entry
               LSTPTR = %ADDR(ARR(QUSOLD + 1));
               // and process all of the entries
               FOR DO_X1 = 1 TO QUSNBRLE;
                 // set LSTPTR2 to the first variable length record for this entry
                 X = 5;
                 LSTPTR2 = %ADDR(ARR(X));
                 // process the data based on key type
                 FOR DO_X2 = 1 TO QUSNBRFR00;
                   IF QUSKFFFR00 = 201;
                     PRTFIL = *BLANKS;
                     PRTFIL = %SUBST(QUSSPLKI:17:QUSDL02);
                   ENDIF;

                   IF QUSKFFFR00 = 202;
                     JOBNM = *BLANKS;
                     JOBNM = %SUBST(QUSSPLKI:17:QUSDL02);
                   ENDIF;

                   IF QUSKFFFR00 = 203;
                     USRNAM = *BLANKS;
                     USRNAM = %SUBST(QUSSPLKI:17:QUSDL02);
                   ENDIF;

                   IF QUSKFFFR00 = 204;
                     JOBNBR = *BLANKS;
                     JOBNBR = %SUBST(QUSSPLKI:17:QUSDL02);
                     //Dsply JobNbr;
                   ENDIF;

                   IF QUSKFFFR00 = 205;
                     SPLFLA = *BLANKS;
                     SPLFLA = %SUBST(QUSSPLKI:17:QUSDL02);
                     SPLFLN = SPLFL#;
                     SPLFLC = %EDITC(SPLFLN:'X');
                   ENDIF;

                   IF QUSKFFFR00 = 206;
                     OUTQNM = *BLANKS;
                     OUTQNM = %SUBST(QUSSPLKI:17:QUSDL02);
                   ENDIF;

                   IF QUSKFFFR00 = 207;
                     OUTQLI = *BLANKS;
                     OUTQLI = %SUBST(QUSSPLKI:17:QUSDL02);
                   ENDIF;

                   IF QUSKFFFR00 = 208;
                     DEVICE = *BLANKS;
                     DEVICE = %SUBST(QUSSPLKI:17:QUSDL02);
                   ENDIF;

                   IF QUSKFFFR00 = 209;
                     USRDTA = *BLANKS;
                     USRDTA = %SUBST(QUSSPLKI:17:QUSDL02);
                   ENDIF;

                   IF QUSKFFFR00 = 210;
                     STAT = *BLANKS;
                     STAT = %SUBST(QUSSPLKI:17:QUSDL02);
                     If Stat = '*READY';
                       Status = 'RDY';
                     Endif;
                     If Stat = '*SAVED';
                       Status = 'SAV';
                     Endif;
                     If Stat = '*HELD';
                       Status = 'HLD';
                     Endif;
                     If Stat = '*MESSAGE';
                       Status = 'MSG';
                     Endif;
                     If Stat = '*MESSAGE';
                       Status = 'MSG';
                     Endif;
                     If Stat = '*DEFERRED';
                       Status = 'DFR';
                     Endif;
                     If Stat = '*WRITING';
                       Status = 'WTR';
                     Endif;
                     If Stat = '*OPEN';
                       Status = 'OPN';
                     Endif;
                   ENDIF;

                   IF QUSKFFFR00 = 211;
                     PAGESA = %SUBST(QUSSPLKI:17:QUSDL02);
                     Monitor;
                       PAGESN = PAGES#;
                     On-Error;
                       PAGESN = 9999;
                     EndMon;
                   ENDIF;

                   IF QUSKFFFR00 = 212;
                     CURPGA = %SUBST(QUSSPLKI:17:QUSDL02);
                     Monitor;
                       CURPAG = CURPG#;
                     On-Error;
                       CURPAG = 9999;
                     EndMon;
                   ENDIF;

                   IF QUSKFFFR00 = 213;
                     COPLFA = %SUBST(QUSSPLKI:17:QUSDL02);
                     Monitor;
                       COPIES = COPLF#;
                     On-Error;
                       COPIES = 99;
                     EndMon;
                   ENDIF;

                   IF QUSKFFFR00 = 214;
                     FORMTY = *BLANKS;
                     FORMTY = %SUBST(QUSSPLKI:17:QUSDL02);
                   ENDIF;

                   IF QUSKFFFR00 = 215;
                     PRIOR = *BLANKS;
                     PRIOR = %SUBST(QUSSPLKI:17:QUSDL02);
                   ENDIF;

                   IF QUSKFFFR00 = 216;
                     OPNDAT = *BLANKS;
                     OPNDAT = %SUBST(QUSSPLKI:17:QUSDL02);
                   ENDIF;
                   // increment LSTPTR2 to the next variable length record
                   X += QUSLFIR02;
                   LSTPTR2 = %ADDR(ARR(X));
                 ENDFOR;

                 // after each entry, increment LSTPTR to the next entry
                 LSTPTR = %ADDR(ARR(QUSSEE + 1));

                 If #QualJob <> '*ALL';
                   If QualJobDs.vJobNbr <> JobNbr;
                     Iter;
                   EndIf;

                   If QualJobDs.vJobName <> JobNm;
                     Iter;
                   EndIf;

                   If QualJobDs.vJobUser <> UsrNam;
                     Iter;
                   EndIf;

                 EndIf;

                 IF *IN41 = *OFF;
                   *IN26 = *ON;
                 ENDIF;
                 IF *IN41 = *ON;
                   *IN26 = *OFF;
                 ENDIF;
                 *IN41 = *ON;
                 SflRRN += 1;
                 *IN99 = *OFF;
                 If QUSNBRLE = SflRRN;
                   *IN99 = *ON;
                 Endif;
                 WRITE LSTSPLFSF;
               ENDFOR;
             ENDIF;
             // Move the program name to the program queue to allow
             // the message subfile to get any program messages.
             PGMQ = @PGMID;
     C                   MOVEL     @PGMID        PGMQ

               // Clear the program message queue.
               QMHRMVPM ( ClStkEntry : ClStkCounter :
               MsgKey : MsgsToRmv : ApiErr );

       // Loop
             DOW 1 = 1;
               // Subfile Control Display
               *IN42 = *ON;
               If Hide > SflRRN;
                 Hide = SflRRN;
               Endif;
               // Write the Subfile Control Record.
               WRITE LSTSPLFSC;
               // If no spool files where found
               If *IN41 = *OFF;
                 Write ErrScr;
               Endif;
               // Fill the message subfile.
               WRITE MSGCTL;
               // Dispaly the Command Line Screen
               EXFMT CMDLINE;
               // Read the Control Record to see if any thing has
               // changed on the display.
               READ LSTSPLFSC;
               *IN99 = %EOF;
               If LRRN = 0;
                 Hide = 1;
               Else;
                 If LRRN > SflRRN;
                   Hide = SflRRN;
                   LRRN = SflRRN;
                 Else;
                   Hide = LRRN;
                 Endif;
               Endif;
               SavRRN = Hide;

               *IN25 = *OFF;

               // Clear the program message queue.
               QMHRMVPM ( ClStkEntry : ClStkCounter :
               MsgKey : MsgsToRmv : ApiErr );

               // If F3 or F12 pressed leave the loop to exit the program.
               IF *INKC = *ON OR *INKL = *ON;
                 LEAVE;
               ENDIF;

               IF *INKA;
                 CustomOptions();
                 Iter;
               EndIf;

               // If F5 pressed or the User name field changed
               // leave the loop and reload the subfile.
               IF *INKE = *ON or *IN27 = *ON;
                 LEAVE;
               ENDIF;
               // If F21 pressed retreive the last command.
               If *INKV = *ON;
                 QUSCMDLN();
                 Iter;
               Endif;
               // If any records are changed process them.
               DOW 1 = 1;
                 READC LSTSPLFSF;
                 *IN98 = %EOF;
                 IF *IN98 = *ON;
                   LEAVE;
                 ENDIF;
                 BldSplCmd();
                 If Prompt = 'Y'  or
                   *INKD = *ON;
                   NewCmd = '?' + NewCmd;
                 EndIf;
                 If NewCmd <> ' ';
                   CmdLen = %CHECKR(' ':NewCmd);
                   CmdLen15 = CmdLen;
                   CALLP(E) QCMDEXC ( NewCmd : CmdLen15 );
                   *IN50 = %ERROR;
                 Endif;
                 Opt = '  ';
                 *IN26 = *ON;
                 Update LstSplfSF;
                 *IN26 = *OFF;
               ENDDO;
               If SavRRN > SFLRRN;
                 SavRRN = SFLRRN;
               Endif;
               Hide = SavRRN;
               LRRN = SavRRN;
               CsrRow = 9;
               CsrCol = 2;

               Leave;
             Enddo;
           ENDIF;
         ENDIF;

         IF *INKC = *ON OR *INKL = *ON;
           LEAVE;
         ENDIF;

         SFLRRN = 0;
         *IN41 = *OFF;
         *IN42 = *OFF;
         *IN45 = *ON;
         Write LSTSPLFSC;
         *IN45 = *OFF;
         LRRN = SavRRN;

       ENDDO;
       // Exit the program
       *INLR = '1';
       RETURN;
       DCL-PROC BldSplCmd;
       NewCmd = ' ';
       Opt = %trimr(%triml(Opt));
       Chain Opt Lstsplfp;
       *IN97 = NOT %FOUND;
       IF *In97 = *Off;
         Pos1 = 1;
         DoW 1 = 1;
           Pos2 = %SCAN( '&' : OptCmd:Pos1 );
           If Pos2 > 0;
             Pos3 = Pos2 - Pos1;
             WrkCmd = ' ';
             %SUBST(WrkCmd:1:Pos3) = %SUBST(OptCmd:
             Pos1:Pos3);
             NewCmd = %trimr(NewCmd) + %trimr(WrkCmd);
             %SUBST(OptFld:1:2) = %SUBST(OptCmd:Pos2:
             2);
             If OptFld = '&F';
               NewCmd = %trimr(NewCmd) + %trimr(PrtFil);
             Endif;
             If OptFld = '&J';
               NewCmd = %trimr(NewCmd) + %trimr(JobNbr);
             Endif;
             If OptFld = '&U';
               NewCmd = %trimr(NewCmd) + %trimr(UsrNam);
             Endif;
             If OptFld = '&N';
               NewCmd = %trimr(NewCmd) + %trimr(JobNm);
             Endif;
             If OptFld = '&S';
               NewCmd = %trimr(NewCmd) + %trimr(Splflc);
             Endif;
             If OptFld = '&O';
               NewCmd = %trimr(NewCmd) + %trimr(OutqNm);
             Endif;
             Pos1 = Pos2 + 2;
           Endif;
           If Pos2 <= 0;
             Leave;
           Endif;
         Enddo;
         Pos3 = %CHECKR(' ':OptCmd);
         Pos3 = Pos3 + 1;
         Pos3 = Pos3 - Pos1;
         WrkCmd = *Blanks;
         %SUBST(WrkCmd:1:Pos3) = %SUBST(OptCmd:
         Pos1:Pos3);
         NewCmd = %trimr(NewCmd) + %trimr(WrkCmd);
         NewCmd = %trimr(NewCmd);
       Endif;
       END-PROC BldSplCmd;

       // Handle custom Options
       Dcl-Proc CustomOptions;

       Dow 1=1;
         LoadCustomSubfile();

         Dow 1=1;
           *IN52 = *On;
           Exfmt CUSTOMSC;
           If *INKL;
             Leave;
           EndIf;

           If *INKF;
             Clear @OPTCMD;
             Clear @DESC;
             Clear @OPTION;
             Clear @PROMPT;
             Dow 1=1;
               Exfmt CUSTOM01;
               Clear @ERRMSG;
               If *INKL;
                 *INKL = *Off;
                 Leave;
               EndIf;

               Chain (@OPTION) LSTSPLFP;
               If %found(LSTSPLFP);
                 @ERRMSG = 'Option already exists.';
                 Iter;
               EndIf;

               If @OPTION = ' ';
                 @ERRMSG = 'Option can not be blank.';
                 Iter;
               EndIf;

               If @DESC = ' ';
                 @ERRMSG = 'Description can not be blank.';
                 Iter;
               EndIf;

               If @OPTCMD = ' ';
                 @ERRMSG = 'Command can not be blank.';
                 Iter;
               EndIf;

               If @PROMPT <> 'Y' and @PROMPT <> 'N';
                 @ERRMSG = 'Prompt by be Y or N.';
                 Iter;
               EndIf;

               OPTCMD = @OPTCMD;
               DESC = @DESC;
               OPTION = @OPTION;
               PROMPT = @PROMPT;

               Write LSTSPLFREC;
               Leave;
             Enddo;
           EndIf;

           Dow 1=1;
             Readc CUSTOMSF;

             If %eof(LSTSPLFFM);
               Leave;
             EndIf;

             If @SELECT = '2';
               *IN60 = *On;
               @OPTCMD = OPTCMD;
               @DESC = DESC;
               @OPTION = OPTION;
               @PROMPT = PROMPT;
               @SELECT = ' ';

               Chain (Option) LSTSPLFP;
               If not %found(LSTSPLFP);
                 Iter;
               EndIf;

               Dow 1=1;
                 Exfmt CUSTOM01;
                 If *INKL = *On;
                   *INKL = *Off;
                   Leave;
                 EndIf;

                 If @OPTCMD = ' ';
                   @ERRMSG = 'Command can not be blank.';
                   Iter;
                 EndIf;

                 If @DESC = ' ';
                   @ERRMSG = 'Description can not be blank.';
                   Iter;
                 EndIf;

                 If @OPTION = ' ';
                   @ERRMSG = 'Option can not be blank.';
                   Iter;
                 EndIf;

                 If @PROMPT <> 'Y' and @PROMPT <> 'N';
                   @ERRMSG = 'Prompt by be Y or N.';
                   Iter;
                 EndIf;

                 OPTCMD = @OPTCMD;
                 DESC = @DESC;
                 OPTION = @OPTION;
                 PROMPT = @PROMPT;

                 Update CUSTOMSF;

                 Update LSTSPLFREC;

                 Leave;
               EndDo;
             EndIf;

             If @SELECT = '4';
               Chain (Option) LSTSPLFP;
               If %found(LSTSPLFP);
                 Delete LSTSPLFP;
               EndIf;
             Endif;

           EndDo;
           LoadCustomSubfile();
         EndDo;

         If *INKL;
           Leave;
         EndIf;
       EndDo;
       End-Proc;

       Dcl-Proc LoadCustomSubfile;
       SFLRRN2 = 0;
       *IN51 = *Off; // turn off subfile display
       *IN52 = *Off; // turn off subfile display control
       *IN55 = *On;  // turn on subfile clear
       Write CUSTOMSC;
       *IN55 = *Off;

       Setll *LOVAL LSTSPLFP;
       Dow 1=1;
         Clear @Select;
         Read LSTSPLFP;
         If %eof(LSTSPLFP);
           Leave;
         EndIf;

         SFLRRN2 +=1;
         Write CUSTOMSF;
         *IN51 = *On;
       EndDo;

       End-Proc;
