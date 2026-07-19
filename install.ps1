[CmdletBinding()]
param(
    [string]$Version = $env:PPS_VERSION,
    [string]$InstallDir = $env:PPS_INSTALL_DIR,
    [string]$Repository = "PROJECT-PS/PPS-CLI"
)

$ErrorActionPreference = "Stop"
if (-not $InstallDir) {
    $InstallDir = Join-Path $env:LOCALAPPDATA "Programs\PPS"
}

$nativeArchitecture = [System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture.ToString().ToUpperInvariant()
$architecture = switch ($nativeArchitecture) {
    "AMD64" { "amd64" }
    "ARM64" { "arm64" }
    default { throw "Unsupported CPU architecture: $nativeArchitecture" }
}

if (-not $Version) {
    $release = Invoke-RestMethod -Headers @{ "User-Agent" = "pps-installer" } -Uri "https://api.github.com/repos/$Repository/releases/latest"
    $Version = $release.tag_name
}
if ($Version -notmatch '^v\d+\.\d+\.\d+$') {
    throw "Invalid version: $Version"
}

$archive = "pps_${Version}_windows_${architecture}.zip"
$baseUrl = "https://github.com/$Repository/releases/download/$Version"
$tempDir = Join-Path ([System.IO.Path]::GetTempPath()) ("pps-install-" + [System.Guid]::NewGuid().ToString("N"))
New-Item -ItemType Directory -Path $tempDir | Out-Null

try {
    $archivePath = Join-Path $tempDir $archive
    $checksumsPath = Join-Path $tempDir "checksums.txt"
    Write-Host "Downloading PPS CLI $Version for windows/$architecture..."
    Invoke-WebRequest -UseBasicParsing -Uri "$baseUrl/$archive" -OutFile $archivePath
    Invoke-WebRequest -UseBasicParsing -Uri "$baseUrl/checksums.txt" -OutFile $checksumsPath

    $checksumLine = Get-Content $checksumsPath | Where-Object { $_ -match "^[0-9a-fA-F]{64}\s+$([regex]::Escape($archive))$" } | Select-Object -First 1
    if (-not $checksumLine) {
        throw "Release checksum for $archive is missing"
    }
    $expected = ($checksumLine -split '\s+')[0].ToLowerInvariant()
    $actual = (Get-FileHash -Algorithm SHA256 -Path $archivePath).Hash.ToLowerInvariant()
    if ($expected -ne $actual) {
        throw "SHA-256 verification failed"
    }

    $extractDir = Join-Path $tempDir "extract"
    Expand-Archive -Path $archivePath -DestinationPath $extractDir
    $executable = Join-Path $extractDir "pps.exe"
    if (-not (Test-Path $executable)) {
        throw "The release archive does not contain pps.exe"
    }
    New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null
    Copy-Item -Force $executable (Join-Path $InstallDir "pps.exe")

    $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
    $pathEntries = @($userPath -split ';' | Where-Object { $_ })
    if ($pathEntries -notcontains $InstallDir) {
        $newPath = (@($pathEntries) + $InstallDir) -join ';'
        [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
        $env:Path = "$env:Path;$InstallDir"
        Write-Host "Added $InstallDir to the user PATH. Open a new terminal if needed."
    }
    Write-Host "Installed PPS CLI $Version to $InstallDir\pps.exe"
}
finally {
    Remove-Item -Recurse -Force -ErrorAction SilentlyContinue $tempDir
}
