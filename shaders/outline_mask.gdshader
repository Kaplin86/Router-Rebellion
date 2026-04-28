shader_type spatial;
render_mode unshaded;

uniform sampler2D DEPTH_TEXTURE : hint_depth_texture;

void fragment() {
    vec2 screen_uv = SCREEN_UV;

    // Get screen pixel size
    vec2 pixel_size = 1.0 / VIEWPORT_SIZE;

    float base_depth = texture(DEPTH_TEXTURE, screen_uv).r;

    float max_diff = 0.0;
    float closest_depth = base_depth;

    for (int x = -5; x <= 5; x++) {
        for (int y = -5; y <= 5; y++) {

            vec2 offset = vec2(float(x), float(y)) * pixel_size;

            

            vec2 sample_uv = screen_uv + offset;

            float sample_depth = texture(DEPTH_TEXTURE, sample_uv).r;


            float diff = length(sample_color - base_color);
            max_diff = max(max_diff, diff);
			
        }
    }

    // Edge detection
    if (max_diff > edge_threshold) {
		vec3 hsv = rgb2hsv(base_color);
		hsv = hsv + vec3(0.0,0.25,-0.1);
        ALBEDO = hsv2rgb(hsv);
    } else {
        ALBEDO = base_color;
    }
	
	
}