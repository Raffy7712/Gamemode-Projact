// ############################################################################################################################################################################### //
// ##########################################################################| Ryuji-RP Basic Gamemode |########################################################################## //
// ############################################################################################################################################################################### //
// #| Developer: 																				|# //																				|# //
// #| 1. Ryuji   																				|# //																				|# //
// #| 2. Raffy   																				|# //																				|# //
// #| 3. Daniel  																				|# //																				|# //
// ############################################################################################################################################################################### //
// #| Thanks To:																				|# //																				|# //
// #| 1. LNH Shironeko   			: Has been an inspiration for us												|# //																|# //
// #| 2. Ryuji  		 		: For the idea of this gamemode													|# //																|# //
// #| 3. Raffy 			 		: have participated in development												|# //																|# //
// #| 4. Daniel			 		: have participated in development												|# //																|# //
// ############################################################################################################################################################################### //
// #####################################################################| Do Not Delete This Credits |############################################################################ //
// ############################################################################################################################################################################### //

#include <a_samp>
#include <a_mysql>
#include <Pawn.CMD>
#include <crashdetect>
#include <sscanf2>

#define FUNC::%0(%1) forward %0(%1); public %0(%1)
#define MYSQL_HOST "localhost"
#define MYSQL_USER "root"
#define MYSQL_PASSWORD ""
#define MYSQL_DATABASE "ryujirp"
#define MAX_CHARACTERS 3
//COLOR
#define COLOR_RED   			0xFF0000FF
#define COLOR_GREEN 			0x00FF00FF
#define COLOR_BLUE  			0x0000FFFF
#define COLOR_ORANGE 			0xFFA500FF
#define COLOR_YELLOW 			0xFFFF00FF
#define COLOR_WHITE  			0xFFFFFFFF


enum{
	DIALOG_OTP,
	DIALOG_LOGIN,
	DIALOG_CREATE_PASSWORD,
	DIALOG_REGISTER_ALERT,
	DIALOG_UCP_CLIST,
	DIALOG_NAME,
	DIALOG_BIRTHDATE,
	DIALOG_GENDER,
	DIALOG_REGION,
	DIALOG_WEIGHT,
	DIALOG_HEIGHT,
}
enum pDataEnum{
	bool:pLoggedIn,
	pUCP[MAX_PLAYER_NAME],
	pName[MAX_PLAYER_NAME],
	pLastLogin,
	Float:pHealth, Float:pArmour,
	Float:pPosX, Float:pPosY, Float:pPosZ, Float:pAngle,
	pInterior,
	pVirtualWorld,
	pSkin,
	pLevel,
	Float:pExp,
	pMoney,
}

new pInfo[MAX_PLAYERS][pDataEnum];
new MySQL:handle;
new PlayerChar[MAX_PLAYERS][MAX_CHARACTERS][MAX_PLAYER_NAME + 1];

forward bool:NameValidation(const nama[]);

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
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]){
	if(dialogid == DIALOG_LOGIN){
		if(response){
			if(strlen(inputtext) < 4 || strlen(inputtext) > 20){
				SendClientMessage(playerid, COLOR_RED, "ERROR: Password must be between 4 and 20 characters.");
				return ShowDialogLogin(playerid);
			}
			new 
				query[256],
				row;
			mysql_format(handle, query, sizeof(query), "SELECT * FROM `account` WHERE `ucp` = '%e' AND `password` = MD5('%e')", pInfo[playerid][pUCP], inputtext);
			mysql_query(handle, query);
			cache_get_row_count(row);
			if(row == 1){
				pInfo[playerid][pLoggedIn] = true;
				SendClientMessage(playerid, COLOR_GREEN, "INFO: Login successful!");
				return ShowDialogClist(playerid);
			}else{
				SendClientMessage(playerid, COLOR_RED, "ERROR: Invalid UCP or password.");
				return ShowDialogLogin(playerid);
			}
		}else{
			SendClientMessage(playerid, COLOR_RED, "INFO: Login cancelled.");
			return Kick(playerid);
		}
	}else if(dialogid == DIALOG_OTP){
		if(response){
			if(strlen(inputtext) < 6 || strlen(inputtext) > 6){
				SendClientMessage(playerid, COLOR_RED, "ERROR: OTP must be exactly 6 characters.");
				return ShowDialogOTP(playerid);
			}
			new 
				query[256],
				row;
			mysql_format(handle, query, sizeof(query), "SELECT * FROM `account` WHERE `ucp` = '%e' AND `otp` = '%e'", pInfo[playerid][pUCP], inputtext);
			mysql_query(handle, query);
			cache_get_row_count(row);
			if(row != 1){
				SendClientMessage(playerid, COLOR_RED, "ERROR: Invalid OTP.");
				return ShowDialogOTP(playerid);
			}else{
				pInfo[playerid][pLoggedIn] = true;
				SendClientMessage(playerid, COLOR_GREEN, "INFO: OTP verified successfully!");
				mysql_format(handle, query, sizeof(query), "UPDATE `account` SET `activated` = 1, `otp` = NULL WHERE `ucp` = '%e'", pInfo[playerid][pUCP]);
				mysql_query(handle, query);
				return ShowDialogCreatePassword(playerid);
			}
		}else{
			SendClientMessage(playerid, COLOR_RED, "INFO: OTP verification cancelled.");
			return Kick(playerid);
		}
	}else if(dialogid == DIALOG_CREATE_PASSWORD){
		if(response){
			if(strlen(inputtext) < 4 || strlen(inputtext) > 20){
				SendClientMessage(playerid, COLOR_RED, "ERROR: Password must be between 4 and 20 characters.");
				return ShowDialogCreatePassword(playerid);
			}
			new query[256];
			mysql_format(handle, query, sizeof(query), "UPDATE `account` SET `password` = MD5('%e') WHERE `ucp` = '%e'", inputtext, pInfo[playerid][pUCP]);
			mysql_query(handle, query);
			pInfo[playerid][pLoggedIn] = true;
			SendClientMessage(playerid, COLOR_GREEN, "INFO: Password created successfully!");
			return ShowDialogLogin(playerid);
		}else{
			SendClientMessage(playerid, COLOR_RED, "INFO: Password creation cancelled.");
			return Kick(playerid);
		}
	}else if(dialogid == DIALOG_UCP_CLIST){
		if(response)
		{
			if(PlayerChar[playerid][listitem][0] == EOS){
				return ShowDialogName(playerid);
			}
			pInfo[playerid][pName] = listitem;
			SetPlayerName(playerid, PlayerChar[playerid][listitem]);
			return LoadChar(playerid, PlayerChar[playerid][listitem]);
			
		}


	}else if(dialogid == DIALOG_NAME){
		if(response){
			if(strlen(inputtext) < 5 || strlen(inputtext) > 25){
				SendClientMessage(playerid, COLOR_RED, "ERROR: Maximum name 20 characters.");
				return ShowDialogName(playerid);
			}
			if(NameValidation(inputtext)){
				new query[256];
				new rows;
				mysql_format(handle, query, sizeof(query), "SELECT * FROM `character` WHERE name = '%e'", inputtext);
				mysql_query(handle, query);
				cache_get_row_count(rows);
				if(rows == 0){
					InsertChar(playerid, inputtext);
				}else{
					SendClientMessage(playerid, COLOR_RED, "ERROR: Character names have been registered");
					ShowDialogName(playerid);
				}
			}else{
				SendClientMessage(playerid, COLOR_RED, "ERROR: Invalid character name");
				ShowDialogName(playerid);
			}
		}else{
			SendClientMessage(playerid, COLOR_RED, "INFO: Character name creation cancelled.");
			return ShowDialogClist(playerid);
		}
	}
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source){
	return 1;
}
//#########################################################################//
//###############################| FUNCTION |##############################//
//#########################################################################//
FUNC::LoadChar(playerid, name[]){
	new 
		query[256],
		row;
	mysql_format(handle, query, sizeof(query), "SELECT * FROM `character` WHERE `ucp` = '%e' AND `name` = '%e'", pInfo[playerid][pUCP], name);
	mysql_query(handle, query);
	cache_get_row_count(row);
	if(row == 1){
		cache_get_value_name(0, "Name", pInfo[playerid][pName], MAX_PLAYER_NAME);
		cache_get_value_name_float(0, "Health", pInfo[playerid][pHealth]);
		cache_get_value_name_float(0, "Armour", pInfo[playerid][pArmour]);
		cache_get_value_name_float(0, "PosX", pInfo[playerid][pPosX]);
		cache_get_value_name_float(0, "PosY", pInfo[playerid][pPosY]);
		cache_get_value_name_float(0, "PosZ", pInfo[playerid][pPosZ]);
		cache_get_value_name_float(0, "Angle", pInfo[playerid][pAngle]);
		cache_get_value_name_int(0, "Interior", pInfo[playerid][pInterior]);
		cache_get_value_name_int(0, "VirtualWorld", pInfo[playerid][pVirtualWorld]);
		cache_get_value_name_int(0, "Skin", pInfo[playerid][pSkin]);
		cache_get_value_name_int(0, "Level", pInfo[playerid][pLevel]);
		cache_get_value_name_float(0, "Exp", pInfo[playerid][pExp]);
		cache_get_value_name_int(0, "Money", pInfo[playerid][pMoney]);
        if(pInfo[playerid][pPosX] == 0.0 && pInfo[playerid][pPosY] == 0.0 && pInfo[playerid][pPosZ] == 0.0){
            pInfo[playerid][pPosX] = 1642.1681;
            pInfo[playerid][pPosY] = -2333.3689;
            pInfo[playerid][pPosZ] = 13.5469;
            pInfo[playerid][pAngle] = 0.0;
        }

        SetSpawnInfo(
            playerid, 0, 1,
            pInfo[playerid][pPosX], pInfo[playerid][pPosY], pInfo[playerid][pPosZ], pInfo[playerid][pAngle],
            0, 0, 0, 0, 0, 0
        );

        SpawnPlayer(playerid);

        SetPlayerHealth(playerid, pInfo[playerid][pHealth]);
        SetPlayerArmour(playerid, pInfo[playerid][pArmour]);
		SetPlayerScore(playerid, pInfo[playerid][pLevel]);
        SetPlayerInterior(playerid, 0);
        SetPlayerVirtualWorld(playerid, 0);
        SetPlayerColor(playerid, COLOR_RED);
        SetPlayerName(playerid, pInfo[playerid][pName]);
        SetPlayerSkin(playerid, 1);
		GivePlayerMoney(playerid, pInfo[playerid][pMoney]);

        SendClientMessage(playerid, COLOR_GREEN, "You have successfully spawned.");
        return 1;
	}else{
		SendClientMessage(playerid, COLOR_RED, "ERROR: Character not found.");
		return ShowDialogClist(playerid);
	}
}
FUNC::InsertChar(playerid, name[]){
	new query[256];
	mysql_format(handle, query, sizeof(query), "INSERT INTO `character` (`UCP`, `Name`) VALUES ('%e', '%e')", pInfo[playerid][pUCP], name);
	mysql_query(handle, query);
	return ShowDialogClist(playerid);
}
FUNC::ShowDialogName(playerid){
	new dialogtext[256];
	format(dialogtext, sizeof(dialogtext), "Please enter your character name.\n\nExample: Daniel_Alexander");
	ShowPlayerDialog(playerid, DIALOG_NAME, DIALOG_STYLE_INPUT, "Character Name", dialogtext, "Next", "Cancel");
	return 1;
}
FUNC::ShowDialogClist(playerid){
	new 
		name[256], 
		count, 
		sgstr[128], 
		query[256];

	mysql_format(handle, query, sizeof(query), "SELECT * FROM `character` WHERE `ucp` = '%e'", pInfo[playerid][pUCP]);
	mysql_query(handle, query);

	for(new i = 0; i < MAX_CHARACTERS; i ++){
		PlayerChar[playerid][i][0] = EOS;
	}

	for (new i = 0; i < cache_num_rows(); i ++){
		cache_get_value_name(i, "Name", PlayerChar[playerid][i]);
	}

	for(new i; i < MAX_CHARACTERS; i ++) if(PlayerChar[playerid][i][0] != EOS){
	    format(sgstr, sizeof(sgstr), "%s\n", PlayerChar[playerid][i]);
		strcat(name, sgstr);
		count++;
	}

	if(count < MAX_CHARACTERS){
		strcat(name, "< Create Character >");
	}

	ShowPlayerDialog(playerid, DIALOG_UCP_CLIST, DIALOG_STYLE_LIST, "Character List", name, "Select", "Cancel");
	return 1;
}
FUNC::UCPCheck(playerid){
	new 
		query[256],
		row,
		active;
	mysql_format(handle, query, sizeof(query), "SELECT ucp, activated FROM `account` WHERE `ucp` = '%e'", pInfo[playerid][pUCP]);
	mysql_query(handle, query);
	cache_get_row_count(row);
	cache_get_value_name_int(0, "activated", active);
	if(!row){
		return ShowDialogRegisterAlert(playerid);
	}if(row == 1){
		if(active == 0){
			ShowDialogOTP(playerid);
		}else{
			ShowDialogLogin(playerid);
		}
		return 1;
	}
	return 1;
}
FUNC::ShowDialogCreatePassword(playerid){
	new dialogtext[256];
	format(dialogtext, sizeof(dialogtext), "Welcome to Ryuji-RP\nUCP Account: %s\nLast Login: %s\nPlease create a password for your account.", pInfo[playerid][pUCP], pInfo[playerid][pLastLogin]);
	ShowPlayerDialog(playerid, DIALOG_CREATE_PASSWORD, DIALOG_STYLE_PASSWORD, "Create Password", dialogtext, "Create", "Cancel");
	return 1;
}
FUNC::ShowDialogOTP(playerid){
	new dialogtext[256];
	format(dialogtext, sizeof(dialogtext), "Welcome to Ryuji-RP\nUCP Account: %s\nPlease enter the OTP code that has been sent by the bot.", pInfo[playerid][pUCP]);
	ShowPlayerDialog(playerid, DIALOG_OTP, DIALOG_STYLE_INPUT, "OTP Verification", dialogtext, "Verify", "Cancel");
	return 1;
}
FUNC::ShowDialogLogin(playerid){
	new dialogtext[256];
	format(dialogtext, sizeof(dialogtext), "Welcome to Ryuji-RP\nUCP Account: %s\nLast Login: %s\nPlease enter your password to continue.", pInfo[playerid][pUCP], pInfo[playerid][pLastLogin]);
	ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login", dialogtext, "Login", "Cancel");
	return 1;
}
FUNC::ShowDialogRegisterAlert(playerid){
	new dialogtext[256];
	format(dialogtext, sizeof(dialogtext), "Welcome to Ryuji-RP\nUCP Account: %s\n\nYour UCP account is not registered.\nPlease register your account to continue.", pInfo[playerid][pUCP]);
	ShowPlayerDialog(playerid, DIALOG_REGISTER_ALERT, DIALOG_STYLE_MSGBOX, "Register Alert", dialogtext, "OK", "");
	return 1;
}

//#########################################################################//
stock GetLastLogin(playerid){
	new query[256], row, datetime[64];
	mysql_format(handle, query, sizeof(query), "SELECT * FROM `account` WHERE ucp = '%e'", pInfo[playerid][pUCP]);
	mysql_query(handle, query);
	cache_get_row_count(row);
	cache_get_value_name(0, "LastLogin", datetime, sizeof(datetime));
	if(row == 1){
		if(strlen(datetime) > 0){
			format(pInfo[playerid][pLastLogin], 64, "%s", datetime);
		}else{
			format(pInfo[playerid][pLastLogin], 64, "Unknown");
		}
	}else{
		format(pInfo[playerid][pLastLogin], 64, "Unknown");
	}
	return 1;
}
stock GetDateTime(const type[]){
    new year, month, day;
    new hour, minute, second;
    new result[64];

    if (strcmp(type, "date", true) == 0){
        getdate(year, month, day);
        format(result, sizeof(result), "%02d/%02d/%04d", day, month, year);
    }else if (strcmp(type, "time", true) == 0){
        gettime(hour, minute, second);
        format(result, sizeof(result), "%02d:%02d:%02d", hour, minute, second);
    }else if (strcmp(type, "datetime", true) == 0){
        getdate(year, month, day);
        gettime(hour, minute, second);
        format(result, sizeof(result), "%02d/%02d/%04d %02d:%02d:%02d", day, month, year, hour, minute, second);
    }else{
        format(result, sizeof(result), "Invalid type");
    }
    return result;
}
stock SavePlayerData(playerid){
	new 
		Float:PosX, Float:PosY, Float:PosZ, Float:Angle,
		Float:Health, Float:Armour, Money, 
		Level, Interior, VirtualWorld, Skin;
	new query[1024];
	new datetime[64];

	GetPlayerPos(playerid, PosX, PosY, PosZ);
	GetPlayerFacingAngle(playerid, Angle);
	GetPlayerHealth(playerid, Health);
	GetPlayerArmour(playerid, Armour);
	Money = GetPlayerMoney(playerid);
	Level = GetPlayerScore(playerid);
	Interior = GetPlayerInterior(playerid);
	VirtualWorld = GetPlayerVirtualWorld(playerid);
	Skin = GetPlayerSkin(playerid);
	datetime = GetDateTime("datetime");

	pInfo[playerid][pPosX] = PosX;
	pInfo[playerid][pPosY] = PosY;
	pInfo[playerid][pPosZ] = PosZ;
	pInfo[playerid][pAngle] = Angle;
	pInfo[playerid][pHealth] = Health;
	pInfo[playerid][pArmour] = Armour;
	pInfo[playerid][pMoney] = Money;
	pInfo[playerid][pLevel] = Level;
	pInfo[playerid][pInterior] = Interior;
	pInfo[playerid][pVirtualWorld] = VirtualWorld;
	pInfo[playerid][pSkin] = Skin;

	mysql_format(
		handle, query, sizeof(query), 
		"UPDATE `character` SET\
		 Health = '%f', Armour = '%f', PosX = '%f', PosY = '%f', \
		 PosZ = '%f', Angle = '%f', Money = '%d', Level = '%d', \
		 Exp = '%f', Interior = '%d', VirtualWorld = '%d', Skin = '%d' WHERE Name = '%s'",
		pInfo[playerid][pHealth], pInfo[playerid][pArmour], pInfo[playerid][pPosX],
		pInfo[playerid][pPosY], pInfo[playerid][pPosZ], pInfo[playerid][pAngle],
		pInfo[playerid][pMoney], pInfo[playerid][pLevel], pInfo[playerid][pExp],
		pInfo[playerid][pInterior], pInfo[playerid][pVirtualWorld], 
		pInfo[playerid][pSkin], pInfo[playerid][pName]
	);
	mysql_query(handle, query);
	mysql_format(handle, query, sizeof(query), "UPDATE `account` SET LastLogin = '%e' WHERE ucp = '%e'", datetime, pInfo[playerid][pUCP]);
	mysql_query(handle, query);
	return 1;
}
stock bool:NameValidation(const nama[]){
    new len = strlen(nama);
    new bool:Underscore = false;
    for(new i = 0; i < len; i++){
        if(nama[i] == '_'){
            Underscore = true;
        }else if(!((nama[i] >= 'A' && nama[i] <= 'Z') || (nama[i] >= 'a' && nama[i] <= 'z'))){
            return false;
        }
    }
    return Underscore;
}
stock GetName(playerid){
	GetPlayerName(playerid, pInfo[playerid][pUCP], MAX_PLAYER_NAME);
	return pInfo[playerid][pUCP];
}
stock ResetEnum(playerid){
	pInfo[playerid][pLoggedIn] = false;
	pInfo[playerid][pUCP] = 0;
	pInfo[playerid][pName] = 0;
	pInfo[playerid][pLastLogin] = 0;
	pInfo[playerid][pHealth] = 100;
	pInfo[playerid][pArmour] = 0;
	pInfo[playerid][pPosX] = 0.0;
	pInfo[playerid][pPosY] = 0.0;
	pInfo[playerid][pPosZ] = 0.0;
	pInfo[playerid][pAngle] = 0.0;
	pInfo[playerid][pMoney] = 0;
	pInfo[playerid][pLevel] = 0;
	pInfo[playerid][pExp] = 0.0;
	pInfo[playerid][pInterior] = 0;
	pInfo[playerid][pVirtualWorld] = 0;
	pInfo[playerid][pSkin] = 0;
	return 1;
}
stock MySQL_SetupConnection(ttl = 3){
	print("[MySQL] Menghubungkan ke database...");

	handle = mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_PASSWORD, MYSQL_DATABASE);

	if(mysql_errno(handle) != 0){
		if(ttl > 1){
			print("[MySQL] Connection to database failed.");
			printf("[MySQL] Trying again (TTL: %d).", ttl-1);
			return MySQL_SetupConnection(ttl-1);
		}else{
			print("[MySQL] Connection to database failed.");
			print("[MySQL] Please check MySQL Login Information.");
			print("[MySQL] Turning off the server");
			return SendRconCommand("exit");
		}
	}
	printf("[MySQL] Connection to database successful! Handle: %d", _:handle);
	return 1;
}
