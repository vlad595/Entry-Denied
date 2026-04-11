shader_type spatial;

uniform vec3 bag_pos;          // Позиція сумки в просторі
uniform float bag_radius = 0.5; // Радіус впливу (ширина сумки)
uniform float push_strength = 1.2;

void vertex() {
    // Отримуємо позицію вершини у світових координатах
    vec3 world_vertex = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;

    // Рахуємо вектор від сумки до вершини
    vec3 diff = world_vertex - bag_pos;
    float dist = length(diff);

    // Якщо вершина близько до сумки — зміщуємо її
    if (dist < bag_radius) {
        // Обчислюємо силу зміщення (чим ближче до центру, тим сильніше)
        float force = (1.0 - (dist / bag_radius)) * push_strength;

        // Зміщуємо тільки по осі Z (або X, залежно від напрямку руху)
        // UV.y дозволяє верхній частині (0.0) лишатися на місці, а нижній (1.0) рухатись
        VERTEX.z += force * UV.y;
    }
}