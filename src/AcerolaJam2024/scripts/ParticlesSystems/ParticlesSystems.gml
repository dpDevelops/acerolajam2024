function ParticleSystemsInit(){
	ptsys_sell_puff = 0;
	ptsys_structure_spawn_puff = 0;
	ptsys_upgrade_effect = 0;
	ptsys_specialization_effect = 0;
	
	SellPuffInit();
	StructureSpawnPuffInit();
	UpgradeEffectInit();
}
function SellPuffInit(){
	with(global.i_engine)
	{
		if(!part_system_exists(ptsys_sell_puff)) ptsys_sell_puff = part_system_create();
		part_system_depth(ptsys_sell_puff,UPPERDEPTH);
		pt_sell_puff = part_type_create();
		part_type_shape(pt_sell_puff,pt_shape_disk);
		part_type_speed(pt_sell_puff,0.5,1.5,0.005,0);
		part_type_size(pt_sell_puff,0.2,0.4,0.005,0.1);
		part_type_color3(pt_sell_puff,color0,color1,color7);
		part_type_direction(pt_sell_puff,0,359,0,0);
		part_type_gravity(pt_sell_puff,0.05,90);
		part_type_life(pt_sell_puff,10,40);
		part_type_alpha3(pt_sell_puff,1,0.2,0.0);
	}
}
function SellPuffCreate(_x,_y){
	with(global.i_engine)
	{
		part_particles_create(ptsys_sell_puff,_x,_y,pt_sell_puff,20);
	}
}
function StructureSpawnPuffInit(){
	with(global.i_engine)
	{
		if(!part_system_exists(ptsys_structure_spawn_puff)) ptsys_structure_spawn_puff = part_system_create();
		
		part_system_depth(ptsys_structure_spawn_puff,UPPERDEPTH);
		pt_structure_spawn_puff = part_type_create();
		part_type_shape(pt_structure_spawn_puff,pt_shape_square);
		part_type_speed(pt_structure_spawn_puff,0.5,1.5,0.005,0);
		part_type_size(pt_structure_spawn_puff,0.2,0.4,0.005,0.1);
		part_type_color3(pt_structure_spawn_puff,color0,color1,color7);
		part_type_direction(pt_structure_spawn_puff,0,359,0,0);
		part_type_gravity(pt_structure_spawn_puff,0.05,90);
		part_type_life(pt_structure_spawn_puff,10,40);
		part_type_alpha3(pt_structure_spawn_puff,1,0.2,0.0);
	}
}
function StructureSpawnPuffCreate(_x,_y){
	with(global.i_engine)
	{
		part_particles_create(ptsys_structure_spawn_puff,_x,_y,pt_structure_spawn_puff,20);
	}
}
function UpgradeEffectInit(){
	with(global.i_engine)
	{
		if(!part_system_exists(ptsys_upgrade_effect)) ptsys_upgrade_effect = part_system_create();
		
		part_system_depth(ptsys_upgrade_effect,UPPERDEPTH);
		pt_upgrade_effect = part_type_create();
		part_type_scale(pt_upgrade_effect,0.03,1.2);
		part_type_shape(pt_upgrade_effect, pt_shape_square);
		part_type_speed(pt_upgrade_effect,0.1,1.4,0.205,0);
		part_type_size(pt_upgrade_effect,0.1,0.3,0.05,0);
		part_type_color3(pt_upgrade_effect,color3,color4,color5);
		part_type_direction(pt_upgrade_effect,90,90,0,0);
		part_type_life(pt_upgrade_effect,20,30);
		part_type_alpha3(pt_upgrade_effect,1,0.4,0.0);
	}
}
function UpgradeEffectCreate(_x,_y){
	with(global.i_engine)
	{
		var _sep = 4;
		var _wid = 4;
		var _hgt = 4;
		repeat(8){
			part_particles_create(ptsys_upgrade_effect, _x+_sep*random_range(-_wid,_wid), _y+_sep*random_range(-_hgt,_hgt), pt_upgrade_effect, 1);
		}
	}
}
