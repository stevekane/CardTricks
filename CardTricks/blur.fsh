//u_sprite_size: vec2
//u_texture: sampler2D
//u_time: float
//v_tex_coord: vec2

void main (void) {
    vec4 sum = vec4(0.0);
    vec4 color = texture2D(u_texture, v_tex_coord);
    int x;
    int y;
    
    for (x = -2; x < 2; x++) {
        for (y = -2; y <= 2; y++) {
            vec2 offset = vec2(x, y) * 0.005;
            
            sum += texture2D(u_texture, v_tex_coord + offset);
        }
    }
    
    gl_FragColor = vec4(( sum / 25.0 ).rgb, 1.0);
}