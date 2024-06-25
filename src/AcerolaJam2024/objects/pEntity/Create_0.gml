/// @description 
fighter = undefined;
Inventory = undefined;
ai = undefined;

function Move(_direction){
	// get direction index for hexagonal movement
	var _dir_index = 30 + _direction;
	if(_dir_index >= 360) _dir_index -= 360;
	_dir_index = _dir_index div 60 == 6 ? 0 : _dir_index div 60;
	// get the hex vectors
	var _oldhex = hex;
	var _newhex = hex_get_neighbor(_oldhex, _dir_index);
	// commit movement
	if(hex_is_enabled(_newhex) && (!array_equals(_oldhex, _newhex))){
		var _point = hex_to_pixel(_newhex, true);
		xTo = _point[1];
		yTo = _point[2];
	}	
	// set move cooldown timer
	move_timer_set_point = max(10, FRAME_RATE*((21-fighter.speed)/20));
	move_timer = move_timer_set_point;
}

function Update(){
	// steer toward desired direction
	script_execute(movement_script);
	if(move_timer > -1) move_timer--;
	CheckNodeChange(id);
	
	// update position relative to the gui layer
	if(visible){
		gui_x = position[1] - camera_get_view_x(view_camera[0]);
		gui_y = position[2] - camera_get_view_y(view_camera[0]);
	}
	
	// animate
	var _idle_lim = 0.6;
	var _move_lim = 0.8;
	var _spd = vect_len(velocity);
	var _dir = vect_direction(velocity);
	var _attacking = false;
    var _theta = 5; // this value will determine a deadzone where the sprite cannot flip their scaling
	if(spr_idle != -1)
	{
		if(!is_undefined(fighter) && fighter.attack_index > -1){
			_attacking = true;
			var _dur = fighter.attack_index == 0 ? fighter.basic_attack.duration : fighter.active_attack.duration;
			if(sprite_index != spr_attack) 
			{
				sprite_index = spr_attack;
				image_index = 0;
				image_speed = 0;
			}
			image_index = min(image_number-1, image_index + image_number/(_dur*FRAME_RATE));

            _dir = attack_direction;
		} else {
            if(_spd <= _idle_lim)
            {
                if(sprite_index != spr_idle) 
                {
                    sprite_index = spr_idle;
                    image_index = 0;
                    image_speed = 1;
                }
			} else if(_spd > _move_lim){
                if(sprite_index != spr_move) 
                {
                    sprite_index = spr_move;
                    image_index = 0;
                    image_speed = 1;
                }
            }
        }
		if((vect_len(velocity) > 0) || (_attacking))
		{
	        if(_dir > 90+_theta) && (_dir < 270-_theta){
	            if(image_xscale != -1) image_xscale = -1;
	        } else if(_dir < 90-_theta) || (_dir > 270+_theta){
	            if(image_xscale != 1) image_xscale = 1;
	        }
		}
	}

    // update the healthbars' position
    if(visible)
    {
		depth = ENTITYDEPTH - 0.3*y*(object_index != oBush);

        basicattackbar_bbox[0] = bbox_left;
        basicattackbar_bbox[1] = bbox_top-4*bar_height;
        basicattackbar_bbox[2] = bbox_right;
        basicattackbar_bbox[3] = bbox_top-5*bar_height;

        activeattackbar_bbox[0] = bbox_left;
        activeattackbar_bbox[1] = bbox_top-3*bar_height;
        activeattackbar_bbox[2] = bbox_right;
        activeattackbar_bbox[3] = bbox_top-4*bar_height;

        healthbar_bbox[0] = bbox_left;
        healthbar_bbox[1] = bbox_top-2*bar_height;
        healthbar_bbox[2] = bbox_right;
        healthbar_bbox[3] = bbox_top-3*bar_height;

        buildtimer_bbox[0] = bbox_left;
        buildtimer_bbox[1] = bbox_top-bar_height;
        buildtimer_bbox[2] = bbox_right;
        buildtimer_bbox[3] = bbox_top-2*bar_height;
        
        commandtimer_bbox[0] = bbox_left;
        commandtimer_bbox[1] = bbox_top;
        commandtimer_bbox[2] = bbox_right;
        commandtimer_bbox[3] = bbox_top-bar_height;
    }
}

function EntityVisibility(){
	visible = abs(position[1] - global.i_camera.x) < global.i_camera.viewWidthHalf+20 && 
	          abs(position[2] - global.i_camera.y) < global.i_camera.viewHeightHalf+20;
}

// movement & position variables
hex = vect2(0,0);
hex_prev = hex;
hex_path_list = ds_list_create();
position = vect2(0,0);
velocity = vect2(0,0);
xTo = position[1];
yTo = position[2]; 
z = 0;
//animation
spr_idle = -1;
spr_move = -1;
spr_attack = -1;
spr_death = -1;
//sound
sound_spawn = snd_empty;
sound_move = snd_empty;
sound_attack = snd_empty;
sound_death = snd_empty;	
movement_script = EntityMovement;
// misc variables 
name = "";
attack_direction = 0;
move_timer_set_point = 100;
move_timer = -1;
collision_radius = 10;
col_moveable = true;
col_ignored = false;
shadow_scale = 0.5 * sprite_get_width(sprite_index) / sprite_get_width(sShadow);
nodes_in_range = [];

// shader stuff
upixelH = shader_get_uniform(shOutline, "pixelH");
upixelW = shader_get_uniform(shOutline, "pixelW");
texelW = texture_get_texel_width(sprite_get_texture(s_pixel,0));
texelH = texture_get_texel_height(sprite_get_texture(s_pixel,0));

// data bars that display over-head
gui_x = 0;
gui_y = 0;
bar_height = 6;
healthbar_bbox =       [0,0,0,0];
buildtimer_bbox =      [0,0,0,0];
commandtimer_bbox =    [0,0,0,0];
basicattackbar_bbox =  [0,0,0,0];
activeattackbar_bbox = [0,0,0,0];

