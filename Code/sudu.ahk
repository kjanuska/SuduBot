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
FileInstall, C:\Users\Kipras\Documents\AHK Scripts\Sudu Tasks\Images\start.png, data\start.png
FileInstall, C:\Users\Kipras\Documents\AHK Scripts\Sudu Tasks\Images\tasks.png, data\tasks.png
FileInstall, C:\Users\Kipras\Documents\AHK Scripts\Sudu Tasks\Images\continue.png, data\continue.png
FileInstall, C:\Users\Kipras\Documents\AHK Scripts\Sudu Tasks\Images\email_box.png, data\email_box.png
FileInstall, C:\Users\Kipras\Documents\AHK Scripts\Sudu Tasks\Images\sudu.png, data\sudu.png

Hotkey !^a, AddTasks
Hotkey !^r, StartTasks
; test
ST_Insert(insert,input,pos=1)
{
    Length := StrLen(input)
    ((pos > 0) ? (pos2 := pos - 1) : (((pos = 0) ? (pos2 := StrLen(input),Length := 0) : (pos2 := pos))))
    output := SubStr(input, 1, pos2) . insert . SubStr(input, pos, Length)
    if (StrLen(output) > StrLen(input) + StrLen(insert))
        ((Abs(pos) <= StrLen(input)/2) ? (output := SubStr(output, 1, pos2 - 1) . SubStr(output, pos + 1, StrLen(input))) : (output := SubStr(output, 1, pos2 - StrLen(insert) - 2) . SubStr(output, pos - StrLen(insert), StrLen(input))))
    return, output
}

; ==============================================================================
/*

 .d8888b.                888                 .d8888b.                   d8b          888    
d88P  Y88b               888                d88P  Y88b                  Y8P          888    
Y88b.                    888                Y88b.                                    888    
 "Y888b.   888  888  .d88888 888  888        "Y888b.    .d8888b 888d888 888 88888b.  888888 
    "Y88b. 888  888 d88" 888 888  888           "Y88b. d88P"    888P"   888 888 "88b 888    
      "888 888  888 888  888 888  888             "888 888      888     888 888  888 888    
Y88b  d88P Y88b 888 Y88b 888 Y88b 888       Y88b  d88P Y88b.    888     888 888 d88P Y88b.  
 "Y8888P"   "Y88888  "Y88888  "Y88888        "Y8888P"   "Y8888P 888     888 88888P"   "Y888 
                                                                            888             
                                                                            888             
                                                                            888             
                        Made by Kipras Januska
                                2020

*/
; ==============================================================================

Gui, Add, Button, x32 y29 w120 h70 gRunEverything, Add tasks and start them
Gui, Add, Button, x32 y109 w120 h70 gDeleteTasks, Delete Tasks
Gui, Add, Button, x162 y69 w120 h70 gRunTasks, (Re)start tasks
Gui, Show, , ChooseMode
Return

GuiClose:
ExitApp
return

; ==============================================================================
; Generate dotted emails and add them to a text file
; ==============================================================================
RunEverything:
    Gui, Destroy
GenerateEmails:
    FileDelete, %A_ScriptDir%\data\paste_emails.txt
    Line := 1
    Loop, Read, %A_ScriptDir%\data\emails.txt
    {
        FileReadLine, Email, %A_ScriptDir%\data\emails.txt, %Line%
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
                FileAppend, %Paste%, %A_ScriptDir%\data\paste_emails.txt
                
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
    Loop, Read, %A_ScriptDir%\data\paste_emails.txt
    {
        TotalEmails += 1
    }
    
    ; ==============================================================================
    ; Ask user for number of tasks and times
    ; ==============================================================================
TaskRequest:
    Gui, Add, Text, , You have %TotalEmails% available tasks. How many do you want?
    Gui, Add, Edit
    Gui, Add, UpDown, vTaskAmount Range1-%TotalEmails%, 1
    Gui, Add, Text, , How many different checkout times?
    Gui, Add, Edit
    Gui, Add, UpDown, vCheckoutTimeCount Range1-500, 1
    Gui, Add, Button, Default w80, OK
    Gui, Show, , TaskSelect
    WinSet, AlwaysOnTop, On, TaskSelect
return

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
        TimeCounter += 1
    }
    Gui, 2:Add, Button, Default w80, OK
    Gui, 2:Show, , TimeSelect
    WinSet, AlwaysOnTop, On, TimeSelect
return

2ButtonOK:
    Gui, 2:Submit
    TimeVarCount := TimeCounter - 1
    VarNum := 1
    Loop %TimeVarCount%
    {
        CheckoutTimes.Push(TempTime%VarNum%)
        VarNum += 1
    }
    Gui, 2:Destroy
    
    Gui, P:Add, Text, , Find the product you want, add the size(s), then press ctrl + alt + a to start.
    Gui, P:Show, , ProductSelect
    WinSet, AlwaysOnTop, On, ProductSelect
return

; ==============================================================================
; Add tasks using emails and times
; ==============================================================================
AddTasks:
    Gui, P:Destroy
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
    
    ; ==============================================================================
    ; Paste emails and times
    ; ==============================================================================
    ReadLine := 1
    Index := 1
    TimePasteCounter := 0
    Loop, %TaskAmount%
    {
        FileReadLine, EmailPaste, %A_ScriptDir%\data\paste_emails.txt, %ReadLine%
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
    
    ; ==============================================================================
    ; Switch to tasks page
    ; ==============================================================================
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
    
    ; ==============================================================================
    ; Start tasks and click continue
    ; ==============================================================================
RunTasks:
    Sleep 100
    ContinueClicks := 0
StartTasks:
    Loop
    {
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
                ImageSearch, ContinueX, ContinueY, 0, 0, 1920, 1080, *10 data\continue.png
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
                } else if ErrorLevel = 1
                {
                    MsgBox cannot find continue image
                } else if ErrorLevel = 2
                {
                    MsgBox error getting continue image resource
                }
            }
        }
        else if ErrorLevel = 1
        {
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
    
    ; ==============================================================================
    ; Delete all tasks
    ; ==============================================================================
DeleteTasks:
    Gui, Destroy
    Gui, 3:Add, Text, , Open Sudu, hover over delete button, press enter
    Gui, 3:Add, Button, Default w80, OK
    Gui, 3:Show, , DeleteTasksGUI
    WinSet, AlwaysOnTop, On, DeleteTasksGUI
    Loop
    {
        IfWinNotActive, DeleteTasksGUI
        {
            WinActivate, DeleteTasksGUI
        }
    }
return

3ButtonOK:
    Gui, 3:Destroy
    
    Loop
    {
        Click
        Sleep, 10
    }
    
    MsgBox Done
ExitApp
return

Escape::
ExitApp
return