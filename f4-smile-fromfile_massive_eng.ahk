#Requires AutoHotkey v2.0

#SingleInstance Force
Persistent

; Initialize variables
global Paused := false
global UsedWordsFile := "used_words.txt"
global WordFile := "words.txt"
global SettingsFile := "settings.ini"
global LogFile := IniRead(SettingsFile, "Settings", "LogFile", "log.txt")
global ErrorLogFile := IniRead(SettingsFile, "Settings", "ErrorLogFile", "errors.log")
global StatsFile := IniRead(SettingsFile, "Settings", "StatsFile", "stats.txt")

; Validate StatsFile
if (StatsFile = "" || !RegExMatch(StatsFile, "^[\w\-]+\.txt$"))
{
    FormattedTime := FormatTime(A_NowUTC, "yyyy-MM-dd HH:mm:ss") " UTC"
    FileAppend "[" FormattedTime "]: Warning: Invalid statistics file name '" StatsFile "', using default: stats.txt`n", ErrorLogFile
    StatsFile := "stats.txt"
}

F4::
{
    try
    {
        LoopCount := InputBox("Enter the number of repetitions:", "Number of cycles", "W300 H150").Value
        if (!IsInteger(LoopCount) || LoopCount < 1)
        {
            FormattedTime := FormatTime(A_NowUTC, "yyyy-MM-dd HH:mm:ss") " UTC"
            FileAppend "[" FormattedTime "]: Error: Invalid number of repetitions entered`n", ErrorLogFile
            MsgBox "Error! Enter an integer greater than 0!"
            return
        }
        
        ; Load array from file
        Array := LoadArrayFromFile(WordFile)
        if (Array.Length = 0)
        {
            FormattedTime := FormatTime(A_NowUTC, "yyyy-MM-dd HH:mm:ss") " UTC"
            FileAppend "[" FormattedTime "]: Error: Failed to load words from file " WordFile "`n", ErrorLogFile
            MsgBox "Error! Failed to load words from file " WordFile
            return
        }
        
        main(LoopCount, Array)
    }
    catch as e
    {
        FormattedTime := FormatTime(A_NowUTC, "yyyy-MM-dd HH:mm:ss") " UTC"
        FileAppend "[" FormattedTime "]: Error in loop: " e.Message "`n", ErrorLogFile
        MsgBox "Error: " e.Message
    }
}

F5::  ; Hotkey to restore words.txt and clear used_words.txt
{
    try
    {
        if !FileExist(UsedWordsFile)
        {
            FormattedTime := FormatTime(A_NowUTC, "yyyy-MM-dd HH:mm:ss") " UTC"
            FileAppend "[" FormattedTime "]: Error: File used_words.txt does not exist`n", ErrorLogFile
            MsgBox "File used_words.txt does not exist!"
            return
        }
        
        ; Read used words
        UsedWords := FileRead(UsedWordsFile)
        
        ; Restore words.txt by appending used words
        if FileExist(WordFile)
        {
            FileAppend UsedWords, WordFile
        }
        else
        {
            FileAppend UsedWords, WordFile
        }
        
        ; Clear used_words.txt
        FileDelete UsedWordsFile
        FileAppend "", UsedWordsFile
        
        ; Log the action
        FormattedTime := FormatTime(A_NowUTC, "yyyy-MM-dd HH:mm:ss") " UTC"
        FileAppend "[" FormattedTime "]: Restored file " WordFile ", cleared " UsedWordsFile "`n", LogFile
        
        TrayTip "Files updated", "words.txt restored, used_words.txt cleared", 1
    }
    catch as e
    {
        FormattedTime := FormatTime(A_NowUTC, "yyyy-MM-dd HH:mm:ss") " UTC"
        FileAppend "[" FormattedTime "]: Error during restoration: " e.Message "`n", ErrorLogFile
        MsgBox "Error during restoration: " e.Message
    }
}

F12::  ; Hotkey to pause/resume
{
    global Paused
    Paused := !Paused
    if (Paused)
    {
        TrayTip "Script paused", "Press F12 to resume", 1
        Pause 1
    }
    else
    {
        TrayTip "Script resumed", "Operation continues", 1
        Pause 0
    }
}

main(LoopCount, Array)
{
    ; Create settings.ini with default values if it doesn't exist
    if !FileExist(SettingsFile)
    {
        IniWrite 1000, SettingsFile, "Delays", "MinDelay"
        IniWrite 1500, SettingsFile, "Delays", "MaxDelay"
        IniWrite "log.txt", SettingsFile, "Settings", "LogFile"
        IniWrite "errors.log", SettingsFile, "Settings", "ErrorLogFile"
        IniWrite "stats.txt", SettingsFile, "Settings", "StatsFile"
    }
    
    ; Load delays from settings.ini
    MinDelay := IniRead(SettingsFile, "Delays", "MinDelay", 1000)
    MaxDelay := IniRead(SettingsFile, "Delays", "MaxDelay", 1500)
    
    ; Validate delays
    if (!IsInteger(MinDelay) || !IsInteger(MaxDelay) || MinDelay < 1 || MaxDelay < 1 || MinDelay > MaxDelay)
    {
        MinDelay := 1000
        MaxDelay := 1500
        ; Overwrite invalid values in settings.ini
        IniWrite MinDelay, SettingsFile, "Delays", "MinDelay"
        IniWrite MaxDelay, SettingsFile, "Delays", "MaxDelay"
        FormattedTime := FormatTime(A_NowUTC, "yyyy-MM-dd HH:mm:ss") " UTC"
        FileAppend "[" FormattedTime "]: Error: Invalid delay values, using default values`n", ErrorLogFile
    }
    
    ; Remove ArrayTime array since we use direct randomization
    ; ArrayTime := [MinDelay, MaxDelay] - this line is removed
    SentCount := 0  ; Counter for sent lines
    StartTime := A_TickCount  ; Record loop start time
    
    ; Create used_words.txt if it doesn't exist
    if !FileExist(UsedWordsFile)
        FileAppend "", UsedWordsFile
    
    Loop LoopCount
    {
        if (Array.Length = 0)
        {
            MsgBox "All words have been used!"
            ; Create empty words.txt if it's empty
            FileDelete WordFile
            FileAppend "", WordFile
            break
        }
        
        rand := Random(1, Array.Length)
        Value := Array[rand]
        
        ; Generate random delay between MinDelay and MaxDelay
        ValueTime := Random(MinDelay, MaxDelay)
        
        ; Send the word
        Send Value
        Sleep ValueTime
        Send "{Enter}"
        Sleep 1000
        
        ; Log the sent word
        FormattedTime := FormatTime(A_NowUTC, "yyyy-MM-dd HH:mm:ss") " UTC"
        FileAppend "[" FormattedTime "]: delay: " ValueTime " ms, send: " Value "`n", LogFile
        
        ; Increment the sent lines counter
        SentCount++
        
        ; Write used word to used_words.txt
        FileAppend Value "`n", UsedWordsFile
        
        ; Remove used word from array
        Array.RemoveAt(rand)
        
        ; Update words.txt by writing remaining words
        FileDelete WordFile
        if (Array.Length > 0)
        {
            for word in Array
                FileAppend word "`n", WordFile
        }
        else
        {
            FileAppend "", WordFile
        }
    }
    
    ; Log statistics to log.txt
    TotalTime := Round((A_TickCount - StartTime) / 1000.0, 1)  ; Time in seconds
    FormattedTime := FormatTime(A_NowUTC, "yyyy-MM-dd HH:mm:ss") " UTC"
    FileAppend "[" FormattedTime "]: Loop completed, sent " SentCount " lines, total time " TotalTime " seconds`n", LogFile
    
    ; Log statistics to stats.txt with error handling
    try
    {
        FileAppend "[" FormattedTime "]: Sent " SentCount " lines, total time " TotalTime " seconds`n", StatsFile
    }
    catch as e
    {
        FormattedTime := FormatTime(A_NowUTC, "yyyy-MM-dd HH:mm:ss") " UTC"
        FileAppend "[" FormattedTime "]: Error writing to stats file " StatsFile ": " e.Message "`n", ErrorLogFile
    }
    
    MsgBox "Loop completed! Sent " SentCount " lines.`nLog saved to " LogFile
}

LoadArrayFromFile(FileName)
{
    arr := []
    if !FileExist(FileName)
        return arr
        
    for line in StrSplit(FileRead(FileName), "`n", "`r")
    {
        line := Trim(line)
        if (line != "")
            arr.Push(line)
    }
    return arr
}
