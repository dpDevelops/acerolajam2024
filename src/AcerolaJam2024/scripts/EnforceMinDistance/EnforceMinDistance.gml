function EnforceMinDistance(other_entity){
	// this function prevents unit-type entities from stacking on top of one another
	// function will return false if the entities are too far apart, anf returns true if the min distance is enforced
	// 
	if(col_ignored) || (other_entity.col_ignored) exit;
	var _mindistance = collision_radius + other_entity.collision_radius;
	var _dist = point_distance(position[1],position[2],other_entity.position[1],other_entity.position[2]);
	var _diff = _mindistance-_dist; if(_diff <= 0) return false;
	var _split = collision_radius / _mindistance;
	var _dir = point_direction(position[1],position[2],other_entity.position[1],other_entity.position[2]);
	if(position[1] + position[2] - other_entity.position[1] - other_entity.position[2] == 0) { _dir = irandom(359) }
	
	if(col_moveable)
	{
		position[1] += _diff*(1-_split)*dcos(_dir-180);
		position[2] -= _diff*(1-_split)*dsin(_dir-180);
	}
	with(other_entity)
	{
		if(col_moveable)
		{
			position[1] += _diff*_split*dcos(_dir);
			position[2] -= _diff*_split*dsin(_dir);
		}
	}
	return true;
}