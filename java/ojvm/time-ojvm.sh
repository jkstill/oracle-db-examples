#!/usr/bin/env bash

declare -a wid=(103 201 323 418 521 621)
declare -a job=('Janitor' 'DBA' 'Junior Staff Member' 'Senior Staff Member' 'Engineer' 'Senior VP')
declare -a salary=(50000 2000000 15000 100000 150000 5000000)

tns=ora192rac-scan/pdb4.jks.com
username=hr
password=hr

declare  -a times

for i in {0..5} 
do
	echo "wid: ${wid[$i]}  job:  ${job[$i]}  salary:  ${salary[$i]}"
	results=$(sqlplus -L "$username"/"$password"@"$tns" @run-Workers_OJVM-exit.sql "${wid[$i]}" "${job[$i]}"  "${salary[$i]}")
	echo "results: $results" | grep Duration 
	times[$i]=$(echo "results: $results" | grep Duration | awk '{ print $3 }')
done

echo

total_time=0

for i in ${!times[@]}
do
	echo ${times[$i]}
	(( total_time += ${times[$i]} ))
done

avg_time=$total_time
(( avg_time /= ${#times[@]} ))

echo Total Time: $total_time
echo Avg Time: $avg_time

