# Формат внешнего ZIP-проекта

Начиная с версии `1.0-external-content`, приложение **Virtual Explorer** работает как плеер. Экскурсия не должна быть зашита в APK: она устанавливается отдельным ZIP-пакетом.

## Структура ZIP

```text
Chernobyl_Sarcophagus_Experience.zip
  project.json
  panoramas/
    reactor_placeholder_360.jpg
  audio/
  textures/
  models/
```

Минимально обязателен только `project.json`. Остальные папки используются по мере наполнения экскурсии.

## Установка

На Android для текущей версии:

1. Скачать ZIP-пакет экскурсии.
2. Положить файл в `Download`.
3. Открыть Virtual Explorer.
4. Нажать `Импорт ZIP`.
5. Выбрать установленный проект и нажать `Запустить выбранный проект`.

Рабочая папка установки внутри приложения:

```text
user://Explorer/Projects
```

## project.json

Корневой файл описывает экскурсию, сцену, объекты, свет и порталы.

```json
{
  "id": "chernobyl_sarcophagus",
  "name": "Chernobyl Sarcophagus Experience",
  "version": "1.0-content-demo",
  "engine": "Virtual Explorer",
  "package_format": 1,
  "type": "hybrid",
  "start_scene": "reactor_block",
  "panoramas": [],
  "tour_scene": {}
}
```

## tour_scene

`tour_scene` — процедурное описание 3D-пространства. Движок строит сцену из данных, поэтому ZIP не обязан содержать `.tscn` и GDScript.

Основные блоки:

- `spawn` — стартовая позиция игрока.
- `environment` — фон и ambient-свет.
- `zones` — зоны маршрута, пол, название текущей зоны и цель HUD.
- `boxes` — физическая геометрия с коллизиями.
- `visual_boxes` — декоративная геометрия без коллизий.
- `labels` — 3D-таблички.
- `interactables` — объекты с описанием.
- `portals` — переходы в 360-панорамы.
- `lights` — источники света.

## Пути к ассетам

Относительные пути считаются относительно папки распакованного проекта.

Пример:

```json
{
  "panorama": "panoramas/reactor_placeholder_360.jpg"
}
```

После установки это будет прочитано как:

```text
user://Explorer/Projects/Chernobyl_Sarcophagus_Experience/panoramas/reactor_placeholder_360.jpg
```

## Зона маршрута

`objective` используется в HUD как текущая цель движения.

```json
{
  "id": "reactor_block",
  "name": "Реакторный блок",
  "objective": "Цель: найти пультовую и 360-портал",
  "position": [0, 0, -4.6],
  "size": [12, 0.22, 9.2],
  "material": "floor"
}
```

## Интерактивный объект

```json
{
  "id": "reactor_panel",
  "name": "Пульт управления",
  "description": "Пультовая зона реакторного блока.",
  "position": [-10.5, 1.05, -2.1],
  "size": [2.1, 0.8, 0.45],
  "material": "blue"
}
```

## Портал в 360

```json
{
  "name": "PanoramaPortal",
  "position": [3.7, 0.1, -7.1],
  "panorama": "panoramas/reactor_placeholder_360.jpg",
  "material": "blue",
  "radius": 0.9,
  "trigger_radius": 1.0
}
```

## Материалы

В текущей версии доступны встроенные имена материалов:

- `floor`
- `wall`
- `dark`
- `metal`
- `rust`
- `pipe`
- `hazard`
- `blue`
- `sign`
- `white`
- `red`
- `stain`
- `dust`
- `exit`
