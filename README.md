# ValheimUpdateScripts

This Repository is containing Scripts for Valheim Server Backups and Updates - includes:

An Soft & Hard Server Restart Procedure (The Soft Script is Only Running with the "normal Server-Start Batch File")
-> Use the Soft Procedure as planned task every day for an auto Update of your instance
-> Link the Soft Procedure to your Start.bat (as documented in the soft Procedure)

To Create an Powershell Planned Task use the following Action Parametes:

Start Program: C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe
Arguments: <Path\To\File.ps1> 
-> For example: (C:\Servers\Steam\patch_install_start_vahleim_soft.ps1)
Start in: <Path\To\Folder\
-> for example: C:\Servers\Steam\
