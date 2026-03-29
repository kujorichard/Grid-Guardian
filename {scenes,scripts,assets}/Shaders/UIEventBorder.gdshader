shader_type canvas_item;
render_mode unshaded;

uniform vec4 border_color : source_color = vec4(1.0, 0.8, 0.3, 0.8);
uniform float border_width : hint_range(0.002, 0.05) = 0.012;
uniform float pulse_speed : hint_range(0.0, 2.0) = 0.9;
uniform float pulse_strength : hint_range(0.0, 1.0) = 0.35;

void fragment() {
	vec2 uv = UV;
	float edge = min(min(uv.x, 1.0 - uv.x), min(uv.y, 1.0 - uv.y));
	float border = step(edge, border_width);
	float pulse = 0.65 + 0.35 * sin(TIME * pulse_speed * 6.28318);
	float alpha = border_color.a * mix(1.0, pulse, pulse_strength) * border;
	COLOR = vec4(border_color.rgb, alpha);
}
