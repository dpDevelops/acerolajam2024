function StartCountdownToLevelStart(_countdown_seconds){
	with(oLevelManager)
	{
		var _t_level = 40 + 5*(level_difficulty div 3);
		var _t_bush = 4;
		var _t_enemy = 6 - (level_difficulty div 4);
	}
	instance_create_depth(0,0,UPPERDEPTH,oLevelCountdown,{
		seconds : _countdown_seconds,
		level_time : _t_level,
		bush_time : _t_bush,
		enemy_time : _t_enemy
	});
}