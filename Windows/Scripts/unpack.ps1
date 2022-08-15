param($product="")
$product = $product.ToLower()

function UnpackFile([string] $name, [string] $archive, [string] $path, [bool] $force){
    Write-Host Unpacking $name -ForegroundColor Cyan -NoNewLine; Write-Host " to:" $path " ... " -NoNewline;
    try {
      if($force){
        Expand-Archive $archive $path -Force
      }else {
        Expand-Archive $archive $path
      }
        Write-Host "Done!" -ForegroundColor Green
    } catch { Write-Host "Failed!" -ForegroundColor Red}
}

# Opening statement
Write-Host "Unpacking the downloads..."

# Version
. .\scripts\version.ps1
. .\scripts\shared-vars.ps1

# Archive for each product
$archives = @{}
$archives.Add('neo4j', (Get-Location).Path + "\install\$($neo4jZip)")
$archives.Add('jre', (Get-Location).Path + "\install\$($jreZip)")
$archives.Add('nomjre', (Get-Location).Path + "\install\$($nomJreZip)")
$archives.Add('nom', (Get-Location).Path + "\install\$($nomZip)")
$archives.Add('nomagent', (Get-Location).Path + "\neo4j-ops-manager-server-$($nomVersion)\$($nomAgentZip)")
$archives.Add('openssl', (Get-Location).Path + "\install\$($opensslZip)")

# Target location for each product 
$locations = @{}
$locations.Add('neo4j', (Get-Location).Path + '\')
$locations.Add('jre', (Get-Location).Path + '\')
$locations.Add('nom', (Get-Location).Path + '\')
$locations.Add('nomagent', (Get-Location).Path + '\')
$locations.Add('nomjre', (Get-Location).Path + '\')
$locations.Add('openssl', (Get-Location).Path + '\')

# Catalog of products
$catalog = "neo4j","jre","nom","nomagent","nomjre","openssl"

# Actual unpack
Foreach ($item in $catalog) {
  # a single product parameter on the commandline overrides the full unpack
  if ($product -eq "" -or $product -eq $item){
      UnpackFile $item $archives[$item] $locations[$item] $True
  }
}

# All done
Write-Host "`nUnpacking Complete" -ForegroundColor Green
