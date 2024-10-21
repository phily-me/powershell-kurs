<#
SYNOPSIS
    A short one-line action-based description, e.g. 'Tests if a function is valid'
.DESCRIPTION
    A longer description of the function, its purpose, common use cases, etc.
.NOTES
    Information or caveats about the function e.g. 'This function is not supported in Linux'
.LINK
    Specify a URI to a help page, this will show when Get-Help -Online is used.
.EXAMPLE
    Code.ps1 -VMNames "DC02","DC03"
    Explanation of the function or its result. You can include multiple examples with additional .EXAMPLE line
.PARAMETER VMNames
.PARAMETER VMGeneration
#>

[CmdletBinding()]
param (
    # Gibt den namen der VM an
    [Parameter(
        Mandatory = $true,
        Position = 1,
        ValueFromPipelineByPropertyName = $true
    )]
    [String[]]$VMNames,

    # Definiert die VM Generation
    [Parameter()]
    [ValidateSet(1, 2)]
    [int32]
    $VMGeneration = 2
)

###############
# Hallo Welt  #
###############

#Variables
$VMMemory = 1GB
$VMSwitchName = "ComputeSwitch"
$VMDirectoryPath = "C:\VMs"
$VHDXName = "OSDisk.vhdx"
$VHDXSize = 30
$IsoPath = "C:\VMs\Images\server.iso" #Bitte an eure Umgebung anpassen


#erzeuge VMs
foreach ($VMName in $VMNames) {
    #erzeuge VM
    New-VM -Name $VMNames -MemoryStartupBytes $VMMemory -Generation $VMGeneration -SwitchName $VMSwitchName -Path $IsoPath
    Write-Host "VM wurde erzeugt"

    #erzeuge VM Disk Verzeichnis
    $VMDiskDirectoryPath = $VMDirectoryPath + '\' + $VMName + "\Virtual Hard Disks"
    New-Item -ItemType File -Path $VMDiskDirectoryPath

    #setze VHDX Pfad zusammen und erzeuge leere VHDX
    $VMDiskPath = $VMDiskDirectoryPath + '\' + $VHDXName
    New-VHD -Path $VMDiskDirectoryPath -SizeBytes $VHDXSize -Dynamic
    Write-Host "Disk wurde erzeugt"

    #attach VHDX und DVD an die VM
    Add-VMHardDiskDrive -VMName $VMName -Path $VMDiskPath
    Add-VMDvdDrive -VMName $VMName -Path $IsoPath
}
