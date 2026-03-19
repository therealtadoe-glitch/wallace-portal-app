@tool
extends Resource
class_name UIStyleTokens
## Lightweight design tokens for consistent spacing/rounding/colors across components.
##
## Assign a UIStyleTokens resource to components that expose `tokens`.
## Make multiple token sets (Desktop, Mobile, Dark, Light) as needed.

@export_group("Spacing")
@export var space_xs: float = 4
@export var space_s: float = 8
@export var space_m: float = 12
@export var space_l: float = 16
@export var space_xl: float = 24

@export_group("Corners")
@export var radius_s: int = 6
@export var radius_m: int = 10
@export var radius_l: int = 14

@export_group("Colors")
@export var overlay_dim: Color = Color(0, 0, 0, 0.45)
@export var surface: Color = Color(0.12, 0.12, 0.12, 1.0)
@export var surface_2: Color = Color(0.16, 0.16, 0.16, 1.0)
@export var text_muted: Color = Color(1, 1, 1, 0.75)
@export var accent: Color = Color(0.3, 0.6, 1.0, 1.0)

@export_group("Typography")
@export var title_size: int = 20
@export var subtitle_size: int = 18
@export var body_size: int = 14
