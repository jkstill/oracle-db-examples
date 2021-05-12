
set serveroutput on size unlimited format wrapped
call dbms_java.set_output(50000);

call WorkerSp('621', 'Senior VP', '650000');

exit

