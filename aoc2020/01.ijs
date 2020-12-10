#!/usr/bin/env jconsole

input=. }:0". > LF splitstring stdin''

sum2=. +/~ input 
sum3=. sum2 +/ input
echo */ (I. (+./ sum2=2020)) { input
echo */ (I. (+./^:2 sum3=2020)) { input

exit''
