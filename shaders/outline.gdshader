shader_type spatial;
render_mode unshaded;

uniform float outline_size_px = 5.0;
uniform float edge_threshold = 0.1;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform sampler2D DEPTH_TEXTURE : hint_depth_texture, filter_linear_mipmap;

vec3 rgb2hsv(vec3 rgb) { float r = rgb.r; float g = rgb.g; float b = rgb.b; float max_val = max(r, max(g, b)); float min_val = min(r, min(g, b)); float delta = max_val - min_val; float h = 0.0; float s = 0.0; float v = max_val; if (delta > 0.0001) { s = delta / max_val; if (abs(r - max_val) < 0.0001) h = (g - b) / delta; else if (abs(g - max_val) < 0.0001) h = 2.0 + (b - r) / delta; else h = 4.0 + (r - g) / delta; h *= 60.0; if (h < 0.0) h += 360.0; } return vec3(h, s, v); } // Convert HSV color to RGB color space // Input: vec3 with h in [0, 360], s and v in [0, 1] // Output: vec3 with components in range [0, 1] 
vec3 hsv2rgb(vec3 hsv) { float h = hsv.x; float s = hsv.y; float v = hsv.z; float c = v * s; float x = c * (1.0 - abs(mod(h / 60.0, 2.0) - 1.0)); float m = v - c; vec3 rgb; if (h < 60.0) rgb = vec3(c, x, 0.0); else if (h < 120.0) rgb = vec3(x, c, 0.0); else if (h < 180.0) rgb = vec3(0.0, c, x); else if (h < 240.0) rgb = vec3(0.0, x, c); else if (h < 300.0) rgb = vec3(x, 0.0, c); else rgb = vec3(c, 0.0, x); rgb += m; return rgb; }

float luminance(vec3 c) {
    return dot(c, vec3(0.299, 0.587, 0.114));
}

bool is_already_outlined(vec3 c) {
    vec3 hsv = rgb2hsv(c);
    return hsv.y > 0.6; // heuristic: boosted saturation = post-processed region
}

void fragment() {
    vec2 screen_uv = SCREEN_UV;

    // Get screen pixel size
    vec2 pixel_size = 1.0 / VIEWPORT_SIZE;

    vec3 base_color = texture(SCREEN_TEXTURE, screen_uv).rgb;
    float base_depth = texture(DEPTH_TEXTURE, screen_uv).r;

    float max_diff = 0.0;
    vec3 closest_color = base_color;
    float closest_depth = base_depth;

    for (int x = -5; x <= 5; x++) {
        for (int y = -5; y <= 5; y++) {

            vec2 offset = vec2(float(x), float(y)) * pixel_size;

            if (length(vec2(float(x), float(y))) > outline_size_px) {
                continue;
            }

            vec2 sample_uv = screen_uv + offset;

            vec3 sample_color = texture(SCREEN_TEXTURE, sample_uv).rgb;
            float sample_depth = texture(DEPTH_TEXTURE, sample_uv).r;

            

            if (!is_already_outlined(sample_color)) {
                continue;
            }

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