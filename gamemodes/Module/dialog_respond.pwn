//#########################################################################//
//###########################| DIALOG RESPONSE |###########################//
//#########################################################################//
Dialog:DIALOG_LOGIN(playerid, response, listitem, inputtext[]){
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
}
Dialog:DIALOG_OTP(playerid, response, listitem, inputtext[]){
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
}
Dialog:DIALOG_CREATE_PASSWORD(playerid, response, listitem, inputtext[]){
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
}
Dialog:DIALOG_UCP_CLIST(playerid, response, listitem, inputtext[]){
	if(response){
		if(pCname[playerid][listitem][0] == EOS){
			return ShowDialogName(playerid);
		}else if(pCactived[playerid][listitem] == 0){
			SendClientMessage(playerid, COLOR_GREEN, "INFO: This character is not active.");
			pCselect[playerid] = listitem;
			return ShowDialogBirthDate(playerid);
		}
		pCselect[playerid] = listitem;
		pInfo[playerid][pName] = listitem;
		SetPlayerName(playerid, pCname[playerid][listitem]);
		return LoadChar(playerid, pCname[playerid][listitem]);
	}
	return 1;
}
Dialog:DIALOG_NAME(playerid, response, listitem, inputtext[]){
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
	return 1;
}
Dialog:DIALOG_BIRTHDATE(playerid, response, listitem, inputtext[]){
	if(response){
		new 
			query[256],
			datestring[32];
		if(DateValidation(playerid, inputtext)){
			if(pCactived[playerid][pCselect[playerid]] == 0){
				format(datestring, sizeof(datestring), "%s", ConvertDateFormat(1, inputtext));
				mysql_format(handle, query, sizeof(query), "UPDATE `character` SET birthdate = '%e' WHERE name = '%e' AND ucp = '%e'", datestring, pCname[playerid][pCselect[playerid]], pInfo[playerid][pUCP]);
				mysql_query(handle, query);
				SendClientMessage(playerid, COLOR_GREEN, "INFO: Successfully changed date of birth");
				return ShowDialogWeight(playerid);
			}else{
				format(datestring, sizeof(datestring), "%s", ConvertDateFormat(1, inputtext));
				mysql_format(handle, query, sizeof(query), "UPDATE `character` SET birthdate = '%e' WHERE name = '%e' AND ucp = '%e'", datestring, pCname[playerid][pCselect[playerid]], pInfo[playerid][pUCP]);
				mysql_query(handle, query);
				SendClientMessage(playerid, COLOR_GREEN, "INFO: Successfully changed date of birth");
				return 1;
			}
		}else{
			return ShowDialogBirthDate(playerid);
		}
	}else{
		return ShowDialogClist(playerid);
	}
}
Dialog:DIALOG_WEIGHT(playerid, response, listitem, inputtext[]){
	if(response){
		new query[256];
		if(WeightValidation(playerid, inputtext)){
			if(pCactived[playerid][pCselect[playerid]] == 0){
				mysql_format(handle, query, sizeof(query), "UPDATE `character` SET weight = '%e' WHERE name = '%e' AND ucp = '%e'", inputtext, pCname[playerid][pCselect[playerid]], pInfo[playerid][pUCP]);
				mysql_query(handle, query);
				SendClientMessage(playerid, COLOR_GREEN, "INFO: Successfully changed weight");
				return ShowDialogHeight(playerid);
			}else{
				mysql_format(handle, query, sizeof(query), "UPDATE `character` SET weight = '%e' WHERE name = '%e' AND ucp = '%e'", inputtext, pCname[playerid][pCselect[playerid]], pInfo[playerid][pUCP]);
				mysql_query(handle, query);
				SendClientMessage(playerid, COLOR_GREEN, "INFO: Successfully changed weight");
			}
		}else{
			return ShowDialogWeight(playerid);
		}
	}else{
		return ShowDialogClist(playerid);
	}
	return 1;
}
Dialog:DIALOG_HEIGHT(playerid, response, listitem, inputtext[]){
	if(response){
		new query[256];
		if(HeightValidation(playerid, inputtext)){
			if(pCactived[playerid][pCselect[playerid]] == 0){
				mysql_format(handle, query, sizeof(query), "UPDATE `character` SET height = '%e' WHERE name = '%e' AND ucp = '%e'", inputtext, pCname[playerid][pCselect[playerid]], pInfo[playerid][pUCP]);
				mysql_query(handle, query);
				SendClientMessage(playerid, COLOR_GREEN, "INFO: Successfully changed height");
				return ShowDialogGender(playerid);
			}else{
				mysql_format(handle, query, sizeof(query), "UPDATE `character` SET height = '%e' WHERE name = '%e' AND ucp = '%e'", inputtext, pCname[playerid][pCselect[playerid]], pInfo[playerid][pUCP]);
				mysql_query(handle, query);
				SendClientMessage(playerid, COLOR_GREEN, "INFO: Successfully changed height");
			}
		}else{
			return ShowDialogHeight(playerid);
		}
	}else{
		return ShowDialogClist(playerid);
	}
	return 1;
}
Dialog:DIALOG_GENDER(playerid, response, listitem, inputtext[]){
	if(response){
		new query[256];
		mysql_format(handle, query, sizeof(query), "UPDATE `character` SET gender = '%e' WHERE name = '%e' AND ucp = '%e'", inputtext, pCname[playerid][pCselect[playerid]], pInfo[playerid][pUCP]);
		mysql_query(handle, query);
		SendClientMessage(playerid, COLOR_GREEN, "INFO: Successfully changed gender");
		return ShowDialogRegion(playerid);
	}else{
		return ShowDialogClist(playerid);
	}
}
Dialog:DIALOG_REGION(playerid, response, listitem, inputtext[]){
	if(response){
		new query[256];
		mysql_format(handle, query, sizeof(query), "UPDATE `character` SET region = '%e', actived = '1' WHERE name = '%e' AND ucp = '%e'", inputtext, pCname[playerid][pCselect[playerid]], pInfo[playerid][pUCP]);
		mysql_query(handle, query);
		SendClientMessage(playerid, COLOR_GREEN, "INFO: Successfully changed region");
		return ShowDialogClist(playerid);
	}else{
		return ShowDialogClist(playerid);
	}
}