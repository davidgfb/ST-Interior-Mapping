//Ray tracing
//http://www.scratchapixel.com/lessons/3d-basic-rendering/minimal-ray-tracer-rendering-simple-shapes/ray-plane-and-ray-disk-intersection

//Interior mapping 
//http://interiormapping.oogst3d.net/

//It is not optimized, but easy for me to understand step by step
float get_T(float h, float ro_weight, float rd_weight) {
    return (h - ro_weight) / rd_weight;
}

vec2 intersect(vec3 ro, vec3 rd, vec3 Axis, float d, int id1, int id2) {    
    float rd_weight = dot(rd, Axis), ro_weight = dot(ro, Axis), pointer = ceil(ro_weight / d),
          h = pointer * d, t = get_T(h, ro_weight, rd_weight); // rd_weight > 0.0, look up
    vec2 value = vec2(t, id1);
    
    if(rd_weight <= 0.0) { // look down
        t = get_T(h - d, ro_weight, rd_weight);
        
        value = vec2(t, id2);    
    }
    
    return value;
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

vec3 render(in vec2 tID, in vec3 ro, in vec3 rd, in vec3 size) {
    float id = tID.y;  
    vec3 color1 = vec3(0.42, 0.85, 0.65), color2 = vec3(1.0, 0.67, 0.55), color3 = vec3(1.0, 0.9, 0.49), 
         color4 = vec3(1.0, 0.77, 0.5), color5 = vec3(0.5, 0.78, 1.0), color6 = vec3(0.59, 0.56, 0.92), 
         pos = (ro + tID.x * rd) / size, tex = vec3(0), value = vec3(0); //green, top //red, bottom //yellow, right //orange, left //blue, front 
         //purple, back  //t  
              
    if (0.9 < id && id < 1.1) {       
        value = color1 * get_Tex(vec2(pos.x, -pos.z));        
    
    } else if (1.9 < id && id < 2.1) {          
        value = color2 * get_Tex(pos.xz);
    
    } else if (2.9 < id && id < 3.1) {      
        value = color3 * get_Tex(vec2(-pos.z, pos.y));
    
    } else if (3.9 < id && id < 4.1) {         
        value = color4 * get_Tex(pos.zy);
    
    } else if (4.9 < id && id < 5.1) {         
        value = color5 * get_Tex(pos.xy);
    
    } else if (5.9 < id && id < 6.1) {         
        value = color6 * get_Tex(pos.xy);
    }    
    
    return value;
}

void mainImage(out vec4 fragColor, vec2 fragCoord) {   
    vec3 cameraPos = vec3(sin(iTime), cos(iTime) / 2.0, 0), 
         ro = vec3((fragCoord * 2.0 - iResolution.xy) / iResolution.y, 2.14), rd = normalize(ro - cameraPos),
         size = vec3(0.8, 0.6, 1), up = vec3(0, 1, 0), right = vec3(1, 0, 0), front = vec3(0, 0, 1), 
         color = render(nearest(intersect(ro, rd, up, size.y, 1, 2), 
         intersect(ro, rd, right, size.x, 3, 4), intersect(ro, rd, front, size.z, 5, 6)), ro, rd, size);
         //tiene que ser 2.1...2.19 //uv // render  //clave // intersect //tID1...3

    // Output to screen
    fragColor = vec4(color, 1);
}
