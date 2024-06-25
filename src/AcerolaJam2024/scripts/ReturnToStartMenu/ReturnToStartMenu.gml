function ReturnToStartMenu(){
	room_start_init_player_entity();
	room_start_init_camera();
	with(oBush) instance_destroy();
	with(oEnemy) instance_destroy();
	with(oDeath) instance_destroy();
	if(global.game_state == GameStates.PAUSE) unpause_game();
	global.game_state = GameStates.PLAY;
	global.player_dead = false;
	with(oLevelManager) LevelManagerInit();
	with(global.i_engine)
	{
		while(ds_stack_size(menu_stack) > 0) instance_destroy(ds_stack_pop(menu_stack));
	}
	instance_create_depth(0,0,UPPERDEPTH,oStartMenu);
}