# batch_ping
A bash shell script to ping a list of IPs, and find the fastest one, mainly used to test the DNS servers.

It will simutanously generate a csv file in the same directory to store ping statistic results.

---
## usage
```Shell
./batch_ping.sh IPLIST_FILE
```

*IPLIST_FILE* is the plain text file which stores the list of IPs to ping.
