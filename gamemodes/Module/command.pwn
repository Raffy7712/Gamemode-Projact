//#########################################################################//
//################################| COMMAND |##############################//
//#########################################################################//
CMD:stats(playerid){
    new dialogtext[512];
    format(dialogtext, sizeof(dialogtext), 
        "Name: %s\n\
        UCP: %s\n\
        Health: %.2f\n\
        Armour: %.2f\n\
        Money: $%d\n\
        Level: %d\n\
        Exp: %.2f\n\
        Birthdate: %s\n\
        Age: %s\n\
        Weight: %d\n\
        Height: %d\n\
        Gender: %s\n\
        Region: %s\n\
        Skin: %d\n\
        Position: (%.2f, %.2f, %.2f)\n\
        Angle: %.2f\n\
        Interior: %d\n\
        Virtual World: %d\n\
        Last Login: %s\n",
        pInfo[playerid][pName],
        pInfo[playerid][pUCP],
        pInfo[playerid][pHealth],
        pInfo[playerid][pArmour],
        pInfo[playerid][pMoney],
        pInfo[playerid][pLevel],
        pInfo[playerid][pExp],
        pInfo[playerid][pBirthDate],
        pInfo[playerid][pAge],
        pInfo[playerid][pWeight],
        pInfo[playerid][pHeight],
        pInfo[playerid][pGender],
        pInfo[playerid][pRegion],
        pInfo[playerid][pSkin],
        pInfo[playerid][pPosX],
        pInfo[playerid][pPosY],
        pInfo[playerid][pPosZ],
        pInfo[playerid][pAngle],
        pInfo[playerid][pInterior],
        pInfo[playerid][pVirtualWorld],
        pInfo[playerid][pLastLogin]
    );
    Dialog_Show(playerid, DIALOG_STATS, DIALOG_STYLE_TABLIST, "Player Stats", dialogtext, "Close", "");
    return 1;
}