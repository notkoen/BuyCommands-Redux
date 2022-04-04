#pragma semicolon 1
#pragma newdecls required

#define PLUGIN_AUTHOR "Someone REWORKED by koen"
#define PLUGIN_VERSION "2.0"

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

public Plugin myinfo = {
    name = "[ZR] Buy Commands Redux",
    author = PLUGIN_AUTHOR,
    description = "Buy Commands for Zombie:Reloaded",
    version = PLUGIN_VERSION,
    url = ""
};

public void OnPluginStart() {
    g_Game = GetEngineVersion();
    
    if(g_Game != Engine_CSGO) {
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
    RegConsoleCmd("sm_ak", Command_ak, "Purchases an AK-47", 0);
    RegConsoleCmd("sm_ak47", Command_ak, "Purchases an AK-47", 0);
    //AUG
    RegConsoleCmd("sm_aug", Command_aug, "Purchases an AUG", 0);
    //FAMAS
    RegConsoleCmd("sm_famas", Command_famas, "Purchases a FAMAS", 0);
    //M4A4
    RegConsoleCmd("sm_m4", Command_m4a4, "Purchases a M4A4", 0);
    RegConsoleCmd("sm_m4a4", Command_m4a4, "Purchases a M4A4", 0);
    //M4A1-S
    RegConsoleCmd("sm_m4a1", Command_m4a1s, "Purchases a M4A1-S", 0);
    RegConsoleCmd("sm_m4s", Command_m4a1s, "Purchases a M4A1-S", 0);
    RegConsoleCmd("sm_m4a1s", Command_m4a1s, "Purchases a M4A1-S", 0);
    RegConsoleCmd("sm_a1s", Command_m4a1s, "Purchases a M4A1-S", 0);
    RegConsoleCmd("sm_m4a1-s", Command_m4a1s, "Purchases a M4A1-S", 0);
    //KRIEG
    RegConsoleCmd("sm_sg556", Command_sg556, "Purchases a SG-553", 0);
    RegConsoleCmd("sm_sg553", Command_sg556, "Purchases a SG-553", 0);
    //GALIL
    RegConsoleCmd("sm_galil", Command_Galil, "Purchases a Galil-AR", 0);
    
    //NOVA
    RegConsoleCmd("sm_nova", Command_nova, "Purchases a Nova", 0);
    //XM1014
    RegConsoleCmd("sm_xm", Command_xm1014, "Purchases a XM-1014", 0);
    RegConsoleCmd("sm_xm1014", Command_xm1014, "Purchases a XM-1014", 0);
    //MAG7
    RegConsoleCmd("sm_mag7", Command_mag7, "Purchases a Mag-7", 0);
    RegConsoleCmd("sm_mag", Command_mag7, "Purchases a Mag-7", 0);
    //SAWED OFF
    RegConsoleCmd("sm_sawed", Command_sawed, "Purchases a Sawed-Off", 0);
    RegConsoleCmd("sm_sawedoff", Command_sawed, "Purchases a Sawed-Off", 0);
    
    //SCAR20
    RegConsoleCmd("sm_scar", Command_scar, "Purchases a SCAR-20", 0);
    //AWP
    RegConsoleCmd("sm_awp", Command_awp, "Purchases an AWP", 0);
    //SCOUT
    RegConsoleCmd("sm_ssg", Command_ssg08, "Purchases a SSG-08", 0);
    RegConsoleCmd("sm_scout", Command_ssg08, "Purchases a SSG-08", 0);
    //G3SG1
    RegConsoleCmd("sm_g3sg1", Command_g3sg1, "Purchases a G3SG1", 0);
    RegConsoleCmd("sm_g3s", Command_g3sg1, "Purchases a G3SG1", 0);
    
    //BIZON
    RegConsoleCmd("sm_pp", Command_bizon, "Purchases a PP-Bizon", 0);
    RegConsoleCmd("sm_bizon", Command_bizon, "Purchases a PP-Bizon", 0);
    //P90
    RegConsoleCmd("sm_p90", Command_p90, "Purchases a P90", 0);
    //MAC10
    RegConsoleCmd("sm_mac10", Command_mac10, "Purchases a Mac-10", 0);
    RegConsoleCmd("sm_mac", Command_mac10, "Purchases a Mac-10", 0);
    //MP9
    RegConsoleCmd("sm_mp9", Command_mp9, "Purchases a MP9", 0);
    //MP7
    RegConsoleCmd("sm_mp7", Command_mp7, "Purchases a MP7", 0);
    //MP5
    RegConsoleCmd("sm_mp5", Command_mp5, "Purchases a MP5-SD", 0);
    //UMP45
    RegConsoleCmd("sm_ump", Command_ump45, "Purchases a UMP-45", 0);
    
    //M249
    RegConsoleCmd("sm_m249", Command_m249, "Purchases a M249", 0);
    //NEGEV
    RegConsoleCmd("sm_negev", Command_negev, "Purchases a Negev", 0);
    
    //USP
    RegConsoleCmd("sm_usp", Command_usp, "Purchases an USP-S", 0);
    //GLOCK
    RegConsoleCmd("sm_glock", Command_glock, "Purchases a Glock-18", 0);
    //P250
    RegConsoleCmd("sm_p250", Command_p250, "Purchases a P250", 0);
    //DEAGLE
    RegConsoleCmd("sm_deagle", Command_deag, "Purchases a Desert Eagle", 0);
    //FIVE SEVEN
    RegConsoleCmd("sm_57", Command_57, "Purchases a FiveseveN", 0);
    RegConsoleCmd("sm_fiveseven", Command_57, "Purchases a FiveseveN", 0);
    //CZ
    RegConsoleCmd("sm_cz", Command_cz, "Purchases a CZ-75", 0);
    RegConsoleCmd("sm_cz75", Command_cz, "Purchases a CZ-75", 0);
    //R8
    RegConsoleCmd("sm_r8", Command_r8, "Purchases a R8-Revolver", 0);
    RegConsoleCmd("sm_revolver", Command_r8, "Purchases a R8-Revolver", 0);
    //ELITES
    RegConsoleCmd("sm_elite", Command_elites, "Purchases Dual Elites", 0);
    RegConsoleCmd("sm_elites", Command_elites, "Purchases Dual Elites", 0);
    RegConsoleCmd("sm_dualies", Command_elites, "Purchases Dual Elites", 0);
    //TEC9
    RegConsoleCmd("sm_tec9", Command_tec9, "Purchases a Tec-9", 0);
    RegConsoleCmd("sm_tec", Command_tec9, "Purchases a Tec-9", 0);
    //P2000
    RegConsoleCmd("sm_p2000", Command_p2k, "Purchases a HKP2000", 0);
    RegConsoleCmd("sm_p2k", Command_p2k, "Purchases a HKP2000", 0);

    //Kevlar
    RegConsoleCmd("sm_kev", Command_armor, "Replenish armor", 0);
    RegConsoleCmd("sm_kevlar", Command_armor, "Replenish armor", 0);
    //HE Grenade
    RegConsoleCmd("sm_he", Command_he, "Purchases a HE grenade", 0);
    //Flashbang Grenade
    RegConsoleCmd("sm_fb", Command_flash, "Purchases a flash bang", 0);
    RegConsoleCmd("sm_flash", Command_flash, "Purchases a flash bang", 0);
    //Decoy Grenade
    RegConsoleCmd("sm_de", Command_decoy, "Purchases a decoy nade", 0);
    RegConsoleCmd("sm_decoy", Command_decoy, "Purchases a decoy nade", 0);
    //Incendiary Grenade
    RegConsoleCmd("sm_fire", Command_incendiary, "Purchases an inciendary grenade", 0);
    RegConsoleCmd("sm_molotov", Command_incendiary, "Purchases an inciendary grenade", 0);
    RegConsoleCmd("sm_molo", Command_incendiary, "Purchases an inciendary grenade", 0);
    RegConsoleCmd("sm_incendiary", Command_incendiary, "Purchases an inciendary grenade", 0);
    //TAG Grenade
    RegConsoleCmd("sm_tg", Command_TagGrenade, "Purchases a TAG grenade", 0);
    RegConsoleCmd("sm_taggrenade", Command_TagGrenade, "Purchases a TAG grenade", 0);
    //Snowball
    RegConsoleCmd("sm_snowball", Command_snowball, "Purchases a snowball", 0);
    RegConsoleCmd("sm_snow", Command_snowball, "Purchases an snowball", 0);
    
    /* Hook Events */
    HookEvent("player_spawn", Hook_EventOnSpawn);
    
    /* Auto Execute Plugin Config */
    AutoExecConfig(true, "BuyCommandsRedux");
}

public void OnClientConnected(int client) {
    g_iSpam[client] = 0;
}

//==============================
// STOCK FUNCTIONS
//------------------------------
stock bool IsValidClient(int client, bool bAllowBots = false, bool bAllowDead = true)  {
    if(!(1 <= client <= MaxClients) || !IsClientInGame(client) || (IsFakeClient(client) && !bAllowBots) || IsClientSourceTV(client) || IsClientReplay(client) || (!bAllowDead && !IsPlayerAlive(client))) {
        return false;
    }
    return true;
}
stock bool IsClientCT(int client) {
    if(GetClientTeam(client) == 3) {
        return true;
    }
    return false;
}
stock int GetClientMoney(int client) {
    return GetEntProp(client, Prop_Send, "m_iAccount");
}
stock void SetClientMoney(int client, int money) {
    SetEntProp(client, Prop_Send, "m_iAccount", money);
}

//==============================
// EVENT HOOKS
//------------------------------
public Action Hook_EventOnSpawn(Handle event, const char[] name, bool broadcast) {
    int client = GetClientOfUserId(GetEventInt(event, "userid"));
    
    if(!IsClientInGame(client))
        return Plugin_Continue;
    if(!IsPlayerAlive(client))
        return Plugin_Continue;
    
    g_iHEAmount[client] = 0;
    g_iFlashAmount[client] = 0;
    g_iDecoyAmount[client] = 0;
    g_iIncAmount[client] = 0;
    g_iSnowAmount[client] = 0;
    g_iTagAmount[client] = 0;
    
    return Plugin_Continue;
}

public Action CS_OnTerminateRound(float &delay, CSRoundEndReason &reason) {
    for(int i = 1; i <= MaxClients; i++)
        if(IsClientInGame(i))
            g_iSpam[i] = 0;
    return Plugin_Continue;
}

//==============================
// ASSAULT RIFLE COMMANDS
//------------------------------
public Action Command_Galil(int client, int args) {
    if(!IsPlayerAlive(client) || !IsClientInGame(client) || !IsValidClient(client) || !IsClientCT(client))
        return Plugin_Handled;
    
    if(!g_cvar_Enable_AR.BoolValue) {
        CPrintToChat(client, "{green}[Buy Commands] {orange}'Assault Rifle' {default}purchases have been {red}disabled");
        return Plugin_Handled;
    }
    
    if(g_iSpam[client] > GetTime()) {
        CPrintToChat(client, "{green}[Buy Commands] {default}You can purchase {orange}'Galil AR' {default}again in {green}%i {default}seconds.", g_iSpam[client] - GetTime());
        return Plugin_Handled;
    }
    
    int cmoney = GetClientMoney(client);
    int gunprice = g_GalilPrice.IntValue;
    
    if(cmoney > gunprice) {
        SetClientMoney(client, cmoney - gunprice);
        CPrintToChat(client, "{green}[Buy Commands] {default}You purchased a {orange}'Galil AR' {default}for {green}$%i", g_GalilPrice.IntValue);
        
        g_iSpam[client] = GetTime() + g_cvar_RebuyCD.IntValue;
        
        if(g_cvar_DropOnRebuy.BoolValue) {
            int weapon = GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY);
            if(weapon != -1) {
                SDKHooks_DropWeapon(client, weapon);
                GivePlayerItem(client, "weapon_galilar");
            }
            else GivePlayerItem(client, "weapon_galilar");
        }
    }
    else if(cmoney < gunprice)
        CPrintToChat(client, "{green}[Buy Commands] {default}You do not have enough money to purchase {orange}'Galil AR' {default}(Missing {green}$%i{default})", g_GalilPrice.IntValue - cmoney);
    
    return Plugin_Handled;
}

public Action Command_ak(int client, int args) {
    if(!IsPlayerAlive(client) || !IsClientInGame(client) || !IsValidClient(client) || !IsClientCT(client))
        return Plugin_Handled;
    
    if(!g_cvar_Enable_AR.BoolValue) {
        CPrintToChat(client, "{green}[Buy Commands] {orange}'Assault Rifle' {default}purchases have been {red}disabled");
        return Plugin_Handled;
    }
    
    if(g_iSpam[client] > GetTime()) {
        CPrintToChat(client, "{green}[Buy Commands] {default}You can purchase an {orange}'AK-47' {default}again in {green}%i {default}seconds.", g_iSpam[client] - GetTime());
        return Plugin_Handled;
    }
    
    int cmoney = GetClientMoney(client);
    int gunprice = g_AKPrice.IntValue;
    
    if(cmoney > gunprice) {
        SetClientMoney(client, cmoney - gunprice);
        CPrintToChat(client, "{green}[Buy Commands] {default}You purchased an {orange}'AK-47' {default}for {green}$%i", g_AKPrice.IntValue);

        g_iSpam[client] = GetTime() + g_cvar_RebuyCD.IntValue;

        if(g_cvar_DropOnRebuy.BoolValue) {
            int weapon = GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY);
            if(weapon != -1) {
                SDKHooks_DropWeapon(client, weapon);
                GivePlayerItem(client, "weapon_ak47");
            }
            else GivePlayerItem(client, "weapon_ak47");
        }
    }
    else if(cmoney < gunprice)
        CPrintToChat(client, "{green}[Buy Commands] {default}You do not have enough money to purchase an {orange}'AK-47' {default}(Missing {green}$%i{default})", gunprice - cmoney);
    
    return Plugin_Handled;
}

public Action Command_sg556(int client, int args) {
    if(!IsPlayerAlive(client) || !IsClientInGame(client) || !IsValidClient(client) || !IsClientCT(client))
        return Plugin_Handled;
        
    if(!g_cvar_Enable_AR.BoolValue) {
        CPrintToChat(client, "{green}[Buy Commands] {orange}'Assault Rifle' {default}purchases have been {red}disabled");
        return Plugin_Handled;
    }
    
    if(g_iSpam[client] > GetTime()) {
        CPrintToChat(client, "{green}[Buy Commands] {default}You can purchase a {orange}'SG-556' {Default}again in {green}%i {default}seconds.", g_iSpam[client] - GetTime());
        return Plugin_Handled;
    }
    
    int cmoney = GetClientMoney(client);
    int gunprice = g_SG556Price.IntValue;
    
    if(cmoney > gunprice) {
        SetClientMoney(client, cmoney - gunprice);
        CPrintToChat(client, "{green}[Buy Commands] {default}You purchased a {orange}'SG-556' {default}for {green}$%i", g_SG556Price.IntValue);

        g_iSpam[client] = GetTime() + g_cvar_RebuyCD.IntValue;

        if(g_cvar_DropOnRebuy.BoolValue) {
            int weapon = GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY);
            if(weapon != -1) {
                SDKHooks_DropWeapon(client, weapon);
                GivePlayerItem(client, "weapon_sg556");
            }
            else GivePlayerItem(client, "weapon_sg556");
        }
    }
    else if(cmoney < gunprice)
        CPrintToChat(client, "{green}[Buy Commands] {default}You do not have enough money to purchase a {orange}'SG-556' {default}(Missing {green}$%i{default})", gunprice - cmoney);
    
    return Plugin_Handled;
}

public Action Command_m4a4(int client, int args) {
    if(!IsPlayerAlive(client) || !IsClientInGame(client) || !IsValidClient(client) || !IsClientCT(client))
        return Plugin_Handled;
    
    if(!g_cvar_Enable_AR.BoolValue) {
        CPrintToChat(client, "{green}[Buy Commands] {orange}'Assault Rifle' {default}purchases have been {red}disabled");
        return Plugin_Handled;
    }
    
    if(g_iSpam[client] > GetTime()) {
        CPrintToChat(client, "{green}[Buy Commands] {default}You can purchase {orange}'M4A4' {default}again in {green}%i {default}seconds.", g_iSpam[client] - GetTime());
        return Plugin_Handled;
    }
    
    int cmoney = GetClientMoney(client);
    int gunprice = g_M4Price.IntValue;
    
    if(cmoney > gunprice) {
        SetClientMoney(client, cmoney - gunprice);
        CPrintToChat(client, "{green}[Buy Commands] {default}You purchased a {orange}'M4A4' {default}for {green}$%i", g_M4Price.IntValue);
        
        g_iSpam[client] = GetTime() + g_cvar_RebuyCD.IntValue;
        
        if(g_cvar_DropOnRebuy.BoolValue) {
            int weapon = GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY);
            if(weapon != -1) {
                SDKHooks_DropWeapon(client, weapon);
                GivePlayerItem(client, "weapon_m4a1");
            }
            else GivePlayerItem(client, "weapon_m4a1");
        }
    }
    else if(cmoney < gunprice)
        CPrintToChat(client, "{green}[Buy Commands] {default}You do not have enough money to purchase a {orange}'M4A4' {default}(Missing {green}$%i{default})", gunprice - cmoney);
    
    return Plugin_Handled;
}

public Action Command_m4a1s(int client, int args) {
    if(!IsPlayerAlive(client) || !IsClientInGame(client) || !IsValidClient(client) || !IsClientCT(client))
        return Plugin_Handled;
    
    if(!g_cvar_Enable_AR.BoolValue) {
        CPrintToChat(client, "{green}[Buy Commands] {orange}'Assault Rifle' {default}purchases have been {red}disabled");
        return Plugin_Handled;
    }
    
    if(g_iSpam[client] > GetTime()) {
        CPrintToChat(client, "{green}[Buy Commands] {default}You can purchase {orange}'M4A1-S' {default}again in {green}%i {default}seconds.",g_iSpam[client]-GetTime());
        return Plugin_Handled;
    }
    
    int cmoney = GetClientMoney(client);
    int gunprice = g_M4SPrice.IntValue;
    
    if(cmoney > gunprice) {
        SetClientMoney(client, cmoney - gunprice);
        CPrintToChat(client, "{green}[Buy Commands] {default}You purchased a {orange}'M4A1-S' {default}for {green}$%i", g_M4SPrice.IntValue);
        
        g_iSpam[client] = GetTime() + g_cvar_RebuyCD.IntValue;
        
        if(g_cvar_DropOnRebuy.BoolValue) {
            int weapon = GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY);
            if(weapon != -1) {
                SDKHooks_DropWeapon(client, weapon);
                GivePlayerItem(client, "weapon_m4a1_silencer");
            }
            else GivePlayerItem(client, "weapon_m4a1_silencer");
        }
    }
    else if(cmoney < gunprice)
        CPrintToChat(client, "{green}[Buy Commands] {default}You do not have enough money to purchase a {orange}'M4A1-S' {default}(Missing {green}$%i{default})", gunprice - cmoney);
    
    return Plugin_Handled;
}

public Action Command_aug(int client, int args) {
    if(!IsPlayerAlive(client) || !IsClientInGame(client) || !IsValidClient(client) || !IsClientCT(client))
        return Plugin_Handled;
    
    if(!g_cvar_Enable_AR.BoolValue) {
        CPrintToChat(client, "{green}[Buy Commands] {orange}'Assault Rifle' {default}purchases have been {red}disabled");
        return Plugin_Handled;
    }
    
    if(g_iSpam[client] > GetTime()) {
        CPrintToChat(client, "{green}[Buy Commands] {default}You can purchase an {orange}'AUG' {default}again in {green}%i {default}seconds.",g_iSpam[client]-GetTime());
        return Plugin_Handled;
    }
    
    int cmoney = GetClientMoney(client);
    int gunprice = g_AUGPrice.IntValue;
    
    if(cmoney > gunprice) {
        SetClientMoney(client, cmoney - gunprice);
        CPrintToChat(client, "{green}[Buy Commands] {default}You purchased an {orange}'AUG' {default}for {green}$%i", g_AUGPrice.IntValue);
        
        g_iSpam[client] = GetTime() + g_cvar_RebuyCD.IntValue;
        
        if(g_cvar_DropOnRebuy.BoolValue) {
            int weapon = GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY);
            if(weapon != -1) {
                SDKHooks_DropWeapon(client, weapon);
                GivePlayerItem(client, "weapon_aug");
            }
            else GivePlayerItem(client, "weapon_aug");
        }
    }
    else if(cmoney < gunprice)
        CPrintToChat(client, "{green}[Buy Commands] {default}You do not have enough money to purchase an {orange}'AUG' {default}(Missing {green}$%i{default})", gunprice - cmoney);
    
    return Plugin_Handled;
}

public Action Command_famas(int client, int args) {
    if(!IsPlayerAlive(client) || !IsClientInGame(client) || !IsValidClient(client) || !IsClientCT(client))
        return Plugin_Handled;
    
    if(!g_cvar_Enable_AR.BoolValue) {
        CPrintToChat(client, "{green}[Buy Commands] {orange}'Assault Rifle' {default}purchases have been {red}disabled");
        return Plugin_Handled;
    }
    
    if(g_iSpam[client] > GetTime()) {
        CPrintToChat(client, "{green}[Buy Commands] {default}You can purchase a {orange}'FAMAS' {default}again in {green}%i {default}seconds.",g_iSpam[client]-GetTime());
        return Plugin_Handled;
    }
    
    int cmoney = GetClientMoney(client);
    int gunprice = g_FAMASPrice.IntValue;
    
    if(cmoney > gunprice) {
        SetClientMoney(client, cmoney - gunprice);
        CPrintToChat(client, "{green}[Buy Commands] {default}You purchased a {orange}'FAMAS' {default}for {green}$%i", g_FAMASPrice.IntValue);
        
        g_iSpam[client] = GetTime()+g_cvar_RebuyCD.IntValue;
        
        if(g_cvar_DropOnRebuy.BoolValue) {
            int weapon = GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY);
            if(weapon != -1) {
                SDKHooks_DropWeapon(client, weapon);
                GivePlayerItem(client, "weapon_famas");
            }
            else GivePlayerItem(client, "weapon_famas");
        }
    }
    else if(cmoney < gunprice)
        CPrintToChat(client, "{green}[Buy Commands] {default}You do not have enough money to purchase a {orange}'FAMAS' {default}(Missing {green}$%i{default})", gunprice - cmoney);
    
    return Plugin_Handled;
}

//==============================
// SHOTGUN COMMANDS
//------------------------------
public Action Command_nova(int client, int args) {
    if(!IsPlayerAlive(client) || !IsClientInGame(client) || !IsValidClient(client) || !IsClientCT(client))
        return Plugin_Handled;
    
    if(!g_cvar_Enable_Shotgun.BoolValue) {
        CPrintToChat(client, "{green}[Buy Commands] {orange}'Shotgun' {default}purchases have been {red}disabled");
        return Plugin_Handled;
    }
    
    if(g_iSpam[client] > GetTime()) {
        CPrintToChat(client, "{green}[Buy Commands] {default}You can purchase a {orange}'Nova' {Default}again in {green}%i {default}seconds.", g_iSpam[client] - GetTime());
        return Plugin_Handled;
    }
    
    int cmoney = GetClientMoney(client);
    int gunprice = g_NovaPrice.IntValue;
    
    if(cmoney > gunprice) {
        SetClientMoney(client, cmoney - gunprice);
        CPrintToChat(client, "{green}[Buy Commands] {default}You purchased a {orange}'Nova' {default}for {green}$%i", g_NovaPrice.IntValue);

        g_iSpam[client] = GetTime() + g_cvar_RebuyCD.IntValue;

        if(g_cvar_DropOnRebuy.BoolValue) {
            int weapon = GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY);
            if(weapon != -1) {
                SDKHooks_DropWeapon(client, weapon);
                GivePlayerItem(client, "weapon_nova");
            }
            else GivePlayerItem(client, "weapon_nova");
        }
    }
    else if(cmoney < gunprice)
        CPrintToChat(client, "{green}[Buy Commands] {default}You do not have enough money to purchase a {orange}'Nova' {default}(Missing {green}$%i{default})", gunprice - cmoney);
    
    return Plugin_Handled;
}

public Action Command_xm1014(int client, int args) {
    if(!IsPlayerAlive(client) || !IsClientInGame(client) || !IsValidClient(client) || !IsClientCT(client))
        return Plugin_Handled;
    
    if(!g_cvar_Enable_Shotgun.BoolValue) {
        CPrintToChat(client, "{green}[Buy Commands] {orange}'Shotgun' {default}purchases have been {red}disabled");
        return Plugin_Handled;
    }
    
    if(g_iSpam[client] > GetTime()) {
        CPrintToChat(client, "{green}[Buy Commands] {default}You can purchase a {orange}'XM-1014' {default}again in {green}%i {default}seconds.", g_iSpam[client] - GetTime());
        return Plugin_Handled;
    }
    
    int cmoney = GetClientMoney(client);
    int gunprice = g_XM1014Price.IntValue;
    
    if(cmoney > gunprice) {
        SetClientMoney(client, cmoney - gunprice);
        CPrintToChat(client, "{green}[Buy Commands] {default}You purchased a {orange}'XM-1014' {default}for {green}$%i", g_XM1014Price.IntValue);

        g_iSpam[client] = GetTime() + g_cvar_RebuyCD.IntValue;

        if(g_cvar_DropOnRebuy.BoolValue) {
            int weapon = GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY);
            if(weapon != -1) {
                SDKHooks_DropWeapon(client, weapon);
                GivePlayerItem(client, "weapon_xm1014");
            }
            else GivePlayerItem(client, "weapon_xm1014");
        }
    }
    else if(cmoney < gunprice)
        CPrintToChat(client, "{green}[Buy Commands] {default}You do not have enough money to purchase a {orange}'XM-1014' {default}(Missing {green}$%i{default})", gunprice - cmoney);
    
    return Plugin_Handled;
}

public Action Command_mag7(int client, int args) {
    if(!IsPlayerAlive(client) || !IsClientInGame(client) || !IsValidClient(client) || !IsClientCT(client))
        return Plugin_Handled;
    
    if(!g_cvar_Enable_Shotgun.BoolValue) {
        CPrintToChat(client, "{green}[Buy Commands] {orange}'Shotgun' {default}purchases have been {red}disabled");
        return Plugin_Handled;
    }
    
    if(g_iSpam[client] > GetTime()) {
        CPrintToChat(client, "{green}[Buy Commands] {default}You can purchase a {orange}'Mag-7' {default}again in {green}%i {default}seconds.", g_iSpam[client] - GetTime());
        return Plugin_Handled;
    }
    
    int cmoney = GetClientMoney(client);
    int gunprice = g_Mag7Price.IntValue;
    
    if(cmoney > gunprice) {
        SetClientMoney(client, cmoney - gunprice);
        CPrintToChat(client, "{green}[Buy Commands] {default}You purchased a {orange}'Mag-7' {default}for {green}$%i", g_Mag7Price.IntValue);

        g_iSpam[client] = GetTime() + g_cvar_RebuyCD.IntValue;

        if(g_cvar_DropOnRebuy.BoolValue)
        {
            int weapon = GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY);
            if(weapon != -1)
            {
                SDKHooks_DropWeapon(client, weapon);
                GivePlayerItem(client, "weapon_mag7");
            }
            else GivePlayerItem(client, "weapon_mag7");
        }
    }
    else if(cmoney < gunprice)
        CPrintToChat(client, "{green}[Buy Commands] {default}You do not have enough money to purchase a {orange}'XM-1014' {default}(Missing {green}$%i{default})", gunprice - cmoney);
    
    return Plugin_Handled;
}

public Action Command_sawed(int client, int args) {
    if(!IsPlayerAlive(client) || !IsClientInGame(client) || !IsValidClient(client) || !IsClientCT(client))
        return Plugin_Handled;
    
    if(!g_cvar_Enable_Shotgun.BoolValue) {
        CPrintToChat(client, "{green}[Buy Commands] {orange}'Shotgun' {default}purchases have been {red}disabled");
        return Plugin_Handled;
    }
    
    if(g_iSpam[client] > GetTime()) {
        CPrintToChat(client, "{green}[Buy Commands] {default}You can purchase a {orange}'Sawed Off' {default}again in {green}%i {default}seconds.", g_iSpam[client] - GetTime());
        return Plugin_Handled;
    }
    
    int cmoney = GetClientMoney(client);
    int gunprice = g_SawedOffPrice.IntValue;
    
    if(cmoney > gunprice) {
        SetClientMoney(client, cmoney - gunprice);
        CPrintToChat(client, "{green}[Buy Commands] {default}You purchased a {orange}'Sawed Off' {default}for {green}$%i", g_SawedOffPrice.IntValue);

        g_iSpam[client] = GetTime()+g_cvar_RebuyCD.IntValue;

        if(g_cvar_DropOnRebuy.BoolValue) {
            int weapon = GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY);
            if(weapon != -1) {
                SDKHooks_DropWeapon(client, weapon);
                GivePlayerItem(client, "weapon_sawedoff");
            }
            else GivePlayerItem(client, "weapon_sawedoff");
        }
    }
    else if(cmoney < gunprice)
        CPrintToChat(client, "{green}[Buy Commands] {default}You do not have enough money to purchase a {orange}'Sawed Off' {default}(Missing {green}$%i{default})", gunprice - cmoney);
    
    return Plugin_Handled;
}

//==============================
// SMG COMMANDS
//------------------------------
public Action Command_mac10(int client, int args) {
    if(!IsPlayerAlive(client) || !IsClientInGame(client) || !IsValidClient(client) || !IsClientCT(client))
        return Plugin_Handled;
    
    if(!g_cvar_Enable_SMG.BoolValue) {
        CPrintToChat(client, "{green}[Buy Commands] {orange}'SMG' {default}purchases have been {red}disabled");
        return Plugin_Handled;
    }
    
    if(g_iSpam[client] > GetTime()) {
        CPrintToChat(client, "{green}[Buy Commands] {default}You can purchase {orange}'Mac-10' {default}again in {green}%i {default}seconds.",g_iSpam[client]-GetTime());
        return Plugin_Handled;
    }
    
    int cmoney = GetClientMoney(client);
    int gunprice = g_Mac10Price.IntValue;
    
    if(cmoney > gunprice) {
        SetClientMoney(client, cmoney - gunprice);
        CPrintToChat(client, "{green}[Buy Commands] {default}You purchased a {orange}'Mac-10' {default}for {green}$%i", g_Mac10Price.IntValue);

        g_iSpam[client] = GetTime() + g_cvar_RebuyCD.IntValue;

        if(g_cvar_DropOnRebuy.BoolValue) {
            int weapon = GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY);
            if(weapon != -1) {
                SDKHooks_DropWeapon(client, weapon);
                GivePlayerItem(client, "weapon_mac10");
            }
            else GivePlayerItem(client, "weapon_mac10");
        }
    }
    else if(cmoney < gunprice)
        CPrintToChat(client, "{green}[Buy Commands] {default}You do not have enough money to purchase a {orange}'Mac-10' {default}(Missing {green}$%i{default})", gunprice - cmoney);
    
    return Plugin_Handled;
}

public Action Command_mp9(int client, int args) {
    if(!IsPlayerAlive(client) || !IsClientInGame(client) || !IsValidClient(client) || !IsClientCT(client))
        return Plugin_Handled;
    
    if(!g_cvar_Enable_SMG.BoolValue) {
        CPrintToChat(client, "{green}[Buy Commands] {orange}'SMG' {default}purchases have been {red}disabled");
        return Plugin_Handled;
    }
    
    if(g_iSpam[client] > GetTime()) {
        CPrintToChat(client, "{green}[Buy Commands] {default}You can purchase a {orange}'MP9' {default}again in {green}%i {default}seconds.", g_iSpam[client] - GetTime());
        return Plugin_Handled;
    }
    
    int cmoney = GetClientMoney(client);
    int gunprice = g_Mp9Price.IntValue;
    
    if(cmoney > gunprice) {
        SetClientMoney(client, cmoney - gunprice);
        CPrintToChat(client, "{green}[Buy Commands] {default}You purchased a {orange}'MP9' {default}for {green}$%i", g_Mp9Price.IntValue);
        
        g_iSpam[client] = GetTime() + g_cvar_RebuyCD.IntValue;
        
        if(g_cvar_DropOnRebuy.BoolValue) {
            int weapon = GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY);
            if(weapon != -1) {
                SDKHooks_DropWeapon(client, weapon);
                GivePlayerItem(client, "weapon_mp9");
            }
            else GivePlayerItem(client, "weapon_mp9");
        }
    }
    else if(cmoney < gunprice)
        CPrintToChat(client, "{green}[Buy Commands] {default}You do not have enough money to purchase a {orange}'MP9' {default}(Missing {green}$%i{default})", gunprice - cmoney);
    
    return Plugin_Handled;
}

public Action Command_mp7(int client, int args) {
    if(!IsPlayerAlive(client) || !IsClientInGame(client) || !IsValidClient(client) || !IsClientCT(client))
        return Plugin_Handled;
    
    if(!g_cvar_Enable_SMG.BoolValue) {
        CPrintToChat(client, "{green}[Buy Commands] {orange}'SMG' {default}purchases have been {red}disabled");
        return Plugin_Handled;
    }
    
    if(g_iSpam[client] > GetTime()) {
        CPrintToChat(client, "{green}[Buy Commands] {default}You can purchase {orange}'MP7' {default} again in {green}%i {default}seconds.",g_iSpam[client]-GetTime());
        return Plugin_Handled;
    }
    
    int cmoney = GetClientMoney(client);
    int gunprice = g_Mp7Price.IntValue;
    
    if(cmoney > gunprice) {
        SetClientMoney(client, cmoney - gunprice);
        CPrintToChat(client, "{green}[Buy Commands] {default}You purchased a {orange}'MP7' {default}for {green}$%i", g_Mp7Price.IntValue);
        
        g_iSpam[client] = GetTime() + g_cvar_RebuyCD.IntValue;
        
        if(g_cvar_DropOnRebuy.BoolValue) {
            int weapon = GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY);
            if(weapon != -1) {
                SDKHooks_DropWeapon(client, weapon);
                GivePlayerItem(client, "weapon_mp7");
            }
            else GivePlayerItem(client, "weapon_mp7");
        }
    }
    else if(cmoney < gunprice)
        CPrintToChat(client, "{green}[Buy Commands] {default}You do not have enough money to purchase a {orange}'MP7' {default}(Missing {green}$%i{default})", gunprice - cmoney);
    
    return Plugin_Handled;
}

public Action Command_mp5(int client, int args) {
    if(!IsPlayerAlive(client) || !IsClientInGame(client) || !IsValidClient(client) || !IsClientCT(client))
        return Plugin_Handled;
    
    if(!g_cvar_Enable_SMG.BoolValue) {
        CPrintToChat(client, "{green}[Buy Commands] {orange}'SMG' {default}purchases have been {red}disabled");
        return Plugin_Handled;
    }
    
    if(g_iSpam[client] > GetTime()) {
        CPrintToChat(client, "{green}[Buy Commands] {default}You can purchase a {orange}'MP5-SD' {default}again in {green}%i {default}seconds.", g_iSpam[client] - GetTime());
        return Plugin_Handled;
    }
    
    int cmoney = GetClientMoney(client);
    int gunprice = g_MP5SDPrice.IntValue;
    
    if(cmoney > gunprice) {
        SetClientMoney(client, cmoney - gunprice);
        CPrintToChat(client, "{green}[Buy Commands] {default}You purchased a {orange}'MP5-SD' {default}for {green}$%i", g_MP5SDPrice.IntValue);
        
        g_iSpam[client] = GetTime() + g_cvar_RebuyCD.IntValue;
        
        if(g_cvar_DropOnRebuy.BoolValue) {
            int weapon = GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY);
            if(weapon != -1) {
                SDKHooks_DropWeapon(client, weapon);
                GivePlayerItem(client, "weapon_mp5sd");
            }
            else GivePlayerItem(client, "weapon_mp5sd");
        }
    }
    else if(cmoney < gunprice)
        CPrintToChat(client, "{green}[Buy Commands] {default}You do not have enough money to purchase a {orange}'MP5-SD' {default}(Missing {green}$%i{default})", gunprice - cmoney);
    
    return Plugin_Handled;
}

public Action Command_ump45(int client, int args) {
    if(!IsPlayerAlive(client) || !IsClientInGame(client) || !IsValidClient(client) || !IsClientCT(client))
        return Plugin_Handled;
    
    if(!g_cvar_Enable_SMG.BoolValue) {
        CPrintToChat(client, "{green}[Buy Commands] {orange}'SMG' {default}purchases have been {red}disabled");
        return Plugin_Handled;
    }
    
    if(g_iSpam[client] > GetTime()) {
        CPrintToChat(client, "{green}[Buy Commands] {default}}You can purchase an {orange}'UMP-45' {default} again in {green}%i {default}seconds.", g_iSpam[client] - GetTime());
        return Plugin_Handled;
    }
    
    int cmoney = GetClientMoney(client);
    int gunprice = g_UMP45Price.IntValue;
    
    if(cmoney > gunprice) {
        SetClientMoney(client, cmoney - gunprice);
        CPrintToChat(client, "{green}[Buy Commands] {default}You purchased an {orange}'UMP-45' {default}for {green}$%i", g_UMP45Price.IntValue);

        g_iSpam[client] = GetTime() + g_cvar_RebuyCD.IntValue;

        if(g_cvar_DropOnRebuy.BoolValue) {
            int weapon = GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY);
            if(weapon != -1) {
                SDKHooks_DropWeapon(client, weapon);
                GivePlayerItem(client, "weapon_ump45");
            }
            else GivePlayerItem(client, "weapon_ump45");
        }
    }
    else if(cmoney < gunprice)
        CPrintToChat(client, "{green}[Buy Commands] {default}You do not have enough money to purchase an {orange}'UMP-45' {default}(Missing {green}$%i{default})", gunprice - cmoney);
    
    return Plugin_Handled;
}

public Action Command_bizon(int client, int args) {
    if(!IsPlayerAlive(client) || !IsClientInGame(client) || !IsValidClient(client) || !IsClientCT(client))
        return Plugin_Handled;
    
    if(!g_cvar_Enable_SMG.BoolValue) {
        CPrintToChat(client, "{green}[Buy Commands] {orange}'SMG' {default}purchases have been {red}disabled");
        return Plugin_Handled;
    }
    
    if(g_iSpam[client] > GetTime()) {
        CPrintToChat(client, "{green}[Buy Commands] {default}You can purchase a {orange}'PP-Bizon' {default}again in {green}%i {default}seconds.",g_iSpam[client]-GetTime());
        return Plugin_Handled;
    }
    
    int cmoney = GetClientMoney(client);
    int gunprice = g_BizonPrice.IntValue;
    
    if(cmoney > gunprice) {
        SetClientMoney(client, cmoney - gunprice);
        CPrintToChat(client, "{green}[Buy Commands] {default}You purchased a {orange}'PP-Bizon' {default}for {green}$%i", g_BizonPrice.IntValue);

        g_iSpam[client] = GetTime() + g_cvar_RebuyCD.IntValue;

        if(g_cvar_DropOnRebuy.BoolValue) {
            int weapon = GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY);
            if(weapon != -1) {
                SDKHooks_DropWeapon(client, weapon);
                GivePlayerItem(client, "weapon_bizon");
            }
            else GivePlayerItem(client, "weapon_bizon");
        }
    }
    else if(cmoney < gunprice)
        CPrintToChat(client, "{green}[Buy Commands] {default}You do not have enough money to purchase a {orange}'PP-Bizon' {default}(Missing {green}$%i{default})", gunprice - cmoney);
    
    return Plugin_Handled;
}

public Action Command_p90(int client, int args) {
    if(!IsPlayerAlive(client) || !IsClientInGame(client) || !IsValidClient(client) || !IsClientCT(client))
        return Plugin_Handled;
    
    if(!g_cvar_Enable_SMG.BoolValue) {
        CPrintToChat(client, "{green}[Buy Commands] {orange}'SMG' {default}purchases have been {red}disabled");
        return Plugin_Handled;
    }
    
    if(g_iSpam[client] > GetTime()) {
        CPrintToChat(client, "{green}[Buy Commands] {default}You can purchase a {orange}'P90' {default}again in {green}%i {default}seconds.",g_iSpam[client]-GetTime());
        return Plugin_Handled;
    }
    
    int cmoney = GetClientMoney(client);
    int gunprice = g_P90Price.IntValue;
    
    if(cmoney > gunprice) {
        SetClientMoney(client, cmoney - gunprice);
        CPrintToChat(client, "{green}[Buy Commands] {default}You purchased a {orange}'P90' {default}for {green}$%i", g_P90Price.IntValue);

        g_iSpam[client] = GetTime() + g_cvar_RebuyCD.IntValue;

        if(g_cvar_DropOnRebuy.BoolValue) {
            int weapon = GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY);
            if(weapon != -1) {
                SDKHooks_DropWeapon(client, weapon);
                GivePlayerItem(client, "weapon_p90");
            }
            else GivePlayerItem(client, "weapon_p90");
        }
    }
    else if(cmoney < gunprice)
        CPrintToChat(client, "{green}[Buy Commands] {default}You do not have enough money to purchase a {orange}'P90' {default}(Missing {green}$%i{default})", gunprice - cmoney);
    
    return Plugin_Handled;
}

//==============================
// MACHING GUN COMMANDS
//------------------------------
public Action Command_m249(int client, int args) {
    if(!IsPlayerAlive(client) || !IsClientInGame(client) || !IsValidClient(client) || !IsClientCT(client))
        return Plugin_Handled;
    
    if(!g_cvar_Enable_MG.BoolValue) {
        CPrintToChat(client, "{green}[Buy Commands] {orange}'Machine Gun' {default}purchases have been {red}disabled");
        return Plugin_Handled;
    }
    
    if(g_iSpam[client] > GetTime()) {
        CPrintToChat(client, "{green}[Buy Commands] {default}You can purchase a {orange}'M249' {default}again in {green}%i {default}seconds.", g_iSpam[client] - GetTime());
        return Plugin_Handled;
    }
    
    int cmoney = GetClientMoney(client);
    int gunprice = g_M249Price.IntValue;
    
    if(cmoney > gunprice) {
        SetClientMoney(client, cmoney - gunprice);
        CPrintToChat(client, "{green}[Buy Commands] {default}You purchased a {orange}'M249' {default}for {green}$%i", g_M249Price.IntValue);
        
        g_iSpam[client] = GetTime() + g_cvar_RebuyCD.IntValue;
        
        if(g_cvar_DropOnRebuy.BoolValue) {
            int weapon = GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY);
            if(weapon != -1) {
                SDKHooks_DropWeapon(client, weapon);
                GivePlayerItem(client, "weapon_m249");
            }
            else GivePlayerItem(client, "weapon_m249");
        }
    }
    else if(cmoney < gunprice)
        CPrintToChat(client, "{green}[Buy Commands] {default}You do not have enough money to purchase a {orange}'M249' {default}(Missing {green}$%i{default})", gunprice - cmoney);
    
    return Plugin_Handled;
}

public Action Command_negev(int client, int args) {
    if(!IsPlayerAlive(client) || !IsClientInGame(client) || !IsValidClient(client) || !IsClientCT(client))
        return Plugin_Handled;
    
    if(!g_cvar_Enable_MG.BoolValue) {
        CPrintToChat(client, "{green}[Buy Commands] {orange}'Machine Gun' {default}purchases have been {red}disabled");
        return Plugin_Handled;
    }
    
    if(g_iSpam[client] > GetTime()) {
        CPrintToChat(client, "{green}[Buy Commands] {default}You can purchase a {orange}'Negev' {default}again in {green}%i {default}seconds.",g_iSpam[client]-GetTime());
        return Plugin_Handled;
    }
    
    int cmoney = GetClientMoney(client);
    int gunprice = g_NegevPrice.IntValue;
    
    if(cmoney > gunprice) {
        SetClientMoney(client, cmoney - gunprice);
        CPrintToChat(client, "{green}[Buy Commands] {default}You purchased a {orange}'Negev' {default}for {green}$%i", g_NegevPrice.IntValue);
        
        g_iSpam[client] = GetTime()+g_cvar_RebuyCD.IntValue;
        
        if(g_cvar_DropOnRebuy.BoolValue) {
            int weapon = GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY);
            if(weapon != -1) {
                SDKHooks_DropWeapon(client, weapon);
                GivePlayerItem(client, "weapon_negev");
            }
            else GivePlayerItem(client, "weapon_negev");
        }
    }
    else if(cmoney < gunprice)
        CPrintToChat(client, "{green}[Buy Commands] {default}You do not have enough money to purchase a {orange}'Negev' {default}(Missing {green}$%i{default})", gunprice - cmoney);
    
    return Plugin_Handled;
}

//==============================
// SNIPER RIFLE COMMANDS
//------------------------------
public Action Command_scar(int client, int args) {
    if(!IsPlayerAlive(client) || !IsClientInGame(client) || !IsValidClient(client) || !IsClientCT(client))
        return Plugin_Handled;
    
    if(!g_cvar_Enable_Sniper.BoolValue) {
        CPrintToChat(client, "{green}[Buy Commands] {orange}'Sniper Rifle' {default}purchases have been {red}disabled");
        return Plugin_Handled;
    }
    
    if(g_iSpam[client] > GetTime()) {
        CPrintToChat(client, "{green}[Buy Commands] {default}You can purchase {orange}'SCAR-20' {default}again in {green}%i {default}seconds.",g_iSpam[client]-GetTime());
        return Plugin_Handled;
    }
    
    int cmoney = GetClientMoney(client);
    int gunprice = g_SCAR20Price.IntValue;
    
    if(cmoney > gunprice) {
        SetClientMoney(client, cmoney - gunprice);
        CPrintToChat(client, "{green}[Buy Commands] {default}You purhcased a {orange}'SCAR-20' {default}for {green}$%i", g_SCAR20Price.IntValue);
        
        g_iSpam[client] = GetTime() + g_cvar_RebuyCD.IntValue;
        
        if(g_cvar_DropOnRebuy.BoolValue) {
            int weapon = GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY);
            if(weapon != -1) {
                SDKHooks_DropWeapon(client, weapon);
                GivePlayerItem(client, "weapon_scar20");
            }
            else GivePlayerItem(client, "weapon_scar20");
        }
    }
    else if(cmoney < gunprice)
        CPrintToChat(client, "{green}[Buy Commands] {default}You do not have enough money to purchase a {orange}'SCAR-20' {default}(Missing {green}$%i{default})", gunprice - cmoney);
    
    return Plugin_Handled;
}

public Action Command_awp(int client, int args) {
    if(!IsPlayerAlive(client) || !IsClientInGame(client) || !IsValidClient(client) || !IsClientCT(client))
        return Plugin_Handled;
    
    if(!g_cvar_Enable_Sniper.BoolValue) {
        CPrintToChat(client, "{green}[Buy Commands] {orange}'Sniper Rifle' {default}purchases have been {red}disabled");
        return Plugin_Handled;
    }
    
    if(g_iSpam[client] > GetTime()) {
        CPrintToChat(client, "{green}[Buy Commands] {default}You can purchase an {orange}'AWP' {default}again in {green}%i {default}seconds.", g_iSpam[client] - GetTime());
        return Plugin_Handled;
    }
    
    int cmoney = GetClientMoney(client);
    int gunprice = g_AWPPrice.IntValue;
    
    if(cmoney > gunprice) {
        SetClientMoney(client, cmoney - gunprice);
        CPrintToChat(client, "{green}[Buy Commands] {default}You purchased an {orange}'AWP' {default}for {green}$%i", g_AWPPrice.IntValue);
        
        g_iSpam[client] = GetTime() + g_cvar_RebuyCD.IntValue;
        
        if(g_cvar_DropOnRebuy.BoolValue) {
            int weapon = GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY);
            if(weapon != -1) {
                SDKHooks_DropWeapon(client, weapon);
                GivePlayerItem(client, "weapon_awp");
            }
            else GivePlayerItem(client, "weapon_awp");
        }
    }
    else if(cmoney < gunprice)
        CPrintToChat(client, "{green}[Buy Commands] {default}You do not have enough money to purchase an {orange}'AWP' {default}(Missing {green}$%i{default})", gunprice - cmoney);
    
    return Plugin_Handled;
}

public Action Command_ssg08(int client, int args) {
    if(!IsPlayerAlive(client) || !IsClientInGame(client) || !IsValidClient(client) || !IsClientCT(client))
        return Plugin_Handled;
    
    if(!g_cvar_Enable_Sniper.BoolValue) {
        CPrintToChat(client, "{green}[Buy Commands] {orange}'Sniper Rifle' {default}purchases have been {red}disabled");
        return Plugin_Handled;
    }
    
    if(g_iSpam[client] > GetTime()) {
        CPrintToChat(client, "{green}[Buy Commands] {default}You can purchase {orange}'SSG-08' {default}again in {green}%i {default}seconds.", g_iSpam[client] - GetTime());
        return Plugin_Handled;
    }
    
    int cmoney = GetClientMoney(client);
    int gunprice = g_SSG08Price.IntValue;
    
    if(cmoney > gunprice) {
        SetClientMoney(client, cmoney - gunprice);
        CPrintToChat(client, "{green}[Buy Commands] {default}You purchased a {orange}'SSG-08' {default}for {green}$%i", g_SSG08Price.IntValue);
        
        g_iSpam[client] = GetTime() + g_cvar_RebuyCD.IntValue;
        
        if(g_cvar_DropOnRebuy.BoolValue) {
            int weapon = GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY);
            if(weapon != -1) {
                SDKHooks_DropWeapon(client, weapon);
                GivePlayerItem(client, "weapon_ssg08");
            }
            else GivePlayerItem(client, "weapon_ssg08");
        }
    }
    else if(cmoney < gunprice)
        CPrintToChat(client, "{green}[Buy Commands] {default}You do not have enough money to purchase an {orange}'AWP' {default}(Missing {green}$%i{default})", gunprice - cmoney);
    
    return Plugin_Handled;
}

public Action Command_g3sg1(int client, int args) {
    if(!IsPlayerAlive(client) || !IsClientInGame(client) || !IsValidClient(client) || !IsClientCT(client))
        return Plugin_Handled;
    
    if(!g_cvar_Enable_Sniper.BoolValue) {
        CPrintToChat(client, "{green}[Buy Commands] {orange}'Sniper Rifle' {default}purchases have been {red}disabled");
        return Plugin_Handled;
    }
    
    if(g_iSpam[client] > GetTime()) {
        CPrintToChat(client, "{green}[Buy Commands] {default}You can purchase a {orange}'G3SG1' {default}again in {green}%i {default}seconds.", g_iSpam[client] - GetTime());
        return Plugin_Handled;
    }
    
    int cmoney = GetClientMoney(client);
    int gunprice = g_G3SG1Price.IntValue;
    
    if(cmoney > gunprice) {
        SetClientMoney(client, cmoney - gunprice);
        CPrintToChat(client, "{green}[Buy Commands] {default}You purchased a {orange}'G3SG1' {default}for {green}$%i", g_G3SG1Price.IntValue);
        
        g_iSpam[client] = GetTime() + g_cvar_RebuyCD.IntValue;
        
        if(g_cvar_DropOnRebuy.BoolValue) {
            int weapon = GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY);
            if(weapon != -1) {
                SDKHooks_DropWeapon(client, weapon);
                GivePlayerItem(client, "weapon_g3sg1");
            }
            else GivePlayerItem(client, "weapon_g3sg1");
        }
    }
    else if(cmoney < gunprice)
        CPrintToChat(client, "{green}[Buy Commands] {default}You do not have enough money to purchase a {orange}'G3SG1' {default}(Missing {green}$%i{default})", gunprice - cmoney);
    
    return Plugin_Handled;
}

//==============================
// PISTOL COMMANDS
//------------------------------
public Action Command_usp(int client, int args) {
    if(!IsPlayerAlive(client) || !IsClientInGame(client) || !IsValidClient(client) || !IsClientCT(client))
        return Plugin_Handled;
    
    if(!g_cvar_Enable_Pistol.BoolValue) {
        CPrintToChat(client, "{green}[Buy Commands] {orange}'Pistol' {default}purchases have been {red}disabled");
        return Plugin_Handled;
    }
    
    int cmoney = GetClientMoney(client);
    int gunprice = g_USPPrice.IntValue;
    
    if(cmoney > gunprice) {
        SetClientMoney(client, cmoney - gunprice);
        CPrintToChat(client, "{green}[Buy Commands] {default}You purchased a {orange}'USP-S' {default}for {green}$%i", g_USPPrice.IntValue);
        
        if(g_cvar_DropOnRebuy.BoolValue) {
            int weapon = GetPlayerWeaponSlot(client, CS_SLOT_SECONDARY);
            if(weapon != -1) {
                SDKHooks_DropWeapon(client, weapon);
                GivePlayerItem(client, "weapon_usp_silencer");
            }
            else GivePlayerItem(client, "weapon_usp_silencer");
        }
    }
    else if(cmoney < gunprice)
        CPrintToChat(client, "{green}[Buy Commands] {default}You do not have enough money to purchase an {orange}'USP-S' {default}(Missing {green}$%i{default})", gunprice - cmoney);
    
    return Plugin_Handled;
}

public Action Command_glock(int client, int args) {
    if(!IsPlayerAlive(client) || !IsClientInGame(client) || !IsValidClient(client) || !IsClientCT(client))
        return Plugin_Handled;
    
    if(!g_cvar_Enable_Pistol.BoolValue) {
        CPrintToChat(client, "{green}[Buy Commands] {orange}'Pistol' {default}purchases have been {red}disabled");
        return Plugin_Handled;
    }
    
    int cmoney = GetClientMoney(client);
    int gunprice = g_GLOCKPrice.IntValue;
    
    if(cmoney > gunprice) {
        SetClientMoney(client, cmoney - gunprice);
        CPrintToChat(client, "{green}[Buy Commands] {default}You purchased a {orange}'Glock-18' {default}for {green}$%i", g_GLOCKPrice.IntValue);
        
        if(g_cvar_DropOnRebuy.BoolValue) {
            int weapon = GetPlayerWeaponSlot(client, CS_SLOT_SECONDARY);
            if(weapon != -1) {
                SDKHooks_DropWeapon(client, weapon);
                GivePlayerItem(client, "weapon_glock");
            }
            else GivePlayerItem(client, "weapon_glock");
        }
    }
    else if(cmoney < gunprice)
        CPrintToChat(client, "{green}[Buy Commands] {default}You do not have enough money to purchase a {orange}'Glock-18' {default}(Missing {green}$%i{default})", gunprice - cmoney);
    
    return Plugin_Handled;
}

public Action Command_p250(int client, int args) {
    if(!IsPlayerAlive(client) || !IsClientInGame(client) || !IsValidClient(client) || !IsClientCT(client))
        return Plugin_Handled;
    
    if(!g_cvar_Enable_Pistol.BoolValue) {
        CPrintToChat(client, "{green}[Buy Commands] {orange}'Pistol' {default}purchases have been {red}disabled");
        return Plugin_Handled;
    }
    
    int cmoney = GetClientMoney(client);
    int gunprice = g_P250Price.IntValue;
    
    if(cmoney > gunprice) {
        SetClientMoney(client, cmoney - gunprice);
        CPrintToChat(client, "{green}[Buy Commands] {default}You purchased a {orange}'P250' {default}for {green}$%i", g_P250Price.IntValue);
        
        if(g_cvar_DropOnRebuy.BoolValue) {
            int weapon = GetPlayerWeaponSlot(client, CS_SLOT_SECONDARY);
            if(weapon != -1) {
                SDKHooks_DropWeapon(client, weapon);
                GivePlayerItem(client, "weapon_p250");
            }
            else GivePlayerItem(client, "weapon_p250");
        }
    }
    else if(cmoney < gunprice)
        CPrintToChat(client, "{green}[Buy Commands] {default}You do not have enough money to purchase a {orange}'P250' {default}(Missing {green}$%i{default})", gunprice - cmoney);
    
    return Plugin_Handled;
}

public Action Command_deag(int client, int args) {
    if(!IsPlayerAlive(client) || !IsClientInGame(client) || !IsValidClient(client) || !IsClientCT(client))
        return Plugin_Handled;
    
    if(!g_cvar_Enable_Pistol.BoolValue) {
        CPrintToChat(client, "{green}[Buy Commands] {orange}'Pistol' {default}purchases have been {red}disabled");
        return Plugin_Handled;
    }
    
    int cmoney = GetClientMoney(client);
    int gunprice = g_DeagPrice.IntValue;
    
    if(cmoney > gunprice) {
        SetClientMoney(client, cmoney - gunprice);
        CPrintToChat(client, "{green}[Buy Commands] {default}You purchased a {orange}'Desert Eagle' {default}for {green}$%i", g_DeagPrice.IntValue);
        
        if(g_cvar_DropOnRebuy.BoolValue) {
            int weapon = GetPlayerWeaponSlot(client, CS_SLOT_SECONDARY);
            if(weapon != -1) {
                SDKHooks_DropWeapon(client, weapon);
                GivePlayerItem(client, "weapon_deagle");
            }
            else GivePlayerItem(client, "weapon_deagle");
        }
    }
    else if(cmoney < gunprice)
        CPrintToChat(client, "{green}[Buy Commands] {default}You do not have enough money to purchase a {orange}'Desert Eagle' {default}(Missing {green}$%i{default})", gunprice - cmoney);
    
    return Plugin_Handled;
}

public Action Command_tec9(int client, int args) {
    if(!IsPlayerAlive(client) || !IsClientInGame(client) || !IsValidClient(client) || !IsClientCT(client))
        return Plugin_Handled;
    
    if(!g_cvar_Enable_Pistol.BoolValue) {
        CPrintToChat(client, "{green}[Buy Commands] {orange}'Pistol' {default}purchases have been {red}disabled");
        return Plugin_Handled;
    }
    
    int cmoney = GetClientMoney(client);
    int gunprice = g_Tec9Price.IntValue;
    
    if(cmoney > gunprice) {
        SetClientMoney(client, cmoney - gunprice);
        CPrintToChat(client, "{green}[Buy Commands] {default}You purchased a {orange}'Tec-9' {default}for {green}$%i", g_Tec9Price.IntValue);

        if(g_cvar_DropOnRebuy.BoolValue) {
            int weapon = GetPlayerWeaponSlot(client, CS_SLOT_SECONDARY);
            if(weapon != -1) {
                SDKHooks_DropWeapon(client, weapon);
                GivePlayerItem(client, "weapon_tec9");
            }
            else GivePlayerItem(client, "weapon_tec9");
        }
    }
    else if(cmoney < gunprice)
        CPrintToChat(client, "{green}[Buy Commands] {default}You do not have enough money to purchase a {orange}'Tec-9' {default}(Missing {green}$%i{default})", gunprice - cmoney);
    
    return Plugin_Handled;
}

public Action Command_p2k(int client, int args) {
    if(!IsPlayerAlive(client) || !IsClientInGame(client) || !IsValidClient(client) || !IsClientCT(client))
        return Plugin_Handled;
    
    if(!g_cvar_Enable_Pistol.BoolValue) {
        CPrintToChat(client, "{green}[Buy Commands] {orange}'Pistol' {default}purchases have been {red}disabled");
        return Plugin_Handled;
    }
    
    int cmoney = GetClientMoney(client);
    int gunprice = g_P2KPrice.IntValue;
    
    if(cmoney > gunprice) {
        SetClientMoney(client, cmoney - gunprice);
        CPrintToChat(client, "{green}[Buy Commands] {default}You purchased a {orange}'HKP2000' {default}for {green}$%i", g_P2KPrice.IntValue);
        
        if(g_cvar_DropOnRebuy.BoolValue) {
            int weapon = GetPlayerWeaponSlot(client, CS_SLOT_SECONDARY);
            if(weapon != -1) {
                SDKHooks_DropWeapon(client, weapon);
                GivePlayerItem(client, "weapon_hkp2000");
            }
            else GivePlayerItem(client, "weapon_hkp2000");
        }
    }
    else if(cmoney < gunprice)
        CPrintToChat(client, "{green}[Buy Commands] {default}You do not have enough money to purchase a {orange}'HKP2000' {default}(Missing {green}$%i{default})", gunprice - cmoney);
    
    return Plugin_Handled;
}

public Action Command_elites(int client, int args) {
    if(!IsPlayerAlive(client) || !IsClientInGame(client) || !IsValidClient(client) || !IsClientCT(client))
        return Plugin_Handled;
    
    if(!g_cvar_Enable_Pistol.BoolValue) {
        CPrintToChat(client, "{green}[Buy Commands] {orange}'Pistol' {default}purchases have been {red}disabled");
        return Plugin_Handled;
    }
    
    int cmoney = GetClientMoney(client);
    int gunprice = g_ELITEPrice.IntValue;
    
    if(cmoney > gunprice) {
        SetClientMoney(client, cmoney - gunprice);
        CPrintToChat(client, "{green}[Buy Commands] {default}You purchased {orange}'Dual Elites' {default}for {green}$%i", g_ELITEPrice.IntValue);
        
        if(g_cvar_DropOnRebuy.BoolValue) {
            int weapon = GetPlayerWeaponSlot(client, CS_SLOT_SECONDARY);
            if(weapon != -1) {
                SDKHooks_DropWeapon(client, weapon);
                GivePlayerItem(client, "weapon_elite");
            }
            else GivePlayerItem(client, "weapon_elite");
        }
    }
    else if(cmoney < gunprice)
        CPrintToChat(client, "{green}[Buy Commands] {default}You do not have enough money to purchase {orange}'Dual Elites' {default}(Missing {green}$%i{default})", gunprice - cmoney);
    
    return Plugin_Handled;
}

public Action Command_57(int client, int args) {
    if(!IsPlayerAlive(client) || !IsClientInGame(client) || !IsValidClient(client) || !IsClientCT(client))
        return Plugin_Handled;
    
    if(!g_cvar_Enable_Pistol.BoolValue) {
        CPrintToChat(client, "{green}[Buy Commands] {orange}'Pistol' {default}purchases have been {red}disabled");
        return Plugin_Handled;
    }
    
    int cmoney = GetClientMoney(client);
    int gunprice = g_F7Price.IntValue;
    
    if(cmoney > gunprice) {
        SetClientMoney(client, cmoney - gunprice);
        CPrintToChat(client, "{green}[Buy Commands] {default}You purchased a {orange}'Five-Seven' {default}for {green}$%i", g_F7Price.IntValue);

        if(g_cvar_DropOnRebuy.BoolValue) {
            int weapon = GetPlayerWeaponSlot(client, CS_SLOT_SECONDARY);
            if(weapon != -1) {
                SDKHooks_DropWeapon(client, weapon);
                GivePlayerItem(client, "weapon_fiveseven");
            }
            else GivePlayerItem(client, "weapon_fiveseven");
        }
    }
    else if(cmoney < gunprice)
        CPrintToChat(client, "{green}[Buy Commands] {default}You do not have enough money to purchase a {orange}'Five-Seven' {default}(Missing {green}$%i{default})", gunprice - cmoney);
    
    return Plugin_Handled;
}

public Action Command_r8(int client, int args) {
    if(!IsPlayerAlive(client) || !IsClientInGame(client) || !IsValidClient(client) || !IsClientCT(client))
        return Plugin_Handled;
    
    if(!g_cvar_Enable_Pistol.BoolValue) {
        CPrintToChat(client, "{green}[Buy Commands] {orange}'Pistol' {default}purchases have been {red}disabled");
        return Plugin_Handled;
    }
    
    int cmoney = GetClientMoney(client);
    int gunprice = g_R8Price.IntValue;
    
    if(cmoney > gunprice) {
        SetClientMoney(client, cmoney - gunprice);
        CPrintToChat(client, "{green}[Buy Commands] {default}you purchased a {orange}'R8-Revolver' {default}for {green}$%i", g_R8Price.IntValue);
        
        if(g_cvar_DropOnRebuy.BoolValue) {
            int weapon = GetPlayerWeaponSlot(client, CS_SLOT_SECONDARY);
            if(weapon != -1) {
                SDKHooks_DropWeapon(client, weapon);
                GivePlayerItem(client, "weapon_revolver");
            }
            else GivePlayerItem(client, "weapon_revolver");
        }
    }
    else if(cmoney < gunprice)
        CPrintToChat(client, "{green}[Buy Commands] {default}You do not have enough money to purchase a {orange}'Five-Seven' {default}(Missing {green}$%i{default})", gunprice - cmoney);
    
    return Plugin_Handled;
}

public Action Command_cz(int client, int args) {
    if(!IsPlayerAlive(client) || !IsClientInGame(client) || !IsValidClient(client) || !IsClientCT(client))
        return Plugin_Handled;
    
    if(!g_cvar_Enable_Pistol.BoolValue) {
        CPrintToChat(client, "{green}[Buy Commands] {orange}'Pistol' {default}purchases have been {red}disabled");
        return Plugin_Handled;
    }
    
    int cmoney = GetClientMoney(client);
    int gunprice = g_CZ7Price.IntValue;
    
    if(cmoney > gunprice) {
        SetClientMoney(client, cmoney - gunprice);
        CPrintToChat(client, "{green}[Buy Commands] {default}You purchased a {orange}'CZ-75' {default}for {green}$%i", g_CZ7Price.IntValue);
        
        if(g_cvar_DropOnRebuy.BoolValue) {
            int weapon = GetPlayerWeaponSlot(client, CS_SLOT_SECONDARY);
            if(weapon != -1) {
                SDKHooks_DropWeapon(client, weapon);
                GivePlayerItem(client, "weapon_cz75a");
            }
            else GivePlayerItem(client, "weapon_cz75a");
        }
    }
    else if(cmoney < gunprice)
        CPrintToChat(client, "{green}[Buy Commands] {default}You do not have enough money to purchase a {orange}'CZ-75' {default}(Missing {green}$%i{default})", gunprice - cmoney);
    
    return Plugin_Handled;
}

//==============================
// KEVLAR COMMAND
//------------------------------
public Action Command_armor(int client, int args) {
    if(!IsPlayerAlive(client) || !IsClientInGame(client) || !IsValidClient(client) || !IsClientCT(client))
        return Plugin_Handled;
    
    if(!g_cvar_Enable_Kevlar.BoolValue) {
        CPrintToChat(client, "{green}[Buy Commands] {orange}'Kevlar' {default}purchases have been {red}disabled");
        return Plugin_Handled;
    }
    
    int cmoney = GetClientMoney(client);
    int gunprice = g_KEVPrice.IntValue;

    if(cmoney > gunprice) {
        SetClientMoney(client, cmoney - gunprice);
        SetEntProp(client, Prop_Send, "m_ArmorValue", 100);
        SetEntProp(client, Prop_Send, "m_bHasHelmet", 1);
    }
    else if(cmoney < gunprice)
        CPrintToChat(client, "{green}[Buy Commands] {default}You do not have enough money to replenish your {orange}'kevlar' {default}(Missing {green}$%i{default})", gunprice - cmoney);
    
    return Plugin_Handled;
}

//==============================
// GRENADE COMMANDS
//------------------------------
public Action Command_he(int client, int args) {
    if(!IsPlayerAlive(client) || !IsClientInGame(client) || !IsValidClient(client) || !IsClientCT(client))
        return Plugin_Handled;
    
    if(!g_cvar_Enable_HE.BoolValue) {
        CPrintToChat(client, "{green}[Buy Commands] {orange}'HE Grenade' {default}purchases have been {red}disabled");
        return Plugin_Handled;
    }
    
    int cmoney = GetClientMoney(client);
    int gunprice = g_HEPrice.IntValue;

    if(cmoney > gunprice) {
        if(g_iHEAmount[client] < g_HEAmount.IntValue) {
            SetClientMoney(client, cmoney - gunprice);
            HEGrenade(client);
            g_iHEAmount[client] += 1;
            CPrintToChat(client, "{green}[Buy Commands] {default}You purchased a {orange}'HE Grenade' {default}for {green}$%i {default}(Remaining purchases: {green}%i{default})", g_HEPrice.IntValue, g_HEAmount.IntValue - g_iHEAmount[client]);
        }
        else CPrintToChat(client, "{green}[Buy Commands] {default}You can only purchase a maximum of {green}%i {orange}'HE Grenades' {default}per round.", g_HEAmount.IntValue);
    }
    else if(cmoney < gunprice)
        CPrintToChat(client, "{green}[Buy Commands] {default}You do not have enough money to purchase a {orange}'HE Grenade' {default}(Missing {green}$%i{default})", gunprice - cmoney);
    
    return Plugin_Handled;
}

public Action Command_flash(int client, int args) {
    if(!IsPlayerAlive(client) || !IsClientInGame(client) || !IsValidClient(client) || !IsClientCT(client))
        return Plugin_Handled;
    
    if(!g_cvar_Enable_Flash.BoolValue) {
        CPrintToChat(client, "{green}[Buy Commands] {orange}'Flashbang Grenades' {default}purchases have been {red}disabled");
        return Plugin_Handled;
    }
    
    int cmoney = GetClientMoney(client);
    int gunprice = g_FlashPrice.IntValue;

    if(cmoney > gunprice) {
        if(g_iFlashAmount[client] < g_FlashAmount.IntValue) {
            SetClientMoney(client, cmoney - gunprice);
            FlashBang(client);
            g_iFlashAmount[client] += 1;
            CPrintToChat(client, "{green}[Buy Commands] {default}You purchased a {orange}'Flashbang' {default}for {green}$%i {default}(Remaining purchases: {green}%i{default})", g_FlashPrice.IntValue, g_FlashAmount.IntValue - g_iFlashAmount[client]);
        }
        else CPrintToChat(client, "{green}[Buy Commands] {default}You can only purchase a maximum of {green}%i {orange}'Flashbangs' {default}per round.", g_FlashAmount.IntValue);
    }
    else if(cmoney < gunprice)
        CPrintToChat(client, "{green}[Buy Commands] {default}You do not have enough money to purchase a {orange}'Flashbang Grenade' {default}(Missing {green}$%i{default})", gunprice - cmoney);
    
    return Plugin_Handled;
}

public Action Command_decoy(int client, int args) {
    if(!IsPlayerAlive(client) || !IsClientInGame(client) || !IsValidClient(client) || !IsClientCT(client))
        return Plugin_Handled;
    
    if(!g_cvar_Enable_Decoy.BoolValue) {
        CPrintToChat(client, "{green}[Buy Commands] {orange}'Decoy Grenades' {default}purchases have been {red}disabled");
        return Plugin_Handled;
    }
    
    int cmoney = GetClientMoney(client);
    int gunprice = g_DecoyPrice.IntValue;

    if(cmoney > gunprice) {
        if(g_iDecoyAmount[client] < g_DecoyAmount.IntValue) {
            SetClientMoney(client, cmoney - gunprice);
            DecoyNade(client);
            g_iDecoyAmount[client] += 1;
            CPrintToChat(client, "{green}[Buy Commands] {default}You purchased a {orange}'Decoy Grenade' {default}for {green}$%i {default}(Remaining purchases: {green}%i{default})", g_DecoyPrice.IntValue, g_DecoyAmount.IntValue - g_iDecoyAmount[client]);
        }
        else CPrintToChat(client, "{green}[Buy Commands] {default}You can only purchase a maximum of {green}%i {orange}'Decoy Grenades' {default}per round.", g_DecoyAmount.IntValue);
    }
    else if(cmoney < gunprice)
        CPrintToChat(client, "{green}[Buy Commands] {default}You do not have enough money to purchase a {orange}'Decoy Grenade' {default}(Missing {green}$%i{default})", gunprice - cmoney);
    
    return Plugin_Handled;
}

public Action Command_incendiary(int client, int args) {
    if(!IsPlayerAlive(client) || !IsClientInGame(client) || !IsValidClient(client) || !IsClientCT(client))
        return Plugin_Handled;
    
    if(!g_cvar_Enable_Inc.BoolValue) {
        CPrintToChat(client, "{green}[Buy Commands] {orange}'Incendiary Grenade' {default}purchases have been {red}disabled");
        return Plugin_Handled;
    }
    
    int cmoney = GetClientMoney(client);
    int gunprice = g_IncPrice.IntValue;

    if(cmoney > gunprice) {
        if(g_iIncAmount[client] < g_IncAmount.IntValue) {
            SetClientMoney(client, cmoney - gunprice);
            IncGrenade(client);
            g_iIncAmount[client] += 1;
            CPrintToChat(client, "{green}[Buy Commands] {default}You purchased an {orange}'Incendiary Grenade' {default}for {green}$%i {default}(Remaining purchases: {green}%i{default})", g_IncPrice.IntValue, g_IncAmount.IntValue - g_iIncAmount[client]);
        }
        else CPrintToChat(client, "{green}[Buy Commands] {default}You can only purchase a maximum of {green}%i {orange}'Decoy Grenades' {default}per round.", g_DecoyAmount.IntValue);
    }
    else if(cmoney < gunprice)
        CPrintToChat(client, "{green}[Buy Commands] {default}You do not have enough money to purchase a {orange}'Decoy Grenade' {default}(Missing {green}$%i{default})", gunprice - cmoney);
    
    return Plugin_Handled;
}

public Action Command_snowball(int client, int args) {
    if(!IsPlayerAlive(client) || !IsClientInGame(client) || !IsValidClient(client) || !IsClientCT(client))
        return Plugin_Handled;
    
    if(!g_cvar_Enable_Snow.BoolValue) {
        CPrintToChat(client, "{green}[Buy Commands] {orange}'Snowball' {default}purchases have been {red}disabled");
        return Plugin_Handled;
    }
    
    int cmoney = GetClientMoney(client);
    int gunprice = g_SnowPrice.IntValue;

    if(cmoney > gunprice) {
        if(g_iSnowAmount[client] < g_SnowAmount.IntValue) {
            SetClientMoney(client, cmoney - gunprice);
            Snowball(client);
            g_iSnowAmount[client] += 1;
            CPrintToChat(client, "{green}[Buy Commands] {default}You purchased a {orange}'Snowball' {default}for {green}$%i {default}(Remaining purchases: {green}%i{default})", g_SnowPrice.IntValue, g_SnowAmount.IntValue - g_iSnowAmount[client]);
        }
        else CPrintToChat(client, "{green}[Buy Commands] {default}You can only purchase a maximum of {green}%i {orange}'Snowball' {default}per round.", g_SnowAmount.IntValue);
    }
    else if(cmoney < gunprice)
        CPrintToChat(client, "{green}[Buy Commands] {default}You do not have enough money to purchase a {orange}'Snowball' {default}(Missing {green}$%i{default})", gunprice - cmoney);
    
    return Plugin_Handled;
}

public Action Command_TagGrenade(int client, int args) {
    if(!IsPlayerAlive(client) || !IsClientInGame(client) || !IsValidClient(client) || !IsClientCT(client))
        return Plugin_Handled;
    
    if(!g_cvar_Enable_Tag.BoolValue) {
        CPrintToChat(client, "{green}[Buy Commands] {orange}'TAG Grenade' {default}purchases have been {red}disabled");
        return Plugin_Handled;
    }
    
    int cmoney = GetClientMoney(client);
    int gunprice = g_TagPrice.IntValue;

    if(cmoney > gunprice) {
        if(g_iTagAmount[client] < g_TagAmount.IntValue) {
            SetClientMoney(client, cmoney - gunprice);
            TagGrenade(client);
            g_iTagAmount[client] += 1;
            CPrintToChat(client, "{green}[Buy Commands] {default}You purchased a {orange}'TAG Grenade' {default}for {green}$%i {default}(Remaining purchases: {green}%i{default})", g_TagPrice.IntValue, g_TagAmount.IntValue - g_iTagAmount[client]);
        }
        else CPrintToChat(client, "{green}[Buy Commands] {default}You can only purchase a maximum of {green}%i {orange}'Snowball' {default}per round.", g_SnowAmount.IntValue);
    }
    else if(cmoney < gunprice)
        CPrintToChat(client, "{green}[Buy Commands] {default}You do not have enough money to purchase a {orange}'Snowball' {default}(Missing {green}$%i{default})", gunprice - cmoney);
    
    return Plugin_Handled;
}

//==============================
// GIVE GRENADE FUNCTION (OFFSETS)
//------------------------------
public void HEGrenade(int client) {
    int offset2 = FindDataMapInfo(client, "m_iAmmo") + (4*14);
    int current2 = GetEntData(client, offset2, 4);
    
    if(current2 == 0)
        GivePlayerItem(client, "weapon_hegrenade");
    else SetEntData(client, offset2, current2 + 1);
}

public void FlashBang(int client) {
    int offset2 = FindDataMapInfo(client, "m_iAmmo") + (4*15);
    int current2 = GetEntData(client, offset2, 4);
    if(current2 == 0)
        GivePlayerItem(client, "weapon_flashbang");
    else SetEntData(client, offset2, current2 + 1);
}

public void IncGrenade(int client) {
    int offset2 = FindDataMapInfo(client, "m_iAmmo") + (4*17);
    int current2 = GetEntData(client, offset2, 4);
    if(current2 == 0)
        GivePlayerItem(client, "weapon_incgrenade");
    else SetEntData(client, offset2, current2 + 1);
}

public void DecoyNade(int client) {
    int offset2 = FindDataMapInfo(client, "m_iAmmo") + (4*18);
    int current2 = GetEntData(client, offset2, 4);
    if(current2 == 0)
        GivePlayerItem(client, "weapon_decoy");
    else SetEntData(client, offset2, current2 + 1);
}

public void TagGrenade(int client) {
    int offset2 = FindDataMapInfo(client, "m_iAmmo") + (4*22);
    int current2 = GetEntData(client, offset2, 4);
    if(current2 == 0)
        GivePlayerItem(client, "weapon_tagrenade");
    else SetEntData(client, offset2, current2 + 1);
}

public void Snowball(int client) {
    int offset2 = FindDataMapInfo(client, "m_iAmmo") + (4*25);
    int current2 = GetEntData(client, offset2, 4);
    if(current2 == 0)
        GivePlayerItem(client, "weapon_snowball");
    else SetEntData(client, offset2, current2 + 1);
}