param($product="")
$product = $product.ToLower()

# Imports
. .\scripts\version.ps1
. .\scripts\functions.ps1
. .\scripts\shared-vars.ps1

# Opening statement
Write-Host "Downloading - there is no progress indicator! Please be patient!" -ForegroundColor Cyan


# URLs for each product
$urls = @{}
$urls.Add('neo4j',"https://neo4j.com/artifact.php?name=$($neo4jZip)")
$urls.Add('jre',"https://cdn.azul.com/zulu/bin/$($jreZip)")
$urls.Add('nomjre',"https://cdn.azul.com/zulu/bin/$($nomJreZip)")
$urls.Add('nom', "https://dist.neo4j.org/ops-manager/$($nomVersion)/$($nomZip)")
$urls.Add('openssl', "https://sourceforge.net/projects/openssl-for-windows/files/$($openSslZip)/download")

# Download location for each product 
$locations = @{}
$locations.Add('neo4j', (Get-Location).Path + "\install\$($neo4jZip)")
$locations.Add('jre', (Get-Location).Path + "\install\$($jreZip)")
$locations.Add('nomjre', (Get-Location).Path + "\install\$($nomJreZip)")
$locations.Add('nom', (Get-Location).Path + "\install\$($nomZip)")
$locations.Add('openssl', (Get-Location).Path + "\install\$($opensslZip)")

# Catalog of products
$catalog = "neo4j","jre","nomjre","nom","openssl"

# Create install folder
Write-Host "Creating 'install' folder ... " -NoNewline;
New-Item -ItemType Directory -Force -Path install | Out-Null
Write-Host "Done!" -ForegroundColor Green

# Actual download
Foreach ($item in $catalog) {
  # a single product parameter on the commandline overrides the full download
  if ($product -eq "" -or $product -eq $item){
    DownloadFile $item $urls[$item] $locations[$item]
  }
}

# All done
Write-Host "`nDownloading Complete" -ForegroundColor Green
