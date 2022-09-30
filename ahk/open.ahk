
; *********************** Header - some configuration  ***********************
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors. (disabled by default)
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
setTitleMatchMode, 2 ; set title match mode to "contains"

; this code was auto generated at:
; https://www.ahkgen.com/?indexes=1&comment1=photoshop&func1=KEY&skey1%5B%5D=WIN&skeyValue1=p&Window1=adobe+photoshop+2020&Program1=%22C%3A%5CProgram+Files%5CAdobe%5CAdobe+Photoshop+2020%5CPhotoshop.exe%22&option1=ActivateOrOpen

; *********************** Configured region - selected functions ************

;quit
#q:: ; (This is a comment:) Windows+q triggers the following
Send ^!{f4} ; Simulates the keypress alt+f4
return ; Finished


;photoshop
#p::ActivateOrOpen("- Adobe Photoshop 2020", "C:\Program Files\Adobe\Adobe Photoshop 2020\Photoshop.exe")

;firefox
#f::ActivateOrOpen("- Mozilla Firefox", "C:\Program Files\Mozilla Firefox\firefox.exe")

;mpv
#m::ActivateOrOpen("- mpv.net", "C:\Program Files\mpv.net\mpvnet.exe")






; *********************** Provided Functions ********************************
OpenConfig()
{
    Run, "https://www.ahkgen.com/?indexes=1&comment1=photoshop&func1=KEY&skey1`%5B`%5D=WIN&skeyValue1=p&Window1=adobe+photoshop+2020&Program1=`%22C`%3A`%5CProgram+Files`%5CAdobe`%5CAdobe+Photoshop+2020`%5CPhotoshop.exe`%22&option1=ActivateOrOpen"
}

LockWorkStation()
{
    DllCall("LockWorkStation")
}

TurnMonitorsOff()
{
    ; from http://autohotkey.com/board/topic/105261-turn-monitor-off-even-when-using-the-computer/?p=642266
    SendMessage,0x112,0xF170,2,,Program Manager
}

ActivateOrOpen(window, program)
{
	; check if window exists
	if WinExist(window)
	{
		WinActivate  ; Uses the last found window.
	}
	else
	{   ; else start requested program
		 Run cmd /c "start ^"^" ^"%program%^"",, Hide ;use cmd in hidden mode to launch requested program
		 WinWait, %window%,,5		; wait up to 5 seconds for window to exist
		 IfWinNotActive, %window%, , WinActivate, %window%
		 {
			  WinActivate  ; Uses the last found window.
		 }
	}
	return
}

ActivateOrOpenChrome(tab, url)
{
    Transform, url, Deref, "%url%" ;expand variables inside url
    Transform, tab, Deref, "%tab%" ;expand variables inside tab
    chrome := "- Google Chrome"
    found := "false"
    tabSearch := tab
    curWinNum := 0

    SetTitleMatchMode, 2
    if WinExist(Chrome)
	{
		WinGet, numOfChrome, Count, %chrome% ; Get the number of chrome windows
		WinActivateBottom, %chrome% ; Activate the least recent window
		WinWaitActive %chrome% ; Wait until the window is active

		ControlFocus, Chrome_RenderWidgetHostHWND1 ; Set the focus to tab control ???

		; Loop until all windows are tried, or until we find it
		while (curWinNum < numOfChrome and found = "false") {
			WinGetTitle, firstTabTitle, A ; The initial tab title
			title := firstTabTitle
			Loop
			{
				if(InStr(title, tabSearch)>0){
					found := "true"
					break
				}
				Send {Ctrl down}{Tab}{Ctrl up}
				Sleep, 50
				WinGetTitle, title, A  ;get active window title
				if(title = firstTabTitle){
					break
				}
			}
			WinActivateBottom, %chrome%
			curWinNum := curWinNum + 1
		}
	}

    ; If we did not find it, start it
    if(found = "false"){
        Run chrome.exe "%url%"
    }
	return
}

; from https://stackoverflow.com/a/28448693
SendUnicodeChar(charCode)
{
    ; if in unicode mode, use Send, {u+####}, else, use the encode method.
    if A_IsUnicode = 1
    {
        Send, {u+%charCode%}
    }
    else
    {
        VarSetCapacity(ki, 28 * 2, 0)
        EncodeInteger(&ki + 0, 1)
        EncodeInteger(&ki + 6, charCode)
        EncodeInteger(&ki + 8, 4)
        EncodeInteger(&ki +28, 1)
        EncodeInteger(&ki +34, charCode)
        EncodeInteger(&ki +36, 4|2)

        DllCall("SendInput", "UInt", 2, "UInt", &ki, "Int", 28)
    }
}

EncodeInteger(ref, val)
{
	DllCall("ntdll\RtlFillMemoryUlong", "Uint", ref, "Uint", 4, "Uint", val)
}
