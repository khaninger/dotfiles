Set WshShell = CreateObject("WScript.Shell")
WshShell.Run "C:\Windows\System32\wsl.exe --shell-type none bash -c ""source /home/hanikevi/.nix-profile/etc/profile.d/hm-session-vars.sh && emacsclient -ca ''", 0, False
Set WshShell = Nothing