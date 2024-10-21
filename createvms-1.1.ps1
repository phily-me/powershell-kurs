[CmdletBinding()]
Param(
  [Parameter(
    Mandatory = $true,
    Position = 1
  )]
  [string[]]$VMNames = "default"
)


# CONFIGURATION
$defaultVm = @{
  name       = "default"
  memorySize = "2GB"
  diskSize   = "50GB"
  vmPath      = "C:\VM"
  vmDiskPath = "C:\VM\default\default.vhdx"
  isoPath    = "C:\Image\SERVER_EVAL_x64FRE_en-us.iso"
}

$vm1 = $defaultVm.Clone()
$vm1.name = "vm1"
$vm1.vmDiskPath = $vm1.vmPath + "\" + $vm1.name + "\" + $vm1.name + ".vhdx"

$vm2 = $defaultVm.Clone()
$vm2.name = "vm2"
$vm2.vmDiskPath = $vm2.vmPath + "\" + $vm2.name + "\" + $vm2.name + ".vhdx"

$vm3 = $defaultVm.Clone()
$vm3.name = "vm3"
$vm3.vmDiskPath = $vm3.vmPath + "\" + $vm3.name + "\" + $vm3.name + ".vhdx"

$VMNames = $vm1, $vm2, $vm3

# COMMANDS
foreach ($vm in $VMNames) {
  New-VM -Name $vm.name -MemoryStartupBytes $vm.memorySize -Generation 2 -Path $vm.vmPath
  New-VHD -Path $vm.vmDiskPath -SizeBytes $vm.diskSize -Dynamic
  Add-VMHardDiskDrive -VMName $vm.name -Path $vm.vmDiskPath
  Add-VMDvdDrive -VMName $vm.name -Path $vm.isoPath
}