<#
########################################################   FYI  ########################################################################################
This is a push script. It means it pushes results to zabbix. The idea is that zabbix will show on the graph only result from a host. If the host is down and doesn't push anything - zabbix will continue showing a straight line.
But for such cases, we have an alert for the host itself.
#>
cls
########################################################################################################################################################
​
​
​
######################################################## INPUT VARs ####################################################################################
$trigger_number_files =  100
$uriSlack = "https://hooks.slack.com/services/T0..."  #This is a link to your slack channel webhook
$zabbix_server = '10.x.x.x'  
$what_host_is_the_sender =  'ha...'  #host name. Should be the same name as in Zabbix for this host
​
​
​
$dir = @(  #shared directories you want to monitor
'\\xxx\xxx\xxx\xxx\Folder1' 
'\\xxx\xxx\xxx\xxx\Folder3' 
'\\xxx\xxx\xxx\xxx\Folder4' 
'\\xxx\xxx\xxx\xxx\Folder5' 
'\\xxx\xxx\xxx\xxx\Folder6' 
'\\xxx\xxx\xxx\xxx\Folder7' 
'\\xxx\xxx\xxx\xxx\Folder8' 
'\\xxx\xxx\xxx\xxx\Folder9' 
'\\xxx\xxx\xxx\xxx\Folder10' 
)
​
$key_for_zabbix_trap = @(  #keys you created in zabbix for each directory
'Folder1_key1'
'Folder1_key2'
'Folder1_key3'
'Folder1_key4'
'Folder1_key5'
'Folder1_key6'
'Folder1_key7'
'Folder1_key8'
'Folder1_key9'
'Folder1_key10'
)
#########################################################################################################################################################
​
​
​
######################################################## Automatic variables based on input variables ###################################################
$hostname = [System.Net.Dns]::GetHostName()
$send_to_zabbix_graph_a_bad_response = 'C:\"Program Files"\"Zabbix Agent"\zabbix_sender.exe -z $zabbix_server -s $what_host_is_the_sender -k $key_for_zabbix_trap[$i] -o -1' 
$send_to_zabbix_graph ='C:\"Program Files"\"Zabbix Agent"\zabbix_sender.exe -z $zabbix_server -s $what_host_is_the_sender -k $key_for_zabbix_trap[$i] -o $num_of_files'
​
​
$i=0
foreach ($item in $dir) 
{
Set-Location -Path $item
#echo "iteration:$i"
​
$num_of_files=(Get-ChildItem | Measure-Object).Count
#echo "num of files in $item is $num_of_files"
​
Invoke-Expression $send_to_zabbix_graph
​
​
​
​
​
$body = ConvertTo-Json @{
    text = "Number of queued faxes on $hostname in $item is:  $num_of_files. The trigger is: $trigger_number_files. Link to the board: https://zabbix.xxx.net/link to your zabbix graph "
    color = "#142954"
}
$post_to_slack_channel = 'Invoke-RestMethod -uri $uriSlack -Method Post -body $body -ContentType "application/json" | Out-Null'
​
​
​
​
$body_fail_case = ConvertTo-Json @{
    text = "Script failed for some reason, please ask tech team to check "
    color = "#142954"
}
$post_to_slack_channel_fail_case = 'Invoke-RestMethod -uri $uriSlack -Method Post -body $body_fail_case -ContentType "application/json" | Out-Null'
​
​
​
​
try 
{
if ($num_of_files -ge $trigger_number_files) {Invoke-Expression $post_to_slack_channel }
}
​
catch 
{
Invoke-Expression $send_to_zabbix_graph_a_bad_response
Invoke-Expression $post_to_slack_channel_fail_case
}
​
​
Start-Sleep -Seconds 0.3
echo "`n"
$i=$i+1
}
​
​
