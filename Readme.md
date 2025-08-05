# ⚽ BALL KICK GAME – My First Third-Person Game – Godot Engine

A simple and flexible third-person character controller built with **Godot Engine 4.x**.  
Includes smooth movement, camera control, and a ball kicking mechanic — ideal for 3D game prototypes.

---
## 🎥 Demo Video

<video width="640" height="360" controls autoplay muted loop>
  <source src="main-video.mp4" type="video/mp4">
  Your browser does not support the video tag.
</video>

A demo video showcasing the gameplay and mechanics.

---
## 🌟 Features

- Character movement using `W`, `A`, `S`, `D` keys  
- Mouse-controlled third-person follow camera  
- Smooth rotation using `lerp_angle`  
- Compatible with Kenney 3D assets  
- Modular project structure  
- Ball kicking mechanic:  
  - Collision detection with `get_overlapping_bodies()`  
  - Direction calculation using angle and vector math  
  - Physical impulse applied with `apply_central_impulse()`

---

## 🖥 UI Implementation & Gameplay

- Designed a simple UI for the game, including the Game Over menu.  
- The game is time-limited; players try to achieve the highest score before time runs out.  
- Each ball can be hit only once to increase the score.  
- After a few seconds post-hit, the ball disappears.

---



## 🛠 Getting Started

1. Open the project with Godot Engine 4.x  
2. Run the `Main.tscn` scene  
3. Move the character with `W`, `A`, `S`, `D` keys and control the camera with the mouse

---

## 👤 Author

Developed by [Emrullah Enis Çetinkaya](https://github.com/emrullah-enis-ctnky)
