#pragma header

uniform vec4 funnyColor;
uniform bool colSet;
uniform float strength;

void main()
{
    vec4 color = flixel_texture2D(bitmap, openfl_TextureCoordv);

    if (color.a > 0.0 && colSet) {
        vec4 target = funnyColor * color.a;
        color = mix(color, target, strength);
    }

    gl_FragColor = color;
}