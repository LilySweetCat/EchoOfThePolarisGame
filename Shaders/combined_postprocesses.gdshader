shader_type canvas_item;

// Виньетка
uniform float vignette_intensity = 0.7;
uniform float vignette_smoothness = -0.5;
uniform vec4 vignette_color : source_color = vec4(0, 0, 0, 1);

// CRT
uniform sampler2D pixel_texture : hint_default_white;
uniform vec2 screen_size = vec2(128, 128);
uniform float crt_intensity : hint_range(0.0, 1.0) = 1.0; // Новая настройка силы CRT

// Сканирующие линии
uniform vec4 scanline_color: source_color = vec4(1.0, 1.0, 1.0, 0.5);
uniform float scanline_spacing: hint_range(2.0, 20.0) = 4.0;
uniform float scanline_width: hint_range(0.1, 1.0) = 0.5;
uniform float edge_softness: hint_range(0.0, 1.0) = 0.25;

// Рыбий глаз
uniform float fish_intensity : hint_range(0.0, 2.0) = 1.0;

// Пикселизация
uniform int pixel_size = 4;

// Включение эффектов
uniform bool enable_vignette = true;
uniform bool enable_crt = true;
uniform bool enable_scanlines = true;
uniform bool enable_fisheye = true;
uniform bool enable_pixelation = true;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
    vec2 uv = UV;
    vec2 screen_uv = SCREEN_UV;
    vec4 color;
    
    // 1. Пикселизация (теперь применяется после рыбьего глаза, если он включен)
    if (enable_pixelation && !enable_fisheye) {
        vec2 pixel_scale = vec2(textureSize(SCREEN_TEXTURE, 0)) / float(pixel_size);
        screen_uv = floor(SCREEN_UV * pixel_scale) / pixel_scale;
    }
    
    // 2. Эффект "рыбий глаз"
    if (enable_fisheye) {
        vec2 iResolution = vec2(textureSize(SCREEN_TEXTURE, 0));
        vec2 fuv = uv;
        fuv.y = 1.0 - fuv.y;
        
        float aspectRatio = iResolution.x / iResolution.y;
        float strength = fish_intensity * 0.03;
        vec2 intensity = vec2(strength * aspectRatio, strength * aspectRatio);
        
        vec2 coords = fuv;
        coords = (coords - 0.5) * 2.0;
        
        vec2 realCoordOffs;
        realCoordOffs.x = (1.0 - coords.y * coords.y) * intensity.y * coords.x;
        realCoordOffs.y = (1.0 - coords.x * coords.x) * intensity.x * coords.y;
        
        fuv = fuv - realCoordOffs;
        fuv.y = 1.0 - fuv.y;
        
        if (fuv.x >= 0.0 && fuv.x <= 1.0 && fuv.y >= 0.0 && fuv.y <= 1.0) {
            // Применяем пикселизацию после рыбьего глаза, если нужно
            if (enable_pixelation) {
                vec2 pixel_scale = vec2(textureSize(SCREEN_TEXTURE, 0)) / float(pixel_size);
                fuv = floor(fuv * pixel_scale) / pixel_scale;
            }
            color = texture(SCREEN_TEXTURE, fuv);
            color.rgb = mix(color.rgb, color.bgr, length(fuv - 0.5));
        } else {
            color = vec4(0.0);
            vec4 border_color = texture(SCREEN_TEXTURE, fuv);
            color.rgb = mix(border_color.rgb, border_color.bgr, length(fuv - 0.5));
        }
    } else {
        color = texture(SCREEN_TEXTURE, screen_uv);
    }
    
    // 3. CRT эффект
    if (enable_crt && crt_intensity > 0.0) {
        vec2 crt_uv = uv * screen_size;
        crt_uv -= floor(crt_uv);
        vec4 crt_overlay = texture(pixel_texture, crt_uv);
        // Применяем интенсивность CRT
        color.rgb = mix(
            color.rgb,
            crt_overlay.rgb * color.rgb * color.a,
            crt_intensity
        );
    }
    
    // 4. Сканирующие линии
    if (enable_scanlines) {
        vec2 scan_uv = FRAGCOORD.xy;
        float line_pos = fract(scan_uv.y / scanline_spacing);
        float scanline = smoothstep(
            scanline_width + edge_softness,
            scanline_width - edge_softness,
            abs(line_pos - 0.5) * 2.0
        );
        color.rgb = mix(color.rgb, scanline_color.rgb, scanline * scanline_color.a);
    }
    
    // 5. Виньетка
    if (enable_vignette) {
        vec2 vignette_uv = SCREEN_UV * 2.0 - 1.0;
        float dist = length(vignette_uv);
        float vignette = smoothstep(vignette_intensity, vignette_intensity - vignette_smoothness, dist);
        color = mix(color, vignette_color, vignette);
    }
    
    COLOR = color;
}