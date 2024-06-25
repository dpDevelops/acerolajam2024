/// @description check for player presence

if(global.game_state != GameStates.PLAY) exit;

if(player_in_range) && (global.i_player.fighter.attack_index == -1)
{
	foraging_progress = min(foraging_threshold, foraging_progress + 5 + global.i_player.fighter.foraging);	
} else {
	if(foraging_progress > 0)
	{
		foraging_progress = max(0, foraging_progress-1);
	}
}

if(foraging_progress == foraging_threshold) 
{
	// heal the player if they have the upgrade
	if(global.i_player.progression[$ "t2_4"][0]) { global.i_player.fighter.hp = min(global.i_player.fighter.hp+1, global.i_player.fighter.hp_max) }
	// consume a flower
	ConsumeForagingCharge();
}