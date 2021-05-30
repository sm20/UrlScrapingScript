<#
Download select hyperlinks from a base address url page

Usage:
- With an Admin Privilege Powershell, Set-ExutionPolicy to unrestricted. Then change it back to restricted afterwards
- From the directory with this program execute .\run.ps1 arg1 arg2
	- arg 1 is the website url from which the urls should be scraped, without a concluding '/' character in the Url
	- arg2 is the directory to store the files, including a concluding '\' symbol
	
	Example: .\run.ps1 http://pages.cpsc.ucalgary.ca/~eberly/Courses/CPSC331/2020/8_Conclusion C:\Users\SM\Desktop\School\331\Lectures\8-Addt_dataStructs`,Algos\
		- Note: The ` character is an escape character in PowerShell
	
#>

#Turn all relative url addresses into complete addresses that use the base address
function Get-AbsoluteURL($pageUrl, $url) {
    [Uri]::new([Uri]$pageUrl, $url).AbsoluteUri
}

#Get all links that are on the base address page
$webUrl = $args[0]	#baseaddress from CLI
$baseAddr = Invoke-WebRequest $webUrl
[String[]]$allLinks = $baseAddr.links.href	#convert all scraped links to strings

#Download each hyperlink one at a time
# reference for regex matching: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_regular_expressions?view=powershell-7.1
	#$OutPath = "C:\Users\SM\Desktop\School\331\Lectures\" <--previous version
$OutPath = $args[1]
$num = 1
foreach($i in $allLinks) {
	if($i -match '.pdf$' -or $i -match '.java$' -or $i -match '.py$' -or $i -match '.sh$') {
		$fullAddr = Get-AbsoluteURL $webUrl $i #turn relative addresses in array to complete URL's
		$fullAddr #debug print
		$saveLocation = $OutPath + "$num -" + $fullAddr.split('/')[-1] #parse addr of save loc based on url extensions route destination name
		$num++ #increment file names preceeding characters for organization purposes
		Invoke-WebRequest -Uri $fullAddr -OutFile ( New-Item -Path $saveLocation -Force ) #save file to loc. Force create folders if !exist
	}
}


<#<--previous version
for ($num = 2 ; $num -le 26 ; $num++){
	
	$fullAddr = Get-AbsoluteURL "http://pages.cpsc.ucalgary.ca/~eberly/Courses/CPSC331/2020/1_Introduction" $allLinks[$num]
	$fullAddr
	$saveLocation = $OutPath + "$num -" + $fullAddr.split('/')[-1]
	Invoke-WebRequest -Uri $fullAddr -Outfile $saveLocation	
}
#>