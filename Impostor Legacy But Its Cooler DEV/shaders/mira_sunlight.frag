#pragma header

uniform float intensity;
uniform float sourceX;
uniform float sourceY;

void main()
{
    vec4 tex = flixel_texture2D(bitmap, openfl_TextureCoordv);

    vec2 uv = openfl_TextureCoordv;
    vec2 source = vec2(sourceX, sourceY);

    vec2 d = uv - source;
    float dist = length(d);

    float glow = 1.0 - smoothstep(0.0, 0.95, dist);
    glow = pow(glow, 2.0);

    // Broad golden spill.
    vec3 gold = vec3(1.0, 0.43, 0.08);
    float spill = glow * intensity;

    vec3 result = tex.rgb;
    result += gold * spill * 0.12;

    // Narrower diagonal beams moving away from the glass source.
    float diagonal = uv.x + uv.y;
    float beam1 = 1.0 - smoothstep(0.0, 0.055, abs(diagonal - (sourceX + sourceY + 0.28)));
    float beam2 = 1.0 - smoothstep(0.0, 0.045, abs(diagonal - (sourceX + sourceY + 0.53)));

    float beams = (beam1 * 0.45 + beam2 * 0.25) * intensity;
    result += gold * beams * 0.07;

    gl_FragColor = vec4(result, tex.a);
}
