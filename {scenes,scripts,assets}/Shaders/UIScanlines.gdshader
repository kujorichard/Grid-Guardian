shader_type canvas_item;
render_mode unshaded;

uniform vec4 line_color : source_color = vec4(0.9, 0.95, 1.0, 1.0);
uniform float opacity : hint_range(0.0, 0.2) = 0.025;
uniform float line_density : hint_range(200.0, 1200.0) = 700.0;
uniform float scroll_speed : hint_range(0.0, 0.2) = 0.02;
uniform float softness : hint_range(0.0, 1.0) = 0.6;

float _hash(vec2 p) {
	return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

void fragment() {
	vec2 uv = UV;
	float wave = 0.5 + 0.5 * sin((uv.y + TIME * scroll_speed) * line_density * 3.14159);
	float line = smoothstep(0.5 - softness * 0.25, 0.5 + softness * 0.25, wave);
	float noise = _hash(uv * 800.0 + TIME) * 0.1;
	float a = opacity * (1.0 - line + noise);
	COLOR = vec4(line_color.rgb, clamp(a, 0.0, opacity));
}
