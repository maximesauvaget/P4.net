Function Find-MsBuild([int] $MaxVersion = 2017)
{
    $agentPath = "$Env:programfiles (x86)\Microsoft Visual Studio\2017\BuildTools\MSBuild\15.0\Bin\msbuild.exe"
    $devPath = "$Env:programfiles (x86)\Microsoft Visual Studio\2017\Enterprise\MSBuild\15.0\Bin\msbuild.exe"
    $proPath = "$Env:programfiles (x86)\Microsoft Visual Studio\2017\Professional\MSBuild\15.0\Bin\msbuild.exe"
    $communityPath = "$Env:programfiles (x86)\Microsoft Visual Studio\2017\Community\MSBuild\15.0\Bin\msbuild.exe"
    $fallback2015Path = "${Env:ProgramFiles(x86)}\MSBuild\14.0\Bin\MSBuild.exe"
    $fallback2013Path = "${Env:ProgramFiles(x86)}\MSBuild\12.0\Bin\MSBuild.exe"
    $fallbackPath = "C:\Windows\Microsoft.NET\Framework\v4.0.30319"
		
    If ((2017 -le $MaxVersion) -And (Test-Path $agentPath)) { return $agentPath } 
    If ((2017 -le $MaxVersion) -And (Test-Path $devPath)) { return $devPath } 
    If ((2017 -le $MaxVersion) -And (Test-Path $proPath)) { return $proPath } 
    If ((2017 -le $MaxVersion) -And (Test-Path $communityPath)) { return $communityPath } 
    If ((2015 -le $MaxVersion) -And (Test-Path $fallback2015Path)) { return $fallback2015Path } 
    If ((2013 -le $MaxVersion) -And (Test-Path $fallback2013Path)) { return $fallback2013Path } 
    If (Test-Path $fallbackPath) { return $fallbackPath } 
        
    throw "Unable to find msbuild"
}

$projectName = "P4.net"
$sourceNugetExe = "https://dist.nuget.org/win-x86-commandline/latest/nuget.exe" 
$MSBuild = Find-MsBuild
   
$erroractionpreference = "Stop"

Write-Host "########"
Write-Host "Downloading nuget."
$targetNugetExe = "nuget.exe"
if (-Not (Test-Path $targetNugetExe))
{
    Invoke-WebRequest $sourceNugetExe -OutFile "nuget.exe" 
}
Write-Host "Downloaded nuget..." 
Write-Host "########"
 
Write-Host "########"
Write-Host "Packing $projectName.csproj"
& ".\nuget.exe" restore "$projectName.sln"
& $MSBuild "$projectName.csproj" /property:Configuration=Release /property:Platform=x64;
& ".\nuget.exe" pack "$projectName.nuspec"
Write-Host "Package created..." 
Write-Host "########"
Write-Host " "
Write-Host " " 
Write-Host "Done..."