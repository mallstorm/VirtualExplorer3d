# Сборка проекта

## Локально

1. Установить Godot 4.x.
2. Открыть папку проекта.
3. Запустить `scenes/Main.tscn`.
4. Для экспорта использовать `export_presets.cfg`.

## GitHub Actions

Workflow находится в `.github/workflows/build.yml`.

После push в `main` он выполняет:

- импорт Godot-проекта;
- экспорт Windows Desktop;
- экспорт Android Debug APK;
- публикацию artifacts.

Android release signing в этот проход не включён. Для релизной публикации нужны keystore secrets.

