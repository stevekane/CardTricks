//u_sprite_size: vec2
//u_texture: sampler2D
//u_time: float
//v_tex_coord: vec2

void main (void) {
    vec4 color = texture2D(u_texture, v_tex_coord);
    float gray = dot(color.rgb, vec3(0.299, 0.587, 0.114));
    
    gl_FragColor = vec4(gray, gray, gray, 1.0);
}