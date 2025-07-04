#if defined _MULTICP_included
	#endinput
#endif

#define _MULTICP_included

#if !defined _samp_included
    #error could not find a_samp.inc, please check your server includes.
#endif

#if !defined _INC_y_iterate
    #tryinclude <YSI_Data\y_iterate>
#endif

#if !defined _INC_y_iterate
    #error Cannot find y_iterate library
#endif

#if !defined _INC_y_hooks
    #tryinclude <YSI_Coding\y_hooks>
#endif

#if !defined _INC_y_iterate
    #error Cannot find y_hooks library
#endif

#if !defined _streamer_included
    #tryinclude <streamer>
#endif
#if !defined _streamer_included
    #error could not find streamer.inc, install streamer library at (github.com/samp-incognito/samp-streamer-plugin)
#endif

#define                 MAX_MULTICP                         100
#define                 INVALID_MULTICP                     -1
#define                 MULTICP_DEFAULT_COL                 0xAA00000FF

forward OnPlayerEnterMultiCP(playerid, cpid);
forward OnPlayerLeaveMultiCP(playerid, cpid);


static
    STREAMER_TAG_AREA:g_cpArea[MAX_PLAYERS][MAX_MULTICP],
    bool:g_cpAutoDisable[MAX_PLAYERS][MAX_MULTICP],
    Iterator:MultiCP<MAX_PLAYERS, MAX_MULTICP>;


stock SetPlayerMultiCP(playerid, cpid, Float:x, Float:y, Float:z, bool:autodisable = false, color = MULTICP_DEFAULT_COL)
{
    if (cpid < 0 || cpid >= MAX_MULTICP)
    {
        print("(error multicp) Invalid cpid.");
        return INVALID_MULTICP;
    }
    if (Iter_Contains(MultiCP<playerid>, cpid))
    {
        print("(error multicp) cpid already in use.");
        return INVALID_MULTICP;
    }
    Iter_Add(MultiCP<playerid>, cpid);
    SetPlayerMapIcon(playerid, cpid, x, y, z, 0, color, MAPICON_GLOBAL_CHECKPOINT);
    g_cpArea[playerid][cpid] = CreateDynamicCylinder(x, y, z - 0.5, z + 0.5, 1.3, _, _, playerid);
    g_cpAutoDisable[playerid][cpid] = autodisable;

    Streamer_SetIntData(STREAMER_TYPE_AREA, g_cpArea[playerid][cpid], E_STREAMER_EXTRA_ID, cpid);
    return cpid;
}

stock DisablePlayerMultiCP(playerid, cpid) {

    if(!Iter_Contains(MultiCP<playerid>, cpid))
        return 0;

    if(IsValidDynamicArea(g_cpArea[playerid][cpid]))
        DestroyDynamicArea(g_cpArea[playerid][cpid]);

    g_cpAutoDisable[playerid][cpid] = false;

    RemovePlayerMapIcon(playerid, cpid);
    Iter_Remove(MultiCP<playerid>, cpid);
    return 1; 
}

stock DisablePlayerAllMultiCP(playerid)
{
    foreach(new cpid : MultiCP<playerid>) if(IsValidDynamicArea(g_cpArea[playerid][cpid]))
    {
        if(IsValidDynamicArea(g_cpArea[playerid][cpid]))
            DestroyDynamicArea(g_cpArea[playerid][cpid]);

        g_cpAutoDisable[playerid][cpid] = false;
        RemovePlayerMapIcon(playerid, cpid);
        
        new next = cpid;
        Iter_SafeRemove(MultiCP<playerid>, next, cpid);
    }
    Iter_Clear(MultiCP<playerid>);
    return 1;

}
stock bool:IsPlayerInMultiCP(playerid, cpid) {

    if(!IsPlayerConnected(playerid))
        return false;

    if(!Iter_Contains(MultiCP<playerid>, cpid))
        return false;

    return (IsPlayerInDynamicArea(playerid, g_cpArea[playerid][cpid]));
}

hook OnPlayerEnterDynArea(playerid, STREAMER_TAG_AREA:areaid) {

    new cpid = INVALID_MULTICP;
    cpid = Streamer_GetIntData(STREAMER_TYPE_AREA, areaid, E_STREAMER_EXTRA_ID);

    if(Iter_Contains(MultiCP<playerid>, cpid))
    {
        if(g_cpAutoDisable[playerid][cpid]) {
            DisablePlayerMultiCP(playerid, cpid); }

        CallLocalFunction(#OnPlayerEnterMultiCP, "dd", playerid, cpid);
    }
}

hook OnPlayerLeaveDynArea(playerid, STREAMER_TAG_AREA:areaid) {

    new cpid = INVALID_MULTICP;
    cpid = Streamer_GetIntData(STREAMER_TYPE_AREA, areaid, E_STREAMER_EXTRA_ID);

    if(Iter_Contains(MultiCP<playerid>, cpid))
    {
        CallLocalFunction(#OnPlayerLeaveMultiCP, "dd", playerid, cpid);
    }
}
