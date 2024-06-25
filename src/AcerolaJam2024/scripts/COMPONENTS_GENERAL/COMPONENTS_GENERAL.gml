Fighter = function(_hp, _strength, _defense, _speed, _range, _xp, _basic_attack=undefined, _active_attack=undefined, _owner=noone) constructor{
    owner = _owner;
	xp = _xp;
	xp_next_level = 1000000000;
	hp = _hp;
    hp_max = _hp;
	foraging = 1;
	strength = _strength;
	defense = _defense;
    speed = _speed;
    range = _range;
	death_object = -1;
	enemies_in_range = ds_list_create();

	kill_count = 0;
	fight_behavior = -1;
	basic_attack = _basic_attack;
	active_attack = _active_attack;
	attack_target = noone; // this stores an instance id to help coordinate the fighting behavior with the steering behavior
    attack_index = -1; // this will either be 0 or 1, 0 for basic & 1 for active
	attack_timer = -1;
	retaliation_target = noone;
    basic_cooldown_timer  = 0   ; // set to 100 after any attack, the attack itself will affect the rate
    basic_cooldown_rate   = 0.01;
    active_cooldown_timer = 0   ; // set to 100 after any attack, the attack itself will affect the rate
    active_cooldown_rate  = 0.01;
    attack_move_penalty   = 0   ;
    
	static Update = function(){
		if(basic_cooldown_timer > 0) basic_cooldown_timer = max(0, basic_cooldown_timer - basic_cooldown_rate);
		if(active_cooldown_timer > 0) active_cooldown_timer = max(0, active_cooldown_timer - active_cooldown_rate);
		if(attack_index > -1)
		{
			if(--attack_timer == 0) 
			{
				attack_index = -1;
				// reset move penalty
				owner.attack_move_penalty = 0;
			}
		}
		if(basic_cooldown_timer > 0) && (--basic_cooldown_timer == 0) {
			// remove non existant instances from enemies in range
			var _size = ds_list_size(enemies_in_range);
			if(_size > 0){ for(var i=_size-1;i>=0;i--){ if(!instance_exists(enemies_in_range[| i])) ds_list_delete(enemies_in_range, i) } }
		}
		if(active_cooldown_timer > 0) && (--active_cooldown_timer == 0) {
			// remove non existant instances from enemies in range
			var _size = ds_list_size(enemies_in_range);
			if(_size > 0){ for(var i=_size-1;i>=0;i--){ if(!instance_exists(enemies_in_range[| i])) ds_list_delete(enemies_in_range, i) } }
		}
	}
	static UseBasic = function(){
		// this function needs to return the cooldown time(measured in steps) for enemy ai to function correctly
		// show_debug_message("UseBasic for object:{0} [1]", object_get_name(owner.object_index), owner.id);
		if(owner.sound_attack != snd_empty) SoundCommand(owner.sound_attack,0,0);
		attack_index = 0;
		attack_timer = ceil(basic_attack.duration*FRAME_RATE);
		basic_cooldown_timer = 100;
		basic_cooldown_rate = 100 / (basic_attack.cooldown*FRAME_RATE);
		owner.image_index = 0;
		owner.attack_move_penalty = basic_attack.move_penalty;
		var _struct = {
			creator : owner.fighter,
			faction : owner.faction,
			target : attack_target,
			attackData : basic_attack,
		}
		instance_create_layer(owner.position[1], owner.position[2], "Instances", basic_attack.damage_obj, _struct);
		return basic_attack.cooldown*FRAME_RATE;
	}
	static UseActive = function(){
		// show_debug_message("UseActive for object:{0} [1]", object_get_name(owner.object_index), owner.id);
		attack_index = 1;
		attack_timer = ceil(active_attack.duration*FRAME_RATE);
		active_cooldown_timer = 100;
		active_cooldown_rate = active_attack.cooldown*FRAME_RATE*0.01;
		owner.image_index = 0;
		owner.attack_move_penalty = active_attack.move_penalty;
		var _struct = {
			creator : owner.fighter,
			faction : owner.faction,
			target : attack_target,
			attackData : active_attack,
		}
		instance_create_layer(owner.position[1],owner.position[2],"Instances", active_attack.damage_obj, _struct);
	}
    static DealDamage = function(_damage, _other_fighter){
		if(is_undefined(_other_fighter)) return false; 
		if(!instance_exists(_other_fighter.owner)) return false;
		if(!instance_exists(owner)) return false;
		if(_other_fighter.hp <= 0) return false; // fighter is already dead
		var _damClac = max(1, _damage - _other_fighter.defense);
		// verify entity
		if(!instance_exists(_other_fighter.owner)) return false; // can't attack non-existance entity
		// run calculation
		_other_fighter.hp -= _damClac // 1 damage minimum is enforced here
		with(_other_fighter.owner)
		{
			CreateFloatNumber(position[1], 0.5*(position[2] + bbox_top), _damClac, FLOATTYPE.FLARE,, 90);
		}
		if(_other_fighter.hp <= 0)
		{	
			// clear id of other entity
			var _ind = ds_list_find_index(enemies_in_range, _other_fighter.owner); 
			if(_ind > -1) ds_list_delete(enemies_in_range, _ind);
			attack_target = noone;
			// deal out rewards
			reward_exp(_other_fighter.xp, owner);
			// incrememnt kill count
			kill_count++;
			// create death effect if applicable
			KillEntity(_other_fighter.owner);
			return true; // fighter has been dealt a killing blow
		} else {
			// allow the other fighter to retaliate if they don't already have a retaliate target
			if(_other_fighter.retaliation_target == noone) || (ds_list_find_index(_other_fighter.enemies_in_range, _other_fighter.retaliation_target) == -1)
			{
				_other_fighter.retaliation_target = owner;
			}
		}
		return false; // fighter is still alive
	}
	static FindEnemies = function(){
		var i, j, _xx, _yy, _hex_count, _hex, _container, _hex_index, _entity;
		var _nodes_in_range = owner.nodes_in_range;
		var _nodes_in_range_count = array_length(_nodes_in_range);
		ds_list_clear(enemies_in_range);
		
		if(_nodes_in_range_count == 0)
		{
			return 0;
		} else {
			// loop through each hex node that is in range of the current entity
			for(i=0; i<_nodes_in_range_count; i++)
			{
				with(global.i_hex_grid)
				{
					_hex_index = hex_get_index(_nodes_in_range[i]);
					_container = global.i_hex_grid.hexarr_containers[_hex_index];
				}
				for(j=0;j<ds_list_size(_container);j++)
				{
					// get entity occupying the hex node
					_entity = _container[| j];
					// validate the entity as an enemy
					if(is_undefined(_entity)) || (!instance_exists(_entity)) || ((_entity.faction == owner.faction)) continue;
					// entity is valid as an enemy, add it to the list
					ds_list_add(enemies_in_range, _entity);
				}
			}
			return ds_list_size(enemies_in_range);
		}
	}
	static Destroy = function(){
		ds_list_destroy(enemies_in_range);
	}
}
Inventory = function(_owner=noone) constructor{
	owner = _owner;
	flower_names = ["red", "blue", "yellow", "fuschia", "speckled"];
	flower_counts = [0,0,-1,-1,-1];
}
