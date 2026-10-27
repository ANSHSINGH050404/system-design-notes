<#
.SYNOPSIS
    Copy the System Design notes out of the Obsidian vault and into this repo.

.DESCRIPTION
    The Obsidian vault at D:\Ansh is the source of truth — that is where the
    notes are written and edited. This repo is the published snapshot.

    The script rewrites three things that only make sense inside a vault:

      1. Absolute local paths (D:\system-design) become repo references.
      2. Wikilinks that point at OTHER vault folders (ATLAS/, opencode-docs/)
         become plain text, because they would dangle here.
      3. Obsidian's ![[excalidraw]] embed becomes a normal markdown link.

    Wikilinks BETWEEN the notes in this repo are left alone, so the copies
    still work as Obsidian notes if you drop them back into the vault.

.EXAMPLE
    .\sync-from-vault.ps1
    git add -A
    git commit -m "sync: refresh notes from the vault"
    git push
#>

[CmdletBinding()]
param(
    [string]$VaultPath = 'D:\Ansh\System-Design',
    [string]$RepoPath = ''
)

$ErrorActionPreference = 'Stop'

# $PSScriptRoot is not reliably populated in a param default under
# `powershell -File`, so resolve it in the body instead.
if ([string]::IsNullOrWhiteSpace($RepoPath)) { $RepoPath = $PSScriptRoot }
if ([string]::IsNullOrWhiteSpace($RepoPath)) { $RepoPath = (Get-Location).Path }

# Notes that belong in this repo. Pi-vs-OpenCode-Architecture.md is
# deliberately excluded: it is a comparison of two agent harnesses, not a
# system design note, and it belongs with the opencode work.
$Notes = @(
    'Projects.md',
    'Learning-Resources.md',
    'System-Design-Home.md',
    'Quick-Commerce-System-Design.md'
)

# Vault folders referenced by the notes but living outside this repo.
$VaultOnlyTargets = @('ATLAS/LLD', 'opencode-docs/MISSION', 'opencode-docs/NOTES')

Write-Host "Syncing from $VaultPath" -ForegroundColor Cyan

# --- drawings -------------------------------------------------------------
$drawingsDir = Join-Path $RepoPath 'Excalidraw'
New-Item -ItemType Directory -Path $drawingsDir -Force | Out-Null

$drawingSource = Join-Path $VaultPath '..\Excalidraw\food-delivery.excalidraw.md'
if (Test-Path $drawingSource) {
    Copy-Item $drawingSource -Destination (Join-Path $drawingsDir 'food-delivery.excalidraw.md') -Force
    Write-Host "  copied Excalidraw/food-delivery.excalidraw.md"
}

# --- notes ----------------------------------------------------------------
# Read and write with explicit UTF-8 and NO BOM.
#
# `Get-Content -Raw` reads using the system ANSI codepage, so a UTF-8
# middle dot (C2 B7) comes back as two characters (Â·). `Set-Content
# -Encoding utf8` then re-encodes each of those, and the file ends up
# double-encoded (C3 82 C2 B7). The .NET APIs below do it correctly.
$utf8 = New-Object System.Text.UTF8Encoding($false)

foreach ($note in $Notes) {
    $source = Join-Path $VaultPath $note
    if (-not (Test-Path $source)) {
        Write-Warning "  missing in the vault: $note (skipped)"
        continue
    }

    $text = [System.IO.File]::ReadAllText($source, $utf8)

    # 1. Absolute local paths -> the repo that holds the code.
    $text = $text.Replace('D:\system-design', 'ANSHSINGH050404/system-design')

    # 2. Wikilinks into other vault folders -> plain text.
    foreach ($target in $VaultOnlyTargets) {
        # A literal backtick inside a double-quoted string needs doubling.
        $text = $text.Replace("[[$target]]", "``$target``")
    }

    # 3. Obsidian excalidraw embed -> a normal link that works on GitHub.
    $text = $text.Replace(
        '![[food-delivery.excalidraw]]',
        '[architecture drawing](Excalidraw/food-delivery.excalidraw.md)'
    )

    [System.IO.File]::WriteAllText((Join-Path $RepoPath $note), $text, $utf8)
    Write-Host "  synced $note"
}

Write-Host "`nDone. Review the diff, then:" -ForegroundColor Cyan
Write-Host "  git add -A; git commit -m 'sync: refresh notes from the vault'; git push"
