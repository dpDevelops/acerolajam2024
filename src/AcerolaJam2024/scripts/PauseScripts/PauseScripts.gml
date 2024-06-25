function pause_game(){
	if(global.game_state != GameStates.PLAY) exit;
	global.game_state_previous = global.game_state;
	global.game_state = GameStates.PAUSE;
	with(oLevelManager) LevelPause();
	instance_create_depth(0,0,UPPERDEPTH-10,oPauseMenu);
}
function unpause_game(){
	if(global.game_state != GameStates.PAUSE) exit;
	global.game_state = global.game_state_previous;
	with(oLevelManager) LevelUnpause();	
	with(oPauseMenu) instance_destroy();
}