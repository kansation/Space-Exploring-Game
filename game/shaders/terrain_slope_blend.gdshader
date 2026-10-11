shader_type spatial;
render_mode cull_disabled;

uniform sampler2D soil_texture : source_color;
uniform sampler2D rock_texture : source_color;
uniform float texture_scale = 0.08;
uniform float rock_slope_start = 0.015;
uniform float rock_slope_end = 0.08;
varying vec3 world_normal;
varying vec3 world_position;

vec3 triplanar_sample(sampler2D texture_map, vec3 position, vec3 blend) {
	vec3 x_sample = texture(texture_map, position.yz * texture_scale).rgb;
	vec3 y_sample = texture(texture_map, position.xz * texture_scale).rgb;
	vec3 z_sample = texture(texture_map, position.xy * texture_scale).rgb;
	return x_sample * blend.x + y_sample * blend.y + z_sample * blend.z;
}

void vertex() {
	world_normal = normalize((MODEL_MATRIX * vec4(NORMAL, 0.0)).xyz);
	world_position = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
	vec3 blend = pow(abs(normalize(world_normal)), vec3(4.0));
	blend /= max(blend.x + blend.y + blend.z, 0.0001);
	vec3 soil = triplanar_sample(soil_texture, world_position, blend);
	vec3 rock = triplanar_sample(rock_texture, world_position, blend);
	float slope = 1.0 - clamp(dot(normalize(world_normal), vec3(0.0, 1.0, 0.0)), 0.0, 1.0);
	float rock_amount = smoothstep(rock_slope_start, rock_slope_end, slope);
	ALBEDO = mix(soil, rock, rock_amount);
	ROUGHNESS = 0.92;
}
