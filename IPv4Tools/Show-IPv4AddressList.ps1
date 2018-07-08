Function Show-IPv4AddressList
{
    <#
    .SYNOPSIS
    Generate a list of IPv4 addresses between the first and the last IP address.
    .DESCRIPTION
    This function receives two IPv4 addresses and generate a list of IP addresses between the first and the last one. 
    .EXAMPLE
    Show-IPv4List -First IP 10.3.5.253 -Last IP 10.3.6.2
    .PARAMETER FirstIP
    The first IPv4 address.
    .PARAMETER LastIP
    The last IPv4 address.
    .LINK
    https://github.com/brunobritorj
    .NOTES
    Version: 1.2
    Author: Bruno B Silva - brunosredes@gmail.com
    #>
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$True,Position=0,ValueFromPipeline=$True)]
        [IPAddress]$FirstIP,
        
        [Parameter(Mandatory=$True,Position=1,ValueFromPipeline=$True)]
        [IPAddress]$LastIP
    )
    Process
    {
        $FirstIP.IPAddressToString
        While ($FirstIP -ne $LastIP)
        {
            If ($FirstIP.GetAddressBytes()[3] -ne 255) { $FirstIP.Address += 16777216 }
            Elseif ($FirstIP.GetAddressBytes()[2] -ne 255) { $FirstIP.Address += -4278124544 }
            Elseif ($FirstIP.GetAddressBytes()[1] -ne 255) { $FirstIP.Address += -4294901504 }
            Elseif ($FirstIP.GetAddressBytes()[0] -ne 255) { $FirstIP.Address += -4294967039 }
            Else { $LastIP = $FirstIP }
            $FirstIP.IPAddressToString
        }
    } #End Process
}