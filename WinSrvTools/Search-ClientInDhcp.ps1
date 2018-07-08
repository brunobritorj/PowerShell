Function Search-ClientInDhcp
{
    <#
    .SYNOPSIS
    Search for a hostname in DHCP servers.
    .DESCRIPTION
    This function searches for a client hostname in DHCP servers. 
    .EXAMPLE
    Search-ClientInDhcp -Hostname MyComputerName
    .EXAMPLE
    Search-ClientInDhcp -Hostname MyComputerName -Servers MySrv01
    .EXAMPLE
    Search-ClientInDhcp -Hostname MyComputerName -Servers MySrv01, MySrv02, MySrv03
    .PARAMETER Hostname
    The hostname of a client device that you are looking for.
    .PARAMETER Servers
    A list of servers, separated by comma, where this script will try find out for the client lease.
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
        [string]$Hostname,
        
        [Parameter(Mandatory=$True,Position=1)]
        [string[]]$Servers = (Get-DhcpServerInDC).DnsName
    )
    Process
    {
        $ErrorActionPreference = 'SilentlyContinue'
        [int]$i = 1
        [int]$Total = $Servidores.count
        $Jobs = @()
        $Servers | % {
            Write-Progress -Activity $_ -Status ("$i/$Total Servers") -PercentComplete ($i/$Total*100) #Barra de progresso
            $Jobs += Get-DhcpServerv4Scope -ComputerName $_ | Get-DhcpServerv4Lease -ComputerName $_ -AsJob
            $i++
        }
        While ( (Get-Job -Id $Jobs.Id).State -eq 'Running' ) { Start-Sleep 5 }
        Get-Job -Id $Jobs.Id | Receive-Job | Where-Object Hostname -Match $Hostname | select ServerIP, HostName, IPAddress, ClientId -Unique
        Remove-Job -Id $Jobs.Id
    } # End process
}