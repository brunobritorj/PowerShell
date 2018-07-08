Function Show-CDPNeighbors
{
    <#
    .SYNOPSIS
    Get a list of CDP neighbors from a Cisco devices.
    .DESCRIPTION
    This function pols a Cisco device by SNMP and retrieves its CDP neighbors. 
    .EXAMPLE
    Show-CDPNeighbors -Device YourDeviceHostName -SNMPCommunity YourCompanySNMP
    .PARAMETER Device
    The hostname or IP address of a Cisco device. It accepts multiples devices separated by comma.
    .PARAMETER SNMPCommunity
    SNMP community configured in the device.
    .PARAMETER SNMPVersion
    SNMP version (1 or 2c) configured in the device.
    .LINK
    https://github.com/brunobritorj
    .NOTES
    Version: 1.0
    Author: Bruno B Silva - brunosredes@gmail.com
    #>
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$True,Position=0,ValueFromPipeline=$True)]
        [string[]]$Device,

        [Parameter(Mandatory=$True,Position=1,ValueFromPipeline=$True)]
        [string]$SNMPCommunity = 'public',

        [Parameter(Mandatory=$True,Position=2,ValueFromPipeline=$True)]
        [string]$SNMPVersion = '2c'
    )
    ForEach ($Dev in $Device)
    {
        (snmpwalk.exe -v $SNMPVersion -c $SNMPCommunity $Dev).Trim() -replace '.*STRING: ' -replace '"' | Select-Object -Unique
    }
}