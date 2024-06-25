PlayerAI = function(_behavior,_owner=noone) constructor{
	focus_target = noone;
	foraging_id = noone;
	behavior = _behavior;
	owner = _owner;
	static Update = function(){
		var _target = focus_target;
		if(_target != noone)
		{
			if(!instance_exists(focus_target)){focus_target = noone} else {
				var _direction = point_direction(owner.position[1], owner.position[2],_target.position[1],_target.position[2]);
				var _tgt_dist = axial_distance(owner.hex, _target.hex);
				if(_target.object_index == oBush)
				{
					// if focus is a bush, then move toward it until hex is shared
					if(owner.move_timer <= 0) && (_tgt_dist > 0) owner.Move(_direction);
				} else {
					// move toward the target until it is in range then attack
					
					if(_tgt_dist <= owner.fighter.range)
					{
						with(owner.fighter)
						{
							// attack valid target
							if(attack_target != _target) attack_target = _target;
							if(attack_index == -1) && (basic_cooldown_timer <= 0)
							{
								owner.attack_direction = _direction;
								UseBasic();
							}
						}
					} else {
						if(owner.move_timer <= 0) owner.Move(_direction);
					}
				}
			}
			exit;
		}
		
		// Auto-Attack behavior will only run when there is no focus target
		_target = GetAutoAttackTarget();
		// if there is a valid auto attack target, then attack it
		if(_target != noone) 
		{
			with(owner.fighter)
			{
				// attack valid target
				if(attack_target != _target) attack_target = _target;
				if(attack_index == -1) && (basic_cooldown_timer <= 0)
				{
					owner.attack_direction = point_direction(owner.position[1], owner.position[2], _target.position[1], _target.position[2]);
					UseBasic();
				}
			}
		}
	}
	static GetAutoAttackTarget = function(){
		var _target = noone;
		switch(behavior)
		{
			case PASSIVE:
				// dont do checks when passive
				break;
			case DEFENSIVE:
				// player will only auto attack in retaliation
				with(owner.fighter)
				{
					if(retaliation_target != noone) 
						&& (instance_exists(retaliation_target))
						&& (ds_list_find_index(enemies_in_range, retaliation_target) > -1)
					{
						_target = retaliation_target;
					} else { retaliation_target = noone }
				}
				break;
			case AGGRESSIVE:
				// player will attack any enemy in range 
				with(owner.fighter)
				{
					// attack the current attack target, if possible
					if(attack_target != noone) 
						&& (instance_exists(attack_target))
						&& (ds_list_find_index(enemies_in_range, attack_target) > -1){
							_target = attack_target;
					} else { attack_target = noone }
					
					// if there is no attack target, attack nearest enemy if possible
					if(_target == noone)
					{
						// determine a target from enemies in range based on varying criteria
						for(var i=0;i<ds_list_size(enemies_in_range);i++)
						{
							_target = enemies_in_range[| i];
							// skip the target if it is undefined or doesn't exist
							if(is_undefined(_target)) || (!instance_exists(_target)) {_target=noone; continue}
							
							// target must be an enemy to be auto attacked
							if(_target.faction != FACTION_ENEMY) {_target=noone; continue}
							
							// valid target found
							break;
						}
						// make sure this doesn't return 'undefined'
						if(is_undefined(_target)) { _target = noone; } 
					}
				}
				break;
		}
		return _target;
	}
	static Destroy = function(){
		
	}
}
EnemyAI = function(_behavior, _owner) constructor{
	focus_target = noone;
	foraging_id = noone;
	behavior = _behavior;
	owner = _owner;
	aggro_flag = false;
	aggro_radius = 2 - global.i_player.progression[$ "t3_4"][0];
	aggro_chase_dist = 2;
	action_time = FRAME_RATE*2;
	action_timer = 1;
	static Update = function(){
		var _target = GetAutoAttackTarget();
		if((_target != noone) || focus_target != noone) && (!aggro_flag)
		{
			aggro_flag = true; 
			//instance_create_depth(owner.x,owner.y,UPPERDEPTH+10,oAggroIndicator,{creator : owner}); 
		}
		if(--action_timer <= 0)
		{
			// decide whether to keep chasing or to start chasing
			var _player_dist = axial_distance(owner.hex, global.i_player.hex);
			if(!aggro_flag){
				if(_player_dist <= aggro_radius) && (behavior == AGGRESSIVE){
					aggro_flag = true;
					focus_target = global.i_player;}
			} else {
				if(_player_dist > aggro_chase_dist){	
					aggro_flag = false;
					focus_target = noone;}
			}

			// behavior changes based on aggro state
			if(aggro_flag) && (focus_target != noone)
			{
				// attack any enemy in range, but prioritize the attack command target
				if(owner.fighter.range >= _player_dist) 
				{
					if(focus_target != noone) && instance_exists(focus_target) _target = focus_target;
					with(owner.fighter)
					{
						// attack valid target
						if(attack_target != _target) attack_target = _target;
						if(attack_index == -1) && (basic_cooldown_timer <= 0)
						{
							owner.attack_direction = point_direction(owner.position[1], owner.position[2], _target.position[1], _target.position[2]);
							UseBasic();
						}
					}
				} else {
					// move toward the player if its not close enough to attack
					with(owner)
					{
						if(move_timer <= 0) && (fighter.attack_index == -1){
							Move(point_direction(position[1], position[2], global.i_player.position[1], global.i_player.position[2]));
						}
					}
				}
			} else {
				// wander
				var _move_chance = 0.1;
				if(random(1) < _move_chance){
					with(owner){
						if(move_timer <= 0) Move(irandom(5)*60);
					}
				}
			}
			action_timer = max(1, min(action_time, owner.move_timer));
			if(_target != noone) action_timer = min(action_timer, owner.fighter.basic_cooldown_timer);
		}
	}
	static GetAutoAttackTarget = function(){
		var _target = noone;
		switch(behavior)
		{
			case PASSIVE:
				// dont do checks when passive
				break;
			case DEFENSIVE:
				// player will only auto attack in retaliation
				with(owner.fighter)
				{
					if(retaliation_target != noone) 
						&& (instance_exists(retaliation_target))
						&& (ds_list_find_index(enemies_in_range, retaliation_target) > -1)
					{
						_target = retaliation_target;
					} else { retaliation_target = noone }
				}
				break;
			case AGGRESSIVE:
				// player will attack any enemy in range 
				with(owner.fighter)
				{
					// attack the current attack target, if possible
					if(attack_target != noone) 
						&& (instance_exists(attack_target))
						&& (ds_list_find_index(enemies_in_range, attack_target) > -1){
							_target = attack_target;
					} else { attack_target = noone }
					
					// if there is no attack target, attack nearest enemy if possible
					if(_target == noone)
					{
						// determine a target from enemies in range based on varying criteria
						for(var i=0;i<ds_list_size(enemies_in_range);i++)
						{
							_target = enemies_in_range[| i];
							// skip the target if it is undefined or doesn't exist
							if(is_undefined(_target)) || (!instance_exists(_target)) {_target = noone; continue}
							
							// target must be the player to be auto attacked
							if(_target.faction != FACTION_PLAYER) {_target = noone; continue}
							
							// valid target found
							break;
						}
					}
				}
				break;
		}
		return _target;
	}
	static Destroy = function(){
		
	}
}