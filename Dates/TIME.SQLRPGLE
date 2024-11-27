       Dcl-S $time_a      Char(8);
       Dcl-S $time_n      Zoned(6:0) INZ(121501);
       Dcl-S $time_hms    Char(8)    INZ('16:23:01');
       Dcl-S $time_usa    Char(8)    INZ('04:23 PM');

       //Current Time in *ISO
       $time_a = %char(%time():*ISO);
       dsply $time_a;

       //Current Time in *HMS
       $time_a = %char(%time():*HMS);
       dsply $time_a;

       //Current Time in *USA
       $time_a = %char(%time():*USA);
       dsply $time_a;

       //Numeric Time to *ISO
       $time_a = %char(%time($time_n):*ISO);
       dsply $time_a;

       //Numeric Time to *HMS
       $time_a = %char(%time($time_n):*HMS);
       dsply $time_a;

       //Numeric Time to *USA
       $time_a = %char(%time($time_n):*USA);
       dsply $time_a;

       //*HMS to *ISO
       $time_a = %char(%time($time_hms:*hms):*ISO);
       dsply $time_a;

       //*HMS to *USA
       $time_a = %char(%time($time_hms:*hms):*USA);
       dsply $time_a;

       //*USA to *ISO
       $time_a = %char(%time($time_usa:*usa):*ISO);
       dsply $time_a;

       //*USA to *HMS
       $time_a = %char(%time($time_usa:*usa):*HMS);
       dsply $time_a;

       //Add Hours
       $time_a = %char((%time($time_usa:*usa) + %hours(2)):*HMS);
       dsply $time_a;

       //Add Minutes
       $time_a = %char((%time($time_usa:*usa) + %minutes(10)):*HMS);
       dsply $time_a;

       //Add Seconds
       $time_a = %char((%time($time_usa:*usa) + %seconds(15)):*HMS);
       dsply $time_a;

       //Substract Hours
       $time_a = %char((%time($time_usa:*usa) + %hours(-2)):*HMS);
       dsply $time_a;

       //Substract Minutes
       $time_a = %char((%time($time_usa:*usa) + %minutes(-10)):*HMS);
       dsply $time_a;

       //Substract Seconds
       $time_a = %char((%time($time_usa:*usa) + %seconds(-15)):*HMS);
       dsply $time_a;

       *inlr = *on