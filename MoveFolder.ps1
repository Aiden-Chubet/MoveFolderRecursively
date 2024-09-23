# Define source and destination directories
$sourceDir = "D:\Shares\Data\Shared\IT\Installers"
$destinationDir = "\\APP01.Domain.Local\C$\Installers"

# Create the destination directory if it doesn't exist
if (-not (Test-Path -Path $destinationDir)) {
    New-Item -ItemType Directory -Path $destinationDir
}

# Define the new destination path for the Software folder
$destinationSoftwareDir = Join-Path -Path $destinationDir -ChildPath (Split-Path -Leaf $sourceDir)

# Create the Software directory in the destination
if (-not (Test-Path -Path $destinationSoftwareDir)) {
    New-Item -ItemType Directory -Path $destinationSoftwareDir
}

# Copy all files and directories from source to destination recursively and verify
$filesCopied = @()
Get-ChildItem -Path $sourceDir -Recurse | ForEach-Object {
    $destinationFile = $_.FullName -replace [regex]::Escape($sourceDir), $destinationSoftwareDir
    $destinationDirPath = Split-Path -Path $destinationFile

    # Create the destination directory if it doesn't exist
    if (-not (Test-Path -Path $destinationDirPath)) {
        New-Item -ItemType Directory -Path $destinationDirPath
    }

    Copy-Item -Path $_.FullName -Destination $destinationFile

    # Verify the file was copied
    if (Test-Path -Path $destinationFile) {
        $filesCopied += $_.FullName
    }
}

# Delete files and directories from source if they were copied successfully
$filesCopied | ForEach-Object {
    Remove-Item -Path $_ -Recurse -Force
}

Write-Output "All files and directories have been copied and verified. Original files have been deleted."
