/// @description 

draw_set_alpha(1);
draw_set_color(c_black);
draw_set_font(f_default_L);
draw_set_halign(fa_left);
draw_set_valign(fa_middle);

// draw the background fade
draw_sprite_ext(s_bg_fade,1,xTo,yTo,1.5,1.5,0,c_white,image_alpha);

// draw the base of the menu
var _x = x-menu_half_w;
var _y = y-menu_half_h;
draw_sprite_ext(menu_9s, 0, _x, _y,menu_xscale,menu_yscale,0,c_white,image_alpha);

// draw the tutorial
var _padding = 5;
_x = tut_pos[1]-tut_half_w;
_y = tut_pos[2]-tut_half_h;
draw_sprite_ext(tut_9s, 0, _x, _y,tut_xscale,tut_yscale,0,c_white,image_alpha);
draw_text_ext(_x+_padding, tut_pos[2], tut, 13, tut_size[1]-(2*_padding));

// draw the credits
var _padding = 5;
_x = cdt_pos[1]-cdt_half_w;
_y = cdt_pos[2]-cdt_half_h;
draw_sprite_ext(cdt_9s, 0, _x, _y,cdt_xscale,cdt_yscale,0,c_white,image_alpha);
draw_set_valign(fa_top);
draw_set_halign(fa_left);
draw_text_ext(_x+_padding,_y+_padding,cdt,13,tut_size[1]-(2*_padding));

// Inherit the parent event
event_inherited();

