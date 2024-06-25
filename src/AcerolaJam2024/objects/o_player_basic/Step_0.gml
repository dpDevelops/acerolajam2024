/// @description 

// premature destruction
if(needs_creator && !instance_exists(creator.owner)) || ((--lifetime <= 0))
{
	// show_debug_message("attack end - " + object_get_name(object_index));
	if(sound_end != snd_empty) SoundCommand(sound_end,x,y);
	destroyed_self = true;
	instance_destroy();
	exit;
}

if(destroyed_self) exit;

if(--damage_point_timer == 0) && (instance_exists(target))
{
	if(sound_damage_point != snd_empty) SoundCommand(sound_damage_point,x,y);
    // show_debug_message("damage point - " + object_get_name(object_index));
	// check for a kill on an enemy, if so, heal if the player has the lifesteal upgrade
	var _tgt_obj = target.object_index;
	if(creator.DealDamage(attackData.damage_value*creator.strength, target.fighter))
	{
		// kill has been confirmed whenever 'DealDamage' returns true
		var _heal_val = global.i_player.progression[$ "t3_3"][0] + 2*global.i_player.progression[$ "t4_1"][0]; 
		if(_heal_val > 0) global.i_player.fighter.hp = min(global.i_player.fighter.hp_max,global.i_player.fighter.hp+_heal_val);
	} else {
		if(global.i_player.progression[$ "t3_1"][0])
		{
			// apply slow to a target that survives the attack
			instance_create_depth(0,0,0,oSlowObject,{target : target});
		}
	}
}



