/*---INFO-------------------------------------------------------------------------------------------------------------------------------------------------
	Discord.ahk: A script that has all the hotkeys I use with Discord

	Author: jmbvill
	Date Modified: 2024.04.27
	Version Number: 1.0.0
	Changelog: Initial Release
*/

;---SETTINGS-----------------------------------------------------------------------------------------------------------------------------------------------
#InstallKeybdHook ;monitors keystrokes that are not supported by RegisterHotkey. Also supports the Input command.
#NoEnv ;Recommended for performance and compatibility with future AutoHotkey releases.
;#Warn  ;Enable warnings to assist with detecting common errors.
SendMode Input ;Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% ;Ensures a consistent starting directory.

;The following settings are disabled because this script sets them during normal operation.
;SetTitleMatchMode, 1 ;The window's title can contain WinTitle anywhere inside it to be a match.
;DetectHiddenWindows, On ;Allows the script to find windows that live on different desktops.

;---INCLUDED FILES-----------------------------------------------------------------------------------------------------------------------------------------

;---LABELS-------------------------------------------------------------------------------------------------------------------------------------------------
;This section is to set labels for use with the SetTimer function

;---MAIN---------------------------------------------------------------------------------------------------------------------------------------------------
;NAME												HOTKEY						INDEX
;Discord_Switch Chat								PAGE UP, PAGE DOWN			#HK01

/*===Discord_Switch Chat========================================================#HK01
	Summary: For use with Discord.
	Overrides Discord's default chat switching hotkeys to the universal chat switching hotkeys

	Hotkey: PAGE UP, PAGE DOWN
*/
$PgUp:: send, ^!{up}
Return
$PgDn:: send, ^!{down}
return