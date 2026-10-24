#pragma header

uniform float amount;

vec2 PincushionDistortion(vec2 uv, float strength)
{
    vec2 st = uv - 0.5;
    float uvA = atan(st.x, st.y);
    float uvD = dot(st, st);

    return 0.5 + vec2(sin(uvA), cos(uvA)) *
        sqrt(uvD) *
        (1.0 - strength * uvD);
}

void main()
{
    vec2 uv = openfl_TextureCoordv;
    vec4 baseColor = flixel_texture2D(bitmap, uv);

    float r = flixel_texture2D(
        bitmap,
        PincushionDistortion(uv, 0.3 * amount)
    ).r;

    float g = flixel_texture2D(
        bitmap,
        PincushionDistortion(uv, 0.15 * amount)
    ).g;

    float b = flixel_texture2D(
        bitmap,
        PincushionDistortion(uv, 0.075 * amount)
    ).b;

    gl_FragColor = vec4(r, g, b, baseColor.a);
}