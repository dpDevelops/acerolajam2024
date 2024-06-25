function FocusProgressionNode(_controls_name="t1_unlock"){
	with(oUpgradeMenu)
	{
		if(progression_focus_name == _controls_name) exit;
		// remove highlight flag on old button
		if(!is_undefined(controlsMap[?progression_focus_name]))
		{ controlsList[| controlsMap[? progression_focus_name]].highlightForced = false; }
		
		// set values of new button
		var btn = controlsList[| controlsMap[? _controls_name]];
		btn.highlightForced = true;
		progression_focus_name = btn.name;
		progression_focus_title = global.i_player.progression[$ btn.name][2];
		progression_focus_text = global.i_player.progression[$ btn.name][3];
		required_flowers = global.i_player.progression[$ btn.name][1];
	}
}
function GetFocusStatus(){
	for(var i=progression_index_start;i<=progression_index_end;i++)
	{
		var btn = controlsList[| i];
		var _onBtn = false;
		with(btn)
		{
			if(sprite == s_upgrade_node_locked) continue;
			_onBtn = point_in_rectangle(mouse_x,mouse_y,xTrue,yTrue,xTrue+width,yTrue+height);
		}
		if(_onBtn){
			// focus the node since we know it is not locked
			FocusProgressionNode(btn.name);
			// dont need to check any more
			return i;
		}
	}
	return -1;
}

function CheckAffordability(){
	for(var i=progression_index_start;i<=progression_index_end;i++)
	{
		var btn = controlsList[| i];
		var acquired = global.i_player.progression[$ btn.name][0];
		var cost = global.i_player.progression[$ btn.name][1];
		// skip if the node is locked
		if(btn.sprite == s_upgrade_node_locked) continue;
		// set sprite to expensive if the player doesn't have enough flowers
		if(!acquired)
		{
			btn.sprite = s_upgrade_node_available;
			// check to see if player can afford then set sprite accordingly
			for(var j=0;j<array_length(cost);j++)
			{
				if(global.i_player.inventory.flower_counts[j] < cost[j]){ 
					btn.sprite = s_upgrade_node_expensive;
					break; 
				}
			}
		}
	}
}

function NodeClickAction(){
	
}
function GetUpgrade(){
	with(oUpgradeMenu)
	{
		var btn = controlsList[| progression_clicked_index];
		if(!is_undefined(btn)) && (btn.sprite != s_upgrade_node_bought)
		{
			// update sprite
			btn.sprite = s_upgrade_node_bought;
			// update player
			with(global.i_player)
			{
				progression[$ btn.name][0] = true; // acquired flag
				var costs = progression[$ btn.name][1] // cost for the upgrade
				for(var i=0; i<array_length(inventory.flower_counts);i++)
					{ inventory.flower_counts[i] -= max(0,costs[i]) }
			}
			PerformUpgrade(btn.name);
			CheckAffordability();
		}
	}
}
function PerformUpgrade(upg_name){
	show_debug_message("upgrading: {0}", upg_name);
	// facilitate the upgrade
	switch(upg_name)
	{
		case "t0_unlock":
		    UnlockNode(["t1_unlock","t1_1","t1_2"]);
		    break;
		case "t1_1":
			// Athletics
		    global.i_player.fighter.speed++;
		    break;
		case "t1_2":
			// Green Thumb I
		    global.i_player.fighter.foraging++;
		    break;
		case "t1_unlock":
		    UnlockNode(["t2_unlock","t2_1","t2_2","t2_3","t2_4"]);
			global.i_player.inventory.flower_counts[2] = max(0, global.i_player.inventory.flower_counts[2]);
			global.i_player.perception_level++;
		    break;
		case "t2_1":
			// Wand Training
		    global.i_player.fighter.range++;
		    break;
		case "t2_2":
			// Constitution I
		    global.i_player.fighter.hp += 10;
			global.i_player.fighter.hp_max += 10;
		    break;
		case "t2_3":
			// Green Thumb II
		    global.i_player.fighter.foraging++;
		    break;
		case "t2_4":
		    // 'Therepy' is implemented elsewhere
		    break;
		case "t2_unlock":
		    UnlockNode(["t3_unlock","t3_1","t3_2","t3_3","t3_4","t3_5","t3_6"]);
			global.i_player.inventory.flower_counts[3] = max(0, global.i_player.inventory.flower_counts[3]);
			global.i_player.perception_level++;
		    break;
		case "t3_1":
		    //Slowing Strikes
			// implemented elsewhere
		    break;
		case "t3_2":
		    //Focused Strikes
			global.i_player.fighter.strength++;
		    break;
		case "t3_3":
		    //Vampirism I
			// implemented elsewhere
		    break;
		case "t3_4":
		    //Stealth Training
			// implemented elsewhere
		    break;
		case "t3_5":
		    //Constitution II
		    global.i_player.fighter.hp += 10;
			global.i_player.fighter.hp_max += 10;
		    break;
		case "t3_6":
		    //Fertilizer
			// implemented elsewhere
		    break;
		case "t3_unlock":
		    UnlockNode(["t4_unlock","t4_1","t4_2"]);
			global.i_player.inventory.flower_counts[4] = max(0, global.i_player.inventory.flower_counts[4]);
			global.i_player.perception_level++;
		    break;
		case "t4_1":
		    //Vampirism II
			// implemented elsewhere
		    break;
		case "t4_2":
		    //Cultivation
			// implemented elsewhere
		    break;
		case "t4_unlock":
		    global.game_state = GameStates.VICTORY;
			instance_create_depth(0,0,UPPERDEPTH+10,oVictoryMenu);
		    break;
	}
}
function UnlockNode(names=[]){
	for(var i=0;i<array_length(names); i++)
	{
		var btn = controlsList[| controlsMap[? names[i]]];
		if(is_undefined(btn)){
			show_debug_message("ERROR: cant unlock [ {0} ]", names[i])
		} else {
			btn.sprite = s_upgrade_node_available;	
		}
	}
}
function UpgradeMenuStartNextLevel(){
	instance_create_depth(0,0,UPPERDEPTH,oUpgradeMenuTransition);
}