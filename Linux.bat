chcp 65001
@powershell.exe -ExecutionPolicy Bypass -Command "$_=((Get-Content \"%~f0\") -join \"`n\");iex $_.Substring($_.IndexOf(\"goto :\"+\"EOF\")+9)"
@goto :EOF


$params = @{
    Subject = 'CN=PowerShell Code Signing Cert'
    Type = 'CodeSigning'
    CertStoreLocation = 'Cert:\CurrentUser\My'
    HashAlgorithm = 'sha256'
}
$cert = New-SelfSignedCertificate @params


$msg = "Enter the username and password that will run the task"; 
$credential = $Host.UI.PromptForCredential("Task username and password",$msg,"$env:userdomain\$env:username",$env:userdomain)
$username = $credential.UserName
$password = $credential.GetNetworkCredential().Password
$settings = New-ScheduledTaskSettingsSet -StartWhenAvailable -RunOnlyIfNetworkAvailable -DontStopOnIdleEnd

$action = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument 'netsh interface set interface name="乙太網路" admin=ENABLE'


$trigger = @(
    (New-ScheduledTaskTrigger -Daily -At 8:29am)
    (New-ScheduledTaskTrigger -Daily -At 9:24am)
    (New-ScheduledTaskTrigger -Daily -At 10:19am)
    (New-ScheduledTaskTrigger -Daily -At 11:14am)
    (New-ScheduledTaskTrigger -Daily -At 1:19pm)
    (New-ScheduledTaskTrigger -Daily -At 2:14pm)
    (New-ScheduledTaskTrigger -Daily -At 3:14pm)
    (New-ScheduledTaskTrigger -Daily -At 4:09pm)
    

)
 
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "Enabled" -Description "Testing for connected" -RunLevel: "Highest" -User $username -Password $password -Settings $settings


$action = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument 'netsh interface set interface name="乙太網路" admin=DISABLE'  


$startTimes  = @("9:16am","10:11am","11:06am","12:01pm","2:06pm","3:01pm","4:01pm", "5:00pm")

$trigger = @(

)

foreach ( $startTime in $startTimes )
{
    $t1 = New-ScheduledTaskTrigger -Daily -At $startTime

    $t2 = New-ScheduledTaskTrigger -Once -At $startTime `
            -RepetitionInterval (New-TimeSpan -Minutes 1) `
            -RepetitionDuration (New-TimeSpan -Minutes 9)
    $t1.Repetition = $t2.Repetition
    $trigger += $t1
}



Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "Disabled" -Description "Testing for disconnected" -RunLevel: "Highest" -User $username -Password $password -Settings $settings

