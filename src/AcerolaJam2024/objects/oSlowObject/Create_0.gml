/// @description 

if(!variable_instance_exists(id, "target")) || (!instance_exists(target))
	{ instance_destroy(); exit; }

timer = -1
slow_duration = FRAME_RATE*3; 
slow_strength = 0.5;

target.fighter.speed -= slow_strength;
