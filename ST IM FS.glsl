vec2 intersect(vec3 ro, vec3 rd, vec3 Axis, float d, int id1, int id2) {    //no id
    float rd_weight = dot(rd, Axis), ro_weight = dot(ro, Axis), pointer = ceil(ro_weight / d), h = pointer * d; 
    int id3 = id1; //rd_weight > 0.0, look up
    
    if (rd_weight <= 0.0) { //look down
        h -= d;            
        id3 = id2;
    }
             
    return vec2((h - ro_weight) / rd_weight, id3);
}

vec2 nearest(vec2 c1, vec2 c2, vec2 c3) { //hay 1 pto fuga
    vec2 value = c2.x < c3.x ? c2 : c3; //c1.x >= c2.x 
    
    if(c1.x < c2.x) {
        value = c1.x < c3.x ? c1 : c3;  
    } 
    
    return value;
}

vec3 get_Tex(vec2 v) { 
    return texture(iChannel0, fract(v)).xyz; 
}

vec3 r = vec3(1, 0, 0), g = vec3(0, 1, 0), b = vec3(0, 0, 1); //ruf 

vec3 render(in vec2 tID, in vec3 ro, in vec3 rd, in vec3 size) {
    float id = tID.y, v0 = 0.9;  
    vec3 colores[6] = vec3[6](r, g, b, vec3(1), r + g, g + b);
    //vec3 c1 = r, c2 = g, c3 = b, c4 = vec3(1), c5 = c1 + c2, c6 = c2 + c3, 
    vec3 pos = (ro + tID.x * rd) / size, 
         tex = vec3(0), value = vec3(0); //purple, back  //t  
    int n_Cond = 0;
    bool esta_Buscando = true;
    
    while (esta_Buscando) {
        if (v0 < id && id < v0 + 0.2) {
            esta_Buscando = false;
        
        } else {
            v0 += 1.0;
            n_Cond++;
        } 
    }
    
    value = colores[n_Cond];
    
    switch (n_Cond) {  
        case 0:
            value *= get_Tex(vec2(pos.x, -pos.z));
            break;
        
        case 1:
            value *= get_Tex(pos.xz);
            break;
            
        case 2:
            value *= get_Tex(vec2(-pos.z, pos.y));
            break;
        
        case 3:
            value *= get_Tex(pos.zy);
            break;
            
        case 4: case 5:
            value *= get_Tex(pos.xy);
            break;
    }
     
    return value;
}

void mainImage(out vec4 fragColor, vec2 fragCoord) {   
    vec3 cameraPos = vec3(sin(iTime), cos(iTime) / 2.0, 0), 
         ro = vec3((fragCoord * 2.0 - iResolution.xy) / iResolution.y, 2.14), rd = normalize(ro - cameraPos),
         size = vec3(0.8, 0.6, 1), right = r, up = g, front = b, 
         color = render(nearest(intersect(ro, rd, up, size.y, 1, 2), intersect(ro, rd, right, size.x, 3, 4), 
                 intersect(ro, rd, front, size.z, 5, 6)), ro, rd, size);
         //tiene que ser 2.1...2.19 //uv // render  //clave // intersect //tID1...3

    // Output to screen
    fragColor = vec4(color, 1);
}
