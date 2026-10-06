$dir = "c:\Users\orischen\Documents\lethal calculator"

# 1. Generate standalone offline HTML file
$iconPath = Join-Path $dir "icons\apple-touch-icon.png"
if (Test-Path $iconPath) {
    $bytes = [System.IO.File]::ReadAllBytes($iconPath)
    $b64 = [System.Convert]::ToBase64String($bytes)
    $dataUri = "data:image/png;base64,$b64"

    $html = Get-Content (Join-Path $dir "index.html") -Raw -Encoding UTF8
    $html = $html.Replace("icons/apple-touch-icon.png", $dataUri)
    $html = $html.Replace("icons/favicon.png", $dataUri)
    $html = $html.Replace("icons/icon-192.png", $dataUri)

    $outHtml = Join-Path $dir "OPTCG_Lethal_Calculator_Offline.html"
    [System.IO.File]::WriteAllText($outHtml, $html, [System.Text.Encoding]::UTF8)
    Write-Output "Generated standalone file: $outHtml"
}

# 2. Create clean ZIP package
$zipPath = Join-Path $dir "OPTCG_Lethal_Calculator_Mobile.zip"
if (Test-Path $zipPath) {
    Remove-Item $zipPath -Force
}

$itemsToZip = @(
    (Join-Path $dir "index.html"),
    (Join-Path $dir "manifest.json"),
    (Join-Path $dir "sw.js"),
    (Join-Path $dir "server.ps1"),
    (Join-Path $dir "start_mobile_server.bat"),
    (Join-Path $dir "OPTCG_Lethal_Calculator_Offline.html"),
    (Join-Path $dir "icons")
)

Compress-Archive -Path $itemsToZip -DestinationPath $zipPath -Force
Write-Output "Successfully created ZIP: $zipPath"
