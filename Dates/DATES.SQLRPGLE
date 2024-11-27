**free
Ctl-Opt Main(Main) ALWNULL(*UsrCtl)  OPTION(*SrcStmt:*NoDebugIO) Text('Example Date Conversions');

Dcl-S @charA       Char(8)    INZ('04/12/01');
Dcl-S @charB       Char(10)   INZ('12/02/2004');
Dcl-S @charC       Char(8)    INZ('12/03/04');
Dcl-S @dateA       Date       INZ(D'2004-12-04');
Dcl-S @numA        Packed(6:0) INZ(041205);
Dcl-S @numB        Packed(7:0) INZ(1041206);
Dcl-S @numC        Packed(8:0) INZ(20041207);
Dcl-S @numD        Packed(6:0) INZ(120804);
Dcl-S @numE        Packed(8:0) INZ(12092004);
Dcl-S todaycymd    Packed(7:0);
Dcl-S StrDate      Date;
Dcl-S EndDate      Date;
Dcl-S todayTs      Timestamp;
Dcl-S vRunDate     Date;
Dcl-S vRunTime     Time;

// character to character...
@charB = %char(%date(@charA:*ymd/):*usa/); // 'yy/mm/dd' to 'mm/dd/ccyy'
@charC = %char(%date(@charA:*ymd/):*mdy/); // 'yy/mm/dd' to 'mm/dd/yy'
@charA = %char(%date(@charB:*usa/):*ymd/); // 'mm/dd/ccyy' to 'yy/mm/dd'
@charC = %char(%date(@charB:*usa/):*mdy/); // 'mm/dd/ccyy' to 'mm/dd/yy'
@charA = %char(%date(@charC:*mdy/):*ymd/); // 'mm/dd/yy' to 'yy/mm/dd'
@charB = %char(%date(@charC:*mdy/):*usa/); // 'mm/dd/yy' to 'mm/dd/ccyy'

       // character to date...
@dateA = %date(@charA:*ymd/); // 'yy/mm/dd' to D'ccyy-mm-dd'
@dateA = %date(@charB:*usa/); // 'mm/dd/ccyy' to D'ccyy-mm-dd'
@dateA = %date(@charC:*mdy/); // 'mm/dd/yy' to D'ccyy-mm-dd'

       // character to numeric...
@numA = %dec(%char(%date(@charA:*ymd/):*ymd0):6:0); // 'yy/mm/dd' to yymmdd
@numB = %dec(%char(%date(@charA:*ymd/):*cymd0):7:0); // 'yy/mm/dd' to cyymmdd
@numC = %dec(%char(%date(@charA:*ymd/):*iso0):7:0); // 'yy/mm/dd' to ccyymmdd
@numD = %dec(%char(%date(@charA:*ymd/):*mdy0):7:0); // 'yy/mm/dd' to mmddyy
@numE = %dec(%char(%date(@charA:*ymd/):*usa0):7:0); // 'yy/mm/dd' to mmddyyyy
@numA = %dec(%char(%date(@charB:*usa/):*ymd0):6:0); // 'mm/dd/ccyy' to yymmdd
@numB = %dec(%char(%date(@charB:*usa/):*cymd0):7:0); // 'mm/dd/ccyy' to cyymmdd
@numC = %dec(%char(%date(@charB:*usa/):*iso0):7:0); // 'mm/dd/ccyy' to ccyymmdd
@numD = %dec(%char(%date(@charB:*usa/):*mdy0):7:0); // 'mm/dd/ccyy' to mmddyy
@numE = %dec(%char(%date(@charB:*usa/):*usa0):7:0); // 'mm/dd/ccyy' to mmddyyyy
@numA = %dec(%char(%date(@charC:*mdy/):*ymd0):6:0); // 'mm/dd/yy' to yymmdd
@numB = %dec(%char(%date(@charC:*mdy/):*cymd0):7:0); // 'mm/dd/yy' to cyymmdd
@numC = %dec(%char(%date(@charC:*mdy/):*iso0):7:0); // 'mm/dd/yy' to ccyymmdd
@numD = %dec(%char(%date(@charC:*mdy/):*mdy0):7:0); // 'mm/dd/yy' to mmddyy
@numE = %dec(%char(%date(@charC:*mdy/):*usa0):7:0); // 'mm/dd/yy' to mmddyyyy

       // date to character...
@charA = %char(@dateA:*ymd/); // D'ccyy-mm-dd' to 'yy/mm/dd'
@charB = %char(@dateA:*usa/); // D'ccyy-mm-dd' to 'mm/dd/ccyy'
@charC = %char(@dateA:*mdy/); // D'ccyy-mm-dd' to 'mm/dd/yy'

       // date to numeric...
@numA = %dec(%char(@dateA:*ymd/):6:0); // D'ccyy-mm-dd' to yymmdd
@numB = %dec(%char(@dateA:*cymd/):7:0); // D'ccyy-mm-dd' to cyymmdd
@numC = %dec(%char(@dateA:*iso-):8:0); // D'ccyy-mm-dd' to ccyymmdd
@numD = %dec(%char(@dateA:*mdy/):6:0); // D'ccyy-mm-dd' to mmddyy
@numE = %dec(%char(@dateA:*usa/):8:0); // D'ccyy-mm-dd' to mmddccyy

       // numeric to character...
@charA = %char(%date(@numA:*ymd):*ymd/); // yymmdd to 'yy/mm/dd'
@charB = %char(%date(@numA:*ymd):*usa/); // yymmdd to 'mm/dd/ccyy'
@charC = %char(%date(@numA:*ymd):*mdy/); // yymmdd to 'mm/dd/yy'
@charA = %char(%date(@numB:*cymd):*ymd/); // cyymmdd to 'yy/mm/dd'
@charB = %char(%date(@numB:*cymd):*usa/); // cyymmdd to 'mm/dd/ccyy'
@charC = %char(%date(@numB:*cymd):*mdy/); // cyymmdd to 'mm/dd/yy'
@charA = %char(%date(@numC:*iso):*ymd/); // D'ccyy-mm-dd' to 'yy/mm/dd'
@charB = %char(%date(@numC:*iso):*usa/); // D'ccyy-mm-dd' to 'mm/dd/ccyy'
@charC = %char(%date(@numC:*iso):*mdy/); // D'ccyy-mm-dd' to 'mm/dd/yy'
@charA = %char(%date(@numD:*mdy):*ymd/); // mmddyy to 'yy/mm/dd'
@charB = %char(%date(@numD:*mdy):*usa/); // mmddyy to 'mm/dd/ccyy'
@charC = %char(%date(@numD:*mdy):*mdy/); // mmddyy to 'mm/dd/yy'
@charA = %char(%date(@numE:*usa):*ymd/); // mmddccyy to 'yy/mm/dd'
@charB = %char(%date(@numE:*usa):*usa/); // mmddccyy to 'mm/dd/ccyy'
@charC = %char(%date(@numE:*usa):*mdy/); // mmddccyy to 'mm/dd/yy'

       // numeric to date...
@dateA = %date(@numA:*ymd); // yymmdd to D'ccyy-mm-dd'
@dateA = %date(@numB:*cymd); // cyymmdd to D'ccyy-mm-dd'
@dateA = %date(@numC:*iso); // ccyymmdd' to D'ccyy-mm-dd'
@dateA = %date(@numD:*mdy); // mmddyy to D'ccyy-mm-dd'
@dateA = %date(@numE:*usa); // mmddccyy to D'ccyy-mm-dd'

       // numeric to numeric...
@numB = %dec(%char(%date(@numA:*ymd):*cymd0):7:0); // yymmdd to cyymmdd
@numC = %dec(%char(%date(@numA:*ymd):*iso0):8:0); // yymmdd to ccyymmdd
@numD = %dec(%char(%date(@numA:*ymd):*mdy0):6:0); // yymmdd to mmddyy
@numE = %dec(%char(%date(@numA:*ymd):*usa0):8:0); // yymmdd to mmddccyy
@numA = %dec(%char(%date(@numB:*cymd):*ymd0):6:0); // cyymmdd to yymmdd
@numC = %dec(%char(%date(@numB:*cymd):*iso0):8:0); // cyymmdd to ccyymmdd
@numD = %dec(%char(%date(@numB:*cymd):*mdy0):6:0); // cyymmdd to mmddyy
@numE = %dec(%char(%date(@numB:*cymd):*usa0):8:0); // cyymmdd to mmddccyy
@numA = %dec(%char(%date(@numC:*iso):*ymd0):6:0); // ccyymmdd to yymmdd
@numB = %dec(%char(%date(@numC:*iso):*cymd0):7:0); // ccyymmdd to cyymmdd
@numD = %dec(%char(%date(@numC:*iso):*mdy0):6:0); // ccyymmdd to mmddyy
@numE = %dec(%char(%date(@numC:*iso):*usa0):8:0); // ccyymmdd to mmddccyy
@numA = %dec(%char(%date(@numD:*mdy):*ymd0):6:0); // mmddyy to yymmdd
@numB = %dec(%char(%date(@numD:*mdy):*cymd0):7:0); // mmddyy to cyymmdd
@numC = %dec(%char(%date(@numD:*mdy):*iso0):8:0); // mmddyy to ccyymmdd
@numE = %dec(%char(%date(@numD:*mdy):*usa0):8:0); // mmddyy to mmddccyy
@numA = %dec(%char(%date(@numE:*usa):*ymd0):6:0); // mmddccyy to yymmdd
@numB = %dec(%char(%date(@numE:*usa):*cymd0):7:0); // mmddccyy to cyymmdd
@numC = %dec(%char(%date(@numE:*usa):*iso0):8:0); // mmddccyy to ccyymmdd
@numD = %dec(%char(%date(@numE:*usa):*mdy0):6:0); // mmddccyy to mmddyy

Exec SQL  Set :RtnDate = Last_Day('2012-09-01');

Exec SQL
          Select Last_Day('2012-09-01') from sysibm/sysdummy1;

Exec SQL   Set :MonthEnd = Last_Day(:MyDate - 1 Month);
Exec SQL   Set :FirstDay = Last_Day(:MyDate - 2 Months) + 1 Day;

Exec SQL Set :TimeStamp =
         Timestamp(obs.ovadate, ( Substring(Digits(obs.ovatime), 1, 2)
                             || ':'
                             || Substring(Digits(obs.ovatime), 3, 2)
                             || ':'
                             || Substring(Digits(obs.ovatime), 5, 2) ));

Exec SQL Set :hours =
         cast(cast (timestampdiff(4, char(CURRENT timestamp -
         timestamp(obs.ovadate, (
         substring(digits(obs.ovatime), 1, 2)
         || ':'
         || substring(digits(obs.ovatime), 3, 2)
         || ':'
         || substring(digits(obs.ovatime), 5, 2) )))) AS
         decimal (11,1)) / 60 AS decimal (11,1));

todaycymd = %dec(%Char(%date():*CYMD0):7:0);

StrDate = %date(%subst(%char(%date()):1:8) + '01':*ISO);
EndDate = StrDate + %months(1) - %days(1);

*INLR = *on;
        // First day of the month
Exec SQL SELECT (DATE('09/20/2012')) - DAY(DATE('09/20/2012') - 1 DAY)
               DAYS  FROM SYSIBM/SYSDUMMY1;

Exec Sql Set :todayTs = current timestamp;
vRunDate = %date(todayTs);
vRunTime = %time(todayTs);
*inlr = *on;
