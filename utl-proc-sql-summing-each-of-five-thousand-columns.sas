%let pgm=utl-proc-sql-with-sum-each-of-five-thousand-columns;

Proc sql summing each of five thousand columns

I realize there is  a non SQL solution, however here is a SQL solution.
This might not be as slow as you think, depends on the Compiler
The 10 rows and 5,500 columns took SECS=3.3 seconds

github
https://tinyurl.com/yw34dp8h
https://github.com/rogerjdeangelis/utl-proc-sql-summing-each-of-five-thousand-columns

StackOverflow
https://stackoverflow.com/questions/70537716/proc-sql-running-out-of-memory

/*                   _
(_)_ __  _ __  _   _| |_
| | `_ \| `_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
*/
data have;
  array cs c1-c5500;
  do rec=1 to 10;
    do over cs;
       cs=int(2*uniform(1234));
    end;
    output;
  end;
  stop;
run;quit;

/*
Middle Observation(5 ) of have - Total Obs 10

 -- NUMERIC --

Variable  Type    Value

C1        N8       0
C2        N8       1
C3        N8       0
C4        N8       0
C5        N8       0
C6        N8       0
C7        N8       0
C8        N8       0
C9        N8       0
C10       N8       0
...
C5496     N8       0
C5497     N8       0
C5498     N8       0
C5499     N8       0
C5500     N8       1
*/

/*           _               _
  ___  _   _| |_ _ __  _   _| |_
 / _ \| | | | __| `_ \| | | | __|
| (_) | |_| | |_| |_) | |_| | |_
 \___/ \__,_|\__| .__/ \__,_|\__|
                |_|
*/


Variable  Type     Sum

C1        N8       6   *  random sum of ones and zeros over 10 records
C2        N8       5      should average about 5
C3        N8       2
C4        N8       3
C5        N8       4
C6        N8       4
C7        N8       4
C8        N8       5
C9        N8       4
C10       N8       6
...
C5496     N8       7
C5497     N8       5
C5498     N8       5
C5499     N8       6
C5500     N8       5

/*
 _ __  _ __ ___   ___ ___  ___ ___
| `_ \| `__/ _ \ / __/ _ \/ __/ __|
| |_) | | | (_) | (_|  __/\__ \__ \
| .__/|_|  \___/ \___\___||___/___/
|_|
*/

%utlnopts;  * you must turn off symbolgen macrogen ...;

%array(_c,values=1-5500);

%put &=_cn;
%put &=_c5500;

%let tym=%sysfunc(time());
proc sql;
  create
     table want as
  select
     %do_over(_c,phrase=sum(c?) as c?,between=comma)
  from
     have
;quit;
%let secs=%sysevalf(%sysfunc(time()) - &tym);
%put &=secs seconds;

* remove the macro variable;
%arraydelete(_c);

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
