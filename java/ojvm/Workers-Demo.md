Java in the DB vs Java in the App Server
========================================


## Environment 

DB: Oracle 19.8 RAC

Client: 

Server: Ubuntu 18.10
Oracle: 12.1
Java 1.6.0_75-b13

Client and Server are connected to the same 1G switch - 1 hop.


## Changes

Removed unneeded code from 

* Workers_jdbc.java
* Workers_OJVM.sql

Created some demo scripts

## Build and Run Demos

### Build Table

```sql

sqlplus hr/hr@yourdb

SQL#  @Workers_table.sql

```

### Build JDBC

```bash
$ORACLE_HOME/jdk/bin/javac -cp $ORACLE_HOME/jdbc/lib/ojdbc6.jar Workers_jdbc.java
```

### Run JDBC

```bash
$ORACLE_HOME/jdk/bin/java -classpath ./:$ORACLE_HOME/jdbc/lib/ojdbc6.jar Workers_jdbc 621 'Senior VP' 650000
Running in JDK VM, outside the database!
Worker Name: Jean Francois
Worker: Id = 621, Name = Jean Francois, Position = Senior VP, Salary = 650000
====> Duration: 205 Milliseconds
```

### Build OJVM

```sql
sqlplus hr/hr@yourdb

SQL# @Workers_OJVM.sql

Java created.

No errors.

Procedure created.

No errors.
```

### Run OJVM

```sql
@run-Workers_OJVM

Call completed.

Running in OracleJVM,  in the database!
Worker Name: Jean Francois
Worker: Id = 621, Name = Jean Francois, Position = Senior VP, Salary = 650000
====> Duration: 26 Milliseconds

Call completed.
```

## Timed Tests

Update the data for each employee (6)

Get the timing for each transaction, sum and average them.

Timing is only transaction time.  

Not included:

* app startup time
* connection time
* exit time

### JDBC Timed Test

Times are in milliseconds

```bash
$  ./time-jdbc.sh
wid: 103  job:  Janitor  salary:  50000
====> Duration: 189 Milliseconds
wid: 201  job:  DBA  salary:  2000000
====> Duration: 207 Milliseconds
wid: 323  job:  Junior Staff Member  salary:  15000
====> Duration: 224 Milliseconds
wid: 418  job:  Senior Staff Member  salary:  100000
====> Duration: 198 Milliseconds
wid: 521  job:  Engineer  salary:  150000
====> Duration: 195 Milliseconds
wid: 621  job:  Senior VP  salary:  5000000
====> Duration: 183 Milliseconds

189
207
224
198
195
183
Total Time: 1196
Avg Time: 199
```

### OJVM Timed Test

```bash
$  ./time-ojvm.sh
wid: 103  job:  Janitor  salary:  50000
====> Duration: 74 Milliseconds
wid: 201  job:  DBA  salary:  2000000
====> Duration: 33 Milliseconds
wid: 323  job:  Junior Staff Member  salary:  15000
====> Duration: 39 Milliseconds
wid: 418  job:  Senior Staff Member  salary:  100000
====> Duration: 31 Milliseconds
wid: 521  job:  Engineer  salary:  150000
====> Duration: 39 Milliseconds
wid: 621  job:  Senior VP  salary:  5000000
====> Duration: 32 Milliseconds

74
33
39
31
39
32
Total Time: 248
Avg Time: 41
```

## Conclusion

This is a brief demo, but even so, the results indicate that when manipulating data in the Oracle database,
performance is quite a bit better when using the Oracle Java engine and avoid the overhead of an external app.

JDBC Average Transaction Time: 199 ms
OJVM Average Transaction Time: 41 ms


