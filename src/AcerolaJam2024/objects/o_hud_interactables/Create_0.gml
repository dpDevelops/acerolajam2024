/// @description 

function SetPlayerBehavior(_bhvr){
	with(global.i_player){ ai.behavior = _bhvr }
	// adjust sprites on the buttons
	with(o_hud_interactables)
	{
		controlsList[| 0].sprite = _bhvr == FORAGING ? s_hud_foraging_activated : s_hud_foraging;
		controlsList[| 1].sprite = _bhvr == AGGRESSIVE ? s_hud_fighting_activated : s_hud_fighting;
	}
}
function FinishLevel(){
	with(oEnemy) { instance_destroy() }
	with(oBush) { instance_destroy() }
	with(global.i_player.fighter) hp = hp_max;
	with(o_hud_interactables)
	{
		time_source_started = false;
		time_source_complete = false;
	}
	if(!instance_exists(oUpgradeMenu)) instance_create_depth(0,0,UPPERDEPTH,oUpgradeMenu);
}

// Inherit the parent event
event_inherited();
// immediately remove from menu stack
ds_stack_pop(global.i_engine.menu_stack);

// general variables
time_source_started = false;
time_source_complete = false;
finish_showpos = vect2((global.i_camera.viewWidthHalf-xstart)-(sprite_get_width(s_hud_finish) div 2), -40);
finish_hidepos = vect2(finish_showpos[1],100);
menu_check = 0;

var _ind = -1;
// foraging button (set player behavior to foraging)
ButtonAdd(-(sprite_get_width(s_hud_foraging) div 2),0,id,++_ind,"forage",s_hud_foraging,,"",,SetPlayerBehavior,[FORAGING]);
// fighting button (set player behavior to fighting)
ButtonAdd(40-(sprite_get_width(s_hud_fighting) div 2),0,id,++_ind,"fight",s_hud_fighting,,"",,SetPlayerBehavior,[AGGRESSIVE]);
// button to end a level and bring up the reserch menu
ButtonAdd(finish_hidepos[1],finish_hidepos[2],id,++_ind,"finish",s_hud_finish,,"",,FinishLevel,[]);
// pause button (top-right corner)
ButtonAdd(1.8*global.i_camera.viewWidthHalf-xstart,0.2*global.i_camera.viewHeightHalf-ystart,id,++_ind,"pause",s_hud_pause,,"",,pause_game,[]);
SetPlayerBehavior(FORAGING);

