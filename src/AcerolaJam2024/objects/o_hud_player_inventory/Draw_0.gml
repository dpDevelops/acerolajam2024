/// @description Insert description here
// You can write your code in this editor
draw_set_alpha(image_alpha);
draw_set_color(c_white);
draw_set_font(f_default_L);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);


for(var i=0;i<5;i++) 
{
	var _pt = draw_points[i];
	var _ct = global.i_player.inventory.flower_counts[i];
	
	// draw title
	if(i == 2) draw_text(_pt[1],_pt[2]-16,inventory_string);
	
	// draw the individual flower count
	if(_ct > -1)
	{
		draw_sprite(s_flowericon, i, draw_points[i][1], draw_points[i][2]);
		draw_text(_pt[1], _pt[2]+16, string(_ct));
	}
}