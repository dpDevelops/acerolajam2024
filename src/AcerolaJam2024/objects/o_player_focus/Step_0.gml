/// @description 

if(global.game_state == GameStates.PAUSE) exit;

target = global.i_player.ai.focus_target;
if(target != noone) && (instance_exists(target))
{
	if(!visible) visible = true;
	x = target.position[1];
	y = target.position[2];
} else {
	if(visible) visible = false;
}
