/// @description 

sound_start = snd_empty;
sound_damage_point = snd_empty;
sound_end = snd_empty;

// Inherit the parent event
event_inherited();
/*
lifetime += 150;

spr_start = s_player_attack_basic_start;
spr_end = s_player_attack_basic_end;

xend = target.position[1];
yend = target.position[2];
image_number_start = sprite_get_number(spr_start);
image_number_end = sprite_get_number(spr_end);

var _scale = 0.6;
image_xscale = _scale;
image_yscale = _scale;
x = creator.owner.x;
y = creator.owner.y;
depth = UPPERDEPTH;
visible = true;
image_speed = 0.6;
image_angle = point_direction(x,y,xend,yend);
