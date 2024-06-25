/// @description 

var _wHalf = string_width(title) div 2;
draw_set_alpha(0.5);
draw_set_color(c_black)
draw_rectangle(x-_wHalf-2,y-6,x+_wHalf+2,y+6,false);

draw_set_color(c_white);
draw_set_alpha(image_alpha);
draw_set_halign(fa_center);
draw_set_valign(fa_middle)
draw_text(x,y,string(title));
