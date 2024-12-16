/*---INFO-------------------------------------------------------------------------------------------------------------------------------------------------
	ahk-util.ahk: A script that has all utility functions that I like to use

	Author: jmbvill
	Date Modified: 2024.04.28
	Version Number: 1.0.0
	Changelog: initial release
*/

;---SETTINGS-----------------------------------------------------------------------------------------------------------------------------------------------
; V1toV2: Removed #NoEnv ;Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ;Enable warnings to assist with detecting common errors.
SendMode("Input") ;Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir(A_ScriptDir) ;Ensures a consistent starting directory.

;The following settings are disabled because this script sets them during normal operation.
;SetTitleMatchMode, 1 ;The window's title can contain WinTitle anywhere inside it to be a match.
;DetectHiddenWindows, On ;Allows the script to find windows that live on different desktops.

;---INCLUDED FILES-----------------------------------------------------------------------------------------------------------------------------------------

;---FUNCTIONS----------------------------------------------------------------------------------------------------------------------------------------------
;RemoveToolTip  										#F01
;createDictionary										#F02

/*======RemoveToolTip===================================#F01
	Summary: Used as a function for SetTimer to jump to when closing tooltips

	Parameters:
		None
	Return:
		None
*/
RemoveToolTip()
{
    ToolTip()
    return
}

/*======createDictionary================================#F02
	Summary: Creates a dictionary based on key value pairs that the user specifies

	Parameters:
		kVPairs: a list of key-value pairs where keys and values are separated by ":" and pairs are separated by "|"
		for example kVPairs = "key1:value1|key2:value2|key3:value3"

	Return:
		dict: a dictionary (technically an associative array)
*/
createDictionary(kVPairs)
{
    ;Initialize an empty dictionary
    local dict := {}

    ;Split the input string into key-value pairs
    pairs := StrSplit(kVPairs, "|")

    ;Loop through each pair and add it to the dictionary
    for _, pair in pairs {
        colonPos := InStr(pair, ":") ;Find the position of the colon in the string
        key := Trim(SubStr(pair, 1, colonPos - 1)) ;Extract the string representing the key
        value := Trim(SubStr(pair, (colonPos + 1)<1 ? (colonPos + 1)-1 : (colonPos + 1))) ;Extract the string representing the value
        dict[key] := value
    }

    return dict
}
