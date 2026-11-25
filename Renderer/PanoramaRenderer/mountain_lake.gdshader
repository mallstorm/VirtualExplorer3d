shader_type spatial;
render_mode unshaded, cull_front, fog_disabled;

varying vec3 sphere_position;

void vertex() {
	sphere_position = VERTEX;
}

float hash21(vec2 p) {
	return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

float ridgeline(float a) {
	return 0.15 + 0.067 * cos(a * 3.0 + 0.8) + 0.040 * cos(a * 7.0 - 0.2)
		+ 0.022 * cos(a * 13.0) + 0.011 * cos(a * 29.0 + 0.7)
		+ 0.006 * cos(a * 53.0);
}

vec3 landscape(vec3 ray, float a) {
	float h = ray.y;
	vec3 sun_dir = normalize(vec3(-0.50, 0.16, -1.0));
	float sun_angle = length(ray - sun_dir);
	vec3 sky = mix(vec3(0.98, 0.36, 0.17), vec3(0.035, 0.065, 0.23), smoothstep(-0.05, 0.70, h));
	sky += vec3(0.55, 0.27, 0.065) * exp(-5.0 * sun_angle);
	sky = mix(sky, vec3(1.0, 0.90, 0.58), 1.0 - smoothstep(0.026, 0.030, sun_angle));

	vec2 stars = ray.xz * 34.0;
	vec2 cell = floor(stars);
	vec2 point = vec2(hash21(cell), hash21(cell + vec2(3.0, 7.0))) * 0.6 + 0.2;
	float sparkle = 1.0 - smoothstep(0.014, 0.055, length(fract(stars) - point));
	sky += vec3(0.72, 0.78, 1.0) * sparkle * step(0.81, hash21(cell + vec2(13.0, 9.0))) * smoothstep(0.46, 0.80, h);

	float far_peak = ridgeline(a + 0.45) * 0.90 + 0.065;
	sky = mix(sky, vec3(0.27, 0.18, 0.32), 1.0 - smoothstep(-0.002, 0.003, h - far_peak));
	float peak = ridgeline(a);
	vec3 rock = mix(vec3(0.068, 0.079, 0.15), vec3(0.18, 0.14, 0.24), smoothstep(0.0, 0.26, h));
	float snow_line = 0.167 + 0.013 * cos(47.0 * a) + 0.006 * sin(113.0 * a);
	rock = mix(rock, vec3(0.62, 0.39, 0.46), smoothstep(snow_line, snow_line + 0.032, h));
	return mix(sky, rock, 1.0 - smoothstep(-0.002, 0.003, h - peak));
}

float forest(float a, float h, float count, float shift, float base, float max_height) {
	float sector = (a / TAU + 0.5) * count + shift;
	float id = mod(floor(sector), count);
	float center = 0.42 + 0.16 * hash21(vec2(id, shift));
	float tree_height = max_height * mix(0.42, 1.0, hash21(vec2(id, shift + 5.0)));
	float level = clamp((h - base) / tree_height, 0.0, 1.0);
	float width = (1.0 - level) * (0.23 + 0.16 * (1.0 - fract(level * 5.0)));
	float crown = (1.0 - smoothstep(width, width + 0.055, abs(fract(sector) - center)))
		* (1.0 - smoothstep(0.95, 1.0, level));
	return max(crown, 1.0 - smoothstep(base - 0.005, base, h));
}

void fragment() {
	vec3 ray = normalize(sphere_position);
	float a = atan(ray.x, -ray.z + 0.00001);
	float h = ray.y;
	vec3 color = landscape(ray, a);
	if (h < 0.0) {
		float ripple = sin(h * 273.0 + sin(a * 23.0) * 1.2) * 0.007;
		vec3 reflected = normalize(vec3(ray.x, max(0.0, -h + ripple), ray.z));
		color = mix(landscape(reflected, a + ripple), vec3(0.026, 0.10, 0.18), mix(0.28, 0.91, smoothstep(0.0, 0.75, -h)));
		color += vec3(0.023, 0.035, 0.046) * sin(h * 132.0 + a * 7.0) * smoothstep(0.0, 0.08, -h);
	}

	float shore = -0.018 + 0.12 * smoothstep(-0.12, 0.72, -cos(a));
	float distant_trees = forest(a, h, 131.0, 0.0, shore, 0.050 + 0.10 * smoothstep(0.0, 0.85, -cos(a)));
	float near_trees = forest(a, h, 89.0, 0.5, shore - 0.022, 0.034 + 0.13 * smoothstep(0.0, 0.85, -cos(a)));
	color = mix(color, vec3(0.072, 0.097, 0.129), distant_trees);
	color = mix(color, vec3(0.026, 0.049, 0.061), near_trees);

	if (h < -0.001) {
		vec2 floor_pos = ray.xz * (1.55 / -h);
		float along = -floor_pos.y;
		if (abs(floor_pos.x) < 0.94 && along > -2.0 && along < 5.5) {
			float plank = (along + 2.0) * 4.0;
			float gap = smoothstep(0.015, 0.085, fract(plank));
			float grain = sin(floor_pos.x * 29.0 + sin(plank * 11.0) * 2.0) * 0.018;
			float variation = hash21(vec2(floor(plank), 7.0)) * 0.10 + grain;
			vec3 wood = vec3(0.29, 0.14, 0.074) + variation;
			color = mix(vec3(0.070, 0.045, 0.039), wood, gap * (1.0 - 0.28 * smoothstep(0.83, 0.94, abs(floor_pos.x))));
		}
	}
	ALBEDO = color;
}
