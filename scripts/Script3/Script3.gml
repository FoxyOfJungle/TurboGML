/*
uniform shader iChunk;

const float2 resolution = float2(1280.0, 720.0);

half saturate(half x) {
	return clamp(x, 0.0, 1.0);
}

float3 saturate3(float3 x) {
    return clamp(x, 0.0, 1.0);
}

half linearstep(half minv, half maxv, half value) {
	return (value - minv) / (maxv - minv);
}

half mask_radial(float2 uv, float2 center, half power, half scale, half smoothness) {
	half smoothh = mix(scale, 0.0, smoothness);
	half sc = scale / 2.0;
	half mask = pow(1.0-saturate((length(uv-center)-sc) / ((smoothh-0.001)-sc)), power);
	return mask;
}

half mask_wave(float2 uv, half yoffset, half hwave_freq, half hwave_amp, half hspeed, half vspeed) {
    half hh = sin(uv.x*hwave_freq + iTime*vspeed) * hwave_amp;
    half variation = (cos(uv.x*15.0 + iTime*hspeed) * hh + 0.5) * 10.0;
    return smoothstep(0.0, 1.0, yoffset-uv.y * variation);
}

float3 hsv2rgb(float3 color) {
	float4 K = float4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
	float3 p = abs(fract(color.xxx + K.xyz) * 6.0 - K.www);
	return color.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), color.y);
}

const float3 lum_weights = float3(0.2126729, 0.7151522, 0.0721750);
half get_luminance(float3 color) {
	return dot(color, lum_weights);
}

float3 blend(float3 source, float3 dest) {
	return source + dest - source * dest;
}

float3 choose_color(half reciprocal, float3 col1, float3 col2) {
    if (reciprocal >= 0.5) return col1; else
    if (reciprocal >= 0.0) return col2;
}

// polynomial smooth max by Inigo Quilez
half smax(half a, half b, half k) {
    half h = max(k-abs(a-b), 0.0)/k;
	return max(a, b) + h*h*k*(1.0/4.0);
}
half heart_curve(float2 uv, half blur, half wings) {
	uv.x *= 0.6;
    uv.y -= 0.5 * smax(sqrt(abs(uv.x)), blur, blur*0.6) * (wings - blur);
    return smoothstep(blur, -blur, length(uv)-0.5);
}


half4 main(float2 fragCoord)
{
    // uvs
    float2 uv = fragCoord/resolution.xy;
    float2 uv_h = (2.0 * fragCoord - resolution.xy) / min(resolution.x, resolution.y);
    float2 uv_f = uv_h;
    
    // main browser texture
    float3 effect_col;
    
    // mask
    //half mask = mask_radial(uv, float2(0.5), 10.0, 1.5, 0.9);
    half mask = mask_wave(uv, 2.0, 1.0, 0.15, 1.0, 0.2);
    half mask_smoothness = 10.0;
    
    
    // Main properties
    half y_offset = 0.0;
    
    
    
    // Heart
    // properties
    const half hearts_amount = 120.0;
    
    const half hearts_speed = 0.25;
    const half hearts_angle = 0.5;
    const half hearts_scale = 80.0;
    const half hearts_intensity = 1.0;
    
    const half hearts_plane_xscale = 80.0;
    const half hearts_plane_yscale = 80.0;
    
    const half hearts_wiggle_amplitude = 2.0;
    const half hearts_wiggle_speed = 3.0;
    
    const float3 red = float3(0.98, 0.12, 0.31);
    const float3 pink = float3(1, 0, 0.5);
    
    const half color_smooth_y = 14.0;
    const half color_smoothness = 1.0;
    
    const half alpha_smooth_y = 8.0;
    const half alpha_smoothness = 1.0;
    
    
    
    half time_hearts = iTime * hearts_speed;
    
    // Hearts
    float3 hearts_col;
    for(half i = 0.0; i < 1.0; i += (1.0/hearts_amount)) {
        // position (normalized value * scale)
        half px = (fract(cos(i*651.3) * 7564.7) - 0.5) * hearts_plane_xscale;
        half py = (fract(-time_hearts*0.3+i*6.32+y_offset) - 0.5) * hearts_plane_yscale;
        half pz = abs(i-0.5) * hearts_scale;
        
        px += sin(mix(0.2, 1.0, i) * time_hearts * hearts_wiggle_speed) * hearts_wiggle_amplitude;
        
        // rotation
        half angle = radians(mix(-hearts_angle, hearts_angle*2.5, abs(i-0.5)));
        uv_h *= mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
        
        // uv
        float2 pos = (uv_h * pz);
        
        // visual
        half alpha = saturate(linearstep(alpha_smooth_y-alpha_smoothness, alpha_smooth_y+alpha_smoothness, py));
        float3 color = choose_color(
            i,
            mix(pink, red, saturate(linearstep(color_smooth_y-color_smoothness, color_smooth_y+color_smoothness, py))),
            red
        );
        
        //float4 heart = texture(iChannel1, pos+float2(px, py)); //choose_image(pos+float2(px, py), i, iChannel1, iChannel1);
        //hearts_col += (heart.rgb * heart.a) * color * alpha;
		
		
		float heart = heart_curve(pos + vec2(px, py), 0.02, 1.0);
        hearts_col += vec3(heart) * color * alpha;
        
    }
    hearts_col *= hearts_intensity;
    
    
    
    // Bloom [unused]
    
    
    
    // add effects
    effect_col += hearts_col;// * mask;
    
    // tone mapping
    //effect_col = 1.0 - exp(-effect_col);
    // gamma
    //effect_col = pow(effect_col, float3(1.0/1.1));
    
	// final
    return float4(effect_col, 1.0);
}
