/// @description 

if(global.mouse_focus == id)
{
	// draw outline around the entity
	shader_set(shOutline);
	shader_set_uniform_f(upixelW, texelW);
	shader_set_uniform_f(upixelH, texelH);
	draw_sprite_ext(sprite_index,image_index,x,y,image_xscale,image_yscale,0,c_white,image_alpha);
	shader_reset();
}

// draw the entity
if(z > 0) draw_sprite_ext(sShadow,0,x,y,shadow_scale,shadow_scale,0,c_white,1);

draw_sprite_ext(sprite_index,image_index,x,y-z,image_xscale,image_yscale,image_angle,image_blend,image_alpha)

var _prog = 0;

if(!is_undefined(fighter))
{
	if(fighter.basic_cooldown_timer > 0)
	{
		_prog = fighter.basic_cooldown_timer; 
		draw_healthbar(basicattackbar_bbox[0],basicattackbar_bbox[1],basicattackbar_bbox[2],basicattackbar_bbox[3],_prog,c_black,c_gray,c_gray,0,true,false);
	}
	if(fighter.active_cooldown_timer > 0)
	{
		_prog = fighter.active_cooldown_timer; 
		draw_healthbar(activeattackbar_bbox[0],activeattackbar_bbox[1],activeattackbar_bbox[2],activeattackbar_bbox[3],_prog,c_black,c_gray,c_gray,0,true,false);
	}
	if(fighter.hp < fighter.hp_max)
	{
		_prog = 100*(fighter.hp / fighter.hp_max);
		draw_healthbar(healthbar_bbox[0],healthbar_bbox[1],healthbar_bbox[2],healthbar_bbox[3],_prog,c_black,c_green,c_green,0,true,false);
	}
}


