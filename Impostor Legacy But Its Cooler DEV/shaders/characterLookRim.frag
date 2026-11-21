#pragma header

uniform sampler2D lutRim;

uniform vec4 uMatrixRow0;
uniform vec4 uMatrixRow1;
uniform vec4 uMatrixRow2;
uniform vec4 uMatrixOffset;
uniform float uMatrixStrength;
uniform float uMatrixThreshold;
uniform float uMatrixRoughness;

uniform float uFrameLeft;
uniform float uFrameTop;
uniform float uFrameRight;
uniform float uFrameBottom;

uniform float uStrength;
uniform float uRimGain;
uniform float uRimAmount;
uniform float uRimSpread;
uniform float uRimCurve;
uniform float uGlowCurve;
uniform float uGlowAmount;

vec3 rimCell(vec3 index)
{
    vec2 tile = vec2(mod(index.b, 8.0), floor(index.b / 8.0)) * 64.0;
    vec2 uv = (tile + index.rg + 0.5) / 512.0;
    return texture2D(lutRim, uv).rgb;
}

vec3 applyRimLook(vec3 color)
{
    vec3 scaled = color * 63.0;
    vec3 index = min(floor(scaled), vec3(62.0));
    vec3 blend = scaled - index;

    vec3 c000 = rimCell(index);
    vec3 c100 = rimCell(index + vec3(1.0, 0.0, 0.0));
    vec3 c010 = rimCell(index + vec3(0.0, 1.0, 0.0));
    vec3 c110 = rimCell(index + vec3(1.0, 1.0, 0.0));
    vec3 c001 = rimCell(index + vec3(0.0, 0.0, 1.0));
    vec3 c101 = rimCell(index + vec3(1.0, 0.0, 1.0));
    vec3 c011 = rimCell(index + vec3(0.0, 1.0, 1.0));
    vec3 c111 = rimCell(index + vec3(1.0, 1.0, 1.0));

    vec3 low = mix(mix(c000, c100, blend.r), mix(c010, c110, blend.r), blend.g);
    vec3 high = mix(mix(c001, c101, blend.r), mix(c011, c111, blend.r), blend.g);
    return mix(low, high, blend.b);
}

vec3 applyEDSSMatrix(vec3 color)
{
    vec4 source = vec4(color, 1.0);
    vec3 transformed = clamp(vec3(
        dot(uMatrixRow0, source),
        dot(uMatrixRow1, source),
        dot(uMatrixRow2, source)
    ) + uMatrixOffset.rgb, 0.0, 1.0);

    float intensity = max(max(color.r, color.g), color.b);
    float coverage = 1.0;
    if (uMatrixThreshold > 0.0)
        coverage = clamp((intensity - uMatrixThreshold) * (1.0 - uMatrixThreshold) * 4.0 * uMatrixRoughness, 0.0, 1.0);

    return mix(color, transformed, coverage * uMatrixStrength);
}

float alphaAt(vec2 uv)
{
    if (uv.x < uFrameLeft || uv.y < uFrameTop || uv.x > uFrameRight || uv.y > uFrameBottom)
        return 0.0;

    return texture2D(bitmap, uv).a;
}

float phaseNoise(vec2 p)
{
    vec3 q = fract(vec3(p.xyx) * vec3(0.1031, 0.1030, 0.0973));
    q += dot(q, q.yzx + 33.33);
    return fract((q.x + q.y) * q.z);
}

float edgeDepth(vec2 uv, vec2 pixelSize)
{
    float coverage = 0.0;
    float weightSum = 0.0;
    float angleOffset = phaseNoise(gl_FragCoord.xy) * 6.2831853;

    for (int k = 0; k < 12; k++)
    {
        float sampleIndex = float(k) + 0.5;
        float radius = sampleIndex / 12.0;
        float weight = 1.0 - radius * 0.75;
        float angle = angleOffset + sampleIndex * 2.3999632;
        vec2 direction = vec2(cos(angle), sin(angle));
        vec2 sampleUV = uv + direction * (radius * 12.0 * uRimSpread) * pixelSize;

        coverage += alphaAt(sampleUV) * weight;
        weightSum += weight;
    }

    return clamp(coverage / weightSum, 0.0, 1.0);
}

float rimWeight(float coverage)
{
    float fade = clamp(1.0 - coverage, 0.0, 1.0);
    float rim = pow(fade, uRimCurve) * uRimGain;
    float glow = pow(fade, uGlowCurve) * uGlowAmount * uRimGain;
    return clamp(max(rim, glow), 0.0, 1.0) * uRimAmount;
}

void main()
{
    vec4 color = flixel_texture2D(bitmap, openfl_TextureCoordv);

    if (color.a <= 0.001)
    {
        gl_FragColor = vec4(0.0);
        return;
    }

    vec3 source = clamp(color.rgb / max(color.a, 0.001), 0.0, 1.0);
    vec3 inner = applyEDSSMatrix(source);

    vec2 pixelSize = 1.0 / openfl_TextureSize;
    float coverage = edgeDepth(openfl_TextureCoordv, pixelSize);
    float rim = clamp(rimWeight(coverage) * uStrength, 0.0, 1.0);

    vec3 graded = mix(inner, applyRimLook(source), rim);
    gl_FragColor = vec4(graded * color.a, color.a);
}
