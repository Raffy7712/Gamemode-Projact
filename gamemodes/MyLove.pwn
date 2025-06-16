// ############################################################################################################################################################################### //
// ##################################################################| Ryuji-RP Basic Gamemode |################################################################################## //
// ############################################################################################################################################################################### //
// #| Developer: 																|| Thanks To:																					|# //
// #| 1. Ryuji   																|| 1. LNH Shironeko		: Has been an inspiration for us										|# //
// #| 2. Raffy   																|| 2. Ryuji  		 	: For the idea of this gamemode											|# //
// #| 3. Daniel  																|| 3. Raffy 			: have participated in development										|# //
// #| 																			|| 4. Daniel 			: For the idea of this gamemode											|# //
// ############################################################################################################################################################################### //
// ##################################################################| Do Not Delete This Credits |############################################################################### //
// ############################################################################################################################################################################### //

#include <a_samp>
#include <a_mysql>
#include <Pawn.CMD>
#include <crashdetect>
#include <sscanf2>
#include <easydialog>
#include <Pawn.CMD>
#include "./module/core.pwn"

#if defined FILTERSCRIPT
public OnFilterScriptInit(){
	return 1;
}

public OnFilterScriptExit(){
	return 1;
}

#else

main(){
	print("\n----------------------------------");
	print(" Ryuji-RP Basic Gamemode");
	print(" Version: 1.0");
	print("----------------------------------\n");
}

#endif

public OnGameModeInit(){
	SetGameModeText("Ryuji-RP");
	MySQL_SetupConnection(3);
	AddPlayerClass(0, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
	return 1;
}

public OnGameModeExit(){
	if(handle != MYSQL_INVALID_HANDLE){
		mysql_close(handle);
		print("[MySQL] connection closed.");
	}
	return 1;
}

public OnPlayerRequestClass(playerid, classid){
	SetPlayerPos(playerid, 1958.3783, 1343.1572, 15.3746);
    SetPlayerCameraPos(playerid, 1958.3783, 1343.1572, 15.3746);
    SetPlayerCameraLookAt(playerid, 1958.3783, 1343.1572, 15.3746);
    if (pInfo[playerid][pUCP] == 0) {
        SendClientMessage(playerid, COLOR_RED, "ERROR: UCP is not initialized.");
        return 0;
    }
	UCPCheck(playerid);
	return 1;
}

public OnPlayerConnect(playerid){
	ResetEnum(playerid);
	GetName(playerid);
	GetLastLogin(playerid);
	return 1;
}

public OnPlayerDisconnect(playerid, reason){
	SavePlayerData(playerid);
	ResetEnum(playerid);
	return 1;
}

public OnPlayerSpawn(playerid){
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason){
	return 1;
}

public OnVehicleSpawn(vehicleid){
	return 1;
}

public OnVehicleDeath(vehicleid, killerid){
	return 1;
}

public OnPlayerText(playerid, text[]){
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[]){
	if (strcmp("/mycommand", cmdtext, true, 10) == 0){
		// Do something here
		return 1;
	}
	return 0;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger){
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid){
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate){
	return 1;
}

public OnPlayerEnterCheckpoint(playerid){
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid){
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid){
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid){
	return 1;
}

public OnRconCommand(cmd[]){
	return 1;
}

public OnPlayerRequestSpawn(playerid){
	SendClientMessage(playerid, COLOR_RED , "ERROR: You are not allowed to spawn yet.");
	return 0;
}

public OnObjectMoved(objectid){
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid){
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid){
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid){
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid){
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2){
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row){
	return 1;
}

public OnPlayerExitedMenu(playerid){
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid){
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys){
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success){
	return 1;
}

public OnPlayerUpdate(playerid){
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid){
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid){
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid){
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid){
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source){
	return 1;
}