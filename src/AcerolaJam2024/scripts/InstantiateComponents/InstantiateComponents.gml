function InstantiatePlayerComponents(_health,_strength,_defense,_speed,_range,_xp){
	// determine the attacks
	var _basic = {
		name : "Thrust Spear",
		cooldown : 2,       // delay, in seconds, between attacks
		move_penalty : 0.8, // move speed reduced during attack
		duration : 0.5,     // movement is reduced, other attacks cannot be done during this time
		damage_point : 10,  // damage is dealt after this step count
		damage_value : 1,
		damage_obj : o_player_basic 
	}
	var _active = {
		name : "Throw Spear",
		cooldown : 5, // delay, in seconds, between attacks
		move_penalty : 0.8, // move speed reduced during attack
		duration : 1.5, // movement is reduced, other attacks cannot be done during this time
		damage_point : 10, // damage is dealt after this step count
		damage_value : 1,
		damage_obj : o_player_active 
	}
	// clear components in they were set previously
	if(variable_instance_exists(id, "fighter")) delete fighter;
	if(variable_instance_exists(id, "ai")) delete ai;
	if(variable_instance_exists(id, "inventory")) delete inventory;
	// set components
	fighter = new global.i_engine.Fighter(_health,_strength,_defense,_speed,_range,_xp,_basic,_active,id);
	ai = new global.i_engine.PlayerAI(DEFENSIVE, id);
	inventory = new global.i_engine.Inventory(id);

	// upgrade variables
	perception_level = 1;
	progression = {
		t0_unlock : [true, [-1,-1,-1,-1,-1], "PERCEPTION LEVEL 1", "\nBase level of Knowledge"], 
		t1_1 :      [false, [1,3,-1,-1,-1], "Athletics", "\n\nSpeed +1"], 
		t1_2 :      [false, [3,1,-1,-1,-1],"Green Thumb I","\n\nForaging +1"],
		t1_unlock : [false, [3,3,-1,-1,-1],"PERCEPTION LEVEL 2","unlocks tier2 upgrades, "+global.i_player.inventory.flower_names[2]+" flowers will now spawn."],
		t2_1 :      [false, [2,2,2,-1,-1],"Wand Training","\n\nRange +1"],
		t2_2 :      [false, [2,3,1,-1,-1],"Constitution","\n\nHealth +10"],
		t2_3 :      [false, [3,1,3,-1,-1],"Green Thumb II","\n\nForaging +1"],
		t2_4 :      [false, [1,1,4,-1,-1],"Therapy","\nObtaining flowers will heal +1 point each."],
		t2_unlock : [false, [4,4,4,-1,-1],"PERCEPTION LEVEL 3","unlocks tier3 upgrades, "+global.i_player.inventory.flower_names[3]+" flowers will now spawn."],
		t3_1 :      [false, [3,2,1,4,-1],"Slowing Strikes","\nEach attack will apply a temporary movement debuff to the target."],
		t3_2 :      [false, [1,2,3,4,-1],"Focused Strikes","\n\nDamage +1"],
		t3_3 :      [false, [1,5,2,1,-1],"Vampirism I","Defeating enemies heals +1 point each."],
		t3_4 :      [false, [2,2,1,2,-1],"Stealth Training","\n\nAggro range -1"],
		t3_5 :      [false, [2,3,3,2,-1],"Constitution II","\n\nHealth +10"],
		t3_6 :      [false, [6,1,1,1,-1],"Fertilizer","\nIncreases bush spawn limit."],
		t3_unlock : [false, [4,4,4,4,-1],"PERCEPTION LEVEL 4","unlocks tier4 upgrades, "+global.i_player.inventory.flower_names[4]+" flowers will now spawn."],
		t4_1 :      [false, [3,3,4,5,-1],"Vampirism II","Defeating enemies heals +2 point each."],
		t4_2 :      [false, [5,4,3,3,-1],"Cultivation","Increases spawn chances for higher tier flowers."],
		t4_unlock : [false, [4,4,4,4,4],"THE ELIXER","This is the conclusion of the research.  With this, eternal life is mine to take!\n\n [ WIN CONDITION ]"],
	}
	//create the movement indicator
	if(!instance_exists(o_player_movement)) instance_create_depth(x,y,ENTITYDEPTH,o_player_movement,{p : id});
}
function InstantiateBushComponents(_health,_strength,_defense,_speed,_range,_xp){
	// determine the attacks
	var _basic = {
		name : "Forage",
		cooldown : 2,       // delay, in seconds, between attacks
		move_penalty : 0.8, // move speed reduced during attack
		duration : 0.5,     // movement is reduced, other attacks cannot be done during this time
		damage_point : 10,  // damage is dealt after this step count
		damage_value : 1,
		damage_obj : o_player_basic 
	}
	var _active = {
		name : "Skill Unknown",
		cooldown : 5, // delay, in seconds, between attacks
		move_penalty : 0.8, // move speed reduced during attack
		duration : 1.5, // movement is reduced, other attacks cannot be done during this time
		damage_point : 10, // damage is dealt after this step count
		damage_value : 1,
		damage_obj : o_player_active 
	}
	fighter = new global.i_engine.Fighter(_health,_strength,_defense,_speed,_range,_xp,_basic,_active,id);

	// run update script on object
	Update();
}
function InstantiateEnemyComponents(_health,_strength,_defense,_speed,_range,_xp,_behavior){
	var _struct = {}
	// determine the attacks
	var _basic = {
		name : "Thrust Spear",
		cooldown : 2.5,       // delay, in seconds, between attacks
		move_penalty : 0.8, // move speed reduced during attack
		duration : 0.5,     // movement is reduced, other attacks cannot be done during this time
		damage_point : 10,  // damage is dealt after this step count
		damage_value : 1,
		damage_obj : o_enemy_basic 
	}
	var _active = {
		name : "Throw Spear",
		cooldown : 5, // delay, in seconds, between attacks
		move_penalty : 0.8, // move speed reduced during attack
		duration : 0.5, // movement is reduced, other attacks cannot be done during this time
		damage_point : 10, // damage is dealt after this step count
		damage_value : 1,
		damage_obj : o_enemy_active 
	}

	fighter = new global.i_engine.Fighter(_health,_strength,_defense,_speed,_range,_xp,_basic,_active,id);
	ai = new global.i_engine.EnemyAI(_behavior, id);
	
	// run update script on object
	Update();
}