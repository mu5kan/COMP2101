function systemhardware {
    write "System Hardware Description"
    Get-CimInstance win32_computersystem | 
    fl Model, Name, Domain, Manufacturer, TotalPhysicalMemory
}
systemhardware

function OperatingSystem {
    Write-Output "OPERATING SYSTEM INFORMATION"
    Get-WmiObject win32_operatingsystem | Select-Object Caption, Version, OSArchitecture | Format-List
}
OperatingSystem

function processorDescription {
    Write "PROCESSOR DESCRIPTION"
    Get-WmiObject win32_processor | 
    Select-Object Name, NumberOfCores, CurrentClockSpeed, MaxClockSpeed,
    @{  n = "L1CacheSize"; 
        e = { switch ($_.L1CacheSize) {
                $null { $outputData = "data unavailable" }
                Default { $outputData = $_.L1CacheSize }
       };
            $outputData }
    },
    @{  n = "L2CacheSize"; 
        e = { switch ($_.L2CacheSize) {
                $null { $outputData = "data unavailable" }
                Default { $outputData = $_.L2CacheSize }
            };
            $outputData }
    },
    @{  n = "L3CacheSize"; 
        e = { switch ($_.L3CacheSize) {
                $null { $outputData = "data unavailable" }
                0 { $outputData = 0 }
                Default { $outputData = $_.L3CacheSize }
            };
            $outputData }
    } | fl
}
processorDescription


function ramSummary {
    Write "RAM SUMMARY"
    $totalRam = 0
    Get-WmiObject win32_physicalmemory |
    ForEach-Object {
        $RamNow = $_ ;
        New-Object -TypeName psObject -Property @{
            Manufacturer = $RamNow.Manufacturer
            Description  = $RamNow.Description
            "Size(GB)"   = $RamNow.Capacity / 1gb
            Bank         = $RamNow.banklabel
            Slot         = $RamNow.devicelocator
        }
        $totalRam += $currentRam.Capacity
    } |
    ft Manufacturer, Description, "Size(GB)", Bank, Slot -AutoSize
    Write "Total RAM Capacity = $($totalRam/1gb) GB"
}
ramSummary


function diskDrive {
    Write "DISK DRIVE INFORMATION"
    $allDrives = Get-CIMInstance CIM_diskdrive | Where-Object DeviceID -ne $null
    foreach ($Disks in $allDrives) {
        $Partitions = $Disks | get-cimassociatedinstance -resultclassname CIM_diskpartition
        foreach ($allcurrentPartition in $Partitions) {
            $LogicalDisks = $allcurrentPartition | get-cimassociatedinstance -resultclassname CIM_logicaldisk
            foreach ($currentLogicalDisk in $LogicalDisks) {
                new-object -typename psobject -property @{
                    Model          = $Disks.Model
                    Manufacturer   = $Disks.Manufacturer
                    Location       = $allcurrentPartition.deviceid
                    Drive          = $currentLogicalDisk.deviceid
                    "Size(GB)"     = [string]($currentLogicalDisk.size / 1gb -as [int]) + 'GB'
                    FreeSpace      = [string]($currentLogicalDisk.FreeSpace / 1gb -as [int]) + 'GB'
                    "FreeSpace(%)" = ([string]((($currentLogicalDisk.FreeSpace / $currentLogicalDisk.Size) * 100) -as [int]) + '%')
                } | ft -AutoSize
            } 
        }
    }   
}
diskDrive


function networkInformation {
    Write "NETWORK INFORMATION"
    get-ciminstance win32_networkadapterconfiguration | Where-Object { $_.ipenabled -eq 'True' } | 
    Select-Object Index, IPAddress, Description, ipsubnet, dnsdomain,
   
    DNSServerSearchOrder |
    ft -autosize Index, IPaddress, Description, ipsubnet, DNSdomain, DNSserversearchorder
}
networkInformation


function graphicsInformation {
    Write "GRAPHICS INFORMATION"
    $controller = Get-WmiObject win32_videocontroller
    $controller = New-Object -TypeName psObject -Property @{
        Name             = $controller.Name
        Description      = $controller.Description
        ScreenResolution = [string]($controller.CurrentHorizontalResolution) + 'px X ' + [string]($controller.CurrentVerticalResolution) + 'px'
    } | fl Name, Description, ScreenResolution
    $controller
}
graphicsInformation