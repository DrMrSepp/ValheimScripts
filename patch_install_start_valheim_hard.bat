@echo off

REM This Script is the actual Patch & Start procedure for the Valheim Server

echo Kill running Tags
Taskkill /IM valheim_server.exe /F

echo Start Server Updates
REM Example: <Path_to_your_steamcmd> +login anonymous +force_install_dir <Path_To_Your_Valheim_Server> +app_update 896660 +quit

C:\Servers\Steam\SteamCMD\steamcmd +login anonymous +force_install_dir C:\Servers\Steam\Server_Files\valheim +app_update 896660 +quit

echo Start Server
set SteamAppId=892970

echo "Starting server PRESS CTRL-C to exit"
REM Tip: Make a local copy of this script to avoid it being overwritten by steam.
REM NOTE: Minimum password length is 5 characters & Password cant be in the server name.
REM NOTE: You need to make sure the ports 2456-2458 is being forwarded to your server through your local router & firewall.
REM Tip: The -savedir parameter is optional. It's defining the location where your server files are saved. Change or delete it to your location if you want.
C:\Servers\Steam\Server_Files\valheim\valheim_server.exe -nographics -batchmode -name "SERVERNAME" -port 2456 -world "WORLDNAME" -password "SERVERPASSWD" -public 1 -savedir "C:\Servers\Steam\Server_Files\valheim\_savedir"

exit
