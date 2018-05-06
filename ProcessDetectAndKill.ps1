#kill a process with a particular name
param(
	[string] $newFile
)

$Query = "Select * From __InstanceCreationEvent within 3 Where TargetInstance ISA 'Win32_Process'"
$Identifier = "StartProcess"
$ActionBlock = {
	$process = $event.SourceEventArgs.NewEvent.TargetInstance
	if $process.Name -contains "*'$newFile'*"{
		Stop-process $process.ProcessID
		Write-host "Process terminated"
	}
}
Register-WMIEvent -Query $Query -SourceIdentifier $Identifier -Action $ActionBlock


#Use this to terminate the event watcher
# Unregister-Event -SourceIdentifier StartProcess
