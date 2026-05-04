shader_type canvas_item;


uniform vec4 transparent_color : source_color = vec4(0.15, 0.15, 0.15, 0.15);
uniform float tolerance = 0.1;

void fragment() {
    // Read the current frame’s pixel
    vec4 col = texture(TEXTURE, UV);

    if (col.r<0.40){
	col.a=col.r-0.15;
	}else{
	col.a=col.r;
	}
	col.r = 1.0;
	col.g = 1.0;
	col.b = 1.0;
	
    COLOR = col;
	}