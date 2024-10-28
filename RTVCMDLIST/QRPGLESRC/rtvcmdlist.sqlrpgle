       CTL-OPT DFTACTGRP(*NO);
       DCL-F RTVLSCMDFM WORKSTN(*EXT) USAGE(*INPUT:*OUTPUT)
             SFILE(RTVCMDSF:SFLRRN) INFDS(DSPDS);

       DCL-DS DSPDS;
         CURSOR BINDEC(4) POS(370);
         LRRN BINDEC(4) POS(378);
       END-DS;

       // QCMDEXEC to run IBMi commands
       DCL-PR QCmdExc ExtPgm('QCMDEXC');
         *N CHAR(2000) Const;
         *N PACKED(15:5) Const;
       END-PR;

       //----------------------------------------------------------------------
       // Stand Alone Fields - TOP
       //----------------------------------------------------------------------
       DCL-S SflRRN PACKED(4);
       DCL-S SavRRN PACKED(4);
       DCL-S Command CHAR(256);
       DCL-S CmdKey CHAR(4);
       DCL-S CmdKeySav CHAR(4);
       DCL-S CommandArr CHAR(256) DIM(5000);
       DCL-S CommandArrIdx PACKED(5:0) DIM(5000);
       //----------------------------------------------------------------------
       // Stand Alone Fields - BOTTOM
       //----------------------------------------------------------------------

       //----------------------------------------------------------------------
       // Mainline Program - TOP
       //----------------------------------------------------------------------
       *IN42 = *ON;
       Hide = 1;

       // Load Subfile
       $Load();

       Hide = 1;

       Dow 1 = 1;
         Exfmt RtvCmdSc;

         If *INKC = *On;
           *INLR = *ON;
           Return;
         EndIf;

         If *IN88 = *On;
           $Load();
           Iter;
         EndIf;

         SavRRN = LRRN;
         Dow 1 = 1;
           ReadC RtvCmdSf;

           If %eof(RTVLSCMDFM);
             Leave;
           EndIf;

           If Opt = 'X';
             command = '? ' + command;
             Monitor;
               qcmdexc(command : %len(%trim(command)));
             On-Error;
             EndMon;
             Opt = '  ';
             Update RtvCmdSF;
           EndIf;

         Enddo;
         Hide = SavRRN;
       Enddo;

       //----------------------------------------------------------------------
       // Mainline Program - BOTTOM
       //----------------------------------------------------------------------

       //----------------------------------------------------------------------
       // $Load - TOP - Load Subfile with a list of commands
       //----------------------------------------------------------------------
       DCL-PROC $Load;
       DCL-S vCount PACKED(5:0);
       *IN99 = *OFF;
       Dow 1=1;
         Command = RtvLstCmd(Command : CmdKey);
         If CmdKey = CmdKeySav;
           *IN99 = *ON;
           Leave;
         EndIf;
         IF %UPPER(Command) = 'RTVCMDLIST';
           Iter;
         Endif;
         IF %UPPER(Command) = '/*      */';
           Iter;
         Endif;

         If %lookup(%upper(Command) : CommandArr) > 0;
           Iter;
         Endif;
         CommandArrIdx += 1;
         CommandArr(CommandArrIdx) = %upper(Command);
         IF *IN51 = *OFF;
           CmdKeySav = CmdKey;
         ENDIF;
         IF *IN51 = *OFF;
           *IN51 = *ON;
         ENDIF;
         #Cmd = Command;
         *IN41 = *ON;
         SflRRN = SflRRN + 1;
         vCount += 1;
         Write RtvCmdSf;
         If vCount >= 14;
           Leave;
         Endif;
       ENDDO;
       Hide = SflRRN;
       END-PROC $Load;
       //----------------------------------------------------------------------
       // $Load - BOTTOM - Load Subfile with a list of commands
       //----------------------------------------------------------------------

       //----------------------------------------------------------------------
       // RtvLstCmd - TOP - Get Last Command from Joblog
       //----------------------------------------------------------------------
       DCL-PROC RtvLstCmd;
         DCL-PI *N CHAR(260);
           Line CHAR(256);
           Key CHAR(4);
         END-PI;

       // Retrieve Request Message API
       DCL-PR QMHRTVRQ EXTPGM('QMHRTVRQ');
          *N LIKE(Command);
          *N LIKE(Length);
          *N LIKE(Format);
          *N LIKE(Type);
          *N LIKE(Key);
          *N LIKE(Error);
       END-PR;

       DCL-S Command CHAR(256);
       DCL-S Format CHAR(8) Inz('RTVQ0100');
       DCL-S Type CHAR(10) Inz('*LAST');
       DCL-S Error CHAR(70);
     
       DCL-DS DS1;
         BinLen BINDEC(9);
         Length CHAR(4) OVERLAY(BinLen);
       END-DS;

       BinLen = 256;
       If Key = ' ';
         Type = '*LAST';
       Else;
         Type = '*PRV';
       Endif;

       DoU Line <> ' ';
         QMHRTVRQ(Command
                : Length
                : Format
                : Type
                : Key
                : Error);
         %SUBST(Key:1:4) = %SUBST(Command:9:4);
         %SUBST(Line:1:215) = %SUBST(Command:41:215);
         Type = '*PRV';
       Enddo;
       Return Line;
       END-PROC;
       //----------------------------------------------------------------------
       // RtvLstCmd - BOTTOM - Get Last Command from Joblog
       //----------------------------------------------------------------------
