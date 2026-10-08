[CmdletBinding()]
param(
    [ValidateSet("codex", "claude", "both")]
    [string]$Target,
    [string]$SkillsDirectory,
    [string]$BackupDirectory,
    [switch]$DryRun
)
$ErrorActionPreference = "Stop"
$sourceDirectory = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot "visual-analysis"))
if (-not (Test-Path -LiteralPath (Join-Path $sourceDirectory "SKILL.md") -PathType Leaf)) {
    throw "The visual-analysis folder is missing. Extract the entire archive before running the installer."
}
if (-not $Target) {
    Write-Host "Visual Analysis installation"
    Write-Host "1. Codex"
    Write-Host "2. Claude Code"
    Write-Host "3. Both"
    $choice = Read-Host "Choose 1, 2 or 3"
    $Target = switch ($choice) { "1" { "codex" } "2" { "claude" } "3" { "both" } default { throw "Invalid choice." } }
}
if ($SkillsDirectory -and $Target -eq "both") {
    throw "Use a custom skills directory with a single target."
}
$userDirectory = [Environment]::GetFolderPath("UserProfile")
if (-not $BackupDirectory) {
    $BackupDirectory = Join-Path $userDirectory ".visual-analysis\backups"
}
$backupRoot = [IO.Path]::GetFullPath($BackupDirectory)
$selectedTargets = if ($Target -eq "both") { @("codex", "claude") } else { @($Target) }
foreach ($selectedTarget in $selectedTargets) {
    $skillsRoot = $SkillsDirectory
    if (-not $skillsRoot) {
        $relativeRoot = if ($selectedTarget -eq "codex") { ".agents\skills" } else { ".claude\skills" }
        $skillsRoot = Join-Path $userDirectory $relativeRoot
    }
    $skillsRoot = [IO.Path]::GetFullPath($skillsRoot)
    $destination = [IO.Path]::GetFullPath((Join-Path $skillsRoot "visual-analysis"))
    if (-not [string]::Equals([IO.Path]::GetDirectoryName($destination), $skillsRoot.TrimEnd('\'), [StringComparison]::OrdinalIgnoreCase)) {
        throw "The destination is outside the selected skills directory."
    }
    if ($destination.StartsWith($sourceDirectory + "\", [StringComparison]::OrdinalIgnoreCase) -or
        $sourceDirectory.StartsWith($destination + "\", [StringComparison]::OrdinalIgnoreCase) -or
        [string]::Equals($destination, $sourceDirectory, [StringComparison]::OrdinalIgnoreCase)) {
        throw "The installation source and destination must be separate folders."
    }
    if ($backupRoot.StartsWith($destination + "\", [StringComparison]::OrdinalIgnoreCase) -or
        [string]::Equals($backupRoot, $destination, [StringComparison]::OrdinalIgnoreCase)) {
        throw "The backup directory must be outside the installed skill."
    }
    if (Test-Path -LiteralPath $destination) {
        $item = Get-Item -LiteralPath $destination -Force
        if (-not $item.PSIsContainer -or ($item.Attributes -band [IO.FileAttributes]::ReparsePoint)) {
            throw "The destination is a file or a symbolic link. Move it before installing."
        }
    }
    if ($DryRun) {
        Write-Host "Would install for $selectedTarget at $destination"
        if (Test-Path -LiteralPath $destination) { Write-Host "Would back up the existing folder under $backupRoot" }
        continue
    }
    [IO.Directory]::CreateDirectory($skillsRoot) | Out-Null
    $savedCopy = $null
    if (Test-Path -LiteralPath $destination) {
        [IO.Directory]::CreateDirectory($backupRoot) | Out-Null
        $backupName = "$selectedTarget-" + (Get-Date -Format "yyyyMMdd-HHmmss") + "-" + [guid]::NewGuid().ToString("N").Substring(0,8)
        $savedCopy = Join-Path $backupRoot $backupName
        Move-Item -LiteralPath $destination -Destination $savedCopy
        Write-Host "Previous version saved at $savedCopy"
    }
    try {
        Copy-Item -LiteralPath $sourceDirectory -Destination $destination -Recurse
        if (-not (Test-Path -LiteralPath (Join-Path $destination "SKILL.md") -PathType Leaf)) {
            throw "The skill file was not copied."
        }
    } catch {
        if ($savedCopy) {
            if (Test-Path -LiteralPath $destination) {
                $failedCopy = $savedCopy + "-failed-install"
                Move-Item -LiteralPath $destination -Destination $failedCopy
            }
            Move-Item -LiteralPath $savedCopy -Destination $destination
        }
        throw
    }
    Write-Host "Installed for $selectedTarget at $destination"
}
if ($DryRun) {
    Write-Host "Dry run complete. No files were changed."
} else {
    Write-Host "Start a new Codex or Claude Code session and invoke Visual Analysis."
    Write-Host "For Claude Chat and Cowork, upload visual-analysis-skill.zip in Customize > Skills."
}
