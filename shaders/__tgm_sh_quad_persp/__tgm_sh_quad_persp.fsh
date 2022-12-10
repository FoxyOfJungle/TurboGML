
// Original implementation by "/home/spag"

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec4 uAB,uCD;
uniform vec4 uUVS;

void main() {
    vec2 AB = uAB.xy - uAB.zw;
    vec2 PA = gl_FragCoord.xy - uAB.xy;
    vec2 CD = uCD.xy - uCD.zw;
    vec2 DA = uCD.zw-uAB.xy;
    
    float cc = CD.x + AB.x;
    float cg = AB.y + CD.y;

    float ap = -cc*DA.y + DA.x*cg;
    float bp = cc*PA.y - DA.x*AB.y + AB.x*DA.y - PA.x*cg;
    float cp = -AB.x*PA.y + PA.x*AB.y;
    
    float v = (-bp-sqrt(bp*bp-4.0*ap*cp))/(2.0*ap);
    float u = (-v*DA.y+PA.y) / (v*cg-AB.y);
    vec2 uv = uUVS.xy+vec2(u,v) * (uUVS.zw-uUVS.xy);
    gl_FragColor = v_vColour * texture2D(gm_BaseTexture, uv);
}
