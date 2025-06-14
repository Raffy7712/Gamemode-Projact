//#########################################################################//
//############################| FUNCTION STOCK |###########################//
//#########################################################################//
stock bool:WeightValidation(playerid, const weight[]){
	for(new i; i < strlen(weight); i++){
		if(weight[i] < '0' || weight[i] > '9'){
			SendClientMessage(playerid, COLOR_RED, "ERROR: Weight must be a number.");
			return false;
		}
	}
	if(strval(weight) < 40 || strval(weight) > 80){
		SendClientMessage(playerid, COLOR_RED, "ERROR: Weight must be between 40 and 80.");
		return false;
	}
	return true;
}
stock IsLeapYear(year){
    return(year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
}
stock ConvertDateFormat(const type, const dateStr[]){
	//type 1 untuk konvert tanggal ke database YYYY/MM/DD
	//type 2 untuk konvert tanggal dari database DD/MM/YYYY
	new datestring[32];
	new day = (dateStr[0] - '0') * 10 + (dateStr[1] - '0');
    new month = (dateStr[3] - '0') * 10 + (dateStr[4] - '0');
    new year = (dateStr[6] - '0') * 1000 + 
               (dateStr[7] - '0') * 100 + 
               (dateStr[8] - '0') * 10 + 
               (dateStr[9] - '0');
	switch(type){
		case 1:{
			format(datestring, sizeof(datestring), "%04d/%02d/%02d", year, month, day);
		}
		case 2:{
			format(datestring, sizeof(datestring), "%02d/%02d/%04d", day, month, year);
		}
		default:{
			format(datestring, sizeof(datestring), "");
		}
	}
	return datestring;
}
stock bool:DateValidation(playerid, const dateStr[]){
	if(strlen(dateStr) != 10){
		SendClientMessage(playerid, COLOR_RED, "ERROR: Date must be in the format DD/MM/YYYY.");
		return false;
	}
	for(new i = 0; i < 10; i++){
        switch(i){
            case 2, 5:{ // Posisi separator
                if(dateStr[i] != '/'){
					SendClientMessage(playerid, COLOR_RED, "ERROR: Invalid date format. Please use DD/MM/YYYY.");
					return false;
				}
            }
            default:{ // Posisi digit
                if(dateStr[i] < '0' || dateStr[i] > '9'){
					SendClientMessage(playerid, COLOR_RED, "ERROR: Invalid character in date. Only digits are allowed.");
					return false;
				}
            }
        }
    }
	new day = (dateStr[0] - '0') * 10 + (dateStr[1] - '0');
    new month = (dateStr[3] - '0') * 10 + (dateStr[4] - '0');
    new year = (dateStr[6] - '0') * 1000 + 
               (dateStr[7] - '0') * 100 + 
               (dateStr[8] - '0') * 10 + 
               (dateStr[9] - '0');

    // Validasi rentang
    if(year < 1950 || year > 2025){
		SendClientMessage(playerid, COLOR_RED, "ERROR: Year must be between 1950 and 2025.");
		return false;
	}
    if(month < 1 || month > 12){
		SendClientMessage(playerid, COLOR_RED, "ERROR: Month must be between 01 and 12.");
		return false;
	}
    
    // Validasi hari berdasarkan bulan
    new maxDays;
    switch(month){
        case 2: maxDays = IsLeapYear(year) ? 29 : 28;
        case 4, 6, 9, 11: maxDays = 30;
        default: maxDays = 31;
    }
	if(day < 1 || day > maxDays){
		SendClientMessage(playerid, COLOR_RED, "ERROR: Invalid day for the specified month.");
		return false;
	}
	return true;
}

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
