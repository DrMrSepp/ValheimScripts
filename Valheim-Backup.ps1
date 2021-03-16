# This Scrpt is an Backup-Procedure for your Valheim Server
# You can run it as Windows Task for example every night

# The following Parameters are depending on your environment and must be defined 

# Folder Name for the ZIP-Backup-File (will be added with YYY MM DD HH mm at the end"
$ZIPNAME="VALHEIMBACKUP" + (Get-Date -format yyyy-MM-dd-HH_mm) + '.zip'

# Defining the Backup Folder
$BackupDirs="C:\Servers\Steam\Server_Files\valheim\_savedir"

# Temp Backup Path (to Create an consistent backup)
# Copy the Files to this Location
$Destination="C:\Backup_temp\valheim" 

#How many of the ölast Backups you want to keep
$Versions="1" 

# Folder(s) that should be included in the backup (in standard - same as Destination) 
$ZipSourcePath = 'C:\Backup_temp\valheim'

#Where should the Backup ZIP File be saved
$ZipDestinationPath = 'C:\Backup\Valheim\'

#How many days should your backups beeing keeped?
$Ziplimit = (Get-Date).AddDays(-30)

########################################
########################################
# FROM NOW ON DO NOT CHANGE THE SCRIPT!#
########################################
########################################

$Backupdir=$Destination +"\Backup-"+ (Get-Date -format yyyy-MM-dd)+"-"+(Get-Random -Maximum 100000)+"\"
$Items=0
$Count=0

#Create ZIP Destination Path if not exist
If(!(test-path $ZipDestinationPath))
{
      New-Item -ItemType Directory -Force -Path $ZipDestinationPath -ErrorAction SilentlyContinue -Confirm:$false
}

#Create Backupdir
Function Create-Backupdir {
    Write-Host "Create Backupdir" $Backupdir
    New-Item -Path $Backupdir -ItemType Directory -Force -ErrorAction SilentlyContinue -Confirm:$false | Out-Null
}
 
#Delete Backupdir
Function Delete-Backupdir {
    Write-Host "Delete old Backup"
    $Delete=$Count-$Versions+1
    Get-ChildItem $Destination -Directory | Sort-Object -Property $_.LastWriteTime -Descending  | Select-Object -First $Delete | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue -Confirm:$false
}
 
#Check if Backupdirs and Destination is available
function Check-Dir {
    if (!(Test-Path $BackupDirs)) {
        return $false
    }
    if (!(Test-Path $Destination)) {
        return $false
    }
}
 
#Save all the Files
Function Make-Backup {
    $Files=@()
    $SumItem=0
 
    foreach ($Backup in $BackupDirs) {
        $colItems = (Get-ChildItem $Backup -recurse | Measure-Object -property length -sum) 
        #"{0:N2}" -f ($colItems.sum / 1MB) + " MB of Files"
        $Items=0
        $FilesCount += Get-ChildItem $Backup -Recurse | Where-Object {$_.mode -notmatch "h"}  
        Copy-Item -Path $Backup -Destination $Backupdir -Force -ErrorAction SilentlyContinue -Confirm:$false
        $SumItem+=$colItems.Sum.ToString()
        $SumItems+=$colItems.Count
    }
 
    $TotalMB="{0:N2}" -f ($SumItem / 1MB) + " MB of Files"
    Write-Host "There will be"$TotalMB "copied and there are"$filesCount.Count "files to copy"
 
    foreach ($Backup in $BackupDirs) {
        $Index=$Backup.LastIndexOf("\")
        $SplitBackup=$Backup.substring(0,$Index)
        $Files = Get-ChildItem $Backup -Recurse | Where-Object {$_.mode -notmatch "h"} 
        foreach ($File in $Files) {
            $restpath = $file.fullname.replace($SplitBackup,"")
            Copy-Item  $file.fullname $($Backupdir+$restpath) -Force -ErrorAction SilentlyContinue -Confirm:$false |Out-Null
            $Items += (Get-item $file.fullname).Length
            $status = "Copy file {0} of {1} and copied {3} MB of {4} MB: {2}" -f $count,$filesCount.Count,$file.Name,("{0:N2}" -f ($Items / 1MB)).ToString(),("{0:N2}" -f ($SumItem / 1MB)).ToString()
            $Text="Copy data Location {0} of {1}" -f $BackupDirs.Rank ,$BackupDirs.Count
            Write-Progress -Activity $Text $status -PercentComplete ($Items / $SumItem*100)  
            $count++
        }
    }
    $SumCount+=$Count
 
    Write-Host "Copied" $SumCount "files with" ("{0:N2}" -f ($Items / 1MB)).ToString()"of MB"
}
 
#Check if Backupdir needs to be cleaned and create Backupdir
$Count=(Get-ChildItem $Destination -Directory).count
if ($count -lt $Versions) {
    Create-Backupdir
} else {
    Delete-Backupdir
    Create-Backupdir
}
 
#Check if all Dir are existing and do the Backup
$CheckDir=Check-Dir
if ($CheckDir -eq $false) {
    Write-Host "One of the Directory are not available, Script has stopped"
} else {
    Make-Backup
}

$Timestamp = (get-date -Format yyyyMMdd)
# Delete files older than the $limit.
Get-ChildItem -Path $ZipDestinationPath -Recurse -Force | Where-Object { !$_.PSIsContainer -and $_.CreationTime -lt $Ziplimit } | Remove-Item -Force -ErrorAction SilentlyContinue -Confirm:$false

# Delete any empty directories left behind after deleting the old files.
Get-ChildItem -Path $ZipDestinationPath -Recurse -Force | Where-Object { $_.PSIsContainer -and (Get-ChildItem -Path $_.FullName -Recurse -Force | Where-Object { !$_.PSIsContainer }) -eq $null } | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue -Confirm:$false

#Create Backup ZIP-File
Add-Type -Assembly "System.IO.Compression.FileSystem" ;
[System.IO.Compression.ZipFile]::CreateFromDirectory($ZipSourcePath, $ZipDestinationPath+$ZIPNAME) ;
