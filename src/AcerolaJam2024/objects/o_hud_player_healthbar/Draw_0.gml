/// @description 

draw_set_alpha(image_alpha);
draw_set_halign(fa_right);
draw_set_valign(fa_top);
draw_text(bbox[0], bbox[1]-3, "HEALTH: ");
draw_healthbar(bbox[0],bbox[1],bbox[2],bbox[3],p_health,c_black,c_red,c_green,0,true,true);

