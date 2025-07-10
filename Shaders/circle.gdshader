shader_type canvas_item;

// Параметры контура
uniform vec4 outline_color : source_color = vec4(1.0, 0.0, 0.0, 1.0); // Красный контур
uniform float outline_width : hint_range(0, 0.2) = 0.05;
uniform float outline_smoothness : hint_range(0, 0.1) = 0.02;

// Параметры внутреннего круга
uniform vec4 fill_color : source_color = vec4(0.0, 0.5, 1.0, 1.0); // Голубой заполнение
uniform float fill_amount : hint_range(0, 1) = 0.0;
uniform float fill_smoothness : hint_range(0, 0.1) = 0.02;

// Общие параметры
uniform vec2 center = vec2(0.5, 0.5);
uniform float radius : hint_range(0, 0.5) = 0.4;
uniform float opacity : hint_range(0, 1) = 1.0;

void fragment() {
    // Нормализованное расстояние от центра
    float dist = distance(UV, center) / radius;
    
    // 1. Контур (с плавными краями)
    float outline = smoothstep(1.0 - outline_width - outline_smoothness, 
                             1.0 - outline_width, dist) - 
                   smoothstep(1.0 - outline_width, 
                             1.0 - outline_width + outline_smoothness, dist);
    
    // 2. Внутренний круг
    float fill = 1.0 - smoothstep(fill_amount - fill_smoothness,
                                 fill_amount + fill_smoothness,
                                 dist);
    
    // 3. Комбинируем с учетом приоритета заполнения
    float alpha = clamp(outline + fill, 0.0, 1.0);
    
    // 4. Смешиваем цвета (если есть и контур и заполнение - приоритет у заполнения)
    vec3 final_color = mix(outline_color.rgb, fill_color.rgb, fill);
    
    // 5. Применяем прозрачность
    COLOR = vec4(final_color, alpha * opacity);
}