//u_sprite_size: vec2
//u_texture: sampler2D
//u_time: float
//v_tex_coord: vec2

void main (void) {
    vec4 color = texture2D(u_texture, v_tex_coord);
    vec3 sepia = vec3(1.2, 1.0, 0.8);
    vec4 gray = dot(color.rgb, vec3(0.299, 0.587, 0.114));
    
    gl_FragColor = vec4(vec3(gray) * sepia, 1.0);
}