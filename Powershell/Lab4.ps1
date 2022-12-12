#This PS script will pull system information and display to terminal.

#System hardware information function
function SystemHardware {
get-ciminstance win32_computersystem | fl
}

#Operating system information function
function OperatingSystem {
get-ciminstance win32_operatingsystem | fl Name,Version
}

#System processor information function
function SystemProcessor {
get-ciminstance win32_processor | fl Description,Speed,NumberofCores,L1CacheSize,L2CacheSize,L3CacheSize
}

Write-Output "System Hardware:"
SystemHardware

Write-Output "Operating System:"
OperatingSystem

Write-Output "SystemProcessor:"
SystemProcessor

#System Ram information function
function SystemRam {
get-ciminstance win32_physicalmemory | format-table Manufacturer,Description,Capacity,DeviceLocator
}

Write-Output "System Ram:"
SystemRam

Write-Output "System Physical Disks:"
  
  $diskdrives = Get-CIMInstance CIM_diskdrive

  foreach ($disk in $diskdrives) {
      $partitions = $disk|get-cimassociatedinstance -resultclassname CIM_diskpartition
      foreach ($partition in $partitions) {
            $logicaldisks = $partition | get-cimassociatedinstance -resultclassname CIM_logicaldisk
            foreach ($logicaldisk in $logicaldisks) {
                     new-object -typename psobject -property @{Manufacturer=$disk.Manufacturer
                                                               Location=$partition.deviceid
                                                               Drive=$logicaldisk.deviceid
                                                               "Size(GB)"=$logicaldisk.size / 1gb -as [int]
                                                               }
           }
      }
  }


function NetworkAdapter {
get-ciminstance win32_networkadapterconfiguration | where-object ipenabled | format-table -autosize Description,Index,ipaddress,ipsubnet,dnshostname,dnsdomain
}

Write-Output "Network Adapters:"
NetworkAdapter

function SystemGraphics {
get-ciminstance win32_videocontroller | fl Name,Description,CurrentHorizontalResolution,CurrentVerticalResolution
}
Write-Output "Systems Graphics:"
SystemGraphics