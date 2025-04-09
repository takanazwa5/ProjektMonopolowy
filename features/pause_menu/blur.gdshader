shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
uniform float lod : hint_range(0.0, 5.0) = 1.5;

void fragment() {
    COLOR = textureLod(screen_texture, SCREEN_UV, lod);
	COLOR.a = 1.0;
}