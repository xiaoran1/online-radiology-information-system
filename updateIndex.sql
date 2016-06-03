REM 
Rem Copyright (c) 1999, 2001, Oracle Corporation.  All rights reserved.  
Rem
Rem    NAME
Rem      drjobdml.sql - DR dbms_JOB DML script
Rem
Rem    NOTES
Rem      This is a script which demonstrates how to submit a DBMS_JOB 
Rem      which will keep a context index up-to-date.
Rem
Rem      Before running this script, please ensure that your database
Rem      is set up to run dbms_jobs.  job_queue_processes must be set
Rem      (and non-zero) in init.ora.  See Administrators Guide for more
Rem      information.
Rem
Rem      Also, due to PL/SQL security, ctxsys must manually grant EXECUTE
Rem      on ctx_ddl directly to the user.  CTXAPP role is not sufficient.
Rem
Rem    USAGE
Rem      as index owner, in SQL*Plus:
Rem
Rem        @drjobdml <indexname> <interval>
Rem
Rem      A job will be submitted to check for and process dml for the
Rem      named index every <interval> minutes
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    gkaminag    11/19/01  - bug 2052473.
Rem    gkaminag    05/14/99 -  bugs
Rem    gkaminag    04/09/99 -  Creation

set serveroutput on
declare
  job3 number;
  job4 number;
begin
  dbms_job.submit(job3, 'ctx_ddl.sync_index(''myindex3'');',
                  interval=>'SYSDATE+0/1440');
  dbms_job.submit(job4, 'ctx_ddl.sync_index(''myindex4'');',
                  interval=>'SYSDATE+0/1440');
  commit;
  dbms_output.put_line('job '||job3||' has been submitted.');
  dbms_output.put_line('job '||job4||' has been submitted.');
end;
/
