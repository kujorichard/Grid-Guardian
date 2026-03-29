shader_type canvas_item;
render_mode unshaded;

uniform vec4 color_top : source_color = vec4(0.08, 0.1, 0.12, 1.0);
uniform vec4 color_bottom : source_color = vec4(0.02, 0.04, 0.06, 1.0);
uniform float alpha : hint_range(0.0, 0.3) = 0.08;
uniform float speed : hint_range(0.0, 1.0) = 0.08;
uniform float drift : hint_range(0.0, 0.1) = 0.03;

void fragment() {
	vec2 uv = UV;
	float wave = sin((uv.x * 2.0 + TIME * speed) * 3.14159);
	float t = clamp(uv.y + wave * drift, 0.0, 1.0);
	vec4 col = mix(color_top, color_bottom, t);
	col.a *= alpha;
	COLOR = col;
}
