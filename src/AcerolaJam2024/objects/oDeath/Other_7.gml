/// @description destroy
if(sprite_index != s_player_death) 
{  // delete as standard
	instance_destroy();
} else {
	// open defeat menu after a bit
	image_speed = 0;
	image_index = image_number-1;
	alarm[0] = round(FRAME_RATE)
}