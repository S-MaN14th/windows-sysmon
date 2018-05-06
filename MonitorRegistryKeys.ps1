#read registry entries from a file and monitor them for changes
param(
    [string] $processName
)
$regEntryList = Get-Content ".\registryEntries.txt"
ForEach ($regentry in $regEntryList) {
    $pos        = $regentry.IndexOf("\")
    $hive       = $regentry.substring(0, $pos)
    $keypath    = $regentry.substring($pos+1).replace("\","\\")
    $query      = "SELECT * FROM RegistryTreeChangeEvent WHERE Hive= '$hive' AND RootPath = '$keyPath'"
    $onCreated = Register-WmiEvent -Query $query -SourceIdentifier KeyChanged -Action {
        $driveLetter = " "
        switch $hive{
            "*HKEY_LOCAL_MACHINE*"  :   {
                                            $driveLetter = "HKLM:\"
                                        }
            "*HKEY_CURRENT_USER*"   :   {
                                            $driveLetter = "HKCU:\"
                                        }
            default                 :   {
                                            Write-host "Unsupported root directory '$hive' for registry"
                                            continue
                                        }

        }
        $searchpath     = $driveLetter + $regentry.substring($pos + 1)
        $searchResult   = Get-ItemProperty -path $searchpath
        if ( $searchResult -contains '*$processName*' ){}
            Write-host "Registry entry found for '$processName'"
        }
    }
}
