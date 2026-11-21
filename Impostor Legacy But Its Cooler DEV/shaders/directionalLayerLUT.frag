#pragma header

uniform sampler2D uDirectionalLUT;

uniform vec4 uBaseRow0;
uniform vec4 uBaseRow1;
uniform vec4 uBaseRow2;
uniform vec4 uBaseRow3;
uniform vec4 uBaseOffset;
uniform float uBaseStrength;
uniform float uBaseThreshold;
uniform float uBaseRoughness;

uniform float uAngle;
uniform float uFrameAngle;
uniform float uLayerDistance;
uniform float uLayerThreshold;
uniform float uLayerStrength;
uniform float uLayerRoughness;
uniform vec2 uScale;
uniform vec4 uFrameBounds;

vec3 lutCell(vec3 index)
{
    vec2 tile = vec2(mod(index.b, 8.0), floor(index.b / 8.0)) * 64.0;
    vec2 coord = (tile + index.rg + 0.5) / 512.0;
    return texture2D(uDirectionalLUT, coord).rgb;
}

vec3 sampleDirectionalLUT(vec3 color)
{
    vec3 p = clamp(color, 0.0, 1.0) * 63.0;
    vec3 i = min(floor(p), vec3(62.0));
    vec3 f = p - i;

    vec3 c000 = lutCell(i);
    vec3 c100 = lutCell(i + vec3(1.0, 0.0, 0.0));
    vec3 c010 = lutCell(i + vec3(0.0, 1.0, 0.0));
    vec3 c110 = lutCell(i + vec3(1.0, 1.0, 0.0));
    vec3 c001 = lutCell(i + vec3(0.0, 0.0, 1.0));
    vec3 c101 = lutCell(i + vec3(1.0, 0.0, 1.0));
    vec3 c011 = lutCell(i + vec3(0.0, 1.0, 1.0));
    vec3 c111 = lutCell(i + vec3(1.0, 1.0, 1.0));

    vec3 low = mix(mix(c000, c100, f.r), mix(c010, c110, f.r), f.g);
    vec3 high = mix(mix(c001, c101, f.r), mix(c011, c111, f.r), f.g);
    return mix(low, high, f.b);
}

float edssBaseCutoff(vec4 color, float threshold, float roughness)
{
    float intensity = max(max(color.r, color.g), color.b);
    if (threshold <= 0.0)
        return 1.0;
    return clamp((intensity - threshold) * (1.0 - threshold) * 4.0 * roughness, 0.0, 1.0);
}

vec4 applyBaseMatrix(vec4 color)
{
    vec4 transformed = vec4(
        dot(uBaseRow0, color),
        dot(uBaseRow1, color),
        dot(uBaseRow2, color),
        dot(uBaseRow3, color)
    ) + uBaseOffset;
    transformed = clamp(transformed, 0.0, 1.0);
    float coverage = edssBaseCutoff(color, uBaseThreshold, uBaseRoughness * 4.0) * uBaseStrength;
    return mix(color, transformed, clamp(coverage, 0.0, 1.0));
}

float alphaAt(vec2 uv)
{
    // Keep samples inside the current atlas frame, as EDSS does.
    if (uv.x < uFrameBounds.x || uv.y < uFrameBounds.y ||
        uv.x >= uFrameBounds.z || uv.y >= uFrameBounds.w)
        return 0.0;

    return texture2D(bitmap, uv).a;
}

float directionalLayerFade(vec2 uv)
{
    float angle = radians(uAngle) + uFrameAngle;
    vec2 pixelOffset = vec2(
        cos(angle) / max(abs(uScale.x), 0.0001) / openfl_TextureSize.x,
        -sin(angle) / max(abs(uScale.y), 0.0001) / openfl_TextureSize.y
    ) * uLayerDistance;

    // Five samples along ONE ray. This only marks the silhouette facing
    // uAngle; it never scans around the full character.
    // Averaging transparent coverage creates a soft inward fade.
    float outside = 0.0;

    float a1 = alphaAt(uv + pixelOffset * 0.20);
    float a2 = alphaAt(uv + pixelOffset * 0.40);
    float a3 = alphaAt(uv + pixelOffset * 0.60);
    float a4 = alphaAt(uv + pixelOffset * 0.80);
    float a5 = alphaAt(uv + pixelOffset);

    // uLayerThreshold controls only alpha-edge feathering here. It is NOT
    // a brightness/saturation cutoff, so dark and neutral colors still map.
    outside += 1.0 - smoothstep(uLayerThreshold, 1.0, a1);
    outside += 1.0 - smoothstep(uLayerThreshold, 1.0, a2);
    outside += 1.0 - smoothstep(uLayerThreshold, 1.0, a3);
    outside += 1.0 - smoothstep(uLayerThreshold, 1.0, a4);
    outside += 1.0 - smoothstep(uLayerThreshold, 1.0, a5);

    float fade = outside * 0.20;
    fade = pow(clamp(fade, 0.0, 1.0), max(uLayerRoughness, 0.25));
    return clamp(fade * uLayerStrength, 0.0, 1.0);
}

void main()
{
    vec4 sampled = flixel_texture2D(bitmap, openfl_TextureCoordv);
    if (sampled.a <= 0.001)
    {
        gl_FragColor = vec4(0.0);
        return;
    }

    vec4 source = sampled;
    source.rgb /= max(source.a, 0.001);

    if (openfl_HasColorTransform || hasColorTransform)
        source = clamp(source * vec4(openfl_ColorMultiplierv.rgb, 1.0) + openfl_ColorOffsetv, 0.0, 1.0);

    // Keep the original EDSS base matrix, threshold and strength intact.
    vec4 baseColor = applyBaseMatrix(source);

    // The LUT receives the original (pre-base-matrix) color, matching the
    // EDSS REPLACE operation. The base matrix remains underneath it.
    // Only the directional alpha mask controls where this LUT is visible.
    vec3 lutColor = sampleDirectionalLUT(source.rgb);
    float layerFade = directionalLayerFade(openfl_TextureCoordv);
    vec3 result = mix(baseColor.rgb, lutColor, layerFade);

    gl_FragColor = vec4(result * baseColor.a, baseColor.a);
    if (hasTransform)
        gl_FragColor *= openfl_Alphav;
}
