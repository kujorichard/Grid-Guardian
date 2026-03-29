shader_type canvas_item;
render_mode unshaded;

uniform sampler2D screen_texture : hint_screen_texture;

uniform float scanline_opacity : hint_range(0.0, 1.0) = 0.2;
uniform float scanline_density : hint_range(200.0, 1200.0) = 600.0;
uniform float vignette_strength : hint_range(0.0, 1.0) = 0.3;
uniform float curvature : hint_range(0.0, 0.2) = 0.03;
uniform float chroma_shift : hint_range(0.0, 2.0) = 0.6;

void fragment() {
	vec2 uv = SCREEN_UV;
	vec2 centered = uv * 2.0 - 1.0;
	float dist2 = dot(centered, centered);
	vec2 warped_uv = uv + centered * dist2 * curvature;

	vec2 pixel = SCREEN_PIXEL_SIZE;
	vec2 shift = vec2(chroma_shift * pixel.x, 0.0);

	vec4 col;
	col.r = texture(screen_texture, warped_uv + shift).r;
	col.g = texture(screen_texture, warped_uv).g;
	col.b = texture(screen_texture, warped_uv - shift).b;
	col.a = 1.0;

	float scan = 0.5 + 0.5 * sin(warped_uv.y * scanline_density * 3.14159);
	float scan_mix = mix(1.0, scan, scanline_opacity);

	float vig = smoothstep(0.6, 1.0, length(centered));
	float vig_mix = mix(1.0, 1.0 - vignette_strength, vig);

	col.rgb *= scan_mix * vig_mix;
	COLOR = col;
}
