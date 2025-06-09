# AutoHotkey Word Sender Script

This AutoHotkey (v2.0) script automates sending words from a text file with customizable delays, logging, and file management. It reads words from `words.txt`, sends them with random delays, and tracks used words in `used_words.txt`. The script also maintains logs and statistics.

## Features

- **Hotkey Controls**:
    - `F4`: Prompts for the number of cycles and sends words from `words.txt` with random delays.
    - `F5`: Restores `words.txt` with words from `used_words.txt` and clears `used_words.txt`.
    - `F12`: Pauses or resumes the script.
- **File Management**:
    - Reads words from `words.txt`.
    - Tracks used words in `used_words.txt`.
    - Logs actions to `log.txt` and errors to `errors.log`.
    - Records statistics in `stats.txt`.
- **Configuration**:
    - Settings stored in `settings.ini`, including minimum and maximum delays (`MinDelay`, `MaxDelay`), and file paths for logs and stats.
    - Automatically creates `settings.ini` with default values if missing.
- **Error Handling**:
    - Validates input and file operations.
    - Logs errors with UTC timestamps.

## Requirements

- [AutoHotkey v2.0+](https://www.autohotkey.com/)
- Windows operating system

## Installation

1. Download and install [AutoHotkey v2.0+](https://www.autohotkey.com/).
2. Clone or download this repository.
3. Ensure the following files are in the same directory as the script:
    - `words.txt`: A text file with one word per line.
    - (Optional) `settings.ini`: Configuration file (created automatically if missing).

## Usage

1. Create a `words.txt` file with one word per line.
2. Run the script (`script.ahk`) with AutoHotkey.
3. Use the following hotkeys:
    - **F4**: Enter the number of words to send. Words are sent with random delays between `MinDelay` and `MaxDelay` (from `settings.ini`).
    - **F5**: Restore `words.txt` with words from `used_words.txt` and clear `used_words.txt`.
    - **F12**: Pause or resume the script.
4. Check `log.txt`, `errors.log`, and `stats.txt` for logs and statistics.

## Configuration

The script uses `settings.ini` for configuration. If missing, it is created with defaults:

```ini
[Delays]
MinDelay=1000
MaxDelay=1500
[Settings]
LogFile=log.txt
ErrorLogFile=errors.log
StatsFile=stats.txt
```

- `MinDelay`, `MaxDelay`: Random delay range (in milliseconds) between sending words.
- `LogFile`, `ErrorLogFile`, `StatsFile`: File paths for logs and statistics.

## File Structure

- `script.ahk`: Main AutoHotkey script
- `words.txt`: Input file with words (one per line)
- `used_words.txt`: Tracks used words (created automatically)
- `settings.ini`: Configuration file (created automatically if missing)
- `log.txt`: Logs actions with timestamps
- `errors.log`: Logs errors with timestamps
- `stats.txt`: Records statistics (e.g., number of words sent, total time)

## Notes

- Ensure `words.txt` exists and contains words before running.
- The script validates inputs and file names to prevent errors.
- Logs and statistics use UTC timestamps.
- If `words.txt` is empty or all words are used, the script notifies the user and creates an empty `words.txt`.

## Contributing

Submit issues or pull requests to improve the script. Ensure changes are compatible with AutoHotkey v2.0+.

## License

This project is licensed under the MIT License. See the LICENSE file for details.

---
# Russian version readme

# Скрипт отправки слов на AutoHotkey

Этот скрипт AutoHotkey (v2.0) автоматизирует отправку слов из текстового файла с настраиваемыми задержками, ведением логов и управлением файлами. Он читает слова из `words.txt`, отправляет их с случайными задержками и отслеживает использованные слова в `used_words.txt`. Скрипт также ведет логи и статистику.

## Возможности

- **Горячие клавиши**:
    - `F4`: Запрашивает количество циклов и отправляет слова из `words.txt` с случайными задержками.
    - `F5`: Восстанавливает `words.txt` словами из `used_words.txt` и очищает `used_words.txt`.
    - `F12`: Приостанавливает или возобновляет выполнение скрипта.
- **Управление файлами**:
    - Читает слова из `words.txt`.
    - Отслеживает использованные слова в `used_words.txt`.
    - Записывает действия в `log.txt` и ошибки в `errors.log`.
    - Ведет статистику в `stats.txt`.
- **Конфигурация**:
    - Настройки хранятся в `settings.ini`, включая минимальную и максимальную задержки (`MinDelay`, `MaxDelay`) и пути к файлам логов и статистики.
    - Автоматически создает `settings.ini` с значениями по умолчанию, если файл отсутствует.
- **Обработка ошибок**:
    - Проверяет вводимые данные и операции с файлами.
    - Записывает ошибки с метками времени в формате UTC.

## Требования

- [AutoHotkey v2.0+](https://www.autohotkey.com/)
- Операционная система Windows

## Установка

1. Скачайте и установите [AutoHotkey v2.0+](https://www.autohotkey.com/).
2. Клонируйте или скачайте этот репозиторий.
3. Убедитесь, что следующие файлы находятся в той же директории, что и скрипт:
    - `words.txt`: Текстовый файл с одним словом на строку.
    - (Необязательно) `settings.ini`: Файл конфигурации (создается автоматически, если отсутствует).

## Использование

1. Создайте файл `words.txt` с одним словом на строку.
2. Запустите скрипт (`script.ahk`) с помощью AutoHotkey.
3. Используйте следующие горячие клавиши:
    - **F4**: Введите количество слов для отправки. Слова отправляются с случайными задержками между `MinDelay` и `MaxDelay` (из `settings.ini`).
    - **F5**: Восстановите `words.txt` словами из `used_words.txt` и очистите `used_words.txt`.
    - **F12**: Приостановите или возобновите скрипт.
4. Проверяйте `log.txt`, `errors.log` и `stats.txt` для просмотра логов и статистики.

## Конфигурация

Скрипт использует `settings.ini` для конфигурации. Если файл отсутствует, он создается с настройками по умолчанию:

```ini
[Delays]
MinDelay=1000
MaxDelay=1500
[Settings]
LogFile=log.txt
ErrorLogFile=errors.log
StatsFile=stats.txt
```

- `MinDelay`, `MaxDelay`: Диапазон случайных задержек (в миллисекундах) между отправкой слов.
- `LogFile`, `ErrorLogFile`, `StatsFile`: Пути к файлам логов и статистики.

## Структура файлов

- `script.ahk`: Основной скрипт AutoHotkey
- `words.txt`: Входной файл со словами (по одному на строку)
- `used_words.txt`: Отслеживает использованные слова (создается автоматически)
- `settings.ini`: Файл конфигурации (создается автоматически, если отсутствует)
- `log.txt`: Логирует действия с метками времени
- `errors.log`: Логирует ошибки с метками времени
- `stats.txt`: Записывает статистику (например, количество отправленных слов, общее время)

## Примечания

- Убедитесь, что `words.txt` существует и содержит слова перед запуском.
- Скрипт проверяет вводимые данные и имена файлов для предотвращения ошибок.
- Логи и статистика используют метки времени в формате UTC.
- Если `words.txt` пуст или все слова использованы, скрипт уведомляет пользователя и создает пустой `words.txt`.

## Вклад

Присылайте сообщения об ошибках или запросы на включение изменений для улучшения скрипта. Убедитесь, что изменения совместимы с AutoHotkey v2.0+.

## Лицензия

Этот проект распространяется под лицензией MIT. Подробности см. в файле LICENSE.

Submit issues or pull requests to improve the script. Ensure changes are compatible with AutoHotkey v2.0+.

## License

This project is licensed under the MIT License. See the LICENSE file for details.
