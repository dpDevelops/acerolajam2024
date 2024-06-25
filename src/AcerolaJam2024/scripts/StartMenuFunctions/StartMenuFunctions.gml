function Start(){
	instance_create_depth(0,0,UPPERDEPTH,oStartMenuTransition);
}
function Tutorial(){
	with(oStartMenu)
		{ show_tutorial = !show_tutorial }
}
function Credits(){
	with(oStartMenu)
		{ show_credits = !show_credits}
}
function Quit(){
	game_end();
}
