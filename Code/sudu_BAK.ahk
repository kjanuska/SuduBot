#NoEnv
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen
SendMode Input
#SingleInstance Ignore
SetTitleMatchMode 2
#WinActivateForce
SetControlDelay -1
SetWinDelay 0
SetKeyDelay -1
SetMouseDelay -1
SetBatchLines -1

FileCreateDir, data
FileInstall, C:\Users\Kipras\Desktop\Sudu_images\start.png, data\start.png
FileInstall, C:\Users\Kipras\Desktop\Sudu_images\tasks.png, data\tasks.png
FileInstall, C:\Users\Kipras\Desktop\Sudu_images\continue.png, data\continue.png
FileInstall, C:\Users\Kipras\Desktop\Sudu_images\email_box.png, data\email_box.png
FileInstall, C:\Users\Kipras\Desktop\Sudu_images\sudu.png, data\sudu.png

Hotkey !^a, AddTasks
Hotkey !^r, StartTasks
SuduID := 0
EmulatorID := 0
/*
Insert
   Insert text into another string at the specified position.
   All text after the inserted text is shifted over.

   insert = Text to insert.
   into   = The text to insert into.
   pos    = The position where to begin inserting. 0 May be used to insert
            at the very end, -1 will offset 1 from the end, and so on.
            *---------------------------------*
            ! | is where it starts inserting. !
            ! positive: [|1|2|3|4|5|6|7]      !
            ! string:   [|a|b|c|d|e|f|g]      !
            !                                 !
            ! negative: [|7|6|5|4|3|2|1|0]    !
            ! string:   [|a|b|c|d|e|f|g| ]    !
            *---------------------------------*

example: st_insert("aaa", "cccbbb", 1)
output:  aaabbbccc
*/
ST_Insert(insert,input,pos=1)
{
	Length := StrLen(input)
	((pos > 0) ? (pos2 := pos - 1) : (((pos = 0) ? (pos2 := StrLen(input),Length := 0) : (pos2 := pos))))
	output := SubStr(input, 1, pos2) . insert . SubStr(input, pos, Length)
	if (StrLen(output) > StrLen(input) + StrLen(insert))
		((Abs(pos) <= StrLen(input)/2) ? (output := SubStr(output, 1, pos2 - 1) . SubStr(output, pos + 1, StrLen(input))) : (output := SubStr(output, 1, pos2 - StrLen(insert) - 2) . SubStr(output, pos - StrLen(insert), StrLen(input))))
	Return, output
}

--------------------------------------------------------------
Gui, Add, Text, , select sudu window and press ctrl + alt + s
Gui, Show, , Sudu
WinSet, AlwaysOnTop, On, Sudu
Return

SelectSudu:
Gui, Destroy
MouseGetPos, , , SuduID, control
WinGetTitle, TargetSuduTitle, ahk_id %SuduID%

Gui, Add, Text, , select emulator window and press ctrl + alt + m
Gui, Show, , Emulator
WinSet, AlwaysOnTop, On, Emulator
Return

SelectEmulator:
Gui, Destroy
MouseGetPos, , , EmulatorID, control
WinGetTitle, TargetEmulatorTitle, ahk_id %EmulatorID%

 := A_WorkingDir . "\myIniFile.ini"

if not (FileExist(myIniFile))
{
    FileAppend, ([mySection] myPermanentVar=0), % myIniFile, utf-16 ; save your ini file asUTF-16LE
}

IniRead, var, % myIniFile, mySection, myPermanentVar ; reads the value from the ini file specifying its section and the key

Gui, Add, Button, x32 y29 w140 h90 , Add tasks and start them
Gui, Add, Button, x392 y239 w-70 h-110 , Start tasks
Gui, Add, Button, x392 y-21 w10 h0 , Start tasks
Gui, Add, Button, x92 y219 w30 h-40 , Button
Gui, Add, Button, x242 y29 w150 h90 , Start tasks
Gui, Show, , Window
Return

--------------------------------------------------------------
GenerateEmails:
FileDelete, %A_WorkingDir%\data\paste_emails.txt
Line := 1
Loop, Read, %A_WorkingDir%\data\emails.txt
{
    FileReadLine, Email, %A_WorkingDir%\data\emails.txt, %Line%
    StringLen, EmailLength, Email
    EmailLengthTotal := EmailLength
    StartingPos := 0
    Position := 1
    Dotted := Email
    Loop, %EmailLengthTotal%
    {
        if StartingPos != 0
        {
            EmailLength := EmailLengthTotal
            Shorten := StartingPos
            Shorten /= 2
            EmailLength -= Shorten
            EmailLength -= 1
            Email := st_insert(".", Email, StartingPos)  
        }
        Loop, %EmailLength%
        {
            Dotted := st_insert(".", Email, Position)
            Paste := 
            (LTrim
            Dotted "@gmail.com
            "
            )
            FileAppend, %Paste%, %A_WorkingDir%\data\paste_emails.txt
            
            Position += 1
        }
        if StartingPos = 0
        {
            StartingPos := 1
        }
        else
        {
            StartingPos += 2
        }
        Position := StartingPos
        Position += 2
    }
    Line += 1
}

TotalEmails := 0
Loop, Read, %A_WorkingDir%\data\paste_emails.txt
{
    TotalEmails += 1
}

--------------------------------------------------------------
TaskRequest:
Gui, Add, Text, , You have %TotalEmails% available tasks. How many do you want?
Gui, Add, Edit
Gui, Add, UpDown, vTaskAmount Range1-%TotalEmails%, 1
Gui, Add, Text, , How many different checkout times?
Gui, Add, Edit
Gui, Add, UpDown, vCheckoutTimeCount Range1-500, 1
Gui, Add, Button, Default w80, OK
Gui, Show, , TaskSelect
WinSet, AlwaysOnTop, On, TaskSelect ahk_class AutoHotkeyGUI
Return

ButtonOK:
Gui, Submit
Gui, Destroy

SplitEmails := TaskAmount / CheckoutTimeCount
SplitEmails := Ceil(SplitEmails)
TimeCounter := 1
CheckoutTimes := []

Loop, %CheckoutTimeCount%
{
    TimeText := "Time " TimeCounter ":"
    Gui, 2:Add, Text, , %TimeText%
    Gui, 2:Add, Edit, vTempTime%TimeCounter%
    CheckoutTimes.Push(TempTime%TimeCounter%)
    TimeCounter += 1
}
Gui, 2:Add, Button, Default w80, OK
Gui, 2:Show, , TimeSelect
WinSet, AlwaysOnTop, On, TimeSelect ahk_class AutoHotkeyGUI
Return

2ButtonOK:
Gui, 2:Submit
Gui, 2:Destroy

Gui, Add, Text, , Find the product you want, add the size(s), then press ctrl + alt + a to start.
Gui, Show, , ProductSelect
WinSet, AlwaysOnTop, On, ProductSelect ahk_class AutoHotkeyGUI
Return

AddTasks:
Gui, Destroy
WinActivate, TargetSuduTitle
Sleep 10
ImageSearch, EmailX, EmailY, 0, 0, 1920, 1080, data\email_box.png

if ErrorLevel = 0
{
    MouseMove, EmailX, EmailY, 0
    Click
}
else if ErrorLevel = 1
{
    MsgBox Can't find email_box!
    ExitApp
}
else if ErrorLevel = 2
{
    MsgBox Error getting email_box image
    ExitApp
}

ReadLine := 1
Index := 1
TimePasteCounter := 0
Loop, %TaskAmount%
{
    FileReadLine, EmailPaste, %A_WorkingDir%\data\paste_emails.txt, %ReadLine%
    Clipboard := EmailPaste
    Send, ^v
    Sleep, 10
    Send, {Tab}
    Sleep, 10
    Send, {Tab}
    Sleep, 10
    if TimePasteCounter = 0
    {
        Clipboard := % CheckoutTimes[Index]
        Send, ^v
    }
    else if TimePasteCounter = %SplitEmails%
    {
        TimePasteCounter := -1
        Index += 1
    }
    TimePasteCounter += 1
    Send, {Tab}
    Sleep, 10
    Send, {Enter}
    Sleep, 10
    Send, {Tab}
    Sleep, 10
    Send, {Tab}
    Sleep, 10
    ReadLine += 1
}

ImageSearch, TasksX, TasksY, 0, 0, 1920, 1080, *5 data\tasks.png
TasksX += 16
TasksY += 16

if ErrorLevel = 0
{
    MouseMove, TasksX, TasksY, 0
    Click
    Sleep, 10
    Click
}
else if ErrorLevel = 1
{
    MsgBox Can't find tasks button
} else if ErrorLevel = 2
{
    MsgBox Error getting tasks image
    ExitApp
}

Sleep 100
ContinueClicks := 0
StartTasks:
Loop
{
    WinActivate, TargetSuduTitle
    Found := False
    ImageSearch, StartX, StartY, 0, 0, 1920, 1080, *5 data\start.png
    StartX += 10
    StartY += 10
    if ErrorLevel = 0
    {
        MouseMove, StartX, StartY, 0
        Click
        While (!Found)
        {
            WinActivate, TargetEmulatorTitle
            ImageSearch, ContinueX, ContinueY, 0, 0, 1920, 1080, *5 data\continue.png
            ContinueX += 81
            ContinueY += 31
            if ErrorLevel = 0
            {
                Sleep 500
                MouseMove, ContinueX, ContinueY, 0
                Click
                ContinueClicks += 1
                Found := True
                Sleep 1000
            }
        }
    }
    else if ErrorLevel = 1
    {
        WinActivate, TargetSuduTitle
        ImageSearch, SuduX, SuduY, 0, 0, 1920, 1080, *5 data\sudu.png
        SuduY += 100
        if ErrorLevel = 0
        {
            MouseMove, SuduX, SuduY, 0
            Click
        }
        else if ErrorLevel = 1
        {
            MsgBox can't find sudu
            ExitApp
        }
        Send {WheelDown 3}
        Sleep, 300
    }
    else if ErrorLevel = 2
    {
        MsgBox Error getting start image
        ExitApp
    }
}

MsgBox Done
ExitApp
Return

Escape::
ExitApp
Return