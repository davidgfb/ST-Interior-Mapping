vec2 intersect(vec3 ro, vec3 rd, vec3 Axis, float d, int id1, int id2) {    //no id
    float rd_weight = dot(rd, Axis), ro_weight = dot(ro, Axis), pointer = ceil(ro_weight / d), h = pointer * d; 
    int id3 = id1; //rd_weight > 0.0, look up
    
    if (rd_weight <= 0.0) { //look down
        h -= d;            
        id3 = id2;
    }
             
    return vec2((h - ro_weight) / rd_weight, id3);
}

vec3 r = vec3(1, 0, 0), g = vec3(0, 1, 0), b = vec3(0, 0, 1); //ruf 

vec3 render(in vec2 tID, in vec3 ro, in vec3 rd, in vec3 size) {
    float id = tID.y, v0 = 0.9;  
    vec3 colores[6] = vec3[6](r, g, b, vec3(1), r + g, g + b), pos = (ro + tID.x * rd) / size, tex = vec3(0), 
         c = vec3(0); //t  
    
    int pos_C = 0; //n_Cond
    
    for (int i = 0; i < 6; i++, v0++) {
        if (v0 < id && id < v0 + 0.2) {
            v0 = 6.1;
            pos_C = i;            
        }
    }
         
    return colores[pos_C];
}

void mainImage(out vec4 fragColor, vec2 fragCoord) {   
    vec3 cameraPos = vec3(sin(iTime), cos(iTime) / 2.0, 0), 
         ro = vec3((fragCoord * 2.0 - iResolution.xy) / iResolution.y, 2.14), rd = normalize(ro - cameraPos),
         size = vec3(0.8, 0.6, 1);        
    vec2 c1 = intersect(ro, rd, g, size.y, 1, 2), c2 = intersect(ro, rd, r, size.x, 3, 4), //right, up
         c3 = intersect(ro, rd, b, size.z, 5, 6), value = c2.x < c3.x ? c2 : c3; //hay 1 pto fuga //c1.x >= c2.x 
         //front
    if(c1.x < c2.x) {
        value = c1.x < c3.x ? c1 : c3;  
    }     
             
    vec3 color = render(value, ro, rd, size); //tiene que ser 2.1...2.19 //uv // render  //clave // intersect //tID1...3

    // Output to screen
    fragColor = vec4(color, 1);
}
