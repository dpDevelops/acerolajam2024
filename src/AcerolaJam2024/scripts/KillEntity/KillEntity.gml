function KillEntity(_ent){
	with(_ent)
	{
		// create death object (i cant remember what this is for)
		if(object_exists(_ent.fighter.death_object)) instance_create_layer(x, y, "Instances", fighter.death_object);
		// create an object to play death animation
		if(spr_death != -1){ instance_create_depth(position[1], position[2], depth, oDeath, { sprite_index : spr_death }) }
		// play death sound
		if(sound_death != snd_empty) SoundCommand(sound_death, x, y);
		// remove entity
		if(object_index != oPlayer) 
		{
			instance_destroy();
		} else {
			// set 'Defeat' state
			global.game_state_previous = global.game_state;
			global.game_state = GameStates.DEFEAT;
			global.player_dead = true;
		}
	}
}