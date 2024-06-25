/// @description 

if(!instance_exists(target))
{
	instance_destroy();
} else {
	if(global.game_state == GameStates.PLAY)
	{
		if(--timer <= 0)
		{
			target.speed += slow_strength;
			instance_destroy();
		}
	}
}
	
