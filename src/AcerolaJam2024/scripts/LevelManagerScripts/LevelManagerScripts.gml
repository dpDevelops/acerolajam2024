function TimedBushPlacement(){
	show_debug_message("timed bush placement");
}

function TimedEnemyPlacement(){
	show_debug_message("timed enemy placement");
	with(oLevelManager)
	{
		var _en_limit = 6 + (2*(level_difficulty div 4));
		var _count = 0;
		with(oEnemy){ _count++ }
		if(_count < _en_limit)
		{
			var _hex = hex_get_enemy_spawn();
			var _pos = hex_to_pixel(_hex,true);
		
			var _types = ["sheep", "wolf", "yak", "warg", "werewolf"];
			var _rand = random(1);
			var _chances = [1.0,0,0,0,0];
			// change odds based on the level index and perception level
			level_difficulty = level_index + 2*(global.i_player.perception_level-1)
			if(level_difficulty < 4){
				_chances = [1.0,0.3,0,0,0];
			} else if(level_difficulty < 4){
				_chances = [1.0,0.8,0.3,0,0];
			} else if(level_difficulty < 12){
				_chances = [1.0,0.95,0.7,0.3,0];
			} else {
				_chances = [1.0,0.99,0.85,0.7,0.4];
			}
			// create the enemy
			for(var i=array_length(_types)-1;i>=0;i--)
			{
				if(_rand < _chances[i])
				{
					with(instance_create_depth(_pos[1], _pos[2], ENTITYDEPTH, oEnemy, {type_string : _types[i]})){
						xTo = _pos[1]; yTo = _pos[2]
						position = _pos; 
					}
					break;
				}
			}
			show_debug_message("difficulty = {0}",level_difficulty);
		}
	}
}

function LevelBegin(_level_time=120, _bush_interval=20, _enemy_interval=15){
	with(oLevelManager)
	{
		if(!level_begin)
		{
			// reconfigure the time sources
			time_source_reconfigure(ts_level_timer,_level_time,time_source_units_seconds,LevelComplete,[],1);
			time_source_reconfigure(ts_bush_timer,_bush_interval,time_source_units_seconds,TimedBushPlacement,[],1);
			time_source_reconfigure(ts_enemy_timer,_enemy_interval,time_source_units_seconds,TimedEnemyPlacement,[],-1);
			// set parameters
			level_index++;
			level_begin = true;
			level_running = true;
		
			// place bushes and inital enemies
			SpawnBush(0.04, 10 + 4*global.i_player.progression[$ "t3_6"][0]);
		
			time_source_start(ts_level_timer);
			time_source_start(ts_bush_timer);
			time_source_start(ts_enemy_timer);
			
			with(o_hud_interactables) time_source_started = true;
		}
	}
}

function LevelPause(){
	with(oLevelManager)
	{
		level_running = false;
	
		time_source_pause(ts_level_timer);
		time_source_pause(ts_bush_timer);
		time_source_pause(ts_enemy_timer);
	}
}
function LevelUnpause(){
	with(oLevelManager)
	{
		level_running = true;

		time_source_resume(ts_level_timer);
		time_source_resume(ts_bush_timer);
		time_source_resume(ts_enemy_timer);
	}
}

function LevelComplete(){
	with(oLevelManager)
	{
		level_begin = false;
		level_running = false;
		timer_minutes_string = "00";
		timer_seconds_string = "00";
		timer_milliseconds_string = "00";
		
		time_source_stop(ts_bush_timer);
		time_source_stop(ts_enemy_timer);

	}
	with(o_hud_interactables) time_source_complete = true;
}

function hex_get_enemy_spawn(_min_dist=3){
	var _enabled_nodes = global.i_hex_grid.hexgrid_enabled_list;
	var _filtered_list = ds_list_create();
	var _target_hex = vect2(0,0);
	var _player_hex = global.i_player.hex;
	// filter available nodes
	for(var i=0;i<ds_list_size(_enabled_nodes);i++)
	{
		_target_hex = global.i_hex_grid.hexarr_hexes[_enabled_nodes[| i]];
		if(axial_distance(_player_hex, _target_hex) >= _min_dist) ds_list_add(_filtered_list, _target_hex);
	}
	// pick a hex at random from the filtered list
	_target_hex = _filtered_list[| irandom(ds_list_size(_filtered_list)-1)];
	ds_list_destroy(_filtered_list);
	return _target_hex;
}
