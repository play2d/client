CONST = {
	NET = {
		
		STAGE = {
			CONNECTING = 0,
			CHECKFILES = 1,
			GETFILENAME = 2,
			GETFILE = 3,
			GETSTATE = 4,
			CONFIRM = 5,
			
			CANCEL = 6,
		},
		
		CONMSG = {
			ACCEPTED = 0,
			IPBAN = 1,
			NAMEBAN = 2,
			LOGINBAN = 3,
			DIFVER = 4,
			WRONGPASS = 5,
			SLOTUNAVAIL = 6,
		},
		
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
		SERVERTRANSFER = 1002;
		RCON = 1003;
		CHATMESSAGE = 1004;
		SCREENMESSAGE = 1005;
		USERMESSAGE = 1006;
		
		PLAYERCONNECT = 1200;
		PLAYERCMD = 1201;
		PLAYERRCON = 1202,
		PLAYERJOIN = 1203;
		PLAYERNAME = 1204;
		PLAYERMOVE = 1205;
		PLAYERDAYA = 1206;
		
		PLAYERSCOREBOARD = 1400;
		PLAYERKICKED = 1401;
		PLAYERBANNED = 1402;
		PLAYERCONNECTED = 1403;
		PLAYERDISCONNECTED = 1404;
		PLAYERNAMED = 1405;
		PLAYERMIC = 1406;
	},

	STATE = {
		DESKTOP = 0;
		LOADING = 1;
		GAMEPLAY = 2;
	}
}