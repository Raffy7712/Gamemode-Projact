// This is a comment
// uncomment the line below if you want to write a filterscript
//#define FILTERSCRIPT
#include <a_samp>
#include <a_mysql>
#include <Pawn.CMD>
#include <crashdetect>
#include <sscanf2>


#define MYSQL_HOST "localhost"
#define MYSQL_USER "root"
#define MYSQL_PASSWORD ""
#define MYSQL_DATABASE "ryujirp"
#define FUNC::%0(%1) forward %0(%1); public %0(%1)
#define MAX_CHARS 3
#define COLOR_RED 0xff0000AA
#define COLOR_GREEN 0x00ff00AA

enum{
    DIALOG_LOGIN,
    DIALOG_INVALID_UCP,
	DIALOG_OTP,
    DIALOG_CREATE_PW,
    DIALOG_UCP,
    DIALOG_CREATE_CHAR,
    DIALOG_AGE,
    DIALOG_GENDER,
    DIALOG_REGION
}
enum pDataEnum{
	bool:pLoggedIn,
	pUcp,
	pName,
	pAge,
	pGender,
	pRegion,
	Int:pMoney,
	Float:pHealth,Float:pArmour,
	Float:pPosX,Float:pPosY,Float:pPosZ,Float:pAngle,
}
enum cDataEnum{
	cName[MAX_PLAYER_NAME],
	cAge,
	cGender,
	cRegion,
	cVip,
	cLevel,
	cExp,
	cMoney,
	Float:cPosX,Float:cPosY,Float:cPosZ,Float:cAngle,
	Float:cHealth,Float:cArmour,
}


//15 itu menyesuaikan jumlah negara nya
new RegionList[15][64] = {
	"United States",
	"United Kingdom",
	"Canada",
	"Mexico",
	"Australia",
	"Germany",
	"France",
	"Italy",
	"Spain",
	"Japan",
	"China",
	"South Korea",
	"Brazil",
	"India",
	"Russia"
};

new pInfo[MAX_PLAYERS][pDataEnum];
new cData[MAX_PLAYERS][cDataEnum];
new MySQL:handle;

forward bool:NameValidation(const nama[]);

#if defined FILTERSCRIPT

public OnFilterScriptInit(){
    print("\n======================================");
    print("==| Blank Filterscript by Ryuji Haston |==");
    print("======================================\n");
    return 1;
}

public OnFilterScriptExit(){
    return 1;
}

#else

main(){
    print("======================================");
    print("========| Ryuji-RP Is started |=======");
    print("======================================\n");
    return 1;
}

#endif

public OnGameModeInit() {
    SetGameModeText("Ryuji-RP");
	MySQL_SetupConnection(3);
    AddPlayerClass(0, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
    return 1;
}

public OnGameModeExit(){
    if (handle != MYSQL_INVALID_HANDLE){
        mysql_close(handle);
        print("MySQL connection closed.");
    }
    return 1;
}

public OnPlayerRequestClass(playerid, classid) {
    SetPlayerPos(playerid, 1958.3783, 1343.1572, 15.3746);
    SetPlayerCameraPos(playerid, 1958.3783, 1343.1572, 15.3746);
    SetPlayerCameraLookAt(playerid, 1958.3783, 1343.1572, 15.3746);

    if (pInfo[playerid][pUcp] == 0) {
        SendClientMessage(playerid, 0xFF0000AA, "ERROR: UCP is not initialized.");
        return 0;
    }

    new query[256];
    mysql_format(handle, query, sizeof(query), "SELECT * FROM `account` WHERE name = '%e'", pInfo[playerid][pUcp]);
    mysql_pquery(handle, query, "CheckPlayerUCP", "d", playerid);
    return 1;
}

public OnPlayerConnect(playerid){
	EnumReset(playerid);
	GetName(playerid);
	return 1;
}

public OnPlayerDisconnect(playerid, reason) {
    // Periksa apakah pemain memiliki data yang valid
    if (strlen(cData[playerid][cName])) {
        // Dapatkan data pemain secara real-time
        new Float:posX, Float:posY, Float:posZ, Float:angle;
        new Float:health, Float:armour;
        new money;

        // Ambil posisi, sudut, kesehatan, armor, dan uang pemain
        GetPlayerPos(playerid, posX, posY, posZ);
        GetPlayerFacingAngle(playerid, angle);
        GetPlayerHealth(playerid, health);
        GetPlayerArmour(playerid, armour);
        money = GetPlayerMoney(playerid);

        // Perbarui data di enum
        cData[playerid][cPosX] = posX;
        cData[playerid][cPosY] = posY;
        cData[playerid][cPosZ] = posZ;
        cData[playerid][cAngle] = angle;
        cData[playerid][cHealth] = health;
        cData[playerid][cArmour] = armour;
        cData[playerid][cMoney] = money;

        // Buat query untuk memperbarui data pemain di database
        new query[512];
        mysql_format(
            handle, query, sizeof(query),
            "UPDATE `character` SET PosX = '%f', PosY = '%f', PosZ = '%f', Angle = '%f', Health = '%f', Armour = '%f', Money = '%d', Level = '%d', Exp = '%d' WHERE Name = '%e'",
            posX, posY, posZ, angle, health, armour, money,
            cData[playerid][cLevel], cData[playerid][cExp], cData[playerid][cName]
        );
        mysql_query(handle, query);
    }

    // Reset data pemain di enum
    EnumReset(playerid);

    return 1;
}

public OnPlayerSpawn(playerid){
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]){
	if(dialogid == DIALOG_OTP){
		if(response == 0) return Kick(playerid);
		if(response == 1){
			if(strlen(inputtext) < 6){
				ShowDialogOTP(playerid);
				SendClientMessage(playerid, 0xFF0000AA, "ERROR: OTP must be 6 characters.");
			}
			new query[256];
			mysql_format(handle, query, sizeof(query), "SELECT * FROM `account` WHERE name = '%e' AND otp = '%e'", pInfo[playerid][pUcp], inputtext);
			mysql_pquery(handle, query, "CheckAccountOTP", "d", playerid);
		}
	}else if(dialogid == DIALOG_CREATE_PW){
		if(response == 0) return Kick(playerid);
		if(response == 1){
			if(strlen(inputtext) < 5){
				ShowDialogCreatePW(playerid);
				SendClientMessage(playerid, 0xff0000AA, "ERROR: Password must be 5 characters.");
			}else{
				new query[256];
				mysql_format(handle, query, sizeof(query), "UPDATE `account` SET password = MD5('%e'), activated = 1, otp = null WHERE name = '%e'", inputtext, pInfo[playerid][pUcp]);
				mysql_query(handle, query);
				ShowDialogLogin(playerid);
			}
		}
	}else if(dialogid == DIALOG_LOGIN){
		if(response == 0) return Kick(playerid);
		if(response == 1){
			if(strlen(inputtext) < 5){
				ShowDialogLogin(playerid);
				SendClientMessage(playerid, 0xff0000AA, "ERROR: Password must be 5 characters.");
			}else{
				new query[256];
				new rows;
				mysql_format(handle, query, sizeof(query), "SELECT * FROM `account` WHERE name = '%e' AND password = MD5('%e')", pInfo[playerid][pUcp], inputtext);
				mysql_query(handle, query);
				cache_get_row_count(rows);
				if(rows){
					ShowCharList(playerid);
				}else{
					ShowDialogLogin(playerid);
					SendClientMessage(playerid, 0xff0000AA, "ERROR: Password is incorrect!");
				}
			}
		}
	}else if(dialogid == DIALOG_UCP){
		if(response == 0) return Kick(playerid);
		if(response == 1){
			if(strcmp(inputtext, "<+>Create Character") == 0){
				ShowDialogCreateChar(playerid);
			}else{
				new query[1024];
				new Age[64], Gender[64], Region[64];
				new bool:isAgeNull, bool:isGenderNull, bool:isRegionNull;
				mysql_format(handle, query, sizeof(query), "SELECT Name, Age, Gender, Region FROM `character` WHERE name = '%e'", inputtext);
				mysql_query(handle, query);
				cache_get_value_name(0, "Name", cData[playerid][cName], MAX_PLAYER_NAME);
				cache_get_value_name(0, "Age", Age, sizeof(Age));
				cache_get_value_name(0, "Gender", Gender, sizeof(Gender));
				cache_get_value_name(0, "Region", Region, sizeof(Region));
				cache_is_value_name_null(0, "Age", isAgeNull);
				cache_is_value_name_null(0, "Gender", isGenderNull);
				cache_is_value_name_null(0, "Region", isRegionNull);
				if (isAgeNull || isGenderNull || isRegionNull || !strlen(Age) || !strlen(Gender) || !strlen(Region)) {
					ShowDialogAge(playerid);
				} else {
					SendClientMessage(playerid, COLOR_GREEN, "You have selected the character.");
					LoadChar(playerid, cData[playerid][cName]);
				}
			}
		}
	}else if(dialogid == DIALOG_CREATE_CHAR){
		if(response == 0) return ShowCharList(playerid);
		if(response == 1){
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
					ShowDialogCreateChar(playerid);
				}
			}else{
				SendClientMessage(playerid, COLOR_RED, "ERROR: Invalid character name");
				ShowDialogCreateChar(playerid);
			}
		}
	}else if (dialogid == DIALOG_AGE) {
		if (response == 0) {
			return ShowCharList(playerid);
		}else if (response == 1) {
			new day, month, year;
			new part[3][5];
			new currentPart = 0, pos = 0, i = 0;
			while (inputtext[i] != '\0' && currentPart < 3) {
				if (inputtext[i] == '/') {
					part[currentPart][pos] = '\0';
					currentPart++;
					pos = 0;
				} else {
					part[currentPart][pos] = inputtext[i];
					pos++;
					if (pos >= sizeof(part[])) {
						SendClientMessage(playerid, COLOR_RED, "ERROR: Incorrect date format");
						return ShowDialogAge(playerid);
					}
				}
				i++;
			}
			part[currentPart][pos] = '\0';
			if (currentPart != 2) {
				SendClientMessage(playerid, COLOR_RED, "ERROR: Incomplete date format");
				return ShowDialogAge(playerid);
			}
			if (strlen(part[0]) != 2 || strlen(part[1]) != 2 || strlen(part[2]) != 4) {
				SendClientMessage(playerid, COLOR_RED, "ERROR: Format must be DD/MM/YYYY");
				return ShowDialogAge(playerid);
			}
			day = strval(part[0]);
			month = strval(part[1]);
			year = strval(part[2]);
			if (year < 1900 || year > 2100 || month < 1 || month > 12 || day < 1 || day > 31) {
				SendClientMessage(playerid, COLOR_RED, "ERROR: Invalid date value");
				return ShowDialogAge(playerid);
			}
			new daysInMonth;
			switch (month) {
				case 1, 3, 5, 7, 8, 10, 12: daysInMonth = 31;
				case 4, 6, 9, 11: daysInMonth = 30;
				case 2: {
					if ((year % 4 == 0 && year % 100 != 0) || (year % 400 == 0))
						daysInMonth = 29;
					else
						daysInMonth = 28;
				}
			}
			if (day > daysInMonth) {
				SendClientMessage(playerid, COLOR_RED, "ERROR: Invalid date value");
				return ShowDialogAge(playerid);
			}
			new dateStr[11];
			new query[256];
			format(dateStr, sizeof(dateStr), "%02d/%02d/%04d", day, month, year);
			mysql_format(
				handle,
				query, sizeof(query),
				"UPDATE `character` SET Age = '%s' WHERE name = '%s'",
				dateStr,
				cData[playerid][cName]
			);
			mysql_query(handle, query);
			ShowDialogGender(playerid);
		}
	}else if(dialogid == DIALOG_GENDER){
		if(response == 0) return ShowCharList(playerid);
		if(response == 1){
			new query[256];
			switch(listitem){
				case 0: mysql_format(handle, query, sizeof(query), "UPDATE `character` SET Gender = 'Male' WHERE name = '%e'", cData[playerid][cName]);
				case 1: mysql_format(handle, query, sizeof(query), "UPDATE `character` SET Gender = 'Female' WHERE name = '%e'", cData[playerid][cName]);
			}
			mysql_query(handle, query);
			ShowDialogRegion(playerid);
		}
	}else if(dialogid == DIALOG_REGION){
		if(response == 0) return ShowCharList(playerid);
		if(response == 1){
			new query[256];
			mysql_format(handle, query, sizeof(query), "UPDATE `character` SET Region = '%e' WHERE name = '%e'", RegionList[listitem], cData[playerid][cName]);
			mysql_query(handle, query);
			ShowCharList(playerid);
		}
	}
	return 1;
}

//====================================================================================//
//=================================| Server Function |================================//
//====================================================================================//

FUNC::LoadChar(playerid, name[]) {
    new query[256];
    mysql_format(handle, query, sizeof(query), "SELECT * FROM `character` WHERE name = '%e'", name);
    mysql_query(handle, query);

    if (mysql_errno(handle) != 0) {
        SendClientMessage(playerid, COLOR_RED, "ERROR: Failed to load character data");
        return 0;
    } else {
        // Muat data karakter dari database
        cache_get_value_name(0, "Name", cData[playerid][cName], MAX_PLAYER_NAME);
        cache_get_value_name(0, "Age", cData[playerid][cAge], 64);
        cache_get_value_name(0, "Gender", cData[playerid][cGender], 64);
        cache_get_value_name(0, "Region", cData[playerid][cRegion], 64);
        cache_get_value_name_int(0, "Vip", cData[playerid][cVip]);
        cache_get_value_name_int(0, "Level", cData[playerid][cLevel]);
        cache_get_value_name_int(0, "Exp", cData[playerid][cExp]);
        cache_get_value_name_int(0, "Money", cData[playerid][cMoney]);
        cache_get_value_name_float(0, "PosX", cData[playerid][cPosX]);
        cache_get_value_name_float(0, "PosY", cData[playerid][cPosY]);
        cache_get_value_name_float(0, "PosZ", cData[playerid][cPosZ]);
        cache_get_value_name_float(0, "Angle", cData[playerid][cAngle]);
        cache_get_value_name_float(0, "Health", cData[playerid][cHealth]);
        cache_get_value_name_float(0, "Armour", cData[playerid][cArmour]);

        if (!strlen(cData[playerid][cName])) {
            SendClientMessage(playerid, COLOR_RED, "ERROR: Character data is not loaded.");
            return 0;
        }

        if (cData[playerid][cPosX] == 0.0 && cData[playerid][cPosY] == 0.0 && cData[playerid][cPosZ] == 0.0) {
            cData[playerid][cPosX] = 1642.1681;
            cData[playerid][cPosY] = -2333.3689;
            cData[playerid][cPosZ] = 13.5469;
            cData[playerid][cAngle] = 0.0;
        }

        // Atur informasi spawn pemain
        SetSpawnInfo(
            playerid, 0, 1, // Team dan Skin ID
            cData[playerid][cPosX], cData[playerid][cPosY], cData[playerid][cPosZ], cData[playerid][cAngle], // Posisi dan Sudut
            0, 0, 0, 0, 0, 0 // Senjata dan Ammo
        );

        // Spawn pemain
        SpawnPlayer(playerid);

        // Atur atribut tambahan
        SetPlayerHealth(playerid, cData[playerid][cHealth]);
        SetPlayerArmour(playerid, cData[playerid][cArmour]);
        SetPlayerInterior(playerid, 0);
        SetPlayerVirtualWorld(playerid, 0);
        SetPlayerColor(playerid, COLOR_RED);
        SetPlayerName(playerid, cData[playerid][cName]);
        SetPlayerSkin(playerid, 1);

        // Hapus pengaturan kamera statis agar kamera mengikuti pemain
        SendClientMessage(playerid, COLOR_GREEN, "You have successfully spawned.");
        return 1;
    }
}

FUNC::InsertChar(playerid, name[]){
	new query[256];
	mysql_format(handle, query, sizeof(query), "INSERT INTO `character` (Ucp, Name, Health) VALUES ('%e', '%e', 100)", pInfo[playerid][pUcp], name);
	mysql_query(handle, query);
	if(mysql_errno(handle) != 0){
		SendClientMessage(playerid, COLOR_RED, "ERROR: Failed to create character");
		return 0;
	}else{
		SendClientMessage(playerid, COLOR_GREEN, "Successfully created a character");
		return 1;
	}
}
FUNC::CheckAccountOTP(playerid){
	new row;
	cache_get_row_count(row);
	if(row == 0){
		ShowDialogOTP(playerid);
		SendClientMessage(playerid, 0xff0000AA, "ERROR: The OTP code you entered is incorrect!");
	}else{
		ShowDialogCreatePW(playerid);
	}
}
FUNC::CheckPlayerUCP(playerid){
	new row;
	cache_get_row_count(row);
	if(row == 0){
		ShowDialogInvalidUCP(playerid);
	}else{
		new bool:activated;
		cache_get_value_name_bool(0, "Activated", activated);
		if(activated){
			ShowDialogLogin(playerid);
		}else{
			ShowDialogOTP(playerid);
		}
	}
	return 1;
}
FUNC::ShowDialogInvalidUCP(playerid){
	ShowPlayerDialog(playerid, DIALOG_INVALID_UCP, DIALOG_STYLE_MSGBOX, "Invalid UCP", "Your UCP account is invalid, please register first.", "OK", "");
	return 1;
}
FUNC::ShowDialogOTP(playerid){
	ShowPlayerDialog(playerid, DIALOG_OTP, DIALOG_STYLE_INPUT, "Enter OTP", "Please enter your OTP", "Submit", "Cancel");
	return 1;
}
FUNC::ShowDialogCreatePW(playerid){
	ShowPlayerDialog(playerid, DIALOG_CREATE_PW, DIALOG_STYLE_PASSWORD, "Create Password", "Please enter new your password", "Submit", "Cancel");
	return 1;
}
FUNC::ShowDialogLogin(playerid){
	ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login", "Please enter your password", "Login", "Cancel");
	return 1;
}
FUNC::ShowCharList(playerid){
	new query[256];
	new count = 0;
	new rows;
	new dialogcontent[2048];
	mysql_format(handle, query, sizeof(query), "SELECT * FROM `character` WHERE ucp = '%e'", pInfo[playerid][pUcp]);
	mysql_query(handle, query);
	cache_get_row_count(rows);
	format(dialogcontent, sizeof(dialogcontent), "Name\tLevel\n");
	if(mysql_errno(handle) != 0){
		format(dialogcontent, sizeof(dialogcontent), "ERROR: Failed to load character list");
	}else{
		for (new i = 0; i < rows; i++){
			new name[512];
			new int:level;
			cache_get_value_name(i, "Name", name);
			cache_get_value_name_int(i, "Level", level);
			format(dialogcontent, sizeof(dialogcontent), "%s%s\t%d\n", dialogcontent, name, level);
			count++;
		}
		if(count < MAX_CHARS){
			format(dialogcontent, sizeof(dialogcontent), "%s<+>Create Character", dialogcontent);
		}
	}
	ShowPlayerDialog(playerid, DIALOG_UCP, DIALOG_STYLE_TABLIST_HEADERS, "Panel UCP", dialogcontent, "Select", "Quit");
	return 1;
}
FUNC::ShowDialogCreateChar(playerid){
	ShowPlayerDialog(playerid, DIALOG_CREATE_CHAR, DIALOG_STYLE_INPUT, "Create Character", "Please enter your character name\nExample: Ryuji_Haston", "OK", "");
	return 1;
}
FUNC::ShowDialogAge(playerid){
	ShowPlayerDialog(playerid, DIALOG_AGE, DIALOG_STYLE_INPUT, "Insert Age", "Please enter your character age", "OK", "");
	return 1;
}
FUNC::ShowDialogGender(playerid){
	ShowPlayerDialog(playerid, DIALOG_GENDER, DIALOG_STYLE_LIST, "Insert Gender", "Male\nFemale", "OK", "");
	return 1;
}
FUNC::ShowDialogRegion(playerid){
	new dialogcontent[2048];
	for (new i = 0; i < sizeof(RegionList); i++){
		format(dialogcontent, sizeof(dialogcontent), "%s%s\n", dialogcontent, RegionList[i]);
	}
	dialogcontent[strlen(dialogcontent) - 1] = '\0';
	ShowPlayerDialog(playerid, DIALOG_REGION, DIALOG_STYLE_LIST, "Insert Region", dialogcontent, "OK", "");
	return 1;
}


//====================================================================================//
//==================================| Server Command |================================//
//====================================================================================//
CMD:ping(playerid, params[]){
	SendClientMessage(playerid, 0x00ad06AA, "Pong!");
	return 1;
}



public OnPlayerCommandText(playerid, cmdtext[])
{
	if (strcmp("/mycommand", cmdtext, true, 10) == 0)
	{
		// Do something here
		return 1;
	}
	return 0;
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
	SendClientMessage(playerid, 0xed0000AA , "ERROR: You are not allowed to spawn yet.");
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
stock IsValidDate(day, month, year){
    if (year < 1900 || year > 2100) return false;
    if (month < 1 || month > 12) return false;

    new daysInMonth;

    switch (month)
    {
        case 1, 3, 5, 7, 8, 10, 12: daysInMonth = 31;
        case 4, 6, 9, 11: daysInMonth = 30;
        case 2:
        {
            if ((year % 4 == 0 && year % 100 != 0) || (year % 400 == 0))
                daysInMonth = 29;
            else
                daysInMonth = 28;
        }
        default: return false; // Bulan tidak valid
    }

    return (day >= 1 && day <= daysInMonth);
}
stock bool:NameValidation(const nama[]){
    new len = strlen(nama);
    if(len < 5 || len > 25) return false;

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
stock MySQL_SetupConnection(ttl = 3){
	print("[MySQL] Menghubungkan ke database...");

	handle = mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_PASSWORD, MYSQL_DATABASE);

	if(mysql_errno(handle) != 0){
		if(ttl > 1){
			//Kami mencoba lagi untuk terhubung ke database
			print("[MySQL] Sambungan ke database tidak berhasil.");
			printf("[MySQL] Coba lagi (TTL: %d).", ttl-1);
			return MySQL_SetupConnection(ttl-1);
		}else{
			//Batalkan dan tutup server
			print("[MySQL] Sambungan ke database tidak berhasil.");
			print("[MySQL] Silakan periksa Informasi Login MySQL.");
			print("[MySQL] Mematikan server");
			return SendRconCommand("exit");
		}
	}
	printf("[MySQL] Koneksi ke database berhasil! Menangani: %d", _:handle);
	return 1;
}
stock GetName(playerid){
	GetPlayerName(playerid, pInfo[playerid][pUcp], MAX_PLAYER_NAME);
	return pInfo[playerid][pUcp];
}
stock EnumReset(playerid){
    pInfo[playerid][pUcp] = 0;
    pInfo[playerid][pName] = 0;
    pInfo[playerid][pLoggedIn] = false;
    return 1;
}
