#macro ASPECT_RATIO 16/9
#macro RESOLUTION_W 640
#macro RESOLUTION_H 720 // doesnt really do anything, height is calculated based on aspect ratio and width
#macro FRAME_RATE 60
#macro ROOM_START rGame
#macro NONE -1
#macro OUT 0
#macro IN 1
#macro UPPERDEPTH -5000
#macro ENTITYDEPTH -200
#macro LOWERDEPTH 0
#macro FACTION_NEUTRAL 0
#macro FACTION_PLAYER 1
#macro FACTION_ENEMY 2
// AI Behaviors
#macro PASSIVE 0
#macro DEFENSIVE 1
#macro AGGRESSIVE 2
#macro FORAGING 3

enum GameStates 
{
	PLAY,
	PAUSE,
    VICTORY,
    DEFEAT,
}
enum FLOATTYPE
{
	FLARE,
	LINEAR,
	TICK
}
