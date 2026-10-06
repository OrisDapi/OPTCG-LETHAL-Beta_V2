Add-Type -AssemblyName System.Drawing

$iconDir = "c:\Users\orischen\Documents\lethal calculator\icons"
if (-not (Test-Path $iconDir)) {
    New-Item -ItemType Directory -Path $iconDir | Out-Null
}

function Create-AppIcon([int]$size, [string]$filename) {
    $bmp = New-Object System.Drawing.Bitmap $size, $size
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

    # Background gradient
    $rect = New-Object System.Drawing.Rectangle 0, 0, $size, $size
    $cTop = [System.Drawing.ColorTranslator]::FromHtml("#131929")
    $cBot = [System.Drawing.ColorTranslator]::FromHtml("#0a0e1a")
    $brush = New-Object System.Drawing.Drawing2D.LinearGradientBrush $rect, $cTop, $cBot, 45.0
    $g.FillRectangle($brush, $rect)

    # Outer border circle
    $margin = [int]($size * 0.05)
    $innerSize = $size - ($margin * 2)
    $cGold = [System.Drawing.ColorTranslator]::FromHtml("#f0b232")
    $penGold = New-Object System.Drawing.Pen $cGold, ([float]($size * 0.035))
    $g.DrawEllipse($penGold, $margin, $margin, $innerSize, $innerSize)

    # Inner circle
    $marginInner = [int]($size * 0.08)
    $innerSize2 = $size - ($marginInner * 2)
    $cBlue = [System.Drawing.ColorTranslator]::FromHtml("#3d4f7c")
    $penInner = New-Object System.Drawing.Pen $cBlue, ([float]($size * 0.015))
    $g.DrawEllipse($penInner, $marginInner, $marginInner, $innerSize2, $innerSize2)

    # Main text: OPTCG
    $fontTitle = New-Object System.Drawing.Font "Arial", ([float]($size * 0.22)), ([System.Drawing.FontStyle]::Bold)
    $brushGold = New-Object System.Drawing.SolidBrush $cGold
    $sf = New-Object System.Drawing.StringFormat
    $sf.Alignment = [System.Drawing.StringAlignment]::Center
    $sf.LineAlignment = [System.Drawing.StringAlignment]::Center

    $titleRect = New-Object System.Drawing.RectangleF 0, ([float]($size * 0.22)), ([float]$size), ([float]($size * 0.3))
    $g.DrawString("OPTCG", $fontTitle, $brushGold, $titleRect, $sf)

    # Sub text: LETHAL
    $cRed = [System.Drawing.ColorTranslator]::FromHtml("#e63946")
    $fontSub = New-Object System.Drawing.Font "Arial", ([float]($size * 0.16)), ([System.Drawing.FontStyle]::Bold)
    $brushRed = New-Object System.Drawing.SolidBrush $cRed
    $subRect = New-Object System.Drawing.RectangleF 0, ([float]($size * 0.52)), ([float]$size), ([float]($size * 0.25))
    $g.DrawString("LETHAL", $fontSub, $brushRed, $subRect, $sf)

    $savePath = Join-Path $iconDir $filename
    $bmp.Save($savePath, [System.Drawing.Imaging.ImageFormat]::Png)

    $g.Dispose()
    $bmp.Dispose()
    Write-Output "Created: $savePath"
}

Create-AppIcon 512 "icon-512.png"
Create-AppIcon 192 "icon-192.png"
Create-AppIcon 180 "apple-touch-icon.png"
Create-AppIcon 64 "favicon.png"
