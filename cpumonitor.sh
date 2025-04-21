#!/bin/bash
 
{
    echo "DATE: $(date)"
    echo ""
 
    echo "CPU USAGE:"
    top -b -n1 | grep "Cpu(s)"
 
    echo ""
    echo "MEMORY USAGE:"
    free -h
 
    echo ""
    echo "DISK USAGE:"
    df -h
 
    echo ""
    echo "Top 5 Memory Consuming Processes:"
    ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -n 6
 
   echo "THIS IS BEVARSI MISHRA"
 
} > "log1.txt"
