

if(is_undefined(global.i_player)) || (is_undefined(global.i_player.inventory)) instance_destroy(); 

width = 50;
height = 10;
bbox = [x,y,x+width,y+height];
p_inventory = global.i_player.inventory;

draw_points = [vect2(0,0),vect2(0,0),vect2(0,0),vect2(0,0),vect2(0,0)];

inventory_string = "";
