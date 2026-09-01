# Architecture

Virtual Explorer combines three scene types:

- Type A: full 3D scenes with collision, player movement, lights and interactable objects.
- Type B: 360 panorama scenes rendered on an inside-facing sphere.
- Type C: hybrid scenes where 3D geometry provides walls/floor/collision and panorama/depth data fills distant or detailed areas.

## Runtime layers

```text
Core
  SceneManager
  SaveManager
  AssetLoader
  InputManager
  ProjectImporter

Player
  PlayerController
  Camera
  Interaction Raycast

Renderer
  PanoramaRenderer
  DepthRenderer
  LightingSystem
  VR
  Photogrammetry

UI
  HUD
  MainMenu

Projects
  Chernobyl
```

## Data flow

`project.json` describes scenes, portals, objects, audio and panorama assets. `SceneManager` loads this metadata, player movement happens inside 3D scenes, and portals switch either to another `.tscn` or to the panorama viewer.

## Asset policy

Large real-world assets are intentionally not embedded in the core repository. Each project owns its own panoramas, models, sounds, textures and information files.
