//#########################################################################//
//###########################| FUNCTION PUBLIC |###########################//
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
FUNC::ShowDialogWeight(playerid){
	new dialogtext[256];
	format(dialogtext, sizeof(dialogtext), "Please enter your character's weight.\n\nExample: 70 (in kg)");
	Dialog_Show(playerid, DIALOG_WEIGHT, DIALOG_STYLE_INPUT, "Character Weight", dialogtext, "Next", "Cancel");
	return 1;
}
FUNC::ShowDialogBirthDate(playerid){
	new dialogtext[256];
	format(dialogtext, sizeof(dialogtext), "Please enter your character's birth date.\n\nExample: 01/01/2000");
	Dialog_Show(playerid, DIALOG_BIRTHDATE, DIALOG_STYLE_INPUT, "Character Birth Date", dialogtext, "Next", "Cancel");
	return 1;
}
FUNC::ShowDialogName(playerid){
	new dialogtext[256];
	format(dialogtext, sizeof(dialogtext), "Please enter your character name.\n\nExample: Daniel_Alexander");
	Dialog_Show(playerid, DIALOG_NAME, DIALOG_STYLE_INPUT, "Character Name", dialogtext, "Next", "Cancel");
	return 1;
}
FUNC::ShowDialogClist(playerid){
	new 
		name[512], 
		count, 
		sgstr[512], 
		query[256];

	name[0] = EOS;
	mysql_format(handle, query, sizeof(query), "SELECT * FROM `character` WHERE `ucp` = '%e'", pInfo[playerid][pUCP]);
	mysql_query(handle, query);
	format(name, sizeof(name), "Name\tLevel\n");
	for(new i = 0; i < MAX_CHARACTERS; i ++){
		pCname[playerid][i][0] = EOS;
		pClevel[playerid][i] = 0;
		pCname[playerid][i][0] = 0;
	}

	for(new i = 0; i < cache_num_rows(); i ++){
		cache_get_value_name(i, "Name", pCname[playerid][i], MAX_PLAYER_NAME);
		cache_get_value_name_int(i, "Level", pClevel[playerid][i]);
		cache_get_value_name_int(i, "Actived", pCactived[playerid][i]);
	}


	for(new i = 0; i < MAX_CHARACTERS; i++){
	    if(pCname[playerid][i][0] != EOS){
    	    format(sgstr, sizeof sgstr, "%s\t%d\n",
    	        pCname[playerid][i],
    	        pClevel[playerid][i]
			);
    	    strcat(name, sgstr);
    	    count++;
    	}
	}

	if(count < MAX_CHARACTERS){
		strcat(name, "< Create Character >");
	}
	Dialog_Show(playerid, DIALOG_UCP_CLIST, DIALOG_STYLE_TABLIST_HEADERS, "Character List", name, "Select", "Cancel");
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
	Dialog_Show(playerid, DIALOG_CREATE_PASSWORD, DIALOG_STYLE_PASSWORD, "Create Password", dialogtext, "Create", "Cancel");
	return 1;
}
FUNC::ShowDialogOTP(playerid){
	new dialogtext[256];
	format(dialogtext, sizeof(dialogtext), "Welcome to Ryuji-RP\nUCP Account: %s\nPlease enter the OTP code that has been sent by the bot.", pInfo[playerid][pUCP]);
	Dialog_Show(playerid, DIALOG_OTP, DIALOG_STYLE_INPUT, "OTP Verification", dialogtext, "Verify", "Cancel");
	return 1;
}
FUNC::ShowDialogLogin(playerid){
	new dialogtext[256];
	format(dialogtext, sizeof(dialogtext), "Welcome to Ryuji-RP\nUCP Account: %s\nLast Login: %s\nPlease enter your password to continue.", pInfo[playerid][pUCP], pInfo[playerid][pLastLogin]);
	Dialog_Show(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login", dialogtext, "Login", "Cancel");
	return 1;
}
FUNC::ShowDialogRegisterAlert(playerid){
	new dialogtext[256];
	format(dialogtext, sizeof(dialogtext), "Welcome to Ryuji-RP\nUCP Account: %s\n\nYour UCP account is not registered.\nPlease register your account to continue.", pInfo[playerid][pUCP]);
	Dialog_Show(playerid, DIALOG_REGISTER_ALERT, DIALOG_STYLE_MSGBOX, "Register Alert", dialogtext, "OK", "");
	return 1;
}