
# VLAN Set in NIC config / NAME 
# link speed
# NIC MODLE
#Performance Settings
#memdump


###### Global variables ####

$vUserName = (Get-Item env:\username).Value 			## This will get username using environment variable
$Target = (Get-Item env:\Computername).Value            ## this is computer name using environment variable
$filepath = (Get-ChildItem env:\userprofile).value		## this is user profile  using environment variable
$date = (Get-date)

############################

$OperatingSystems= Get-WmiObject -computername $Target Win32_OperatingSystem
$ComputerSystems = Get-WmiObject -computername $Target Win32_ComputerSystem
$PRoutes = Get-WmiObject -computername $Target Win32_IP4PersistedRouteTable
$TimeZone = Get-WmiObject -computername $Target Win32_Timezone
$SchedTasks = Get-WmiObject -computername $Target Win32_ScheduledJob
$RecoveryOptions = Get-WmiObject -computername $Target Win32_OSRecoveryConfiguration
$service = Get-WmiObject -ComputerName $Target Win32_Service
$proccess = Get-WmiObject  -ComputerName $Target win32_process
$Products = get-wmiobject -ComputerName $Target Win32_Product
$Groups = Get-WmiObject -computername $Target win32_GROUPUSER | WHERE {$_.groupcomponent -match 'administrators' }  | foreach {[wmi]$_.partcomponent } -ErrorAction SilentlyContinue
$UserAccounts = Get-WmiObject -ComputerName $Target Win32_UserAccount -Filter "localAccount='$true'"
$Groupusers = get-wmiobject -ComputerName $Target Win32_Groupuser 
$Physicaldisk = Get-WmiObject -ComputerName $Target win32_DiskDrive
$logicaldisk = Get-WmiObject -ComputerName $Target win32_logicalDisk
$Shares = Get-wmiobject -ComputerName $Target Win32_Share
$vComputerName = Get-WmiObject -computername $target Win32_NetworkAdapterConfiguration
$iComputerName = Get-WMiObject -computername $target Win32_NetworkAdapter -filter "netconnectionid is not null"
$LBTime=$OperatingSystems.ConvertToDateTime($OperatingSystems.Lastbootuptime)
$INTime=$OperatingSystems.ConvertToDateTime($OperatingSystems.InstallDate)
$ObjKeyboards = Get-WmiObject -ComputerName $Target Win32_Keyboard

##############################
#######  FUNCTIONS HTML ######
##############################

Function Get-CustomHTML ($Header){
$Report = @"
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<html><head><title>$($Header)</title>
<META http-equiv=Content-Type content='text/html; charset=windows-1252'>

<meta name="save" content="history">

<style type="text/css">
DIV .expando {DISPLAY: block; FONT-WEIGHT: bold; FONT-SIZE: 8pt; left: 8px; COLOR: #ffffff; FONT-FAMILY: Arial; POSITION: absolute; TEXT-DECORATION: underline}
TABLE {TABLE-LAYOUT: fixed; FONT-SIZE: 100%; WIDTH: 100%}
*{margin:0}
.dspcont { display:none; BORDER-RIGHT: #008000 1px solid; BORDER-TOP: #008000 1px solid; PADDING-LEFT: 16px; FONT-SIZE: 8pt;MARGIN-BOTTOM: -1px; PADDING-BOTTOM: 5px; MARGIN-LEFT: 0px; BORDER-LEFT: #B1BABF 1px solid; WIDTH: 95%; COLOR: #000000; MARGIN-RIGHT: 0px; PADDING-TOP: 4px; BORDER-BOTTOM: #B1BABF 1px solid; FONT-FAMILY: Tahoma; POSITION: relative; BACKGROUND-COLOR: #f9f9f9}
.filler {BORDER-RIGHT: medium none; BORDER-TOP: medium none; DISPLAY: block; BACKGROUND: none transparent scroll repeat 0% 0%; MARGIN-BOTTOM: -1px; FONT: 100%/8px Tahoma; MARGIN-LEFT: 43px; BORDER-LEFT: medium none; COLOR: #ffffff; MARGIN-RIGHT: 0px; PADDING-TOP: 4px; BORDER-BOTTOM: medium none; POSITION: relative}
.save{behavior:url(#default#savehistory);}
.dspcont1{ display:none}
a.dsphead0 {BORDER-RIGHT: #008000 1px solid; PADDING-RIGHT: 5em; BORDER-TOP: #008000 1px solid; DISPLAY: block; PADDING-LEFT: 5px; FONT-WEIGHT: bold; FONT-SIZE: 12pt; MARGIN-BOTTOM: -1px; MARGIN-LEFT: 0px; BORDER-LEFT: #008000 1px solid; CURSOR: hand; COLOR: #FFFFFF; MARGIN-RIGHT: 0px; PADDING-TOP: 4px; BORDER-BOTTOM: #B1BABF 1px solid; FONT-FAMILY: Tahoma; POSITION: relative; HEIGHT: 2.25em; WIDTH: 95%; BACKGROUND-COLOR: #2C2CB4}
a.dsphead1 {BORDER-RIGHT: #008000 1px solid; PADDING-RIGHT: 5em; BORDER-TOP: #008000 1px solid; DISPLAY: block; PADDING-LEFT: 5px; FONT-WEIGHT: bold; FONT-SIZE: 6pt; MARGIN-BOTTOM: -1px; MARGIN-LEFT: 0px; BORDER-LEFT: #008000 1px solid; CURSOR: hand; COLOR: #ffffff; MARGIN-RIGHT: 0px; PADDING-TOP: 4px; BORDER-BOTTOM: #B1BABF 1px solid; FONT-FAMILY: Tahoma; POSITION: relative; HEIGHT: 2.25em; WIDTH: 95%; BACKGROUND-COLOR: #2C2CB4}
a.dsphead2 {BORDER-RIGHT: #008000 1px solid; PADDING-RIGHT: 5em; BORDER-TOP: #008000 1px solid; DISPLAY: block; PADDING-LEFT: 5px; FONT-WEIGHT: bold; FONT-SIZE: 6pt; MARGIN-BOTTOM: -1px; MARGIN-LEFT: 0px; BORDER-LEFT: #008000 1px solid; CURSOR: hand; COLOR: #ffffff; MARGIN-RIGHT: 0px; PADDING-TOP: 4px; BORDER-BOTTOM: #B1BABF 1px solid; FONT-FAMILY: Tahoma; POSITION: relative; HEIGHT: 2.25em; WIDTH: 95%; BACKGROUND-COLOR: #2C2CB4}
a.dsphead1 span.dspchar{font-family:monospace;font-weight:normal;}
td {VERTICAL-ALIGN: TOP; FONT-FAMILY: Arial}
th {VERTICAL-ALIGN: TOP; COLOR: #2C2CB4; TEXT-ALIGN: left}
BODY {margin-left: 4pt} 
BODY {margin-right: 4pt} 
BODY {margin-top: 4pt} 
</style>


<script type="text/javascript">
function dsp(loc){
   if(document.getElementById){
      var foc=loc.firstChild;
      foc=loc.firstChild.innerHTML?
         loc.firstChild:
         loc.firstChild.nextSibling;
      foc.innerHTML=foc.innerHTML=='hide'?'show':'hide';
      foc=loc.parentNode.nextSibling.style?
         loc.parentNode.nextSibling:
         loc.parentNode.nextSibling.nextSibling;
      foc.style.display=foc.style.display=='block'?'none':'block';}}  

if(!document.getElementById)
   document.write('<style type="text/css">\n'+'.dspcont{display:block;}\n'+ '</style>');
</script>

</head>
<body>
<b><font face="Arial" size="12">$($Header)</font></b><hr size="6" color="#2C2CB4">
<font face="Arial" size="1">Report created on $(Get-Date)</font>
<div class="filler"></div>
<div class="filler"></div>
<div class="filler"></div>
<div class="save">
"@
Return $Report
}

Function Get-CustomHeader0 ($Title){
$Report = @"
		<h1><a class="dsphead0">$($Title)</a></h1>
	<div class="filler"></div>
"@
Return $Report
}

Function Get-CustomHeader ($Num, $Title){
$Report = @"
	<h2><a href="javascript:void(0)" class="dsphead$($Num)" onclick="dsp(this)">
	<span class="expando">show</span>$($Title)</a></h2>
	<div class="dspcont">
"@
Return $Report
}

Function Get-CustomHeaderClose{

	$Report = @"
		</DIV>
		<div class="filler"></div>
"@
Return $Report
}

Function Get-CustomHeader0Close{

	$Report = @"
</DIV>
"@
Return $Report
}

Function Get-CustomHTMLClose{

	$Report = @"
</div>

</body>
</html>
"@
Return $Report
}

Function Get-HTMLTable{
	param([array]$Content)
	$HTMLTable = $Content | ConvertTo-Html
	$HTMLTable = $HTMLTable -replace '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">', ""
	$HTMLTable = $HTMLTable -replace '<html xmlns="http://www.w3.org/1999/xhtml">', ""
	$HTMLTable = $HTMLTable -replace '<head>', ""
	$HTMLTable = $HTMLTable -replace '<title>HTML TABLE</title>', ""
	$HTMLTable = $HTMLTable -replace '</head><body>', ""
	$HTMLTable = $HTMLTable -replace '</body></html>', ""
	Return $HTMLTable
}

Function Get-HTMLDetail ($Heading, $Detail){
$Report = @"
<TABLE>
	<tr>
	<th width='25%'><b>$Heading</b></font></th>
	<td width='75%'>$($Detail)</td>
	</tr>
</TABLE>
"@
Return $Report
}

##########################
#######  FUNCTIONS  ######
##########################

# WINDOWS Networks config
$IPCONFIG =$vComputerName | Where-Object {$_.IPenabled -eq "True" } | Select-Object Description,
        @{Name='IpAddress';Expression={$_.IpAddress -join '; '}}, 
        @{Name='IpSubnet';Expression={$_.IpSubnet -join '; '}},
        @{Name='DefaultIPgateway';Expression={$_.DefaultIPgateway -join '; '}}, 
        @{Name='MacAddress';Expression={$_.MacAddress -join '; '}}, 
        @{Name='DomainDNSRegistration';Expression={$_.DomainDNSRegistrationEnabled -join '; '}}, 
        @{Name='DNSServerSearchOrder';Expression={$_.DNSServerSearchOrder -join '; '}}
#Binding Order 
$Binding = (Get-Itemproperty "HKLM:\SYSTEM\CurrentControlSet\services\Tcpip\Linkage").bind
$NICs = Get-WmiObject -Class win32_networkadapter | where {$_.Netconnectionid -ne $null} | select NetCOnnectionID,GUID,NetEnabled
$i = 1
$NICOut = @()
foreach ($obj in $Binding) {
 $GUID = $obj.trimstart("\Device\")
 $Data = ($NICs | where {$_.GUID -eq $GUID})
 If ($Data.NetConnectionID -eq $null){
 Continue
 }
 $NICInfo= New-Object PSObject
 $NICInfo | Add-member NoteProperty Binding $i
 $NICInfo | Add-member NoteProperty Name $Data.NetConnectionID
 $NICInfo | Add-member NoteProperty "NIC Enabled" $Data.NetEnabled
 $NICInfo | Add-member NoteProperty GUID $Data.GUID
 $NICOut += $NICInfo
$i++
}
$Bindingout = $NICOut | Select Name,
         @{Name="Binding"; Expression={$_.Binding}},
         @{Name="NIC Enabled"; Expression={$_."NIC Enabled"}} 
# Routes 			 
$routes = $PRoutes | select Caption,
        @{Name='Destination';Expression={$_.Destination -join '; '}}, 
        @{Name='Mask';Expression={$_.Mask -join '; '}},
        @{Name='NextHop';Expression={$_.NextHop -join '; '}}, 
        @{Name='Metric1';Expression={$_.Metric1 -join '; '}}
		
# DiskInfromation 		 
$diskinfo = $logicaldisk | select DeviceID,VolumeName,
		@{Name="Size(GB)";Expression={[decimal]("{0:N0}" -f($_.size/1gb))}},
		@{Name="Free Space(GB)";Expression={[decimal]("{0:N0}" -f($_.freespace/1gb))}},
		@{Name="Free (%)";Expression={"{0,6:P0}" -f(($_.freespace/1gb) / ($_.size/1gb))}}
		
#Local Users
$UA =$UserAccounts | select Name,
         @{Name="Description"; Expression={$_.Description}},
         @{Name="Status"; Expression={$_."Status"}} 

#Local Administrators Group
$UG =$Groups | Select-object Domain,Name,Accounttype 

# WINDOWS FIREWALL Functions
$DomainProfile = get-itemproperty -Path “HKLM:\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\DomainProfile” –name "EnableFirewall" -erroraction 'silentlycontinue'
$DFWState = if ($DomainProfile.EnableFirewall -eq "0x00000000"){"Disabled"} else 
	{"Enabled"
	}

$PublicProfile = get-itemproperty -Path “HKLM:\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\PublicProfile” –name " EnableFirewall" -erroraction 'silentlycontinue'
$PFWState = if ($PublicProfile.EnableFirewall -eq "0x00000000"){"Disabled"} else 
	{"Enable"
	} 

$StandardProfile = get-itemproperty -Path “HKLM:\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile” –name " EnableFirewall" -erroraction 'silentlycontinue'
$SFWState = if ($StandardProfile.EnableFirewall -eq "0x00000000"){"Disabled"} else 
	{"Enabled"
	}
# WINDOWS RDP Functions
$TSConnections = get-itemproperty -Path “HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server” –name " fDenyTSConnections" -erroraction 'silentlycontinue'          
$RDPEnabled = if ($TSConnections.silentlycontinue -eq "0x00000000"){"Allowed"} else 
	{"NOT Allowed"
	}
$RDPTcp = get-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -name "UserAuthentication" -erroraction 'silentlycontinue' 
$RDPAuth = if ($RDPTcp.UserAuthentication -eq "0x00000000"){"Disabled"} else 
	{"Enabled"}
	
# WINDOWS Legal Logon Message
$LegalNoticeCaption = get-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Winlogon' -name "LegalNoticeCaption" -erroraction 'silentlycontinue'
$LegalNotice = if ($RDPTcp.LegalNoticeCaption -like "Legal Message"){"Configured"} else 
	{ "Not Configured"
	}
$ULegalNoticeText = get-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Winlogon' -name "ULegalNoticeText" -erroraction 'silentlycontinue'
$LegalMessage = if ($RDPTcp.UserAuthentication -like "Adapt WARNING"){"Configured"} else 
	{" Not Configured"
	}
# Template Build Details 
$BuildAuthor = get-ItemProperty  -Path "HKLM\SOFTWARE\Adapt\Build Management"	-name "BuildAuthor" -erroraction 'silentlycontinue'
$BuildAuthor = if ($BuildAuthor."Build Author" -eq $null ){"Not Configured"} else 
	{ $BuildAuthor."BuildAuthor"
	}
$BuildReviewer = get-ItemProperty -Path "HKLM\SOFTWARE\Adapt\Build Management"	-name "BuildReviewer"	-erroraction 'silentlycontinue'
$BuildReviewer = if ($BuildReviewer."BuildReviewer" -eq $null){" Not Configured"} else 
	{$BuildReviewer."Build Reviewer"
	}
$BuildDate =get-ItemProperty  -Path "HKLM\SOFTWARE\Adapt\Build Management"	-name "BuildDate"	-erroraction 'silentlycontinue'
$BuildDate =if ($BuildDate."Build Date" -eq $null){"Not Configured"} else 
	{ $BuildDate."Build Date"
	}
$BuildType =get-ItemProperty  -Path "HKLM\SOFTWARE\Adapt\Build Management"	-name "BuildType"	-erroraction 'silentlycontinue'
$BuildType =if ($BuildType."Build Type" -eq $null){"Not Configured"} else 
	{$BuildType."Build Type"
	}
$BuildVersion =get-ItemProperty  -Path "HKLM\SOFTWARE\Adapt\Build Management"	-name "BuildVersion" -erroraction 'silentlycontinue'
$BuildVersion = if ($BuildVersion."BuildVersion" -eq $null){"Not Configured"} else 
	{$BuildVersion."Build Version"
	}

# UAC
$PromptUAC = get-itemproperty  -Path “HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System” –name "ConsentPromptBehaviorAdmin" -erroraction 'silentlycontinue'  
$UACPrompt = if ($PromptUAC."ConsentPromptBehaviorAdmin" -eq “00000000”){"Diabled"} else 
	{"Enabled"
	}   
$EnableLUA = get-itemproperty  -Path “HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System” –name "EnableLUA" -erroraction 'silentlycontinue'       
$UACState = if ($EnableLUA."EnableLUA" -eq "00000000"){"Diabled"} else 
	{"Enabled"
	}                 
#ADMIN SHARE FIX
$ADMINSHARE = get-itemproperty -Path “HKLM:\Software\Microsoft\Windows\Currentversion\policies\System” –name “LocalAccountTokenFilterPolicy” -erroraction 'silentlycontinue'  
$LocalAccountTokenFilterPolicy = if ($ADMINSHARE."LocalAccountTokenFilterPolicy" -eq “1”){"Applied"} else 
	{ "NOT configured"
	}             
#Memp Dump 
$CrashDumpEnabled = get-itemproperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\CrashControl" -name "CrashDumpEnabled" -erroraction 'silentlycontinue'
$MemDump = if ($CrashDumpEnabled."CrashDumpEnabled" -eq “00000003”){"Configuration Applied"} else 
	{"Not configured"
	} 

#Page File details 
$pagefile = get-ItemProperty -path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -name "pagingfiles"

#Last Windows Update
$Win_Update = get-ItemProperty -path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\Results\Install\" -name "LastSuccessTime" -erroraction 'silentlycontinue'  
$WindowsUpdate = if ($Win_Update.LastSuccessTime -eq $null ){"No Windows Updates"} else 
	{ $Win_Update.LastSuccessTime
	} 

#Windows NTP server
$NTPTYPE = get-ItemProperty -path "HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\Parameters\" -name  "type" -erroraction 'silentlycontinue'  
$TimeSyn = if ($NTPTYPE.type -eq “NT5DS”){"Time Syn: Domain Hierarchy ((PDC))"} else 
	{"Local NTP Server Used"}
	
$NTPSERVER = get-ItemProperty -path "HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\Parameters\" -name  "NtpServer" -erroraction 'silentlycontinue'  

#Windows Service Pack
$ServicePack = if ($OperatingSystems.CSDVersion -eq $null){"No Service Pack"} else 
	{"$OperatingSystems.CSDVersion"}

#Windows SNMP
$SNMPSERVICE = 
   if ((Get-Service | Where-Object {$_.displayname -eq "SNMP SERVICE"} | Select-Object Status) -ne "running")
{"Running"} else { "Not Running"} 


$PermittedManagers = get-ItemProperty -path "HKLM:\SYSTEM\CurrentControlSet\Services\SNMP\Parameters" -name "PermittedManagers"-erroraction 'silentlycontinue'  
$SNMPManagers = if ($PermittedManagers -eq $null ) 
{"Not Configured"} else {$PermittedManagers}

$ValidCommunities = get-ItemProperty -path "HKLM:\SYSTEM\CurrentControlSet\Services\SNMP\Parameters" -name "ValidCommunities" -erroraction 'silentlycontinue'
$SNMPCommunities = if ($ValidCommunities -eq $null ) 
{"Not Configured"} else {$ValidCommunities}

$SNMP_feature = Get-WindowsFeature | Where-Object {$_.name -like "*SNMP*"} | select Name,Installed 

#Windows AV 
$AV = $Products | Where-Object {$_.name -like "*symantec*" -or $_.name -like "*Kaspersky*" -or  $_.name -like "*Trend*"  } | Select-Object Name,Vendor,Version 

#OS Language
$OSLanguage =
If ($OperatingSystems.OSLanguage -eq "1033") 
{"UK English"} else {"NOT UK English"}

#Keyboard Language
$KeyboardsLanguage =
if ($ObjKeyboards.Layout -eq "00000809" )
{"UK English"} else {"NOT UK English"}

#Windows Services 
$services = Get-Service  | Where-Object {$_.status -eq "Running"} | select ServiceName,Status 

#Windows Proccess  
$poc = $proccess  | select Caption,ProcessId,
        @{Expression={$_.Vm /1mb -as [Int]};Label="VM (MB)"}, 
        @{Expression={$_.Ws /1Mb -as [Int]};Label="WS (MB)"} |sort "Vm (MB)" -Descending
		
# BGINFO	
$BGINFO = get-itemproperty -Path HKLM:\Software\Microsoft\Windows\Currentversion\run -Name bginfo -erroraction 'silentlycontinue' 
$BgConfig = Test-Path c:\bginfo\config.bgi
$Bgexe = Test-Path c:\bginfo\bginfo.exe

$BGINFOC = if ($BgConfig -eq "true"){"Configured"} else 
	{"NOT Configured "
	}
$BGINFOE =if ($Bgexe -eq "true"){"Configured"} else 
	{"NOT Configured"
	}
$BGINFOR = if ($BGINFO.BGINFO -eq $null ){"NOT Configured"} else 
	{ $BGINFO.BGINFO
	} 
	
#Windows Activation
    $LStatus = "UnLicensed"
    Get-WmiObject SoftwareLicensingProduct | Select  -First 2 | ForEach-Object { 
        If($_.LicenseStatus -eq 1) {
            $LStatus = "Windows is Licensed"}
        elseif ($_.LicenseStatus -ne 0) {
            Switch($_.LicenseStatus) {
                2 { $LStatus = "OOBGrace" }
                3 { $LStatus = "OOTGrace" }
                4 { $LStatus = "NonGenuineGrace" }
                5 { $LStatus = "Notification" }
                6 { $LStatus = "ExtendedGrace" }
           } 

    }
	}
		 
##############################
#######  Creating HTML  ######
##############################


# Report Title 
	$MyReport = Get-CustomHTML "$Target Acceptance Into Service "
	        $MyReport += Get-CustomHeader0  "Windows OS Infromation "
# Window OS Infromation 
		$MyReport += Get-HTMLDetail "Computer Name" ($ComputerSystems.DNSHOSTNAME)
        $MyReport += Get-HTMLDetail "Computer Domain" ($ComputerSystems.Domain)
		$MyReport += Get-HTMLDetail "Computer Role" ($OperatingSystems.Description)
        $MyReport += Get-HTMLDetail "Arcitecture" ($OperatingSystems.OSArchitecture)
        $MyReport += Get-HTMLDetail "Service Pack" $ServicePack 
		$MyReport += Get-HTMLDetail "Windows Activation State" $LStatus 
        $MyReport += Get-HTMLDetail "System Lanuage" $OSLanguage
        $MyReport += Get-HTMLDetail "Keyboad Language" $KeyboardsLanguage
        $MyReport += Get-HTMLDetail "OS Country" ($OperatingSystems.CountryCode)
        $MyReport += Get-HTMLDetail "Time Zone" ($TimeZone.Caption)
		$MyReport += Get-HTMLDetail "Last System Boot" ($LBTime)
		$MyReport += Get-HTMLDetail "Last Windows Updates" $WindowsUpdate
        $MyReport += Get-HTMLDetail "SystemDrive" ($OperatingSystems.SystemDrive)
        $MyReport += Get-HTMLDetail "WindowsDirectory" ($OperatingSystems.WindowsDirectory)
		$MyReport += Get-CustomHeaderClose
# System Specification 
     $MyReport += Get-CustomHeader0 "System Specifications "
		$MyReport += Get-HTMLDetail "Manufacturer" ($ComputerSystems.Manufacturer)
        $MyReport += Get-HTMLDetail "Model" ($ComputerSystems.Model)
        $MyReport += Get-HTMLDetail "Number of Processors" ($ComputerSystems.Numberofprocessors)
		$MyReport += Get-HTMLDetail "Number of Logical Processors" ($ComputerSystems.Numberoflogicalprocessors)
        $MyReport += Get-HTMLDetail "Total Memory" ([math]::round($ComputerSystems.TotalPhysicalMemory /1GB))
        $MyReport += Get-HTMLDetail "BootDevice" ($OperatingSystems.BootDevice)
        $MyReport += Get-HTMLDetail "Install Date" $INTime
        $MyReport += Get-HTMLDetail "Build Number" ($OperatingSystems.BuildNumber)
        $MyReport += Get-HTMLDetail "Serial Number" ($OperatingSystems.SerialNumber)
		$MyReport += Get-CustomHeaderClose
# Disk Information
    $MyReport += Get-CustomHeader0 "Disk Information"
        $MyReport += Get-HTMLTable $diskinfo 
	$MyReport += Get-CustomHeaderClose
# WINDOWS Network Information
    $MyReport += Get-CustomHeader0 "Network Configuration"
        $MyReport += Get-HTMLTable $IPCONFIG
	$MyReport += Get-CustomHeaderClose
# WINDOWS Network Binding
    $MyReport += Get-CustomHeader0 "Network Binding"
        $MyReport += Get-HTMLTable $Bindingout 
	$MyReport += Get-CustomHeaderClose
# WINDOWS Network Routes
    $MyReport += Get-CustomHeader0 "Network Routes"
        $MyReport += Get-HTMLTable $routes
	$MyReport += Get-CustomHeaderClose	
# Local Users
    $MyReport += Get-CustomHeader0 "Local Users"
        $MyReport += Get-HTMLTable $UA
	$MyReport += Get-CustomHeaderClose
# Local Admins
    $MyReport += Get-CustomHeader0 "Local Admins"
        $MyReport += Get-HTMLTable $UG
	$MyReport += Get-CustomHeaderClose
# WINDOWS Build configuration
    $MyReport += Get-CustomHeader0 "Build Configuration"
        $MyReport += Get-HTMLDetail "SNMP Managers" $SNMPManagers
        $MyReport += Get-HTMLDetail "SNMP Communitie String"$SNMPCommunities
#SNMP FEATURE
        $MyReport += Get-HTMLDetail "SNMP features"
             $MyReport += Get-HTMLTable $SNMP_feature
        $MyReport += Get-HTMLDetail "SNMP Service State" $SNMPSERVICE
#Windows Firwall
        $MyReport += Get-HTMLDetail "Domain Firewall State"$DFWState
        $MyReport += Get-HTMLDetail "Public Firewall State"$PFWState
        $MyReport += Get-HTMLDetail "Standard Firewall State"$SFWState
#Admin Share FIX
        $MyReport += Get-HTMLDetail "Admin Share fix" $LocalAccountTokenFilterPolicy
#Windows NTP server
        $MyReport += Get-HTMLDetail "Time Sync Policy" $TimeSyn
        $MyReport += Get-HTMLDetail "NTP Servers" $NTPSERVER.NtpServer
# WINDOWS RDP Functions
        $MyReport += Get-HTMLDetail "Remote Desktop" $RDPEnabled
        $MyReport += Get-HTMLDetail "Remote Desktop Network Level Authentication" $RDPAuth
# WINDOWS Legal Logon Message
        $MyReport += Get-HTMLDetail "Legal Notice Caption"$LegalNotice
        $MyReport += Get-HTMLDetail "Legal Message"$LegalMessage
# WINDOWS Page File
        $MyReport += Get-HTMLDetail "Page File Configuration"$pagefile.pagingfiles
# WINDOWS MEMDump		
		$MyReport += Get-HTMLDetail "Mem Dump Configuration"$MemDump
# WINDOWS BGINFO	 		
		$MyReport += Get-HTMLDetail "UAC Promt Configuration"$BGINFOC 
		$MyReport += Get-HTMLDetail "BGINFO EXE File" $BGINFOE 
		$MyReport += Get-HTMLDetail "BGINFO Registary" $BGINFOR 
# WINDOWS UAC
		$MyReport += Get-HTMLDetail "BGINFO Config File"$UACPrompt
		$MyReport += Get-HTMLDetail "UAC State"$UACState
# Template INFO				
		$MyReport += Get-HTMLDetail "BuildAuthor"$BuildAuthor
		$MyReport += Get-HTMLDetail "BuildReviewer"$BuildReviewer
		$MyReport += Get-HTMLDetail "BuildType"$BuildType
		$MyReport += Get-HTMLDetail "BuildDate"$BuildDate
 	$MyReport += Get-CustomHeaderClose

	$Filename = "C:\Dell\" + $Target + "_" + $date.Hour + $date.Minute + "_" + $Date.Day + "-" + $Date.Month + "-" + $Date.Year + ".htm"
	$MyReport | out-file -encoding ASCII -filepath $Filename
	Write "Audit saved as $Filename"