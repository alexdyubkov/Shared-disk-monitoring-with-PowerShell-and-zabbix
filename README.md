# Shared-disk-monitoring-with-PowerShell-and-zabbix
Zabbix can't monitor files on shared disks by itself. But it can be done using PowerShell script and sending results(push) to Zabbix graphs. Alerts can be sent to Slack.

To do it - 2 things should be done:
a)preparations in zabbix. Check  preparations.png
b)script should be created. Check queued_files_checker.ps1
