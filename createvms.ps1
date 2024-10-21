<#
.SYNOPSIS
  Create a list of VMs
.DESCRIPTION
  A longer description of the function, its purpose, common use cases, etc.
.NOTES
  This script is only part of a powershell course, not to be used in production. you've been warned :)
.EXAMPLE
  createvms.ps1 -VMs vm1,vm2
  Creates two VMs with default config
.PARAMETER VMs
  a list of VMs as string to be created
#>

[CmdletBinding()]
param (
  [Parameter(
    Mandatory = $true
  )]
  [string[]]
  $VMs
)

# CONFIGURATION
$defaultVmConfiguration = @{
  name       = "default"
  memorySize = "2GB"
  diskSize   = "50GB"
  vmPath     = "C:\VM"
  vmDiskPath = "C:\VM\default\default.vhdx"
  isoPath    = "C:\Image\SERVER_EVAL_x64FRE_en-us.iso"
}
function createVmConfiguration {
  Param(
    [Parameter()]
    [string]$vmName,
    [Parameter()]
    [hashtable]$vmObject
  )
  $vm = $defaultVmConfiguration.Clone()
  $vm.name = $vmName
  $vm.vmDiskPath = $vm.vmPath + "\" + $vm.name + "\" + $vm.name + ".vhdx"

  return $vm
}

if ($VMs) {
  $vmConfigurations = @()
  foreach ($vm in $VMs) {
    $vmConfigurations += createVmConfiguration($vm)
  }
}
else {
  # No vm names provided. Exiting.
  exit 1
}

# COMMANDS
foreach ($vm in $vmConfigurations) {
  New-VM -Name $vm.name -MemoryStartupBytes $vm.memorySize -Generation 2 -Path $vm.vmPath
  New-VHD -Path $vm.vmDiskPath -SizeBytes $vm.diskSize -Dynamic
  Add-VMHardDiskDrive -VMName $vm.name -Path $vm.vmDiskPath
  Add-VMDvdDrive -VMName $vm.name -Path $vm.isoPath
}