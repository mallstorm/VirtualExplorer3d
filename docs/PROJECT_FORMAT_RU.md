# Формат проекта экскурсии

Каждая экскурсия описывается файлом `project.json`.

Минимальная структура:

```json
{
  "id": "chernobyl",
  "name": "Chernobyl Sarcophagus Experience",
  "version": "0.3",
  "type": "hybrid",
  "start_scene": "reactor_block",
  "scenes": []
}
```

Типы сцен:

- `3d` - полноценная 3D-сцена.
- `360` - панорама.
- `hybrid` - 3D + 360/Depth/AI reconstruction.

Объекты:

```json
{
  "id": "reactor_panel",
  "name": "Пульт управления",
  "description": "Пульт управления реактором РБМК",
  "audio": "res://Projects/Chernobyl/audio/reactor_panel.wav",
  "interaction": "info"
}
```

Порталы:

```json
{
  "id": "reactor_360_portal",
  "position": [3.2, 0.06, -5.6],
  "target": "reactor_360"
}
```
