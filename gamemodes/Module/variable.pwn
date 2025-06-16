//#########################################################################//
//###############################| VARIABLE |##############################//
//#########################################################################//
new pInfo[MAX_PLAYERS][pDataEnum];
new MySQL:handle;
new pCname[MAX_PLAYERS][MAX_CHARACTERS][MAX_PLAYER_NAME + 1];
new pClevel[MAX_PLAYERS][MAX_CHARACTERS];
new pCactived[MAX_PLAYERS][MAX_CHARACTERS];
new pCselect[MAX_PLAYERS];
new CountryList[MAX_COUNTRY][CountryListEnum] = {
    {"Afghanistan"},
    {"Cambodia"},
    {"China"},
    {"Colombia"},
    {"Cuba"},
    {"El Salvador"},
    {"England"},
    {"Finland"},
    {"France"},
    {"Germany"},
    {"Guatemala"},
    {"Honduras"},
    {"Indonesia"},
    {"Italy"},
    {"Japan"},
    {"Mexico"},
    {"Mongolia"},
    {"Myanmar"},
    {"Nicaragua"},
    {"North Korea"},
    {"Palestine"},
    {"Portugal"},
    {"Romania"},
    {"Russia"},
    {"Saudi Arabia"},
    {"Somalia"},
    {"South Africa"},
    {"South Korea"},
    {"United States"},
    {"Venezuela"}
};