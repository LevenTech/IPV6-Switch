#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


;-----------------------------------|
;                                   |
; IPV6 Switch by LevenTech          |
;                                   |
; Version 1.0 (9-29-17)             |
;                                   |
;-----------------------------------|


; TRAY ICON CONFIGURATION
;-------------------------
Menu, Tray, Tip, IPV6 Switch by LevenTech
Menu, Tray, Icon, 6_Question.ico, 1, 0

Menu, Tray, NoStandard
Menu, Tray, Add, Instructions, MyHelp
;Menu, Tray, Add
;Menu, Tray, Add, Edit Script, EditScript
;Menu, Tray, Add, Exit Script to Recompile, ReloadScript
Menu, Tray, Default, Instructions 
Menu, Tray, Standard

HideTrayTip() {
    TrayTip  ; Attempt to hide it the normal way.
    if SubStr(A_OSVersion,1,3) = "10." {
        Menu Tray, NoIcon
        Sleep 200  ; It may be necessary to adjust this sleep.
        Menu Tray, Icon
    }
}

; INITIALIZE STATE VAR
;----------------------
IsIPV6on = 


; ONGOING BACKGROUND CODE
;-------------------------
MyLoop:
	While, Not IsIPV6on=0
	{
		WinWaitActive, ahk_exe chrome_plex.exe
		TrayTip, IPv6 is ON, Disable Before Refreshing Metdata, 18
		Sleep, 30000
	}
Return

; HELP TEXT
;-----------
MyHelp: 
+^/::
!^/::
	message = 
	message = %message%`n  Ctrl + Alt + F6:`t DISABLE IPv6 on Ethernet2
	message = %message%`n  Ctrl + Shift + F6:`t ENABLE IPv6 on Ethernet2
	message = %message%`n
	message = %message%`n  Ctrl + F6:`t TOGGLE IPv6 on Ethernet2
	message = %message%`n `t`t (only works after Enabling or Disabling once)
	message = %message%`n
	MsgBox, , IPV6 Switch by LevenTech, %message%
Return


^!F6::
DisableIPV6:
	if not A_IsAdmin 
	{
		TrayTip, Can't Disable IPV6, Need Admin Privileges
	} else
	{
		Run, C:\Program` Files\NVSPBind\nvspbind.exe -d {9A1305B7-B62B-460C-B5ED-A6A13AE0C343} ms_tcpip6
		IsIPV6on = 0
		Menu, Tray, Icon, 6X.ico, 1, 0
		TrayTip, IPv6 OFF, Disabled IPv6 on Ethernet2, 17
	}
Return

^+F6::
EnableIPV6:
	if not A_IsAdmin 
	{
		TrayTip, Can't Enable IPV6, Need Admin Privileges
	} else
	{
		Run, C:\Program` Files\NVSPBind\nvspbind.exe -e {9A1305B7-B62B-460C-B5ED-A6A13AE0C343} ms_tcpip6
		IsIPV6on = 1
		Menu, Tray, Icon, 6_Circle.ico, 1, 0
		TrayTip, IPv6 ON, Enabled IPv6 on Ethernet2, 17
	}
	Goto, MyLoop
Return

^F6::
	if (IsIPV6on = 1)
	{
		Goto, DisableIPV6
	} else if (IsIPV6on = 0)
	{
		Goto, EnableIPV6
	} else 
	{
		TrayTip, Can't Toggle IPV6, Use Ctrl+Alt or Ctrl+Shift Once
	}
Return


