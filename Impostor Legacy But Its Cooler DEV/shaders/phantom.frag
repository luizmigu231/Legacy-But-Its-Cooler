#pragma header

uniform float time;
uniform float strength;
uniform float alpha;
uniform float speed;
uniform float ghostOffset;
uniform float distortion;
uniform float rgbShift;

float hash(vec2 p)
{
    p = fract(p * vec2(123.34, 456.21));
    p += dot(p, p + 45.32);
    return fract(p.x * p.y);
}

void main()
{
    vec2 uv = openfl_TextureCoordv;
    vec2 texel = 1.0 / openfl_TextureSize;

    float t = time * speed;

    vec2 centered = uv - 0.5;

    float wave1 = sin(
        uv.y * 28.0 +
        t * 2.0 +
        sin(uv.x * 12.0 + t)
    );

    float wave2 = sin(
        uv.x * 20.0 -
        t * 1.7 +
        uv.y * 15.0
    );

    vec2 distortionOffset;

    distortionOffset.x =
        wave1 * distortion * 0.004 * strength;

    distortionOffset.y =
        wave2 * distortion * 0.002 * strength;

    vec2 distortedUV = uv + distortionOffset;

    vec4 mainColor =
        flixel_texture2D(bitmap, distortedUV);

    float offset =
        ghostOffset *
        strength *
        (0.7 + sin(t * 2.0) * 0.3);

    vec2 ghostDirection = normalize(
        centered + vec2(0.0001)
    );

    vec2 ghostUV =
        distortedUV +
        ghostDirection * offset;

    vec4 ghostColor =
        flixel_texture2D(bitmap, ghostUV);

    vec2 rgbOffset =
        vec2(rgbShift * texel.x * strength, 0.0);

    float red =
        flixel_texture2D(
            bitmap,
            distortedUV + rgbOffset
        ).r;

    float blue =
        flixel_texture2D(
            bitmap,
            distortedUV - rgbOffset
        ).b;

    vec3 rgbColor = vec3(
        red,
        mainColor.g,
        blue
    );

    float edge =
        length(
            vec2(
                dFdx(mainColor.a),
                dFdy(mainColor.a)
            )
        );

    edge = smoothstep(
        0.0,
        0.25,
        edge
    );

    float pulse =
        0.82 +
        sin(t * 3.0) * 0.12;

    float ghostAlpha =
        ghostColor.a *
        0.42 *
        strength;

    vec3 finalColor =
        mix(
            rgbColor,
            ghostColor.rgb,
            ghostAlpha
        );

    finalColor =
        mix(
            finalColor,
            finalColor + vec3(0.12, 0.18, 0.22),
            edge * 0.55 * strength
        );

    float finalAlpha =
        max(
            mainColor.a,
            ghostColor.a * 0.65
        );

    finalAlpha *=
        alpha *
        pulse;

    gl_FragColor = vec4(
        finalColor,
        finalAlpha
    );
}