#pragma header

uniform float radius;
uniform float strength;

void main()
{
    vec2 uv = openfl_TextureCoordv;

    vec2 center = vec2(0.5, 0.5);
    vec2 delta = uv - center;

    float aspect = openfl_TextureSize.x / openfl_TextureSize.y;

    delta.x *= aspect;

    float dist = length(delta);

    vec2 direction = delta / max(dist, 0.0001);
    direction.x /= aspect;

    float width = 0.12;

    float wave = exp(
        -pow((dist - radius) / width, 2.0)
    );

    wave *= strength;

    float amount = clamp(wave, 0.0, 1.0);

    float offset = 0.065 * amount;

    vec2 rUV = clamp(uv - direction * offset, 0.0, 1.0);
    vec2 gUV = uv;
    vec2 bUV = clamp(uv + direction * offset, 0.0, 1.0);

    vec4 original = flixel_texture2D(bitmap, uv);

    float r = flixel_texture2D(bitmap, rUV).r;
    float g = flixel_texture2D(bitmap, gUV).g;
    float b = flixel_texture2D(bitmap, bUV).b;

    vec3 chromatic = vec3(r, g, b);

    gl_FragColor = vec4(
        mix(original.rgb, chromatic, amount),
        original.a
    );
}