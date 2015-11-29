# Play2D
----------------------------------------------------------------------------------------------------
Play2D is a highly Counter-Strike2D inspired game that runs the objective of bringing the players a bigger experience and the developers a much wide modding enviroment by being open source and entirely written and moddable in the scripting language, Lua and using the LÖVE2D to its full extent.


# Installation
----------------------------------------------------------------------------------------------------
* [Packing to LÖVE](#packing)
* [Compiling](#compiling)

<a name="packing"></a>Packing to LÖVE
You'll first need to install LÖVE2D. You can get it from https://www.love2d.org however, if you're not running a debian based distribution, you may need to compile/install LÖVE2D yourself. You'll also need to install the zlib and LFS lua libraries as they serve as a backbone for some operations. We recommend you to use luarocks5.1 (luarocks for Lua version 5.1) to do this as it is quick and easy.

Then, to pack the code into a LÖVE file you just need to compress the code directory into a ZIP and replace the .zip extention with .love. 

You can then run this .love file if löve is properly installed on your machine.
(Eg: packedGame.zip (contains main.lua, conf.lua, sys folder, etc) > packedGame.love)

This way is universal and the process is the same for all operating systems.

<a name="compiling"></a>Compiling into a binary executable
To compile the code into a binary executable you'll first need to pack the code into a .love as explained earlier and...

* Windows
1. Open cmd as administrator
2. Get the path where LÖVE2D is installed to, in most of the cases, C:\Program Files\LOVE\
3. Run the following command to create the executable (it joins LÖVE's executable and the .love packed code) ```copy /b path\to\love.exe+packedGame.love exeBinaryGame.exe```
4. Copy the .dll libraries from LÖVE directory to the new executable directory
5. Launch the compiled executable

* Linux
1. Get the path where LÖVE2D's binary is installed to, in most of the cases, /usr/bin/love
2. Run the following command to create the executable (it joins löve's binary and the .love packed code) ```cat /path/to/love packedGame.love > exeBinaryGame```
3. Mark the file as an executable (give it execute permissions through chmod command): ```chmod a+x ./exeBinaryGame```
4. Launch the compiled executable: ```./exeBinaryGame```
(Note that the compiled executable will not be universal, while it may work on your machine it may not work on others, there's some factors that it will rely on (CPU architecture, distribution, etc))

----------------------------------------------------------------------------------------------------
# Third Parties
----------------------------------------------------------------------------------------------------
Using LÖVE
* https://love2d.org/wiki/License

Using icons from Icons8
* https://icons8.com/license/

Using zlib
* http://www.zlib.net/zlib_license.html

Using LFS
* https://keplerproject.github.io/luafilesystem/license.html

----------------------------------------------------------------------------------------------------
Copyright (c),
	2015-2015, Matías "Starkkz" Hermosilla
	2015-2015, Eero-Antero "tarjoilija" Säisä
	2015-2015, Kelvin "_Yank" Francisco
	2015-2015, Feodor "Pagyra" Vladimirovich 
	2015-2015, Dark Soul
	2015-2015, RYX_Aria

All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.