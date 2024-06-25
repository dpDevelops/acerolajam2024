/// @description 

draw_set_alpha(image_alpha);
draw_set_halign(fa_right);
draw_set_valign(fa_top);
draw_text(bbox[0], bbox[1]-3, "STAMINA: ");
draw_healthbar(bbox[0],bbox[1],bbox[2],bbox[3],p_stamina,c_black,color,color,0,true,true);

