Play2D loads the commands from this folder directly to it's environment.
So please do not add commands from untrustful sources, they could be used to steal your login data.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

How to create a command?
1. The console module automatically parses commands and puts their arguments on the vararg (...)
2. The file will be run when the command is executed

Example: myTestCommand.lua

local Args = {...}
if type(Args[1]) == "number" then
	print("My command pushed a number!")
else
	print("My command pushed something else!")
end