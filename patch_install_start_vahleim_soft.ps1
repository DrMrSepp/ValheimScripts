# This Script is for softly (Re)starting your Valheim Server (include BepInDex if your'e using it)
# Valheim is running its database onmem - The database is written every 20 minutes to disk.
# If the Server is getting restarted simply by killing and restarting valheim_server.exe, the restart will cause data loss.


# Get Process ID of Valheim and End the Server softly (DO NOT CHANGE!)

$ProcessID = Get-Process valheim_server |select -expand id
echo $ProcessID
$MemberDefinition = '
    [DllImport("kernel32.dll")]public static extern bool FreeConsole();
    [DllImport("kernel32.dll")]public static extern bool AttachConsole(uint p);
    [DllImport("kernel32.dll")]public static extern bool GenerateConsoleCtrlEvent(uint e, uint p);
    public static void SendCtrlC(uint p) {
        FreeConsole();
        AttachConsole(p);
        GenerateConsoleCtrlEvent(0, p);
        FreeConsole();
        AttachConsole(uint.MaxValue);
    }'
Add-Type -Name 'dummyName' -Namespace 'dummyNamespace' -MemberDefinition $MemberDefinition 
[dummyNamespace.dummyName]::SendCtrlC($ProcessID)

# Wait for the soft Server-Stop (While writing the OnMem Database to HDD) - Change TimeFrame if your'e on an big Instance

Start-Sleep -s 30

# OPTIONAL OF YOURE USING MODS: Get Process ID of BepInDex and End the Batch Task hartdly

$ProcessID = Get-Process | Where-Object { $_.MainWindowTitle -like '*BepInEx*' } |select -expand id
Stop-Process -Id $ProcessID

# Restart your Server (including Patches) start-process "cmd.exe" "/c <path\to\your\server.bat>"
start-process "cmd.exe" "/c C:\Servers\Steam\patch_install_start_valheim_hard.bat"