/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

// draw the flower on top of the bush (for the flowers that exist)
for(var i=0;i<5;i++)
{
	if(foraging_charges[i] > 0) 
	{
		draw_sprite_ext(s_flowers, i,
	        flower_positions[i][1], flower_positions[i][2],
			1,1,flower_angles[i],c_white,image_alpha);
	}
}
	
	

if(foraging_progress > 0)
{
	draw_healthbar(
		buildtimer_bbox[0],buildtimer_bbox[1],buildtimer_bbox[2],buildtimer_bbox[3]
		,100*foraging_progress/foraging_threshold,c_black,c_gray,c_gray,0,true,true);
}