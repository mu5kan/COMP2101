new-item -path alias:np -value notepad|out-null
 
function welcome {
write-output "Welcome Dear User $env:username"
$now = get-date -format 'HH:MM tt on dddd'
write-output "It is $now."
}

welcome
 
function get-cpuinfo{
get-ciminstance cim_processor | format-list Manufacturer, name, maxclockspeed, currentclockspeed, numberofcores, numberoflogicalprocessors
}

get-cpuinfo

function get-mydisks {
get-physicaldisk | format-table Manufacturer, Model, SerialNumber, FirmwareRevision, Size
}