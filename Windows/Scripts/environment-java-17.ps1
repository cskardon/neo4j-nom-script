# Version
. .\scripts\version.ps1
. .\scripts\shared-vars.ps1

# Environment
if (Test-Path env:_JAVA_OPTIONS) {
  Remove-Item env:_JAVA_OPTIONS
}
$env:JAVA_HOME = $javaJRELocation
$env:PATH = "$($javaJRELocation)\bin;" + $env:PATH
