/// @description 

LevelManagerScripts();

function LevelManagerInit(){
	gui_w = display_get_gui_width();
	gui_h = display_get_gui_height();

	timer_pos = vect2(0.5*gui_w,10);

	if(!variable_instance_exists(id, "ts_level_timer"))
		{ts_level_timer = time_source_create(time_source_global,1,time_source_units_seconds,LevelComplete)}
		else{time_source_reset(ts_level_timer)}
	if(!variable_instance_exists(id, "ts_bush_timer"))
		{ts_bush_timer = time_source_create(time_source_global,1,time_source_units_seconds,TimedBushPlacement)}
		else{time_source_reset(ts_bush_timer)}
	if(!variable_instance_exists(id, "ts_enemy_timer"))
		{ts_enemy_timer = time_source_create(time_source_global,1,time_source_units_seconds,TimedEnemyPlacement)}
		else{time_source_reset(ts_enemy_timer)}
		
	level_index = 0; // -1 means that the game has not begun yet
	level_begin = false;
	level_running = false;
	level_difficulty = 0;

	timer_minutes_string = "00";
	timer_seconds_string = "00";
	timer_milliseconds_string = "00";

	with(o_hud_interactables)
	{
		time_source_started = false;
		time_source_complete = false;
		SetPlayerBehavior(FORAGING);
	}
}
LevelManagerInit();