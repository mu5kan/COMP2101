param (
    [switch]$System,
    [switch]$Disks,
    [switch]$Network
)
if ( !($System) -and !($Network) -and !($Disks)) {
    systemhardware
    processorDescription
    OperatingSystem
    ramSummary
    graphicsInformation
    diskDrive
    networkInformation
}
if ($System) {
    systemhardware
    processorDescription
    OperatingSystem
    ramSummary
    graphicsInformation
}
if ($Network) {
    networkInformation
}
if ($Disks) {
    diskDrive
}
