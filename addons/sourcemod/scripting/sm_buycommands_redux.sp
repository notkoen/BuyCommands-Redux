#pragma semicolon 1
#pragma newdecls required

#define PLUGIN_AUTHOR "Someone REWORKED by koen"
#define PLUGIN_VERSION "2.1.0"

#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <cstrike>
#include <csgocolors_fix>

int g_iSpam[MAXPLAYERS+1];
int g_iHEAmount[MAXPLAYERS+1];
int g_iFlashAmount[MAXPLAYERS+1];
int g_iDecoyAmount[MAXPLAYERS+1];
int g_iIncAmount[MAXPLAYERS+1];
int g_iTagAmount[MAXPLAYERS+1];
int g_iSnowAmount[MAXPLAYERS+1];

ConVar g_cvar_RebuyCD;

ConVar g_AKPrice;
ConVar g_M4Price;
ConVar g_AUGPrice;
ConVar g_FAMASPrice;
ConVar g_M4SPrice;
ConVar g_GalilPrice;
ConVar g_SG556Price;
ConVar g_cvar_Enable_AR;

ConVar g_SCAR20Price;
ConVar g_AWPPrice;
ConVar g_SSG08Price;
ConVar g_G3SG1Price;
ConVar g_cvar_Enable_Sniper;

ConVar g_P90Price;
ConVar g_BizonPrice;
ConVar g_Mac10Price;
ConVar g_Mp9Price;
ConVar g_Mp7Price;
ConVar g_MP5SDPrice;
ConVar g_UMP45Price;
ConVar g_cvar_Enable_SMG;

ConVar g_NovaPrice;
ConVar g_XM1014Price;
ConVar g_SawedOffPrice;
ConVar g_Mag7Price;
ConVar g_cvar_Enable_Shotgun;

ConVar g_M249Price;
ConVar g_NegevPrice;
ConVar g_cvar_Enable_MG;

ConVar g_USPPrice;
ConVar g_DeagPrice;
ConVar g_F7Price;
ConVar g_GLOCKPrice;
ConVar g_P2KPrice;
ConVar g_CZ7Price;
ConVar g_ELITEPrice;
ConVar g_R8Price;
ConVar g_Tec9Price;
ConVar g_P250Price;
ConVar g_cvar_Enable_Pistol;

ConVar g_KEVPrice;
ConVar g_cvar_Enable_Kevlar;

ConVar g_HEPrice;
ConVar g_HEAmount;
ConVar g_cvar_Enable_HE;
ConVar g_FlashPrice;
ConVar g_FlashAmount;
ConVar g_cvar_Enable_Flash;
ConVar g_DecoyPrice;
ConVar g_DecoyAmount;
ConVar g_cvar_Enable_Decoy;
ConVar g_IncPrice;
ConVar g_IncAmount;
ConVar g_cvar_Enable_Inc;
ConVar g_TagPrice;
ConVar g_TagAmount;
ConVar g_cvar_Enable_Tag;
ConVar g_SnowPrice;
ConVar g_SnowAmount;
ConVar g_cvar_Enable_Snow;

ConVar g_cvar_DropOnRebuy;
EngineVersion g_Game;

public Plugin myinfo =
{
	name = "[ZR] Buy Commands Redux",
	author = PLUGIN_AUTHOR,
	description = "Buy Commands for Zombie:Reloaded",
	version = PLUGIN_VERSION,
	url = ""
};

public void OnPluginStart()
{
	//Check game engine version as plugin is made for CSGO only
	g_Game = GetEngineVersion();
	if (g_Game != Engine_CSGO)
	{
		SetFailState("This plugin is for CSGO only");
	}
	
	CreateConVar("sm_buycommands_version", PLUGIN_VERSION, "Buy Commands version");
	
	/* Rebuy Cooldown Cvar */
	g_cvar_RebuyCD = CreateConVar("sm_rebuy_cooldown", "5", "Rebuy cooldown (in seconds)");
	
	/* AR Price Cvars */
	g_cvar_Enable_AR = CreateConVar("sm_bc_enable_AR", "1", "Enable Assault Rifle buy commands? (1 = Enable | 0 = Disable)", FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_GalilPrice = CreateConVar("sm_bc_galil_p", "1800", "Price of purchasing a Galil-AR");
	g_AKPrice = CreateConVar("sm_bc_ak_p", "2700", "Price of purchasing an AK-47");
	g_SG556Price = CreateConVar("sm_bc_sg556_p", "3000", "Price of purchasing an SG-556");
	g_M4Price = CreateConVar("sm_bc_m4_p", "3100", "Price of purchasing a M4A4");
	g_M4SPrice = CreateConVar("sm_bc_m4s_p", "2900", "Price of purchasing a M4A1-S");
	g_AUGPrice = CreateConVar("sm_bc_aug_p", "3300", "Price of Purchasing an AUG");
	g_FAMASPrice = CreateConVar("sm_bc_famas_p", "2050", "Price of purchasing a FAMAS");
	
	/* Shotgun Price Cvars */
	g_cvar_Enable_Shotgun = CreateConVar("sm_bc_enable_shotgun", "1", "Enable shotgun buy commands? (1 = Enable | 0 = Disable)", FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_NovaPrice = CreateConVar("sm_bc_nova_p", "1050", "Price of purchasing a Nova");
	g_XM1014Price = CreateConVar("sm_bc_xm1014_p", "2000", "Price of purchasing a XM-1014");
	g_Mag7Price = CreateConVar("sm_bc_mag7_p", "1300", "Price of purchasing a Mag-7");
	g_SawedOffPrice = CreateConVar("sm_bc_SawedOff_p", "1100", "Price of purchasing a Sawed-Off");
	
	/* Sniper Price Cvars */
	g_cvar_Enable_Sniper = CreateConVar("sm_bc_enable_sniper", "1", "Enable sniper buy commands? (1 = Enable | 0 = Disable)", FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_SCAR20Price = CreateConVar("sm_bc_scar_p", "5000", "Price of purchasing a SCAR-20");
	g_AWPPrice = CreateConVar("sm_bc_awp_p", "4750", "Price of purchasing an AWP");
	g_SSG08Price = CreateConVar("sm_bc_ssg08_p", "1700", "Price of purchasing a SSG-08");
	g_G3SG1Price = CreateConVar("sm_bc_g3sg1_p", "5000", "Price of purchasing a G3SG1");
	
	/* SMG Price Cvars */
	g_cvar_Enable_SMG = CreateConVar("sm_bc_enable_smg", "1", "Enable SMG buy commands? (1 = Enable | 0 = Disable)", FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_Mac10Price = CreateConVar("sm_bc_mac10_p", "1050", "Price of purchasing a MAC-10");
	g_Mp9Price = CreateConVar("sm_bc_mp9_p", "1250", "Price of purchasing a MP9");
	g_Mp7Price = CreateConVar("sm_bc_mp7_p", "1500", "Price of purchasing a MP7");
	g_MP5SDPrice = CreateConVar("sm_bc_mp5sd_p", "1500", "Price of purchasing a MP5-SD");
	g_UMP45Price = CreateConVar("sm_bc_ump45_p", "1200", "Price of purchasing a UMP-45");
	g_BizonPrice = CreateConVar("sm_bc_bizon_p", "1400", "Price of purchasing a PP-Bizon");
	g_P90Price = CreateConVar("sm_bc_p90_p", "2350", "Price of purchasing a P90");
	
	/* Machine Gun Price Cvars */
	g_cvar_Enable_MG = CreateConVar("sm_bc_enable_mg", "1", "Enable MG buy commands? (1 = Enable | 0 = Disable)", FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_M249Price = CreateConVar("sm_bc_m249_p", "5200", "Price of purchasing a M49");
	g_NegevPrice = CreateConVar("sm_bc_negev_p", "1700", "Price of purchasing a Negev");
	
	/* Pistol Price Cvars */
	g_cvar_Enable_Pistol = CreateConVar("sm_bc_enable_pistol", "1", "Enable pistol buy commands? (1 = Enable | 0 = Disable)", FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_USPPrice = CreateConVar("sm_bc_usp_p", "200", "Price of purshaing a USP-S");
	g_DeagPrice = CreateConVar("sm_bc_deag_p", "700", "Price of purchasing a Desert Eagle");
	g_F7Price = CreateConVar("sm_bc_57_p", "500", "Price of purchasing a Five-seveN");
	g_GLOCKPrice = CreateConVar("sm_bc_glock_p", "200", "Price of purchasing a Glock-18");
	g_P2KPrice = CreateConVar("sm_bc_p2000_p", "200", "Price of purchasing a P-2000");
	g_CZ7Price = CreateConVar("sm_bc_cz_p", "500", "Price of purchasing a CZ-75");
	g_ELITEPrice = CreateConVar("sm_bc_elites_p", "300", "Price of purchasing Dual Barettas");
	g_R8Price = CreateConVar("sm_bc_r8_p", "600", "Price of purchasing a R8 Revolver");
	g_Tec9Price = CreateConVar("sm_bc_tec9_p", "500", "Price of purchasing a Tec-9");
	g_P250Price = CreateConVar("sm_bc_p250_p", "300", "Price of purchasing a P250");
	
	/* Kevlar Price Cvar */
	g_cvar_Enable_Kevlar = CreateConVar("sm_bc_enable_kevlar", "1", "Enable rebuying kevlar? (1 = Enable | 0 = Disable)", FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_KEVPrice = CreateConVar("sm_bc_kev_p", "1000", "Price of rebuying Kevlar and Helmet");
	
	/* Grenade Price Cvars */
	//HE Grenade Cvars
	g_HEPrice = CreateConVar("sm_bc_he_p", "300", "Price of purchasing a HE Grenade");
	g_HEAmount = CreateConVar("sm_bc_he_amount", "1", "Max amount of HE Grenades purchasable per round");
	g_cvar_Enable_HE = CreateConVar("sm_bc_enable_he", "1", "Enable HE Grenade buy command? (1 = Enable | 0 = Disable)", FCVAR_NOTIFY, true, 0.0, true, 1.0);
	//Flashbang Grenade Cvars
	g_FlashPrice = CreateConVar("sm_bc_flash_p", "200", "Price of purchasing a Flashbang");
	g_FlashAmount = CreateConVar("sm_bc_flash_amount", "2", "Max amount of Flashbangs purchasable per round");
	g_cvar_Enable_Flash = CreateConVar("sm_bc_enable_flash", "1", "Enable Flashbang Grenade buy command? (1 = Enable | 0 = Disable)", FCVAR_NOTIFY, true, 0.0, true, 1.0);
	//Decoy Grenade Cvars
	g_DecoyPrice = CreateConVar("sm_bc_decoy_p", "50", "Price of purchasing a Decoy Grenade");
	g_DecoyAmount = CreateConVar("sm_bc_decoy_amount", "0", "Max amount of Decoy Grenades purchasable per round");
	g_cvar_Enable_Decoy = CreateConVar("sm_bc_enable_decoy", "1", "Enable Decoy Grenade buy command? (1 = Enable | 0 = Disable)", FCVAR_NOTIFY, true, 0.0, true, 1.0);
	//Incendiary Grenade Cvars
	g_IncPrice = CreateConVar("sm_bc_inc_p", "600", "Price of purchasing an Incendiary Grenade");
	g_IncAmount = CreateConVar("sm_bc_inc_amount", "1", "Max amount of Incendiary Grenades purchasable per round");
	g_cvar_Enable_Inc = CreateConVar("sm_bc_enable_inc", "1", "Enable Incendiary Grenade buy command? (1 = Enable | 0 = Disable)", FCVAR_NOTIFY, true, 0.0, true, 1.0);
	//Tag grenade
	g_TagPrice = CreateConVar("sm_bc_tag_p", "300", "Price of purchasing a TAG Grenade");
	g_TagAmount = CreateConVar("sm_bc_tag_amount", "1", "Max amount of TAG Grenades purchasable per round");
	g_cvar_Enable_Tag = CreateConVar("sm_bc_enable_tag", "1", "Enable TAG Grenade buy command? (1 = Enable | 0 = Disable)", FCVAR_NOTIFY, true, 0.0, true, 1.0);
	//Snowball Grenade Cvars
	g_SnowPrice = CreateConVar("sm_bc_snow_p", "300", "Price of purchasing a Snowball");
	g_SnowAmount = CreateConVar("sm_bc_snow_amount", "1", "Max amount of Snowballs purchasable per round");
	g_cvar_Enable_Snow = CreateConVar("sm_bc_enable_snow", "0", "Enable Snowball buy command? (1 = Enable | 0 = Disable)", FCVAR_NOTIFY, true, 0.0, true, 1.0);
	
	/* Force drop Cvars */
	g_cvar_DropOnRebuy = CreateConVar("sm_bc_droponrebuy", "1", "Force players to drop their weapons when rebuying? (1 = Enable | 0 = Disable)");

	/* Purchase weapon commands */
	//AK47
	RegConsoleCmd("sm_ak", Command_ak, "Purchases an AK-47");
	RegConsoleCmd("sm_ak47", Command_ak, "Purchases an AK-47");
	//AUG
	RegConsoleCmd("sm_aug", Command_aug, "Purchases an AUG");
	//FAMAS
	RegConsoleCmd("sm_famas", Command_famas, "Purchases a FAMAS");
	//M4A4
	RegConsoleCmd("sm_m4", Command_m4a4, "Purchases a M4A4");
	RegConsoleCmd("sm_m4a4", Command_m4a4, "Purchases a M4A4");
	//M4A1-S
	RegConsoleCmd("sm_m4a1", Command_m4a1s, "Purchases a M4A1-S");
	RegConsoleCmd("sm_m4s", Command_m4a1s, "Purchases a M4A1-S");
	RegConsoleCmd("sm_m4a1s", Command_m4a1s, "Purchases a M4A1-S");
	RegConsoleCmd("sm_a1s", Command_m4a1s, "Purchases a M4A1-S");
	RegConsoleCmd("sm_m4a1-s", Command_m4a1s, "Purchases a M4A1-S");
	//KRIEG
	RegConsoleCmd("sm_sg556", Command_sg556, "Purchases a SG-553");
	RegConsoleCmd("sm_sg553", Command_sg556, "Purchases a SG-553");
	//GALIL
	RegConsoleCmd("sm_galil", Command_Galil, "Purchases a Galil-AR");
	
	//NOVA
	RegConsoleCmd("sm_nova", Command_nova, "Purchases a Nova");
	//XM1014
	RegConsoleCmd("sm_xm", Command_xm1014, "Purchases a XM-1014");
	RegConsoleCmd("sm_xm1014", Command_xm1014, "Purchases a XM-1014");
	//MAG7
	RegConsoleCmd("sm_mag7", Command_mag7, "Purchases a Mag-7");
	RegConsoleCmd("sm_mag", Command_mag7, "Purchases a Mag-7");
	//SAWED OFF
	RegConsoleCmd("sm_sawed", Command_sawed, "Purchases a Sawed-Off");
	RegConsoleCmd("sm_sawedoff", Command_sawed, "Purchases a Sawed-Off");
	
	//SCAR20
	RegConsoleCmd("sm_scar", Command_scar, "Purchases a SCAR-20");
	//AWP
	RegConsoleCmd("sm_awp", Command_awp, "Purchases an AWP");
	//SCOUT
	RegConsoleCmd("sm_ssg", Command_ssg08, "Purchases a SSG-08");
	RegConsoleCmd("sm_scout", Command_ssg08, "Purchases a SSG-08");
	//G3SG1
	RegConsoleCmd("sm_g3sg1", Command_g3sg1, "Purchases a G3SG1");
	RegConsoleCmd("sm_g3s", Command_g3sg1, "Purchases a G3SG1");
	
	//BIZON
	RegConsoleCmd("sm_pp", Command_bizon, "Purchases a PP-Bizon");
	RegConsoleCmd("sm_bizon", Command_bizon, "Purchases a PP-Bizon");
	//P90
	RegConsoleCmd("sm_p90", Command_p90, "Purchases a P90");
	//MAC10
	RegConsoleCmd("sm_mac10", Command_mac10, "Purchases a Mac-10");
	RegConsoleCmd("sm_mac", Command_mac10, "Purchases a Mac-10");
	//MP9
	RegConsoleCmd("sm_mp9", Command_mp9, "Purchases a MP9");
	//MP7
	RegConsoleCmd("sm_mp7", Command_mp7, "Purchases a MP7");
	//MP5
	RegConsoleCmd("sm_mp5", Command_mp5, "Purchases a MP5-SD");
	//UMP45
	RegConsoleCmd("sm_ump", Command_ump45, "Purchases a UMP-45");
	
	//M249
	RegConsoleCmd("sm_m249", Command_m249, "Purchases a M249");
	//NEGEV
	RegConsoleCmd("sm_negev", Command_negev, "Purchases a Negev");
	
	//USP
	RegConsoleCmd("sm_usp", Command_usp, "Purchases an USP-S");
	//GLOCK
	RegConsoleCmd("sm_glock", Command_glock, "Purchases a Glock-18");
	//P250
	RegConsoleCmd("sm_p250", Command_p250, "Purchases a P250");
	//DEAGLE
	RegConsoleCmd("sm_deagle", Command_deag, "Purchases a Desert Eagle");
	//FIVE SEVEN
	RegConsoleCmd("sm_57", Command_57, "Purchases a FiveseveN");
	RegConsoleCmd("sm_fiveseven", Command_57, "Purchases a FiveseveN");
	//CZ
	RegConsoleCmd("sm_cz", Command_cz, "Purchases a CZ-75");
	RegConsoleCmd("sm_cz75", Command_cz, "Purchases a CZ-75");
	//R8
	RegConsoleCmd("sm_r8", Command_r8, "Purchases a R8-Revolver");
	RegConsoleCmd("sm_revolver", Command_r8, "Purchases a R8-Revolver");
	//ELITES
	RegConsoleCmd("sm_elite", Command_elites, "Purchases Dual Elites");
	RegConsoleCmd("sm_elites", Command_elites, "Purchases Dual Elites");
	RegConsoleCmd("sm_dualies", Command_elites, "Purchases Dual Elites");
	//TEC9
	RegConsoleCmd("sm_tec9", Command_tec9, "Purchases a Tec-9");
	RegConsoleCmd("sm_tec", Command_tec9, "Purchases a Tec-9");
	//P2000
	RegConsoleCmd("sm_p2000", Command_p2k, "Purchases a HKP2000");
	RegConsoleCmd("sm_p2k", Command_p2k, "Purchases a HKP2000");

	//Kevlar
	RegConsoleCmd("sm_kev", Command_armor, "Replenish armor");
	RegConsoleCmd("sm_kevlar", Command_armor, "Replenish armor");
	//HE Grenade
	RegConsoleCmd("sm_he", Command_he, "Purchases a HE grenade");
	//Flashbang Grenade
	RegConsoleCmd("sm_fb", Command_flash, "Purchases a flash bang");
	RegConsoleCmd("sm_flash", Command_flash, "Purchases a flash bang");
	//Decoy Grenade
	RegConsoleCmd("sm_de", Command_decoy, "Purchases a decoy nade");
	RegConsoleCmd("sm_decoy", Command_decoy, "Purchases a decoy nade");
	//Incendiary Grenade
	RegConsoleCmd("sm_fire", Command_incendiary, "Purchases an inciendary grenade");
	RegConsoleCmd("sm_molotov", Command_incendiary, "Purchases an inciendary grenade");
	RegConsoleCmd("sm_molo", Command_incendiary, "Purchases an inciendary grenade");
	RegConsoleCmd("sm_incendiary", Command_incendiary, "Purchases an inciendary grenade");
	//TAG Grenade
	RegConsoleCmd("sm_ta", Command_TagGrenade, "Purchases a TA Grenade");
	RegConsoleCmd("sm_tg", Command_TagGrenade, "Purchases a TA Grenade");
	RegConsoleCmd("sm_taggrenade", Command_TagGrenade, "Purchases a TA Grenade");
	//Snowball
	RegConsoleCmd("sm_snowball", Command_snowball, "Purchases a snowball");
	RegConsoleCmd("sm_snow", Command_snowball, "Purchases an snowball");
	
	/* Hook Events */
	HookEvent("player_spawn", Hook_EventOnSpawn);
	
	/* Auto Execute Plugin Config */
	AutoExecConfig(true, "BuyCommandsRedux");
	
	/* Load Translations */
	LoadTranslations("buycommands.phrases");
}

public void OnClientConnected(int client)
{
	g_iSpam[client] = 0;
}

//==============================
// STOCK FUNCTIONS
//------------------------------
stock bool IsValidClient(int client, bool bAllowBots = false, bool bAllowDead = true)
{
	if (!(1 <= client <= MaxClients) || !IsClientInGame(client) || (IsFakeClient(client) && !bAllowBots) || IsClientSourceTV(client) || IsClientReplay(client) || (!bAllowDead && !IsPlayerAlive(client)))
	{
		return false;
	}
	return true;
}

stock bool IsClientCT(int client)
{
	if (GetClientTeam(client) == 3)
	{
		return true;
	}
	return false;
}

stock int GetClientMoney(int client)
{
	return GetEntProp(client, Prop_Send, "m_iAccount");
}

stock void SetClientMoney(int client, int money)
{
	SetEntProp(client, Prop_Send, "m_iAccount", money);
}

//==============================
// EVENT HOOKS
//------------------------------
public Action Hook_EventOnSpawn(Handle event, const char[] name, bool broadcast)
{
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	
	if (!IsClientInGame(client))
		return Plugin_Continue;
	if (!IsPlayerAlive(client))
		return Plugin_Continue;
	
	g_iHEAmount[client] = 0;
	g_iFlashAmount[client] = 0;
	g_iDecoyAmount[client] = 0;
	g_iIncAmount[client] = 0;
	g_iSnowAmount[client] = 0;
	g_iTagAmount[client] = 0;
	
	return Plugin_Continue;
}

public Action CS_OnTerminateRound(float &delay, CSRoundEndReason &reason)
{
	for (int i = 1; i <= MaxClients; i++)
	{
		if (IsClientInGame(i))
			g_iSpam[i] = 0;
	}
	return Plugin_Continue;
}

//==============================
// ASSAULT RIFLE COMMANDS
//------------------------------
public Action Command_Galil(int client, int args)
{
	if (!IsValidClient(client) || !IsClientCT(client))
		return Plugin_Handled;
	
	if (!g_cvar_Enable_AR.BoolValue)
	{
		CPrintToChat(client, "%t", "Purchase Disabled", "Plugin Prefix", "ar");
		return Plugin_Handled;
	}
	
	if (g_iSpam[client] > GetTime())
	{
		CPrintToChat(client, "%t", "Purchase Cooldown", "Plugin Prefix", "galil", g_iSpam[client] - GetTime());
		return Plugin_Handled;
	}
	
	int cmoney = GetClientMoney(client);
	int gunprice = g_GalilPrice.IntValue;
	
	if (cmoney > gunprice)
	{
		SetClientMoney(client, cmoney - gunprice);
		CPrintToChat(client, "%t", "Purchase", "Plugin Prefix", "galil", gunprice);
		
		g_iSpam[client] = GetTime() + g_cvar_RebuyCD.IntValue;
		
		if (g_cvar_DropOnRebuy.BoolValue)
		{
			int weapon = GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY);
			if (weapon != -1)
			{
				SDKHooks_DropWeapon(client, weapon);
				GivePlayerItem(client, "weapon_galilar");
			}
			else GivePlayerItem(client, "weapon_galilar");
		}
	}
	else if (cmoney < gunprice)
		CPrintToChat(client, "%t", "Not Enough Money", "Plugin Prefix", gunprice - cmoney);
	
	return Plugin_Handled;
}

public Action Command_ak(int client, int args)
{
	if (!IsValidClient(client) || !IsClientCT(client))
		return Plugin_Handled;
	
	if (!g_cvar_Enable_AR.BoolValue)
	{
		CPrintToChat(client, "%t", "Purchase Disabled", "Plugin Prefix", "ar");
		return Plugin_Handled;
	}
	
	if (g_iSpam[client] > GetTime())
	{
		CPrintToChat(client, "%t", "Purchase Cooldown", "Plugin Prefix", "ak", g_iSpam[client] - GetTime());
		return Plugin_Handled;
	}
	
	int cmoney = GetClientMoney(client);
	int gunprice = g_AKPrice.IntValue;
	
	if (cmoney > gunprice)
	{
		SetClientMoney(client, cmoney - gunprice);
		CPrintToChat(client, "%t", "Purchase", "Plugin Prefix", "ak", gunprice);

		g_iSpam[client] = GetTime() + g_cvar_RebuyCD.IntValue;

		if (g_cvar_DropOnRebuy.BoolValue)
		{
			int weapon = GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY);
			if (weapon != -1)
			{
				SDKHooks_DropWeapon(client, weapon);
				GivePlayerItem(client, "weapon_ak47");
			}
			else GivePlayerItem(client, "weapon_ak47");
		}
	}
	else if (cmoney < gunprice)
		CPrintToChat(client, "%t", "Not Enough Money", "Plugin Prefix", gunprice - cmoney);
	
	return Plugin_Handled;
}

public Action Command_sg556(int client, int args)
{
	if (!IsValidClient(client) || !IsClientCT(client))
		return Plugin_Handled;
		
	if (!g_cvar_Enable_AR.BoolValue)
	{
		CPrintToChat(client, "%t", "Purchase Disabled", "Plugin Prefix", "ar");
		return Plugin_Handled;
	}
	
	if (g_iSpam[client] > GetTime())
	{
		CPrintToChat(client, "%t", "Purchase Cooldown", "Plugin Prefix", "sg556", g_iSpam[client] - GetTime());
		return Plugin_Handled;
	}
	
	int cmoney = GetClientMoney(client);
	int gunprice = g_SG556Price.IntValue;
	
	if (cmoney > gunprice)
	{
		SetClientMoney(client, cmoney - gunprice);
		CPrintToChat(client, "%t", "Purchase", "Plugin Prefix", "sg556", gunprice);

		g_iSpam[client] = GetTime() + g_cvar_RebuyCD.IntValue;

		if (g_cvar_DropOnRebuy.BoolValue)
		{
			int weapon = GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY);
			if (weapon != -1)
			{
				SDKHooks_DropWeapon(client, weapon);
				GivePlayerItem(client, "weapon_sg556");
			}
			else GivePlayerItem(client, "weapon_sg556");
		}
	}
	else if (cmoney < gunprice)
		CPrintToChat(client, "%t", "Not Enough Money", "Plugin Prefix", gunprice - cmoney);
	
	return Plugin_Handled;
}

public Action Command_m4a4(int client, int args)
{
	if (!IsValidClient(client) || !IsClientCT(client))
		return Plugin_Handled;
	
	if (!g_cvar_Enable_AR.BoolValue)
	{
		CPrintToChat(client, "%t", "Purchase Disabled", "Plugin Prefix", "ar");
		return Plugin_Handled;
	}
	
	if (g_iSpam[client] > GetTime())
	{
		CPrintToChat(client, "%t", "Purchase Cooldown", "Plugin Prefix", "m4", g_iSpam[client] - GetTime());
		return Plugin_Handled;
	}
	
	int cmoney = GetClientMoney(client);
	int gunprice = g_M4Price.IntValue;
	
	if (cmoney > gunprice)
	{
		SetClientMoney(client, cmoney - gunprice);
		CPrintToChat(client, "%t", "Purchase", "Plugin Prefix", "m4", gunprice);
		
		g_iSpam[client] = GetTime() + g_cvar_RebuyCD.IntValue;
		
		if (g_cvar_DropOnRebuy.BoolValue)
		{
			int weapon = GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY);
			if (weapon != -1)
			{
				SDKHooks_DropWeapon(client, weapon);
				GivePlayerItem(client, "weapon_m4a1");
			}
			else GivePlayerItem(client, "weapon_m4a1");
		}
	}
	else if (cmoney < gunprice)
		CPrintToChat(client, "%t", "Not Enough Money", "Plugin Prefix", gunprice - cmoney);
	
	return Plugin_Handled;
}

public Action Command_m4a1s(int client, int args)
{
	if (!IsValidClient(client) || !IsClientCT(client))
		return Plugin_Handled;
	
	if (!g_cvar_Enable_AR.BoolValue)
	{
		CPrintToChat(client, "%t", "Purchase Disabled", "Plugin Prefix", "ar");
		return Plugin_Handled;
	}
	
	if (g_iSpam[client] > GetTime())
	{
		CPrintToChat(client, "%t", "Purchase Cooldown", "Plugin Prefix", "m4s", g_iSpam[client] - GetTime());
		return Plugin_Handled;
	}
	
	int cmoney = GetClientMoney(client);
	int gunprice = g_M4SPrice.IntValue;
	
	if (cmoney > gunprice)
	{
		SetClientMoney(client, cmoney - gunprice);
		CPrintToChat(client, "%t", "Purchase", "Plugin Prefix", "m4s", gunprice);
		
		g_iSpam[client] = GetTime() + g_cvar_RebuyCD.IntValue;
		
		if (g_cvar_DropOnRebuy.BoolValue)
		{
			int weapon = GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY);
			if (weapon != -1)
			{
				SDKHooks_DropWeapon(client, weapon);
				GivePlayerItem(client, "weapon_m4a1_silencer");
			}
			else GivePlayerItem(client, "weapon_m4a1_silencer");
		}
	}
	else if (cmoney < gunprice)
		CPrintToChat(client, "%t", "Not Enough Money", "Plugin Prefix", gunprice - cmoney);
	
	return Plugin_Handled;
}

public Action Command_aug(int client, int args)
{
	if (!IsValidClient(client) || !IsClientCT(client))
		return Plugin_Handled;
	
	if (!g_cvar_Enable_AR.BoolValue)
	{
		CPrintToChat(client, "%t", "Purchase Disabled", "Plugin Prefix", "ar");
		return Plugin_Handled;
	}
	
	if (g_iSpam[client] > GetTime())
	{
		CPrintToChat(client, "%t", "Purchase Cooldown", "Plugin Prefix", "aug", g_iSpam[client] - GetTime());
		return Plugin_Handled;
	}
	
	int cmoney = GetClientMoney(client);
	int gunprice = g_AUGPrice.IntValue;
	
	if (cmoney > gunprice)
	{
		SetClientMoney(client, cmoney - gunprice);
		CPrintToChat(client, "%t", "Purchase", "Plugin Prefix", "aug", gunprice);
		
		g_iSpam[client] = GetTime() + g_cvar_RebuyCD.IntValue;
		
		if (g_cvar_DropOnRebuy.BoolValue)
		{
			int weapon = GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY);
			if (weapon != -1)
			{
				SDKHooks_DropWeapon(client, weapon);
				GivePlayerItem(client, "weapon_aug");
			}
			else GivePlayerItem(client, "weapon_aug");
		}
	}
	else if (cmoney < gunprice)
		CPrintToChat(client, "%t", "Not Enough Money", "Plugin Prefix", gunprice - cmoney);
	
	return Plugin_Handled;
}

public Action Command_famas(int client, int args)
{
	if (!IsValidClient(client) || !IsClientCT(client))
		return Plugin_Handled;
	
	if (!g_cvar_Enable_AR.BoolValue)
	{
		CPrintToChat(client, "%t", "Purchase Disabled", "Plugin Prefix", "ar");
		return Plugin_Handled;
	}
	
	if (g_iSpam[client] > GetTime())
	{
		CPrintToChat(client, "%t", "Purchase Cooldown", "Plugin Prefix", "famas", g_iSpam[client] - GetTime());
		return Plugin_Handled;
	}
	
	int cmoney = GetClientMoney(client);
	int gunprice = g_FAMASPrice.IntValue;
	
	if (cmoney > gunprice)
	{
		SetClientMoney(client, cmoney - gunprice);
		CPrintToChat(client, "%t", "Purchase", "Plugin Prefix", "famas", gunprice);
		
		g_iSpam[client] = GetTime() + g_cvar_RebuyCD.IntValue;
		
		if (g_cvar_DropOnRebuy.BoolValue)
		{
			int weapon = GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY);
			if (weapon != -1)
			{
				SDKHooks_DropWeapon(client, weapon);
				GivePlayerItem(client, "weapon_famas");
			}
			else GivePlayerItem(client, "weapon_famas");
		}
	}
	else if (cmoney < gunprice)
		CPrintToChat(client, "%t", "Not Enough Money", "Plugin Prefix", gunprice - cmoney);
	
	return Plugin_Handled;
}

//==============================
// SHOTGUN COMMANDS
//------------------------------
public Action Command_nova(int client, int args)
{
	if (!IsValidClient(client) || !IsClientCT(client))
		return Plugin_Handled;
	
	if (!g_cvar_Enable_Shotgun.BoolValue)
	{
		CPrintToChat(client, "Purchase Disabled", "Plugin Prefix", "shotgun");
		return Plugin_Handled;
	}
	
	if (g_iSpam[client] > GetTime())
	{
		CPrintToChat(client, "%t", "Purchase Cooldown", "Plugin Prefix", "nova", g_iSpam[client] - GetTime());
		return Plugin_Handled;
	}
	
	int cmoney = GetClientMoney(client);
	int gunprice = g_NovaPrice.IntValue;
	
	if (cmoney > gunprice)
	{
		SetClientMoney(client, cmoney - gunprice);
		CPrintToChat(client, "%t", "Purchase", "Plugin Prefix", "nova", gunprice);

		g_iSpam[client] = GetTime() + g_cvar_RebuyCD.IntValue;

		if (g_cvar_DropOnRebuy.BoolValue)
		{
			int weapon = GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY);
			if (weapon != -1)
			{
				SDKHooks_DropWeapon(client, weapon);
				GivePlayerItem(client, "weapon_nova");
			}
			else GivePlayerItem(client, "weapon_nova");
		}
	}
	else if (cmoney < gunprice)
		CPrintToChat(client, "%t", "Not Enough Money", "Plugin Prefix", gunprice - cmoney);
	
	return Plugin_Handled;
}

public Action Command_xm1014(int client, int args)
{
	if (!IsValidClient(client) || !IsClientCT(client))
		return Plugin_Handled;
	
	if (!g_cvar_Enable_Shotgun.BoolValue)
	{
		CPrintToChat(client, "Purchase Disabled", "Plugin Prefix", "shotgun");
		return Plugin_Handled;
	}
	
	if (g_iSpam[client] > GetTime())
	{
		CPrintToChat(client, "%t", "Purchase Cooldown", "Plugin Prefix", "xm", g_iSpam[client] - GetTime());
		return Plugin_Handled;
	}
	
	int cmoney = GetClientMoney(client);
	int gunprice = g_XM1014Price.IntValue;
	
	if (cmoney > gunprice)
	{
		SetClientMoney(client, cmoney - gunprice);
		CPrintToChat(client, "%t", "Purchase", "Plugin Prefix", "xm", gunprice);

		g_iSpam[client] = GetTime() + g_cvar_RebuyCD.IntValue;

		if (g_cvar_DropOnRebuy.BoolValue)
		{
			int weapon = GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY);
			if (weapon != -1)
			{
				SDKHooks_DropWeapon(client, weapon);
				GivePlayerItem(client, "weapon_xm1014");
			}
			else GivePlayerItem(client, "weapon_xm1014");
		}
	}
	else if (cmoney < gunprice)
		CPrintToChat(client, "%t", "Not Enough Money", "Plugin Prefix", gunprice - cmoney);
	
	return Plugin_Handled;
}

public Action Command_mag7(int client, int args)
{
	if (!IsValidClient(client) || !IsClientCT(client))
		return Plugin_Handled;
	
	if (!g_cvar_Enable_Shotgun.BoolValue)
	{
		CPrintToChat(client, "Purchase Disabled", "Plugin Prefix", "shotgun");
		return Plugin_Handled;
	}
	
	if (g_iSpam[client] > GetTime())
	{
		CPrintToChat(client, "%t", "Purchase Cooldown", "Plugin Prefix", "mag", g_iSpam[client] - GetTime());
		return Plugin_Handled;
	}
	
	int cmoney = GetClientMoney(client);
	int gunprice = g_Mag7Price.IntValue;
	
	if (cmoney > gunprice)
	{
		SetClientMoney(client, cmoney - gunprice);
		CPrintToChat(client, "%t", "Purchase", "Plugin Prefix", "mag", gunprice);

		g_iSpam[client] = GetTime() + g_cvar_RebuyCD.IntValue;

		if (g_cvar_DropOnRebuy.BoolValue)
		{
			int weapon = GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY);
			if (weapon != -1)
			{
				SDKHooks_DropWeapon(client, weapon);
				GivePlayerItem(client, "weapon_mag7");
			}
			else GivePlayerItem(client, "weapon_mag7");
		}
	}
	else if (cmoney < gunprice)
		CPrintToChat(client, "%t", "Not Enough Money", "Plugin Prefix", gunprice - cmoney);
	
	return Plugin_Handled;
}

public Action Command_sawed(int client, int args)
{
	if (!IsValidClient(client) || !IsClientCT(client))
		return Plugin_Handled;
	
	if (!g_cvar_Enable_Shotgun.BoolValue)
	{
		CPrintToChat(client, "Purchase Disabled", "Plugin Prefix", "shotgun");
		return Plugin_Handled;
	}
	
	if (g_iSpam[client] > GetTime())
	{
		CPrintToChat(client, "%t", "Purchase Cooldown", "Plugin Prefix", "sawed", g_iSpam[client] - GetTime());
		return Plugin_Handled;
	}
	
	int cmoney = GetClientMoney(client);
	int gunprice = g_SawedOffPrice.IntValue;
	
	if (cmoney > gunprice)
	{
		SetClientMoney(client, cmoney - gunprice);
		CPrintToChat(client, "%t", "Purchase", "Plugin Prefix", "sawed", gunprice);

		g_iSpam[client] = GetTime() + g_cvar_RebuyCD.IntValue;

		if (g_cvar_DropOnRebuy.BoolValue)
		{
			int weapon = GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY);
			if (weapon != -1)
			{
				SDKHooks_DropWeapon(client, weapon);
				GivePlayerItem(client, "weapon_sawedoff");
			}
			else GivePlayerItem(client, "weapon_sawedoff");
		}
	}
	else if (cmoney < gunprice)
		CPrintToChat(client, "%t", "Not Enough Money", "Plugin Prefix", gunprice - cmoney);
	
	return Plugin_Handled;
}

//==============================
// SMG COMMANDS
//------------------------------
public Action Command_mac10(int client, int args)
{
	if (!IsValidClient(client) || !IsClientCT(client))
		return Plugin_Handled;
	
	if (!g_cvar_Enable_SMG.BoolValue)
	{
		CPrintToChat(client, "Purchase Disabled", "Plugin Prefix", "smg");
		return Plugin_Handled;
	}
	
	if (g_iSpam[client] > GetTime())
	{
		CPrintToChat(client, "%t", "Purchase Cooldown", "Plugin Prefix", "mac", g_iSpam[client] - GetTime());
		return Plugin_Handled;
	}
	
	int cmoney = GetClientMoney(client);
	int gunprice = g_Mac10Price.IntValue;
	
	if (cmoney > gunprice)
	{
		SetClientMoney(client, cmoney - gunprice);
		CPrintToChat(client, "%t", "Purchase", "Plugin Prefix", "mac", gunprice);

		g_iSpam[client] = GetTime() + g_cvar_RebuyCD.IntValue;

		if (g_cvar_DropOnRebuy.BoolValue)
		{
			int weapon = GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY);
			if (weapon != -1)
			{
				SDKHooks_DropWeapon(client, weapon);
				GivePlayerItem(client, "weapon_mac10");
			}
			else GivePlayerItem(client, "weapon_mac10");
		}
	}
	else if (cmoney < gunprice)
		CPrintToChat(client, "%t", "Not Enough Money", "Plugin Prefix", gunprice - cmoney);
	
	return Plugin_Handled;
}

public Action Command_mp9(int client, int args)
{
	if (!IsValidClient(client) || !IsClientCT(client))
		return Plugin_Handled;
	
	if (!g_cvar_Enable_SMG.BoolValue)
	{
		CPrintToChat(client, "Purchase Disabled", "Plugin Prefix", "smg");
		return Plugin_Handled;
	}
	
	if (g_iSpam[client] > GetTime())
	{
		CPrintToChat(client, "%t", "Purchase Cooldown", "Plugin Prefix", "mp9", g_iSpam[client] - GetTime());
		return Plugin_Handled;
	}
	
	int cmoney = GetClientMoney(client);
	int gunprice = g_Mp9Price.IntValue;
	
	if (cmoney > gunprice)
	{
		SetClientMoney(client, cmoney - gunprice);
		CPrintToChat(client, "%t", "Purchase", "Plugin Prefix", "mp9", gunprice);
		
		g_iSpam[client] = GetTime() + g_cvar_RebuyCD.IntValue;
		
		if (g_cvar_DropOnRebuy.BoolValue)
		{
			int weapon = GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY);
			if (weapon != -1)
			{
				SDKHooks_DropWeapon(client, weapon);
				GivePlayerItem(client, "weapon_mp9");
			}
			else GivePlayerItem(client, "weapon_mp9");
		}
	}
	else if (cmoney < gunprice)
		CPrintToChat(client, "%t", "Not Enough Money", "Plugin Prefix", gunprice - cmoney);
	
	return Plugin_Handled;
}

public Action Command_mp7(int client, int args)
{
	if (!IsValidClient(client) || !IsClientCT(client))
		return Plugin_Handled;
	
	if (!g_cvar_Enable_SMG.BoolValue)
	{
		CPrintToChat(client, "Purchase Disabled", "Plugin Prefix", "smg");
		return Plugin_Handled;
	}
	
	if (g_iSpam[client] > GetTime())
	{
		CPrintToChat(client, "%t", "Purchase Cooldown", "Plugin Prefix", "mp7", g_iSpam[client] - GetTime());
		return Plugin_Handled;
	}
	
	int cmoney = GetClientMoney(client);
	int gunprice = g_Mp7Price.IntValue;
	
	if (cmoney > gunprice)
	{
		SetClientMoney(client, cmoney - gunprice);
		CPrintToChat(client, "%t", "Purchase", "Plugin Prefix", "mp7", gunprice);
		
		g_iSpam[client] = GetTime() + g_cvar_RebuyCD.IntValue;
		
		if (g_cvar_DropOnRebuy.BoolValue)
		{
			int weapon = GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY);
			if (weapon != -1)
			{
				SDKHooks_DropWeapon(client, weapon);
				GivePlayerItem(client, "weapon_mp7");
			}
			else GivePlayerItem(client, "weapon_mp7");
		}
	}
	else if (cmoney < gunprice)
		CPrintToChat(client, "%t", "Not Enough Money", "Plugin Prefix", gunprice - cmoney);
	
	return Plugin_Handled;
}

public Action Command_mp5(int client, int args) 
{
	if (!IsValidClient(client) || !IsClientCT(client))
		return Plugin_Handled;
	
	if (!g_cvar_Enable_SMG.BoolValue)
	{
		CPrintToChat(client, "Purchase Disabled", "Plugin Prefix", "smg");
		return Plugin_Handled;
	}
	
	if (g_iSpam[client] > GetTime())
	{
		CPrintToChat(client, "%t", "Purchase Cooldown", "Plugin Prefix", "mp5", g_iSpam[client] - GetTime());
		return Plugin_Handled;
	}
	
	int cmoney = GetClientMoney(client);
	int gunprice = g_MP5SDPrice.IntValue;
	
	if (cmoney > gunprice)
	{
		SetClientMoney(client, cmoney - gunprice);
		CPrintToChat(client, "%t", "Purchase", "Plugin Prefix", "mp5", gunprice);
		
		g_iSpam[client] = GetTime() + g_cvar_RebuyCD.IntValue;
		
		if (g_cvar_DropOnRebuy.BoolValue)
		{
			int weapon = GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY);
			if (weapon != -1)
			{
				SDKHooks_DropWeapon(client, weapon);
				GivePlayerItem(client, "weapon_mp5sd");
			}
			else GivePlayerItem(client, "weapon_mp5sd");
		}
	}
	else if (cmoney < gunprice)
		CPrintToChat(client, "%t", "Not Enough Money", "Plugin Prefix", gunprice - cmoney);
	
	return Plugin_Handled;
}

public Action Command_ump45(int client, int args)
{
	if (!IsValidClient(client) || !IsClientCT(client))
		return Plugin_Handled;
	
	if (!g_cvar_Enable_SMG.BoolValue)
	{
		CPrintToChat(client, "Purchase Disabled", "Plugin Prefix", "smg");
		return Plugin_Handled;
	}
	
	if (g_iSpam[client] > GetTime())
	{
		CPrintToChat(client, "%t", "Purchase Cooldown", "Plugin Prefix", "ump", g_iSpam[client] - GetTime());
		return Plugin_Handled;
	}
	
	int cmoney = GetClientMoney(client);
	int gunprice = g_UMP45Price.IntValue;
	
	if (cmoney > gunprice)
	{
		SetClientMoney(client, cmoney - gunprice);
		CPrintToChat(client, "%t", "Purchase", "Plugin Prefix", "ump", gunprice);

		g_iSpam[client] = GetTime() + g_cvar_RebuyCD.IntValue;

		if (g_cvar_DropOnRebuy.BoolValue)
		{
			int weapon = GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY);
			if (weapon != -1)
			{
				SDKHooks_DropWeapon(client, weapon);
				GivePlayerItem(client, "weapon_ump45");
			}
			else GivePlayerItem(client, "weapon_ump45");
		}
	}
	else if (cmoney < gunprice)
		CPrintToChat(client, "%t", "Not Enough Money", "Plugin Prefix", gunprice - cmoney);
	
	return Plugin_Handled;
}

public Action Command_bizon(int client, int args)
{
	if (!IsValidClient(client) || !IsClientCT(client))
		return Plugin_Handled;
	
	if (!g_cvar_Enable_SMG.BoolValue)
	{
		CPrintToChat(client, "Purchase Disabled", "Plugin Prefix", "smg");
		return Plugin_Handled;
	}
	
	if (g_iSpam[client] > GetTime())
	{
		CPrintToChat(client, "%t", "Purchase Cooldown", "Plugin Prefix", "bizon", g_iSpam[client] - GetTime());
		return Plugin_Handled;
	}
	
	int cmoney = GetClientMoney(client);
	int gunprice = g_BizonPrice.IntValue;
	
	if (cmoney > gunprice)
	{
		SetClientMoney(client, cmoney - gunprice);
		CPrintToChat(client, "%t", "Purchase", "Plugin Prefix", "bizon", gunprice);

		g_iSpam[client] = GetTime() + g_cvar_RebuyCD.IntValue;

		if (g_cvar_DropOnRebuy.BoolValue)
		{
			int weapon = GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY);
			if (weapon != -1)
			{
				SDKHooks_DropWeapon(client, weapon);
				GivePlayerItem(client, "weapon_bizon");
			}
			else GivePlayerItem(client, "weapon_bizon");
		}
	}
	else if (cmoney < gunprice)
		CPrintToChat(client, "%t", "Not Enough Money", "Plugin Prefix", gunprice - cmoney);
	
	return Plugin_Handled;
}

public Action Command_p90(int client, int args)
{
	if (!IsValidClient(client) || !IsClientCT(client))
		return Plugin_Handled;
	
	if (!g_cvar_Enable_SMG.BoolValue)
	{
		CPrintToChat(client, "Purchase Disabled", "Plugin Prefix", "smg");
		return Plugin_Handled;
	}
	
	if (g_iSpam[client] > GetTime())
	{
		CPrintToChat(client, "%t", "Purchase Cooldown", "Plugin Prefix", "p90", g_iSpam[client] - GetTime());
		return Plugin_Handled;
	}
	
	int cmoney = GetClientMoney(client);
	int gunprice = g_P90Price.IntValue;
	
	if (cmoney > gunprice)
	{
		SetClientMoney(client, cmoney - gunprice);
		CPrintToChat(client, "%t", "Purchase", "Plugin Prefix", "p90", gunprice);

		g_iSpam[client] = GetTime() + g_cvar_RebuyCD.IntValue;

		if (g_cvar_DropOnRebuy.BoolValue)
		{
			int weapon = GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY);
			if (weapon != -1)
			{
				SDKHooks_DropWeapon(client, weapon);
				GivePlayerItem(client, "weapon_p90");
			}
			else GivePlayerItem(client, "weapon_p90");
		}
	}
	else if (cmoney < gunprice)
		CPrintToChat(client, "%t", "Not Enough Money", "Plugin Prefix", gunprice - cmoney);
	
	return Plugin_Handled;
}

//==============================
// MACHING GUN COMMANDS
//------------------------------
public Action Command_m249(int client, int args)
{
	if (!IsValidClient(client) || !IsClientCT(client))
		return Plugin_Handled;
	
	if (!g_cvar_Enable_MG.BoolValue)
	{
		CPrintToChat(client, "Purchase Disabled", "Plugin Prefix", "lmg");
		return Plugin_Handled;
	}
	
	if (g_iSpam[client] > GetTime())
	{
		CPrintToChat(client, "%t", "Purchase Cooldown", "Plugin Prefix", "m249", g_iSpam[client] - GetTime());
		return Plugin_Handled;
	}
	
	int cmoney = GetClientMoney(client);
	int gunprice = g_M249Price.IntValue;
	
	if (cmoney > gunprice)
	{
		SetClientMoney(client, cmoney - gunprice);
		CPrintToChat(client, "%t", "Purchase", "Plugin Prefix", "m249", gunprice);
		
		g_iSpam[client] = GetTime() + g_cvar_RebuyCD.IntValue;
		
		if (g_cvar_DropOnRebuy.BoolValue)
		{
			int weapon = GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY);
			if (weapon != -1)
			{
				SDKHooks_DropWeapon(client, weapon);
				GivePlayerItem(client, "weapon_m249");
			}
			else GivePlayerItem(client, "weapon_m249");
		}
	}
	else if (cmoney < gunprice)
		CPrintToChat(client, "%t", "Not Enough Money", "Plugin Prefix", gunprice - cmoney);
	
	return Plugin_Handled;
}

public Action Command_negev(int client, int args)
{
	if (!IsValidClient(client) || !IsClientCT(client))
		return Plugin_Handled;
	
	if (!g_cvar_Enable_MG.BoolValue)
	{
		CPrintToChat(client, "Purchase Disabled", "Plugin Prefix", "lmg");
		return Plugin_Handled;
	}
	
	if (g_iSpam[client] > GetTime())
	{
		CPrintToChat(client, "%t", "Purchase Cooldown", "Plugin Prefix", "negev", g_iSpam[client] - GetTime());
		return Plugin_Handled;
	}
	
	int cmoney = GetClientMoney(client);
	int gunprice = g_NegevPrice.IntValue;
	
	if (cmoney > gunprice)
	{
		SetClientMoney(client, cmoney - gunprice);
		CPrintToChat(client, "%t", "Purchase", "Plugin Prefix", "negev", gunprice);
		
		g_iSpam[client] = GetTime() + g_cvar_RebuyCD.IntValue;
		
		if (g_cvar_DropOnRebuy.BoolValue)
		{
			int weapon = GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY);
			if (weapon != -1)
			{
				SDKHooks_DropWeapon(client, weapon);
				GivePlayerItem(client, "weapon_negev");
			}
			else GivePlayerItem(client, "weapon_negev");
		}
	}
	else if (cmoney < gunprice)
		CPrintToChat(client, "%t", "Not Enough Money", "Plugin Prefix", gunprice - cmoney);
	
	return Plugin_Handled;
}

//==============================
// SNIPER RIFLE COMMANDS
//------------------------------
public Action Command_scar(int client, int args)
{
	if (!IsValidClient(client) || !IsClientCT(client))
		return Plugin_Handled;
	
	if (!g_cvar_Enable_Sniper.BoolValue)
	{
		CPrintToChat(client, "Purchase Disabled", "Plugin Prefix", "sniper");
		return Plugin_Handled;
	}
	
	if (g_iSpam[client] > GetTime())
	{
		CPrintToChat(client, "%t", "Purchase Cooldown", "Plugin Prefix", "scar", g_iSpam[client] - GetTime());
		return Plugin_Handled;
	}
	
	int cmoney = GetClientMoney(client);
	int gunprice = g_SCAR20Price.IntValue;
	
	if (cmoney > gunprice)
	{
		SetClientMoney(client, cmoney - gunprice);
		CPrintToChat(client, "%t", "Purchase", "Plugin Prefix", "scar", gunprice);
		
		g_iSpam[client] = GetTime() + g_cvar_RebuyCD.IntValue;
		
		if (g_cvar_DropOnRebuy.BoolValue)
		{
			int weapon = GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY);
			if (weapon != -1)
			{
				SDKHooks_DropWeapon(client, weapon);
				GivePlayerItem(client, "weapon_scar20");
			}
			else GivePlayerItem(client, "weapon_scar20");
		}
	}
	else if (cmoney < gunprice)
		CPrintToChat(client, "%t", "Not Enough Money", "Plugin Prefix", gunprice - cmoney);
	
	return Plugin_Handled;
}

public Action Command_awp(int client, int args)
{
	if (!IsValidClient(client) || !IsClientCT(client))
		return Plugin_Handled;
	
	if (!g_cvar_Enable_Sniper.BoolValue)
	{
		CPrintToChat(client, "Purchase Disabled", "Plugin Prefix", "sniper");
		return Plugin_Handled;
	}
	
	if (g_iSpam[client] > GetTime())
	{
		CPrintToChat(client, "%t", "Purchase Cooldown", "Plugin Prefix", "awp", g_iSpam[client] - GetTime());
		return Plugin_Handled;
	}
	
	int cmoney = GetClientMoney(client);
	int gunprice = g_AWPPrice.IntValue;
	
	if (cmoney > gunprice)
	{
		SetClientMoney(client, cmoney - gunprice);
		CPrintToChat(client, "%t", "Purchase", "Plugin Prefix", "awp", gunprice);
		
		g_iSpam[client] = GetTime() + g_cvar_RebuyCD.IntValue;
		
		if (g_cvar_DropOnRebuy.BoolValue)
		{
			int weapon = GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY);
			if (weapon != -1)
			{
				SDKHooks_DropWeapon(client, weapon);
				GivePlayerItem(client, "weapon_awp");
			}
			else GivePlayerItem(client, "weapon_awp");
		}
	}
	else if (cmoney < gunprice)
		CPrintToChat(client, "%t", "Not Enough Money", "Plugin Prefix", gunprice - cmoney);
	
	return Plugin_Handled;
}

public Action Command_ssg08(int client, int args)
{
	if (!IsValidClient(client) || !IsClientCT(client))
		return Plugin_Handled;
	
	if (!g_cvar_Enable_Sniper.BoolValue)
	{
		CPrintToChat(client, "Purchase Disabled", "Plugin Prefix", "sniper");
		return Plugin_Handled;
	}
	
	if (g_iSpam[client] > GetTime())
	{
		CPrintToChat(client, "%t", "Purchase Cooldown", "Plugin Prefix", "ssg", g_iSpam[client] - GetTime());
		return Plugin_Handled;
	}
	
	int cmoney = GetClientMoney(client);
	int gunprice = g_SSG08Price.IntValue;
	
	if (cmoney > gunprice)
	{
		SetClientMoney(client, cmoney - gunprice);
		CPrintToChat(client, "%t", "Purchase", "Plugin Prefix", "ssg", gunprice);
		
		g_iSpam[client] = GetTime() + g_cvar_RebuyCD.IntValue;
		
		if (g_cvar_DropOnRebuy.BoolValue)
		{
			int weapon = GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY);
			if (weapon != -1)
			{
				SDKHooks_DropWeapon(client, weapon);
				GivePlayerItem(client, "weapon_ssg08");
			}
			else GivePlayerItem(client, "weapon_ssg08");
		}
	}
	else if (cmoney < gunprice)
		CPrintToChat(client, "%t", "Not Enough Money", "Plugin Prefix", gunprice - cmoney);
	
	return Plugin_Handled;
}

public Action Command_g3sg1(int client, int args)
{
	if (!IsValidClient(client) || !IsClientCT(client))
		return Plugin_Handled;
	
	if (!g_cvar_Enable_Sniper.BoolValue)
	{
		CPrintToChat(client, "Purchase Disabled", "Plugin Prefix", "sniper");
		return Plugin_Handled;
	}
	
	if (g_iSpam[client] > GetTime())
	{
		CPrintToChat(client, "%t", "Purchase Cooldown", "Plugin Prefix", "g3sg1", g_iSpam[client] - GetTime());
		return Plugin_Handled;
	}
	
	int cmoney = GetClientMoney(client);
	int gunprice = g_G3SG1Price.IntValue;
	
	if (cmoney > gunprice)
	{
		SetClientMoney(client, cmoney - gunprice);
		CPrintToChat(client, "%t", "Purchase", "Plugin Prefix", "g3sg1", gunprice);
		
		g_iSpam[client] = GetTime() + g_cvar_RebuyCD.IntValue;
		
		if (g_cvar_DropOnRebuy.BoolValue)
		{
			int weapon = GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY);
			if (weapon != -1)
			{
				SDKHooks_DropWeapon(client, weapon);
				GivePlayerItem(client, "weapon_g3sg1");
			}
			else GivePlayerItem(client, "weapon_g3sg1");
		}
	}
	else if (cmoney < gunprice)
		CPrintToChat(client, "%t", "Not Enough Money", "Plugin Prefix", gunprice - cmoney);
	
	return Plugin_Handled;
}

//==============================
// PISTOL COMMANDS
//------------------------------
public Action Command_usp(int client, int args)
{
	if (!IsValidClient(client) || !IsClientCT(client))
		return Plugin_Handled;
	
	if (!g_cvar_Enable_Pistol.BoolValue)
	{
		CPrintToChat(client, "Purchase Disabled", "Plugin Prefix", "pistol");
		return Plugin_Handled;
	}
	
	int cmoney = GetClientMoney(client);
	int gunprice = g_USPPrice.IntValue;
	
	if (cmoney > gunprice)
	{
		SetClientMoney(client, cmoney - gunprice);
		CPrintToChat(client, "%t", "Purchase", "Plugin Prefix", "usp", gunprice);
		
		if (g_cvar_DropOnRebuy.BoolValue)
		{
			int weapon = GetPlayerWeaponSlot(client, CS_SLOT_SECONDARY);
			if (weapon != -1)
			{
				SDKHooks_DropWeapon(client, weapon);
				GivePlayerItem(client, "weapon_usp_silencer");
			}
			else GivePlayerItem(client, "weapon_usp_silencer");
		}
	}
	else if (cmoney < gunprice)
		CPrintToChat(client, "%t", "Not Enough Money", "Plugin Prefix", gunprice - cmoney);
	
	return Plugin_Handled;
}

public Action Command_glock(int client, int args)
{
	if (!IsValidClient(client) || !IsClientCT(client))
		return Plugin_Handled;
	
	if (!g_cvar_Enable_Pistol.BoolValue)
	{
		CPrintToChat(client, "Purchase Disabled", "Plugin Prefix", "pistol");
		return Plugin_Handled;
	}
	
	int cmoney = GetClientMoney(client);
	int gunprice = g_GLOCKPrice.IntValue;
	
	if (cmoney > gunprice)
	{
		SetClientMoney(client, cmoney - gunprice);
		CPrintToChat(client, "%t", "Purchase", "Plugin Prefix", "glock", gunprice);
		
		if (g_cvar_DropOnRebuy.BoolValue)
		{
			int weapon = GetPlayerWeaponSlot(client, CS_SLOT_SECONDARY);
			if (weapon != -1)
			{
				SDKHooks_DropWeapon(client, weapon);
				GivePlayerItem(client, "weapon_glock");
			}
			else GivePlayerItem(client, "weapon_glock");
		}
	}
	else if (cmoney < gunprice)
		CPrintToChat(client, "%t", "Not Enough Money", "Plugin Prefix", gunprice - cmoney);
	
	return Plugin_Handled;
}

public Action Command_p250(int client, int args)
{
	if (!IsValidClient(client) || !IsClientCT(client))
		return Plugin_Handled;
	
	if (!g_cvar_Enable_Pistol.BoolValue)
	{
		CPrintToChat(client, "Purchase Disabled", "Plugin Prefix", "pistol");
		return Plugin_Handled;
	}
	
	int cmoney = GetClientMoney(client);
	int gunprice = g_P250Price.IntValue;
	
	if (cmoney > gunprice)
	{
		SetClientMoney(client, cmoney - gunprice);
		CPrintToChat(client, "%t", "Purchase", "Plugin Prefix", "p250", gunprice);
		
		if (g_cvar_DropOnRebuy.BoolValue)
		{
			int weapon = GetPlayerWeaponSlot(client, CS_SLOT_SECONDARY);
			if (weapon != -1)
			{
				SDKHooks_DropWeapon(client, weapon);
				GivePlayerItem(client, "weapon_p250");
			}
			else GivePlayerItem(client, "weapon_p250");
		}
	}
	else if (cmoney < gunprice)
		CPrintToChat(client, "%t", "Not Enough Money", "Plugin Prefix", gunprice - cmoney);
	
	return Plugin_Handled;
}

public Action Command_deag(int client, int args)
{
	if (!IsValidClient(client) || !IsClientCT(client))
		return Plugin_Handled;
	
	if (!g_cvar_Enable_Pistol.BoolValue)
	{
		CPrintToChat(client, "Purchase Disabled", "Plugin Prefix", "pistol");
		return Plugin_Handled;
	}
	
	int cmoney = GetClientMoney(client);
	int gunprice = g_DeagPrice.IntValue;
	
	if (cmoney > gunprice)
	{
		SetClientMoney(client, cmoney - gunprice);
		CPrintToChat(client, "%t", "Purchase", "Plugin Prefix", "deagle", gunprice);
		
		if (g_cvar_DropOnRebuy.BoolValue)
		{
			int weapon = GetPlayerWeaponSlot(client, CS_SLOT_SECONDARY);
			if (weapon != -1)
			{
				SDKHooks_DropWeapon(client, weapon);
				GivePlayerItem(client, "weapon_deagle");
			}
			else GivePlayerItem(client, "weapon_deagle");
		}
	}
	else if (cmoney < gunprice)
		CPrintToChat(client, "%t", "Not Enough Money", "Plugin Prefix", gunprice - cmoney);
	
	return Plugin_Handled;
}

public Action Command_tec9(int client, int args)
{
	if (!IsValidClient(client) || !IsClientCT(client))
		return Plugin_Handled;
	
	if (!g_cvar_Enable_Pistol.BoolValue)
	{
		CPrintToChat(client, "Purchase Disabled", "Plugin Prefix", "pistol");
		return Plugin_Handled;
	}
	
	int cmoney = GetClientMoney(client);
	int gunprice = g_Tec9Price.IntValue;
	
	if (cmoney > gunprice)
	{
		SetClientMoney(client, cmoney - gunprice);
		CPrintToChat(client, "%t", "Purchase", "Plugin Prefix", "tec9", gunprice);

		if (g_cvar_DropOnRebuy.BoolValue)
		{
			int weapon = GetPlayerWeaponSlot(client, CS_SLOT_SECONDARY);
			if (weapon != -1)
			{
				SDKHooks_DropWeapon(client, weapon);
				GivePlayerItem(client, "weapon_tec9");
			}
			else GivePlayerItem(client, "weapon_tec9");
		}
	}
	else if (cmoney < gunprice)
		CPrintToChat(client, "%t", "Not Enough Money", "Plugin Prefix", gunprice - cmoney);
	
	return Plugin_Handled;
}

public Action Command_p2k(int client, int args)
{
	if (!IsValidClient(client) || !IsClientCT(client))
		return Plugin_Handled;
	
	if (!g_cvar_Enable_Pistol.BoolValue)
	{
		CPrintToChat(client, "Purchase Disabled", "Plugin Prefix", "pistol");
		return Plugin_Handled;
	}
	
	int cmoney = GetClientMoney(client);
	int gunprice = g_P2KPrice.IntValue;
	
	if (cmoney > gunprice)
	{
		SetClientMoney(client, cmoney - gunprice);
		CPrintToChat(client, "%t", "Purchase", "Plugin Prefix", "p2000", gunprice);
		GiveP2000(client);
	}
	else if (cmoney < gunprice)
		CPrintToChat(client, "%t", "Not Enough Money", "Plugin Prefix", gunprice - cmoney);
	
	return Plugin_Handled;
}

public Action Command_elites(int client, int args)
{
	if (!IsValidClient(client) || !IsClientCT(client))
		return Plugin_Handled;
	
	if (!g_cvar_Enable_Pistol.BoolValue)
	{
		CPrintToChat(client, "Purchase Disabled", "Plugin Prefix", "pistol");
		return Plugin_Handled;
	}
	
	int cmoney = GetClientMoney(client);
	int gunprice = g_ELITEPrice.IntValue;
	
	if (cmoney > gunprice)
	{
		SetClientMoney(client, cmoney - gunprice);
		CPrintToChat(client, "%t", "Purchase", "Plugin Prefix", "elites", gunprice);
		
		if (g_cvar_DropOnRebuy.BoolValue)
		{
			int weapon = GetPlayerWeaponSlot(client, CS_SLOT_SECONDARY);
			if (weapon != -1)
			{
				SDKHooks_DropWeapon(client, weapon);
				GivePlayerItem(client, "weapon_elite");
			}
			else GivePlayerItem(client, "weapon_elite");
		}
	}
	else if (cmoney < gunprice)
		CPrintToChat(client, "%t", "Not Enough Money", "Plugin Prefix", gunprice - cmoney);
	
	return Plugin_Handled;
}

public Action Command_57(int client, int args)
{
	if (!IsValidClient(client) || !IsClientCT(client))
		return Plugin_Handled;
	
	if (!g_cvar_Enable_Pistol.BoolValue)
	{
		CPrintToChat(client, "Purchase Disabled", "Plugin Prefix", "pistol");
		return Plugin_Handled;
	}
	
	int cmoney = GetClientMoney(client);
	int gunprice = g_F7Price.IntValue;
	
	if (cmoney > gunprice)
	{
		SetClientMoney(client, cmoney - gunprice);
		CPrintToChat(client, "%t", "Purchase", "Plugin Prefix", "fiveseven", gunprice);

		if (g_cvar_DropOnRebuy.BoolValue)
		{
			int weapon = GetPlayerWeaponSlot(client, CS_SLOT_SECONDARY);
			if (weapon != -1)
			{
				SDKHooks_DropWeapon(client, weapon);
				GivePlayerItem(client, "weapon_fiveseven");
			}
			else GivePlayerItem(client, "weapon_fiveseven");
		}
	}
	else if (cmoney < gunprice)
		CPrintToChat(client, "%t", "Not Enough Money", "Plugin Prefix", gunprice - cmoney);
	
	return Plugin_Handled;
}

public Action Command_r8(int client, int args)
{
	if (!IsValidClient(client) || !IsClientCT(client))
		return Plugin_Handled;
	
	if (!g_cvar_Enable_Pistol.BoolValue)
	{
		CPrintToChat(client, "Purchase Disabled", "Plugin Prefix", "pistol");
		return Plugin_Handled;
	}
	
	int cmoney = GetClientMoney(client);
	int gunprice = g_R8Price.IntValue;
	
	if (cmoney > gunprice)
	{
		SetClientMoney(client, cmoney - gunprice);
		CPrintToChat(client, "%t", "Purchase", "Plugin Prefix", "r8", gunprice);
		
		if (g_cvar_DropOnRebuy.BoolValue)
		{
			int weapon = GetPlayerWeaponSlot(client, CS_SLOT_SECONDARY);
			if (weapon != -1)
			{
				SDKHooks_DropWeapon(client, weapon);
				GivePlayerItem(client, "weapon_revolver");
			}
			else GivePlayerItem(client, "weapon_revolver");
		}
	}
	else if (cmoney < gunprice)
		CPrintToChat(client, "%t", "Not Enough Money", "Plugin Prefix", gunprice - cmoney);
	
	return Plugin_Handled;
}

public Action Command_cz(int client, int args)
{
	if (!IsValidClient(client) || !IsClientCT(client))
		return Plugin_Handled;
	
	if (!g_cvar_Enable_Pistol.BoolValue)
	{
		CPrintToChat(client, "Purchase Disabled", "Plugin Prefix", "pistol");
		return Plugin_Handled;
	}
	
	int cmoney = GetClientMoney(client);
	int gunprice = g_CZ7Price.IntValue;
	
	if (cmoney > gunprice)
	{
		SetClientMoney(client, cmoney - gunprice);
		CPrintToChat(client, "%t", "Purchase", "Plugin Prefix", "cz", gunprice);
		
		if (g_cvar_DropOnRebuy.BoolValue)
		{
			int weapon = GetPlayerWeaponSlot(client, CS_SLOT_SECONDARY);
			if (weapon != -1)
			{
				SDKHooks_DropWeapon(client, weapon);
				GivePlayerItem(client, "weapon_cz75a");
			}
			else GivePlayerItem(client, "weapon_cz75a");
		}
	}
	else if (cmoney < gunprice)
		CPrintToChat(client, "%t", "Not Enough Money", "Plugin Prefix", gunprice - cmoney);
	
	return Plugin_Handled;
}

//==============================
// KEVLAR COMMAND
//------------------------------
public Action Command_armor(int client, int args)
{
	if (!IsValidClient(client) || !IsClientCT(client))
		return Plugin_Handled;
	
	if (!g_cvar_Enable_Kevlar.BoolValue)
	{
		CPrintToChat(client, "Purchase Disabled", "Plugin Prefix", "armor");
		return Plugin_Handled;
	}
	
	int cmoney = GetClientMoney(client);
	int gunprice = g_KEVPrice.IntValue;

	if (cmoney > gunprice)
	{
		SetClientMoney(client, cmoney - gunprice);
		CPrintToChat(client, "%t", "Purchase", "Plugin Prefix", "armor", gunprice);
		SetEntProp(client, Prop_Send, "m_ArmorValue", 100);
		SetEntProp(client, Prop_Send, "m_bHasHelmet", 1);
	}
	else if (cmoney < gunprice)
		CPrintToChat(client, "%t", "Not Enough Money", "Plugin Prefix", gunprice - cmoney);
	
	return Plugin_Handled;
}

//==============================
// GRENADE COMMANDS
//------------------------------
public Action Command_he(int client, int args)
{
	if (!IsValidClient(client) || !IsClientCT(client))
		return Plugin_Handled;
	
	if (!g_cvar_Enable_HE.BoolValue)
	{
		CPrintToChat(client, "%t", "Purchase Disabled", "Plugin Prefix", "he");
		return Plugin_Handled;
	}
	
	int cmoney = GetClientMoney(client);
	int gunprice = g_HEPrice.IntValue;

	if (cmoney > gunprice)
	{
		if (g_iHEAmount[client] < g_HEAmount.IntValue)
		{
			SetClientMoney(client, cmoney - gunprice);
			HEGrenade(client);
			g_iHEAmount[client] += 1;
			CPrintToChat(client, "%t", "Purchase Remaining", "Plugin Prefix", "he", gunprice, g_HEAmount.IntValue - g_iHEAmount[client]);
		}
		else CPrintToChat(client, "%t", "Max Amount Purchased", "Plugin Prefix", g_HEAmount.IntValue, "he"); 
	}
	else if (cmoney < gunprice)
		CPrintToChat(client, "%t", "Not Enough Money", "Plugin Prefix", gunprice - cmoney);
	
	return Plugin_Handled;
}

public Action Command_flash(int client, int args)
{
	if (!IsValidClient(client) || !IsClientCT(client))
		return Plugin_Handled;
	
	if (!g_cvar_Enable_Flash.BoolValue)
	{
		CPrintToChat(client, "%t", "Purchase Disabled", "Plugin Prefix", "fb");
		return Plugin_Handled;
	}
	
	int cmoney = GetClientMoney(client);
	int gunprice = g_FlashPrice.IntValue;
	
	if (cmoney > gunprice)
	{
		if (g_iFlashAmount[client] < g_FlashAmount.IntValue)
		{
			SetClientMoney(client, cmoney - gunprice);
			FlashBang(client);
			g_iFlashAmount[client] += 1;
			CPrintToChat(client, "%t", "Purchase Remaining", "Plugin Prefix", "fb", gunprice, g_FlashAmount.IntValue - g_iFlashAmount[client]);
		}
		else CPrintToChat(client, "%t", "Max Amount Purchased", "Plugin Prefix", g_FlashAmount.IntValue, "fb");
	}
	else if (cmoney < gunprice)
		CPrintToChat(client, "%t", "Not Enough Money", "Plugin Prefix", gunprice - cmoney);
	
	return Plugin_Handled;
}

public Action Command_decoy(int client, int args)
{
	if (!IsValidClient(client) || !IsClientCT(client))
		return Plugin_Handled;
	
	if (!g_cvar_Enable_Decoy.BoolValue)
	{
		CPrintToChat(client, "%t", "Purchase Disabled", "Plugin Prefix", "de");
		return Plugin_Handled;
	}
	
	int cmoney = GetClientMoney(client);
	int gunprice = g_DecoyPrice.IntValue;

	if (cmoney > gunprice)
	{
		if (g_iDecoyAmount[client] < g_DecoyAmount.IntValue)
		{
			SetClientMoney(client, cmoney - gunprice);
			DecoyNade(client);
			g_iDecoyAmount[client] += 1;
			CPrintToChat(client, "%t", "Purchase Remaining", "Plugin Prefix", "de", gunprice, g_DecoyAmount.IntValue - g_iDecoyAmount[client]);
		}
		else CPrintToChat(client, "%t", "Max Amount Purchased", "Plugin Prefix", g_DecoyAmount.IntValue, "de");
	}
	else if (cmoney < gunprice)
		CPrintToChat(client, "%t", "Not Enough Money", "Plugin Prefix", gunprice - cmoney);
	
	return Plugin_Handled;
}

public Action Command_incendiary(int client, int args)
{
	if (!IsValidClient(client) || !IsClientCT(client))
		return Plugin_Handled;
	
	if (!g_cvar_Enable_Inc.BoolValue)
	{
		CPrintToChat(client, "%t", "Purchase Disabled", "Plugin Prefix", "inc");
		return Plugin_Handled;
	}
	
	int cmoney = GetClientMoney(client);
	int gunprice = g_IncPrice.IntValue;

	if (cmoney > gunprice)
	{
		if (g_iIncAmount[client] < g_IncAmount.IntValue)
		{
			SetClientMoney(client, cmoney - gunprice);
			IncGrenade(client);
			g_iIncAmount[client] += 1;
			CPrintToChat(client, "%t", "Purchase Remaining", "Plugin Prefix", "inc", gunprice, g_IncAmount.IntValue - g_iIncAmount[client]);
		}
		else CPrintToChat(client, "%t", "Max Amount Purchased", "Plugin Prefix", g_IncAmount.IntValue, "inc");
	}
	else if (cmoney < gunprice)
		CPrintToChat(client, "%t", "Not Enough Money", "Plugin Prefix", gunprice - cmoney);
	
	return Plugin_Handled;
}

public Action Command_snowball(int client, int args)
{
	if (!IsValidClient(client) || !IsClientCT(client))
		return Plugin_Handled;
	
	if (!g_cvar_Enable_Snow.BoolValue)
	{
		CPrintToChat(client, "%t", "Purchase Disabled", "Plugin Prefix", "snow");
		return Plugin_Handled;
	}
	
	int cmoney = GetClientMoney(client);
	int gunprice = g_SnowPrice.IntValue;

	if (cmoney > gunprice)
	{
		if (g_iSnowAmount[client] < g_SnowAmount.IntValue)
		{
			SetClientMoney(client, cmoney - gunprice);
			Snowball(client);
			g_iSnowAmount[client] += 1;
			CPrintToChat(client, "%t", "Purchase Remaining", "Plugin Prefix", "snow", gunprice, g_SnowAmount.IntValue - g_iSnowAmount[client]);
		}
		else CPrintToChat(client, "%t", "Max Amount Purchased", "Plugin Prefix", g_SnowAmount.IntValue, "snow");
	}
	else if (cmoney < gunprice)
		CPrintToChat(client, "%t", "Not Enough Money", "Plugin Prefix", gunprice - cmoney);
	
	return Plugin_Handled;
}

public Action Command_TagGrenade(int client, int args)
{
	if (!IsValidClient(client) || !IsClientCT(client))
		return Plugin_Handled;
	
	if (!g_cvar_Enable_Tag.BoolValue)
	{
		CPrintToChat(client, "%t", "Purchase Disabled", "Plugin Prefix", "tag");
		return Plugin_Handled;
	}
	
	int cmoney = GetClientMoney(client);
	int gunprice = g_TagPrice.IntValue;

	if (cmoney > gunprice)
	{
		if (g_iTagAmount[client] < g_TagAmount.IntValue)
		{
			SetClientMoney(client, cmoney - gunprice);
			TagGrenade(client);
			g_iTagAmount[client] += 1;
			CPrintToChat(client, "%t", "Purchase Remaining", "Plugin Prefix", "tag", gunprice, g_TagAmount.IntValue - g_iTagAmount[client]);
		}
		else CPrintToChat(client, "%t", "Max Amount Purchased", "Plugin Prefix", g_TagAmount.IntValue, "tag");
	}
	else if (cmoney < gunprice)
		CPrintToChat(client, "%t", "Not Enough Money", "Plugin Prefix", gunprice - cmoney);
	
	return Plugin_Handled;
}

//==============================
// GIVE GRENADE FUNCTION (OFFSETS)
//------------------------------
public void HEGrenade(int client)
{
	int offset2 = FindDataMapInfo(client, "m_iAmmo") + (4*14);
	int current2 = GetEntData(client, offset2, 4);
	
	if (current2 == 0)
		GivePlayerItem(client, "weapon_hegrenade");
	else SetEntData(client, offset2, current2 + 1);
}

public void FlashBang(int client)
{
	int offset2 = FindDataMapInfo(client, "m_iAmmo") + (4*15);
	int current2 = GetEntData(client, offset2, 4);

	if (current2 == 0)
		GivePlayerItem(client, "weapon_flashbang");
	else SetEntData(client, offset2, current2 + 1);
}

public void IncGrenade(int client)
{
	int offset2 = FindDataMapInfo(client, "m_iAmmo") + (4*17);
	int current2 = GetEntData(client, offset2, 4);

	if (current2 == 0)
		GivePlayerItem(client, "weapon_incgrenade");
	else SetEntData(client, offset2, current2 + 1);
}

public void DecoyNade(int client)
{
	int offset2 = FindDataMapInfo(client, "m_iAmmo") + (4*18);
	int current2 = GetEntData(client, offset2, 4);

	if (current2 == 0)
		GivePlayerItem(client, "weapon_decoy");
	else SetEntData(client, offset2, current2 + 1);
}

public void TagGrenade(int client)
{
	int offset2 = FindDataMapInfo(client, "m_iAmmo") + (4*22);
	int current2 = GetEntData(client, offset2, 4);

	if (current2 == 0)
		GivePlayerItem(client, "weapon_tagrenade");
	else SetEntData(client, offset2, current2 + 1);
}

public void Snowball(int client)
{
	int offset2 = FindDataMapInfo(client, "m_iAmmo") + (4*25);
	int current2 = GetEntData(client, offset2, 4);

	if (current2 == 0)
		GivePlayerItem(client, "weapon_snowball");
	else SetEntData(client, offset2, current2 + 1);
}

//==============================
// P2000 FIX (Thanks tilgep!)
//------------------------------
public void GiveP2000(int client)
{
	// Spawn p2000
	int wep = CreateEntityByName("weapon_hkp2000");
	if (wep == -1)
	{
		LogError("[BuyCommands] Failed to create a valid weapon entity.");
	}

	// Find origin offset
	int offset = FindDataMapInfo(wep, "m_vecOrigin");
	if (offset == -1)
	{
		LogError("[BuyCommands] Failed to find a valid offset for origin.");
		RemoveEntity(wep);
	}

	// Move p2000 to player (doesnt spawn in the void)
	float o[3];
	GetClientAbsOrigin(client, o);
	SetEntDataVector(wep, offset, o);

	// Spawn it
	if (!DispatchSpawn(wep))
	{
		LogError("[BuyCommands] Failed to dispatch weapon.");
		RemoveEntity(wep);
	}

	// Drop current weapon and give p2000 to client
	int currentWeapon = GetPlayerWeaponSlot(client, CS_SLOT_SECONDARY);
	if (currentWeapon != -1) SDKHooks_DropWeapon(client, currentWeapon);

	EquipPlayerWeapon(client, wep);
}