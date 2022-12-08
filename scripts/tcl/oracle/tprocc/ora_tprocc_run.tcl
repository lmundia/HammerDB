#!/bin/tclsh
# maintainer: Pooja Jain

set tmpdir $::env(TMP)
puts "SETTING CONFIGURATION"
dbset db ora
dbset bm TPC-C

diset connection system_user system
diset connection system_password manager
diset connection instance oracle

set vu [ numberOfCPUs ]
set warehouse [ expr {$vu * 5} ]
diset tpcc count_ware $warehouse
diset tpcc num_vu $vu
diset tpcc tpcc_user tpcc
diset tpcc tpcc_pass tpcc

iset tpcc ora_driver timed
diset tpcc ora_total_iterations 10000000
diset tpcc ora_rampup 2
diset tpcc ora_duration 5
diset tpcc ora_timeprofile true
diset tpcc allwarehouse true
diset tpcc checkpoint true

loadscript
puts "TEST STARTED"
vuset vu vcpu
vucreate
tcstart
tcstatus
set jobid [ vurun ]
vudestroy
tcstop
puts "TEST COMPLETE"
set of [ open $tmpdir/ora_tprocc w ]
puts $of $jobid
close $of
