CONST = {
	NET = {
		CHANNELS = {
			MAX = 10;
			
			UNCONNECTED = 0;		-- Unconnected messages (serverinfo, etc)
			CONNECTING = 1;
			MAP = 2;
			
			STATE = 3;				-- Use this to handle all entity creation/remove
			CHAT = 4;				-- Chat messages
			PLAYERS = 5;			-- Game state messages
			OBJECTS = 6;			-- Game state messages (players, weapons, vehicles, etc)
			
			PLAYERSKIN = 7;		-- To receive the player skin faster
		},
		
		-- Message types > 50
		SERVERINFO = 1001;
		RCON = 1002;
		CHATMESSAGE = 1003;
		SCREENMESSAGE = 1004;
		USERMESSAGE = 1005;
	},

	STATE = {
		DESKTOP = 0;
		LOADING = 1;
		GAMEPLAY = 2;
	}
}