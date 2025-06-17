#Requires AutoHotkey v2.0

#SingleInstance Force
Persistent

; Инициализация переменных
global Paused := false
global UsedWordsFile := "used_words.txt"
global WordFile := "words.txt"
global SettingsFile := "settings.ini"
global LogFile := IniRead(SettingsFile, "Settings", "LogFile", "TwitchChatLog.txt")
global ErrorLogFile := IniRead(SettingsFile, "Settings", "ErrorLogFile", "errors.log")
global StatsFile := IniRead(SettingsFile, "Settings", "StatsFile", "stats.txt")

; Функция для записи файла с UTF-8 BOM
WriteFileUTF8BOM(FileName, Content)
{
    try
    {
        FileObj := FileOpen(FileName, "w", "UTF-8")
        if (FileObj)
        {
            FileObj.Write(Content)
            FileObj.Close()
            return true
        }
        return false
    }
    catch
    {
        return false
    }
}

; Функция для чтения файла с UTF-8 BOM
ReadFileUTF8BOM(FileName)
{
    try
    {
        if !FileExist(FileName)
            return ""
        
        FileObj := FileOpen(FileName, "r", "UTF-8")
        if (FileObj)
        {
            Content := FileObj.Read()
            FileObj.Close()
            return Content
        }
        return ""
    }
    catch
    {
        return ""
    }
}

; Функция для добавления в файл с UTF-8 BOM
AppendFileUTF8BOM(FileName, Content)
{
    try
    {
        ; Читаем существующий контент
        ExistingContent := ReadFileUTF8BOM(FileName)
        
        ; Добавляем новый контент
        NewContent := ExistingContent . Content
        
        ; Записываем обновленный контент
        return WriteFileUTF8BOM(FileName, NewContent)
    }
    catch
    {
        return false
    }
}

; Валидация StatsFile
if (StatsFile = "" || !RegExMatch(StatsFile, "^[\w\-]+\.txt$"))
{
    FormattedTime := FormatTime(A_NowUTC, "yyyy-MM-dd HH:mm:ss") " UTC"
    AppendFileUTF8BOM(ErrorLogFile, "[" FormattedTime "]: Предупреждение: Некорректное имя файла статистики '" StatsFile "', используется по умолчанию: stats.txt`n")
    StatsFile := "stats.txt"
}

F4::
{
    try
    {
        LoopCount := InputBox("Введите число повторов:", "Количество циклов", "W300 H150").Value
        if (!IsInteger(LoopCount) || LoopCount < 1)
        {
            FormattedTime := FormatTime(A_NowUTC, "yyyy-MM-dd HH:mm:ss") " UTC"
            AppendFileUTF8BOM(ErrorLogFile, "[" FormattedTime "]: Ошибка: Введено некорректное число повторов`n")
            MsgBox "Ошибка! Введите целое число больше 0!"
            return
        }
        
        ; Загружаем массив из файла
        Array := LoadArrayFromFile(WordFile)
        if (Array.Length = 0)
        {
            FormattedTime := FormatTime(A_NowUTC, "yyyy-MM-dd HH:mm:ss") " UTC"
            AppendFileUTF8BOM(ErrorLogFile, "[" FormattedTime "]: Ошибка: Не удалось загрузить слова из файла " WordFile "`n")
            MsgBox "Ошибка! Не удалось загрузить слова из файла " WordFile
            return
        }
        
        main(LoopCount, Array)
    }
    catch as e
    {
        FormattedTime := FormatTime(A_NowUTC, "yyyy-MM-dd HH:mm:ss") " UTC"
        AppendFileUTF8BOM(ErrorLogFile, "[" FormattedTime "]: Ошибка в цикле: " e.Message "`n")
        MsgBox "Ошибка: " e.Message
    }
}

F5::  ; Горячая клавиша для восстановления words.txt и очистки used_words.txt
{
    try
    {
        if !FileExist(UsedWordsFile)
        {
            FormattedTime := FormatTime(A_NowUTC, "yyyy-MM-dd HH:mm:ss") " UTC"
            AppendFileUTF8BOM(ErrorLogFile, "[" FormattedTime "]: Ошибка: Файл used_words.txt не существует`n")
            MsgBox "Файл used_words.txt не существует!"
            return
        }
        
        ; Читаем использованные слова
        UsedWords := ReadFileUTF8BOM(UsedWordsFile)
        
        ; Восстанавливаем words.txt, добавляя использованные слова
        if FileExist(WordFile)
        {
            AppendFileUTF8BOM(WordFile, UsedWords)
        }
        else
        {
            WriteFileUTF8BOM(WordFile, UsedWords)
        }
        
        ; Очищаем used_words.txt
        WriteFileUTF8BOM(UsedWordsFile, "")
        
        ; Логируем действие
        FormattedTime := FormatTime(A_NowUTC, "yyyy-MM-dd HH:mm:ss") " UTC"
        AppendFileUTF8BOM(LogFile, "[" FormattedTime "]: Восстановлен файл " WordFile ", очищен " UsedWordsFile "`n")
        
        TrayTip "Файлы обновлены", "words.txt восстановлен, used_words.txt очищен", 1
    }
    catch as e
    {
        FormattedTime := FormatTime(A_NowUTC, "yyyy-MM-dd HH:mm:ss") " UTC"
        AppendFileUTF8BOM(ErrorLogFile, "[" FormattedTime "]: Ошибка при восстановлении: " e.Message "`n")
        MsgBox "Ошибка при восстановлении: " e.Message
    }
}

F12::  ; Горячая клавиша для приостановки/возобновления
{
    global Paused
    Paused := !Paused
    if (Paused)
    {
        TrayTip "Скрипт приостановлен", "Нажмите F12 для возобновления", 1
        Pause 1
    }
    else
    {
        TrayTip "Скрипт возобновлен", "Работа продолжается", 1
        Pause 0
    }
}

main(LoopCount, Array)
{
    ; Создаем settings.ini с значениями по умолчанию, если он отсутствует
    if !FileExist(SettingsFile)
    {
        IniWrite 1000, SettingsFile, "Delays", "MinDelay"
        IniWrite 1500, SettingsFile, "Delays", "MaxDelay"
        IniWrite "TwitchChatLog.txt", SettingsFile, "Settings", "LogFile"
        IniWrite "errors.log", SettingsFile, "Settings", "ErrorLogFile"
        IniWrite "stats.txt", SettingsFile, "Settings", "StatsFile"
    }
    
    ; Загружаем задержки из settings.ini
    MinDelay := IniRead(SettingsFile, "Delays", "MinDelay", 1000)
    MaxDelay := IniRead(SettingsFile, "Delays", "MaxDelay", 1500)
    
    ; Валидация задержек
    if (!IsInteger(MinDelay) || !IsInteger(MaxDelay) || MinDelay < 1 || MaxDelay < 1 || MinDelay > MaxDelay)
    {
        MinDelay := 1000
        MaxDelay := 1500
        ; Перезаписываем некорректные значения в settings.ini
        IniWrite MinDelay, SettingsFile, "Delays", "MinDelay"
        IniWrite MaxDelay, SettingsFile, "Delays", "MaxDelay"
        FormattedTime := FormatTime(A_NowUTC, "yyyy-MM-dd HH:mm:ss") " UTC"
        AppendFileUTF8BOM(ErrorLogFile, "[" FormattedTime "]: Ошибка: Некорректные значения задержек, использованы значения по умолчанию`n")
    }
    
    SentCount := 0  ; Счетчик отправленных строк
    StartTime := A_TickCount  ; Замеряем время начала цикла
    
    ; Создаем used_words.txt, если он отсутствует
    if !FileExist(UsedWordsFile)
        WriteFileUTF8BOM(UsedWordsFile, "")
    
    Loop LoopCount
    {
        if (Array.Length = 0)
        {
            MsgBox "Все слова использованы!"
            ; Создаем пустой words.txt, если он пуст
            WriteFileUTF8BOM(WordFile, "")
            break
        }
        
        rand := Random(1, Array.Length)
        Value := Array[rand]
        
        ; Генерируем случайную задержку между MinDelay и MaxDelay
        ValueTime := Random(MinDelay, MaxDelay)
        
        ; Отправляем слово
        Send Value
        Sleep ValueTime
        Send "{Enter}"
        Sleep 1000
        
        ; Логируем отправленное слово
        FormattedTime := FormatTime(A_NowUTC, "yyyy-MM-dd HH:mm:ss") " UTC"
        AppendFileUTF8BOM(LogFile, "[" FormattedTime "]: delay: " ValueTime " ms, send: " Value "`n")
        
        ; Увеличиваем счетчик отправленных строк
        SentCount++
        
        ; Записываем использованное слово в used_words.txt
        AppendFileUTF8BOM(UsedWordsFile, Value "`n")
        
        ; Удаляем использованное слово из массива
        Array.RemoveAt(rand)
        
        ; Обновляем words.txt, записывая оставшиеся слова
        if (Array.Length > 0)
        {
            NewContent := ""
            for word in Array
                NewContent .= word "`n"
            WriteFileUTF8BOM(WordFile, NewContent)
        }
        else
        {
            WriteFileUTF8BOM(WordFile, "")
        }
    }
    
    ; Логируем статистику в log.txt
    TotalTime := Round((A_TickCount - StartTime) / 1000.0, 1)  ; Время в секундах
    FormattedTime := FormatTime(A_NowUTC, "yyyy-MM-dd HH:mm:ss") " UTC"
    AppendFileUTF8BOM(LogFile, "[" FormattedTime "]: Цикл завершен, отправлено " SentCount " строк, общее время " TotalTime " секунд`n")
    
    ; Логируем статистику в stats.txt с обработкой ошибок
    try
    {
        AppendFileUTF8BOM(StatsFile, "[" FormattedTime "]: Отправлено " SentCount " строк, общее время " TotalTime " секунд`n")
    }
    catch as e
    {
        FormattedTime := FormatTime(A_NowUTC, "yyyy-MM-dd HH:mm:ss") " UTC"
        AppendFileUTF8BOM(ErrorLogFile, "[" FormattedTime "]: Ошибка записи в файл статистики " StatsFile ": " e.Message "`n")
    }
    
    MsgBox "Цикл завершен! Отправлено " SentCount " строк.`nЛог сохранен в " LogFile
}

LoadArrayFromFile(FileName)
{
    arr := []
    if !FileExist(FileName)
        return arr
        
    Content := ReadFileUTF8BOM(FileName)
    for line in StrSplit(Content, "`n", "`r")
    {
        line := Trim(line)
        if (line != "")
            arr.Push(line)
    }
    return arr
}
