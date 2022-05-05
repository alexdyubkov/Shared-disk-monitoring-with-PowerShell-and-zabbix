# Shared-disk-monitoring-with-PowerShell-and-zabbix
____

## Issue description: 
Zabbix can't monitor files on shared disks by itself. 

## Solution:
But it can be done using **PowerShell** script and sending results(push) to **Zabbix graphs**. Alerts can be sent to **Slack**.




### To do it - 2 things should be done:
a)preparations in zabbix. Check  [Preparations.png](https://github.com/alexdyubkov/Shared-disk-monitoring-with-PowerShell-and-zabbix/blob/main/Preparations.png)
<br>
b)script should be created. Check [queued_files_checker.ps1](https://github.com/alexdyubkov/Shared-disk-monitoring-with-PowerShell-and-zabbix/blob/main/queued_files_checker.ps1)
