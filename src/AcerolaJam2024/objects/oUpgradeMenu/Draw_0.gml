/// @description 

draw_set_alpha(1);
draw_set_color(c_black);
draw_set_font(f_default_L);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_alpha(image_alpha);

// draw the background fade
draw_sprite_ext(s_bg_fade,0,xTo,yTo,1.5,1.5,0,c_white,min(global.bg_fade, image_alpha));

// draw the base of the menu
var _x = x-menu_half_w;
var _y = y-menu_half_h;
draw_sprite_ext(menu_9s, 0, _x, _y,menu_xscale,menu_yscale,0,c_white,image_alpha);
draw_sprite(sUpgradeMenuButtonPlacement,0,_x,_y);

if(time_source_get_state(ts_progression_buy) == time_source_state_active)
{
	var btn = controlsList[| progression_clicked_index];
	var _w = 50;
	var _h = 10;
	var _x = btn.xTrue+(btn.width div 2) - (_w div 2);
	var _y = btn.yTrue-8;

	if(!is_undefined(btn))
	{
		draw_healthbar(_x,_y,_x+_w,_y-_h,progression_buy_progress,c_black,c_ltgrey,c_ltgrey,0,true,true);
	}
}

// show cost for focused node
var p_str = "";
var r_str = "";
for(var i=0;i<5;i++)
{
	// draw player's flower count in red if it is not enough for the upgrade
	if(required_flowers[i] > global.i_player.inventory.flower_counts[i]) draw_set_color(c_red);
	if(global.i_player.inventory.flower_counts[i] == -1){p_str = "-"} else {
		p_str = string(global.i_player.inventory.flower_counts[i])
		// draw flower icon only if the player has unlocked it
		draw_sprite(s_flowericon,i,flower_draw_positions[i][1],flower_draw_positions[i][2]-16);
	}
	if(required_flowers[i] == -1){r_str = "-"} else {r_str = string(required_flowers[i])}

	// draw player flowers
	draw_text(flower_draw_positions[i][1],flower_draw_positions[i][2],p_str);
	// draw required flowers
	draw_set_color(c_black);
	draw_text(flower_draw_positions[i][1],flower_draw_positions[i][2]+16,r_str);
}

// show description for the upgrade
_x = x + 156;
_y = y-80;
draw_set_valign(fa_top);
draw_text(_x,_y,progression_focus_title);
draw_text_ext(_x,_y+18,progression_focus_text,10,126);

// Inherit the parent event
event_inherited();

