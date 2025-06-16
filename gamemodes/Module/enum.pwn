//#########################################################################//
//##################################| ENUM |###############################//
//#########################################################################//
enum pDataEnum{
	bool:pLoggedIn,
	pUCP[MAX_PLAYER_NAME],
	pName[MAX_PLAYER_NAME],
	pLastLogin[32],
	Float:pHealth, Float:pArmour,
	Float:pPosX, Float:pPosY, Float:pPosZ, Float:pAngle,
	pInterior,
	pVirtualWorld,
	pSkin,
	pLevel,
	Float:pExp,
	pMoney,
	pBirthDate[32],
	pAge[4],
	pWeight,
	pHeight,
	pGender[32],
	pRegion[32]
}
enum CountryListEnum{
	CountryName[32],
}