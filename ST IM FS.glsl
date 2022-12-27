//Ray tracing
//http://www.scratchapixel.com/lessons/3d-basic-rendering/minimal-ray-tracer-rendering-simple-shapes/ray-plane-and-ray-disk-intersection

//Interior mapping 
//http://interiormapping.oogst3d.net/

//It is not optimized, but easy for me to understand step by step
float get_T(float h, float ro_weight, float rd_weight) {
    return (h - ro_weight) / rd_weight;
}

vec2 intersect(in vec3 ro, in vec3 rd, in vec3 Axis, in float d, in float id1, in float id2) {    
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

vec3 render(in vec2 tID, in vec3 ro, in vec3 rd, in vec3 size) {
    float t = tID.x, id = tID.y;  
    vec3 color1 = vec3(0.42, 0.85, 0.65), color2 = vec3(1.0, 0.67, 0.55), color3 = vec3(1.0, 0.9, 0.49), 
         color4 = vec3(1.0, 0.77, 0.5), color5 = vec3(0.5, 0.78, 1.0), color6 = vec3(0.59, 0.56, 0.92), 
         pos = (ro + t * rd) / size; //green, top //red, bottom //yellow, right //orange, left //blue, front 
         //purple, back    
              
    if (id > 0.9 && id < 1.1) {
        vec3 tex = texture( iChannel0, fract(vec2(pos.x,-pos.z)) ).xyz; 
        
        return color1 * tex;        
    
    } else if (id > 1.9 && id < 2.1) {
        vec3 tex = texture( iChannel0, fract(pos.xz) ).xyz; 
        
        return color2 * tex;
    
    } else if (id > 2.9 && id < 3.1) {
        vec3 tex = texture( iChannel0, fract(vec2(-pos.z,pos.y)) ).xyz; 
        
        return color3 * tex;
    
    } else if (id > 3.9 && id < 4.1) {
        vec3 tex = texture( iChannel0, fract(pos.zy) ).xyz; 
        
        return color4 * tex;
    
    } else if (id > 4.9 && id < 5.1) {
        vec3 tex = texture( iChannel0, fract(pos.xy)).xyz; 
        
        return color5 * tex;
    
    } else if (id > 5.9 && id < 6.1) {
        vec3 tex = texture( iChannel0, fract(pos.xy) ).xyz; 
        
        return color6 * tex;
    }    
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec3 cameraPos = vec3(sin(iTime), cos(iTime) / 2.0, 0);    
    
    vec2 uv = (fragCoord * 2.0 - iResolution.xy) / iResolution.y;
    vec3 ro = vec3(uv, 2.14), rd = normalize(ro - cameraPos), size = vec3(0.8, 0.6, 1), up = vec3(0, 1, 0), 
         right = vec3(1, 0, 0), front = vec3(0, 0, 1); //tiene que ser 2.1...2.19
    
    // intersect
    vec2 tID1 = intersect(ro, rd, up, size.y, 1.0, 2.0), tID2 = intersect(ro, rd, right, size.x, 3.0, 4.0),
         tID3 = intersect(ro, rd, front, size.z, 5.0, 6.0), tID = nearest(tID1, tID2, tID3);
    
    // render 
    vec3 color = render(tID, ro, rd, size);

    // Output to screen
    fragColor = vec4(color, 1);
}
