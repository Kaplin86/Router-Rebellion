# Router Rebellion

Router Rebellion is an action RPG where you design and modify your weapon’s behavior using a node-based graph editor.

Made in Godot 4.6.1
Made for Hack Club's [Horizons](https://horizons.hackclub.com/) Event

## Status
Early prototype - core shooting and graph-based bullet customization implemented. Backend structure for Status Effects, Dialogue Cutscenes, and enemies are close to finish.

## Current features
- Customizable bullets with 7 different node types
- Bullet factory layouts save to user file
- Melee enemy AI
- Dialogue Editor (intended for developer)
- Dynamic spawning triggers for enemies
- Inventory and item pickup system

## Keybinds
- WASD / Arrow Keys - Movement
- Mouse - Aim
- Click - Shoot
- Q - Open gun editor

### Navigating the gun editor
This uses the default godot graph node controls:
- Drag the output circle of a node to an input circle to create a connection
- Drag the input circle away to break the connection
- Drag the output circle into open space to create a new node
- Zoom in and out with scroll wheel

## Running the project
1. Clone the repo or download as a ZIP
2. Open Godot 4.6.1
3. Click "Import" and select the `project.godot` file (or zip file if you did that instead)

## AI usage
AI Has been used in this project to:
- Help code shader scripts
- Help code more complex 3D subjects (E.g. making an object move "forward" from direction)
