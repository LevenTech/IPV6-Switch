#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


;-----------------------------------|
;                                   |
; IPV6 Switch by LevenTech          |
;                                   |
; Version 1.5 (10-25-17)            |
;                                   |
;-----------------------------------|


; INITIALIZE STATE VAR
;----------------------
InitialState = 0


; TRAY ICON CONFIGURATION
;-------------------------
Menu, Tray, Tip, IPV6 Switch by LevenTech
Menu, Tray, Icon, %A_ScriptDir%\Icons\IPV6_OFF.ico, 1, 0

Menu, Tray, NoStandard



Menu, Tray, Add, Instructions, MyHelp
Menu, Tray, Add, Toggle IPV6, ToggleIPV6
Menu, Tray, Add
Menu, Tray, Add, Edit Script, EditScript
Menu, Tray, Standard

Menu, Tray, Default, Toggle IPV6 

If (InitialState)
{
	Menu, Tray, Rename, Toggle IPV6, Enable IPV6
	Goto, EnableIPV6
} else
{
	Menu, Tray, Rename, Toggle IPV6, Disable IPV6
	Goto, DisableIPV6
}

Return

RefreshTrayTip() {
    Menu Tray, NoIcon
    Menu Tray, Icon
	Return
}
MyTrayTip(title, text, options=0) {
	RefreshTrayTip()
	TrayTip %title%, %text%, , %options% 
	RefreshTrayTip()
	Return
}

EditScript: 
	message = 
	Run, notepad++.exe "%A_ScriptDir%\IPV6` Switch.ahk"
Return



; ONGOING BACKGROUND CODE
;-------------------------
CheckForPlex:
	While, Not IsIPV6on=0
	{
		WinWaitActive, ahk_exe chrome_plex.exe
		MyTrayTip("IPv6 is ON","Disable Before Refreshing Metdata",18)
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


DisableIPV6:
	if not A_IsAdmin 
	{
		MyTrayTip("Can't Disable IPV6","Need Admin Privileges")
	} else
	{
		Run, C:\Program` Files\NVSPBind\nvspbind.exe -d {9A1305B7-B62B-460C-B5ED-A6A13AE0C343} ms_tcpip6
		IsIPV6on = 0
		Menu, Tray, Icon, %A_ScriptDir%\Icons\IPV6_OFF.ico, 1, 0
		Menu, Tray, Rename, Disable IPV6, Enable IPV6
		MyTrayTip("IPv6 OFF","Disabled IPv6 on Ethernet2",17)
	}
Return

EnableIPV6:
	if not A_IsAdmin 
	{
		MyTrayTip("Can't Enable IPV6","Need Admin Privileges")
	} else
	{
		Run, C:\Program` Files\NVSPBind\nvspbind.exe -e {9A1305B7-B62B-460C-B5ED-A6A13AE0C343} ms_tcpip6
		IsIPV6on = 1
		Menu, Tray, Icon, %A_ScriptDir%\Icons\IPV6_ON.ico, 1, 0
		Menu, Tray, Rename, Enable IPV6, Disable IPV6
		MyTrayTip("IPv6 ON","Enabled IPv6 on Ethernet2",17)
	}
	SetTimer, CheckForPlex, -100
Return

ToggleIPV6:
	if (IsIPV6on = 1)
	{
		Goto, DisableIPV6
	} else 
	{
		Goto, EnableIPV6
	}
Return

