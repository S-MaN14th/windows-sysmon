#monitor a directory for file creation

$folder 			= 'C:\Users\admin\Desktop'					#the folder you want to monitor
$filter 			= '*.*'                             # any filename, any extension

$fsw = New-Object IO.FileSystemWatcher $folder, $filter -Property @{
	IncludeSubdirectories = $false              # do not monitor the subdirectories
	NotifyFilter = [IO.NotifyFilters]'FileName, LastWrite'
}
$onCreated = Register-ObjectEvent $fsw Created -SourceIdentifier FileCreated -Action {
	$name 			= $Event.SourceEventArgs.Name
	$changeType = $Event.SourceEventArgs.ChangeType
	$timeStamp 	= $Event.TimeGenerated
	Write-Host "'$name' '$changeType'"
}

#Use this to terminate the event watcher
#Unregister-Event -SourceIdentifier FileCreated
