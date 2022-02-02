;;Script created by PodX12

#SingleInstance, Force
SetWorkingDir, %A_ScriptDir%
SetKeyDelay, 100

global timestamp = 0

; Update this to the saves directory of your minecraft instance
global SavesDirectory := "C:\Users\PodX1\Downloads\MultiMC\instances\MULTI3\.minecraft\saves\"

; Update this to where you want all of your old worlds to be moved to, this is to ensure the macro doesnt freeze on the select world screen
global OldWorldDirectory := "C:\Users\PodX1\Downloads\MultiMC\instances\MULTI3\.minecraft\saves\_oldWorlds"

global seed := ""

if( !seed ){
    MsgBox No seed set, please ensure you have configured the seed at the top of the ahk file
}

IfNotExist, %SavesDirectory%
{
    MsgBox Could not find save folder at %SavesDirectory% please ensure SavesDirectory and OldWorldDirectory is correct at the top of the ahk file
    ExitApp
}

IfNotExist, OldWorldDirectory
    FileCreateDir, OldWorldDirectory

CreateWorld(){
    Loop, Files, %OldWorldDirectory%*, D
    {
        _Check :=SubStr(A_LoopFileName,1,1)
        If (_Check!="_")
        {
            FileMoveDir, %SavesDirectory%%A_LoopFileName%, OldWorldDirectory\%A_LoopFileName%%A_NowUTC%, R
        }
    }
    delay := 45 ; Fine tune for your PC/comfort level (Each screen needs to be visible for at least a frame)
    SetKeyDelay, 0
    send {Esc}{Esc}{Esc}
    send {Tab}{Enter}
    SetKeyDelay, delay
    send {Tab}
    SetKeyDelay, 0
    send {Tab}{Tab}{Enter}
    send {Tab}{Tab}{Enter}{Enter}{Enter}{Tab}{Tab}{Tab}
    SetKeyDelay, delay
    send {Tab}{Enter}
    SetKeyDelay, 0
    send {Tab}{Tab}{Tab}
    Send %seed%
    Send {Shift}+{Tab}
    SetKeyDelay, delay
    send {Shift}+{Tab}{Enter}
}

ExitWorld()
{
    SetKeyDelay, 0
    send {Esc}{Shift}+{Tab}{Enter}
    SetKeyDelay, 50
}

#IfWinActive, Minecraft
    {

        RAlt::
            WinGetPos, X, Y, W, H, Minecraft
            WinGetActiveTitle, Title
            IfNotInString Title, player
                CreateWorld()
            else {
                ExitWorld()
                Sleep, 100
                Loop {
                    IfWinActive, Minecraft
                    {
                        PixelSearch, Px, Py, 0, 0, W, H, 0x00FCFC, 1, Fast
                        if (!ErrorLevel) {
                            Sleep, 100
                            IfWinActive, Minecraft
                            {
                                CreateWorld()
                                break
                            }
                        }
                    }
                }
            }
        return

        RCtrl::
            ExitWorld()
        return

    }
