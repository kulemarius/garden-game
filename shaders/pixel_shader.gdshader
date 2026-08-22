shader_type canvas_item;

uniform float pixel_size : hint_range(1.0, 32.0) = 8.0;

uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;

void fragment() {
	vec2 screen_size = 1.0 / SCREEN_PIXEL_SIZE;

	vec2 pixel_uv = floor(SCREEN_UV * screen_size / pixel_size) * pixel_size;
	pixel_uv /= screen_size;

	COLOR = texture(screen_texture, pixel_uv);
}