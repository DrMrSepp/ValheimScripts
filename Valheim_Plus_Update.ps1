# This Script is automaticly Updating your ValeimPlus Installation from GIT
# The Server SHOULD BE STOPPED WHILE DOING THE UPDATE!
# The following Parameters are depending on your environment and must be defined 

Write-Host Define Parameters and Folders - Change to your pathes!
$temp_path = "c:\tmp\"
$valheimsrvpath =  "C:\tmp\test-ziel\"

# From now on do not Change the Script

Write-Host Define GIT Project

$repo = "valheimPlus/ValheimPlus"
$file = "WindowsServer.zip"
$releases = "https://api.github.com/repos/$repo/releases"

Write-Host Getting latest Release
$tag = (Invoke-WebRequest $releases | ConvertFrom-Json)[0].tag_name

Write-Host Define Parameters and Folders - NOT CHANGE!

$download = "https://github.com/$repo/releases/download/$tag/$file"
$zip = "$name-$tag.zip"
$dir = "$name-$tag"

Write-Host Dowloading latest release
Invoke-WebRequest $download -Out $temp_path$zip

Write-Host Extracting release files
Expand-Archive $zip -Force -DestinationPath $temp_path$dir

Write-Host Delete ZIP File
Remove-Item $temp_path$zip -Recurse -Force -ErrorAction SilentlyContinue

Write-Host Patch Valheim Plus
Copy-Item -Path "$temp_path$dir\*" -Destination "$valheimsrvpath" -Recurse -Force

Write-Host Delete Unpacked Folder
Remove-Item $temp_path$dir -Recurse -Force -ErrorAction SilentlyContinue