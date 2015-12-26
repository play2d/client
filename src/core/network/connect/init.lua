local Path = ...

Core.Connect.Response = {}

require(Path..".connect")
require(Path..".response_accepted")
require(Path..".response_difver")
require(Path..".response_ipban")
require(Path..".response_loginban")
require(Path..".response_nameban")
require(Path..".response_slotunavail")
require(Path..".response_wrongpass")