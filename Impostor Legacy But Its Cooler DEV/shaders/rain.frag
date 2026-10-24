#pragma header

#define screenCoord openfl_TextureCoordv
uniform vec2 uScreenResolution;
uniform vec4 uCameraBounds;

vec2 screenToWorld(vec2 screenCoord)
{
	vec2 scale = vec2(uCameraBounds.z - uCameraBounds.x, uCameraBounds.w - uCameraBounds.y);
	vec2 offset = vec2(uCameraBounds.x, uCameraBounds.y);
	return screenCoord * scale + offset;
}

vec2 worldToScreen(vec2 worldCoord)
{
	vec2 scale = vec2(uCameraBounds.z - uCameraBounds.x, uCameraBounds.w - uCameraBounds.y);
	vec2 offset = vec2(uCameraBounds.x, uCameraBounds.y);
	return (worldCoord - offset) / scale;
}

vec2 bitmapCoordScale()
{
	return openfl_TextureCoordv / screenCoord;
}

vec2 screenToBitmap(vec2 screenCoord)
{
	return screenCoord * bitmapCoordScale();
}

vec4 sampleBitmapScreen(vec2 screenCoord)
{
	return texture2D(bitmap, screenToBitmap(screenCoord));
}

vec4 sampleBitmapWorld(vec2 worldCoord)
{
	return sampleBitmapScreen(worldToScreen(worldCoord));
}

float rand(vec2 p)
{
    p = fract(p * vec2(0.1031, 0.1030));
    p += dot(p, p.yx + 33.33);
    return fract((p.x + p.y) * p.x);
}

// actual shader
uniform float uScale;
uniform float uIntensity;
uniform float uTime;

float rainDist(vec2 p, float scale, float intensity) {
	// scale everything
	p *= 0.1;
	// sheer
	p.x += p.y * 0.1;
	// scroll
	p.y -= uTime * 500.0 / scale;
	// expand Y
	p.y *= 0.03;
	float ix = floor(p.x);
	// shift Y
	p.y += mod(ix, 2.0) * 0.5 + (rand(vec2(ix)) - 0.5) * 0.3;
	float iy = floor(p.y);
	vec2 index = vec2(ix, iy);
	// mod
	p -= index;
	// shift X
	p.x += (rand(index.yx) * 2.0 - 1.0) * 0.35;
	// distance
	vec2 a = abs(p - 0.5);
	float res = max(a.x * 0.8, a.y * 0.5) - 0.1;
	// decimate
	float density = 1.0 - intensity * 0.9;
	return mix(res, 1.0, step(rand(index), density));
}

void main() {
	vec2 wpos = screenToWorld(screenCoord);
	float intensity = uIntensity;

	vec3 add = vec3(0);
	float rainSum = 0.0;

	float invScale = 1.0 / uScale;
	const int numLayers = 2;
	const vec3 rainAdd = vec3(0.1, 0.15, 0.2);
	const vec3 rainColor = vec3(1.0, 0.4078, 0.6745);

	for (int i = 0; i < numLayers; i++) {
		float scale;

		if (i == 0)
			scale = 1.0;
		else if (i == 1)
        		scale = 1.8;

		float r = rainDist(wpos * (scale * invScale) + 500.0 * float(i), scale, intensity);
		if (r < 0.0) {
			float v = (1.0 - exp(r * 5.0)) / scale * 2.0;
			wpos.x += v * 10.0 * uScale;
			wpos.y -= v * 2.0 * uScale;
			add += rainAdd * v;
			rainSum += (1.0 - rainSum) * 0.75;
		}
	}
        vec2 uv = worldToScreen(wpos);
        vec3 color = texture2D(bitmap, uv).rgb;

	color += add;
	color = mix(color, rainColor, 0.1 * rainSum);

	// alpha 1.0 doesn't really matter for camGame
	gl_FragColor = vec4(color, 1.0);
}
