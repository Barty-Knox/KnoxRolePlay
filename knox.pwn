#include <a_samp>
#include <a_mysql>
#include <mdialog>
#include <Pawn.CMD>
#include <streamer>
#include <sscanf2>
#include <mxDate>

#define public:%0(%1) 			forward%0(%1);public%0(%1)
#define IsPlayerAdminLogin(%0) 	(PlayerAdminLogin{%0} == 1)
#define IsPlayerLogin(%0) 		(PlayerLogin{%0} == 1)
#define SendUseCommand(%0,%1) 	SendClientMessage(%0, 0xBEBEBEFF, %1)
#define SendInvalidPlayer(%0) 	SendClientMessage(%0, 0xBEBEBEFF, "Игрок не найден")

new connect;

enum(<<=1)
{
    CMD_CHAT = 1,
    CMD_ADMIN,
    CMD_MODER
};

enum PLAYER_INFO
{
	P_ID,
	P_NAME[MAX_PLAYER_NAME],
	P_IP[16],
	P_GENDER,
	P_SKIN,
	P_ADM_LVL,
	P_MUTE_TIME
}
new Player[MAX_PLAYERS][PLAYER_INFO];

new temp_PlayerPassword[MAX_PLAYERS][32];

new PlayerAdminLogin[MAX_PLAYERS char];
new PlayerLogin[MAX_PLAYERS char];

new timer_PlayerSecond[MAX_PLAYERS];
new timer_PlayerLimitTime[MAX_PLAYERS];

new Text:LogoTD[3];

new VehEngine[MAX_VEHICLES char];
new VehLight[MAX_VEHICLES char];
new VehDoors[MAX_VEHICLES char];

main()
{
	print("\n----------------------------------");
	print(" Blank Gamemode by your name here");
	print("----------------------------------\n");
}

public OnGameModeInit()
{
    CreateDynamicObject(19126, 1083.98242, -1362.92749, 13.25386, 0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19126, 1085.14209, -1362.93115, 13.25386, 0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19126, 1086.40393, -1362.92920, 13.25386, 0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19126, 1087.93689, -1362.93701, 13.25386, 0.00000, 0.00000, 0.00000);
	
	LogoTD[0] = TextDrawCreate(544.9999, 10.3851, "knox");
	TextDrawLetterSize(LogoTD[0], 0.4, 1.6);
	TextDrawColor(LogoTD[0], -750633473);
	TextDrawFont(LogoTD[0], 2);
	TextDrawSetShadow(LogoTD[0], 0);

	LogoTD[1] = TextDrawCreate(547.0333, 21.9259, "RolePlay");
	TextDrawLetterSize(LogoTD[1], 0.1896, 1.3967);
	TextDrawColor(LogoTD[1], 1994705663);
	TextDrawFont(LogoTD[1], 2);
	TextDrawSetShadow(LogoTD[1], 0);

	LogoTD[2] = TextDrawCreate(545.0001, 22.4444, "LD_SPAC:white");
	TextDrawLetterSize(LogoTD[2], 0.0, 0.0);
	TextDrawTextSize(LogoTD[2], 43.0, 3.0);
	TextDrawColor(LogoTD[2], -1);
	TextDrawFont(LogoTD[2], 4);
	
	DisableInteriorEnterExits();
	EnableStuntBonusForAll(0);
	ManualVehicleEngineAndLights();
	
	SetGameModeText("knox v 0.1");
	AddPlayerClass(0, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
	connect = mysql_connect("127.0.0.1", "root", "knox", "123");
	return 1;
}

public OnGameModeExit()
{
	mysql_close(connect);
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	return 1;
}

public OnPlayerConnect(playerid)
{
	new string[42 + MAX_PLAYER_NAME];
	RemoveBuildingForPlayer(playerid, 1440, 1085.7031, -1361.0234, 13.2656, 0.25);
	for(new i; i < sizeof(LogoTD); i++) TextDrawShowForPlayer(playerid, LogoTD[i]);
	ClearPlayer(playerid);
	GetPlayerName(playerid, Player[playerid][P_NAME], MAX_PLAYER_NAME);
	GetPlayerIp(playerid, Player[playerid][P_IP], 16);
	mysql_format(connect, string, sizeof string, "SELECT `id` FROM `users` WHERE `name`='%s'", Player[playerid][P_NAME]);
	mysql_tquery(connect, string, "IsPlayerReg", "d", playerid);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	for(new i; i < sizeof(LogoTD); i++) TextDrawHideForPlayer(playerid, LogoTD[i]);
	if(IsPlayerLogin(playerid))
	{
        KillTimer(timer_PlayerSecond[playerid]);
        SavePlayer(playerid);
	}
	return 1;
}

public OnPlayerSpawn(playerid)
{
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
	new string[MAX_CHATBUBBLE_LENGTH];
	if(!IsPlayerLogin(playerid)) return 0;
	if(IsPlayerMuted(playerid)) return 0;
	format(string, sizeof string, "%s[%d]: %s", Player[playerid][P_NAME], playerid, text);
    ProxDetector(playerid, 20.0, string);
	return 0;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}
public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(newkeys & KEY_ACTION) callcmd::engine(playerid);
	if(newkeys & KEY_FIRE) callcmd::light(playerid);
	return 1;
}
public OnPlayerUpdate(playerid)
{
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}

public OnPlayerCommandReceived(playerid, cmd[], params[], flags)
{
	if(!IsPlayerLogin(playerid))
	{
	    SendClientMessage(playerid, 0xBEBEBEFF, "Вы должны авторизоваться");
        return 0;
	}
    if(flags & CMD_MODER)
	{
	    if(Player[playerid][P_ADM_LVL] < 1) return 0;
     	if(!IsPlayerAdminLogin(playerid))
 		{
 		    SendClientMessage(playerid, 0xBEBEBEFF, "Вы должны авторизоваться как администратор");
 		    return 0;
 		}
	}
	if(flags & CMD_CHAT && IsPlayerMuted(playerid)) return 0;
    return 1;
}

public OnPlayerCommandPerformed(playerid, cmd[], params[], result, flags)
{
    if(result == -1)
    {
        SendClientMessage(playerid, 0xBEBEBEFF, "Такой команды нет!");
        return 0;
    }

    return 1;
}

public: IsPlayerReg(playerid)
{
	new rows, fields;
	cache_get_data(rows, fields);
	if(rows)
	{
	    new string[140];
	    Player[playerid][P_ID] = cache_get_field_content_int(0, "id");
		format(string, sizeof string, "\
			SELECT `ban_users`.*,`users`.`name` FROM `ban_users`,`users` WHERE `ban_users`.`admin`=`users`.`id` AND `ban_users`.`user`='%d'\
		", Player[playerid][P_ID]);
		mysql_tquery(connect, string, "IsPlayerBanned", "d", playerid);
		timer_PlayerLimitTime[playerid] = SetTimerEx("PlayerLimitTime", 3 * 60000, false, "d", playerid);
	}
	else
	{
	    Dialog_Show(playerid, "PlayerRegistText");
		timer_PlayerLimitTime[playerid] = SetTimerEx("PlayerLimitTime", 5 * 60000, false, "d", playerid);
	}
	return 1;
}

public: PlayerLimitTime(playerid)
{
	Dialog_Message(playerid, "Сообщение сервера", "{FFFFFF}\
		Время на авторизацию/регистрацию истекло.\
	", "Ok");
	KickEx(playerid);
	return 1;
}

public: IsPlayerBanned(playerid)
{
	new rows, fields;
	cache_get_data(rows, fields);
	if(rows)
	{
	    new admin[MAX_PLAYER_NAME];
	    new string[128 + sizeof(admin) + 50];
	    new data = cache_get_field_content_int(0, "data"),
			lost = cache_get_field_content_int(0, "lost");
		if(lost < gettime())
		{
            Dialog_Show(playerid, "PlayerLoginText");
            format(string, sizeof string, "DELETE FROM `ban_users` WHERE `user`='%d'", Player[playerid][P_ID]);
            mysql_tquery(connect, string);
		}
		else
		{
		    cache_get_field_content(0, "name", admin);
		    cache_get_field_content(0, "reason", string);
            format(string, sizeof string, "{FFFFFF}\
				Вы заблокированы!\n\
				Администратором: %s\n\
				Дата блокировки: %s\n\
				Дата разблокировки: %s\n\
				Причина: %s\
			", admin, date(.timestamp = data + 3600 * 6), date(.timestamp = lost), string);
			Dialog_Message(playerid, "Сообщение сервера", string, "Ok");
	        KickEx(playerid);
		}
	}
	else
	{
        Dialog_Show(playerid, "PlayerLoginText");
	}
	return 1;
}

public: LoadPlayerData(playerid)
{
    new rows, fields;
	cache_get_data(rows, fields);
	if(rows)
	{
	    Player[playerid][P_GENDER] = cache_get_field_content_int(0, "gender");
	    Player[playerid][P_SKIN] = cache_get_field_content_int(0, "skin");
	    Player[playerid][P_ADM_LVL] = cache_get_field_content_int(0, "adm_lvl");
	    Player[playerid][P_MUTE_TIME] = cache_get_field_content_int(0, "mute_time");
	    SetSpawnInfo(playerid, 0, Player[playerid][P_SKIN], 1085.2888, -1332.7443, 13.6365, 202.4771, 0, 0, 0, 0, 0, 0);
		SpawnPlayer(playerid);
		timer_PlayerSecond[playerid] = SetTimerEx("PlayerSecondTimer", 1000, true, "d", playerid);
    	PlayerLogin{playerid} = 1;
		KillTimer(timer_PlayerLimitTime[playerid]);
	}
	return 1;
}

public: PlayerSecondTimer(playerid)
{
	if(Player[playerid][P_MUTE_TIME] > 0) Player[playerid][P_MUTE_TIME]--;
	return 1;
}

stock ProxDetector(playerid, Float:radius, text[], color1 = 0xFFFFFFFF, color2 = 0xEAEAEAFF)
{
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);
	new world = GetPlayerVirtualWorld(playerid),
	    interior = GetPlayerInterior(playerid);
	for(new i; i < MAX_PLAYERS; i++)
	{
		if(!IsPlayerConnected(i)) continue;
		if(!IsPlayerInRangeOfPoint(i, radius, x, y, z)) continue;
		if(world != GetPlayerVirtualWorld(i)) continue;
		if(interior != GetPlayerInterior(i)) continue;
		if(IsPlayerInRangeOfPoint(i, radius / 2, x, y, z))
		{
            SendClientMessage(i, color1, text);
		}
		else
		{
            SendClientMessage(i, color2, text);
		}
	}
	return 1;
}

stock ClearPlayer(playerid)
{
    PlayerAdminLogin{playerid} = 0;
    PlayerLogin{playerid} = 0;
	return 1;
}

stock SendAdminMessage(color, text[], adm_lvl = 1)
{
	if(adm_lvl < 1) return 1;
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(!IsPlayerConnected(i)) continue;
		if(Player[i][P_ADM_LVL] < adm_lvl) continue;
		if(!IsPlayerAdminLogin(i)) continue;
		SendClientMessage(i, color, text);
	}
	return 1;
}

stock IsPlayerMuted(playerid)
{
	if(Player[playerid][P_MUTE_TIME] > 0)
	{
	    new time = Player[playerid][P_MUTE_TIME];
	    if(time <= 60)
	    {
            SendClientMessage(playerid, 0xBEBEBEFF, "Чат заблокирован! До разблокировки отсталось примерно минута");
		}
		else
		{
			new string[MAX_CHATBUBBLE_LENGTH];
			format(string, sizeof string, "Чат заблокирован! До разблокировки отсталось примерно %d мин.", floatround(time / 60));
            SendClientMessage(playerid, 0xBEBEBEFF, string);
		}
		return 1;
	}
	return 0;
}

stock SavePlayer(playerid)
{
	new string[74];
	mysql_format(connect, string, sizeof string, "UPDATE `users` SET `mute_time`='%d' WHERE `id`='%d'", Player[playerid][P_MUTE_TIME], Player[playerid][P_ID]);
	mysql_tquery(connect, string);
	return 1;
}

stock SetVehicleEngine(vehicle, status)
{
 	VehEngine{vehicle} = status;
    SetVehicleParamsEx(vehicle, status, -1, -1, -1, -1, -1, -1);
	return 1;
}

stock SetVehicleLight(vehicle, status)
{
	VehLight{vehicle} = status;
    SetVehicleParamsEx(vehicle, -1, status, -1, -1, -1, -1, -1);
	return 1;
}

stock SetVehicleDoors(vehicle, status)
{
	VehDoors{vehicle} = status;
    SetVehicleParamsEx(vehicle, -1, -1, -1, status, -1, -1, -1);
	return 1;
}

// ============================== [ Kick ] =====================================

stock KickEx(playerid)
{
	new ping = GetPlayerPing(playerid);
	if(ping > 2500) ping = 2500;
 	else if(ping < 200) ping = 200;
    SetTimerEx("KickPlayer", ping, false, "d", playerid);
    return 1;
}

public: KickPlayer(playerid)
{
	return Kick(playerid);
}

// ============================== [ Диалоги ] ==================================

// - Админ авторизация

DialogCreate:AdminLoginText(playerid)
{
    Dialog_Open(playerid, "AdminLogin", DIALOG_STYLE_PASSWORD, "Админ авторизация", "{FFFFFF}\
		Введите свой админ ключ:\
	", "Ввод", "Выход");
    return 1;
}

DialogResponse:AdminLogin(playerid, response, listitem, inputtext[])
{
	if(!response) return 0;
	new string[150];
	SHA256_PassHash(inputtext, "knox-admin-top", string, 64);
	mysql_format(connect, string, sizeof string, "\
		SELECT 1 FROM `users` WHERE `id`='%d' AND `adm_pass`='%s'\
	", Player[playerid][P_ID], string);
	new Cache:cache = mysql_query(connect, string);
	if(cache_get_row_count(connect) <= 0) {
	    new count = GetPVarInt(playerid, "AdmPasswordCount");
	    count++;
	    if(count >= 3) {
			SendClientMessage(playerid, 0xE7120EFF, "Вы ввели админ ключ неверно три раза!");
			SendClientMessage(playerid, 0xE7120EFF, "За это Вы были отключены от сервера");
			return KickEx(playerid);
		}
		format(string, sizeof string, "Вы ввели пароль неверно. Попыток: %d", 3 - count);
		SendClientMessage(playerid, 0xE7120EFF, string);
		SetPVarInt(playerid, "AdmPasswordCount", count);
		Dialog_Show(playerid, "AdminLoginText");
		return cache_delete(cache);
	}
	cache_delete(cache);
	PlayerAdminLogin{playerid} = 1;
	format(string, sizeof string, "Вы успешно вошли как администратор %d уровня", Player[playerid][P_ADM_LVL]);
    SendClientMessage(playerid, 0x527DBDFF, string);
    format(string, sizeof string, "Администратор %s вошел как администратор %d уровня", Player[playerid][P_NAME], Player[playerid][P_ADM_LVL]);
    SendAdminMessage(0xEA3752FF, string);
	return 1;
}

// - Регистрация

DialogCreate:PlayerRegistText(playerid)
{
 	new string[100 + MAX_PLAYER_NAME];
    format(string, sizeof string, "{FFFFFF}\
		Аккаунт {B219D8}%s{FFFFFF} не зарегестрирован!\n\
		Чтобы зарегестрировать аккаунт введите пароль:\
	", Player[playerid][P_NAME]);
    Dialog_Open(playerid, "PlayerRegist", DIALOG_STYLE_INPUT, "Регистрация", string, "Ввод", "Выход");
    return 1;
}

DialogResponse:PlayerRegist(playerid, response, listitem, inputtext[])
{
	if(!response) {
		SendClientMessage(playerid, 0xE7120EFF, "Вы прервали регистрацию!");
		return KickEx(playerid);
	}
	new len = strlen(inputtext);
	if(len < 6) {
        Dialog_Show(playerid, "PlayerRegistText");
		return SendClientMessage(playerid, 0xE7120EFF, "Пароль должен быть более 6-ти символов");
	}
	if(len > 32) {
        Dialog_Show(playerid, "PlayerRegistText");
		return SendClientMessage(playerid, 0xE7120EFF, "Пароль должен быть менее 32-х символов");
	}
	format(temp_PlayerPassword[playerid], 32, inputtext);
	Dialog_Open(playerid, "PlayerRegistGender", DIALOG_STYLE_MSGBOX, "Регистрация", "{FFFFFF}Ваш пол?", "Женский", "Мужской");
	return 1;
}

DialogResponse:PlayerRegistGender(playerid, response, listitem, inputtext[])
{
	new skin = response ? 193 : 23;
	new string[250];
	SHA256_PassHash(temp_PlayerPassword[playerid], "knox-server-top", string, 64);
	mysql_format(connect, string, sizeof string, "\
		INSERT INTO `users`(`id`,`name`,`password`,`reg_ip`,`reg_data`,`gender`,`skin`) VALUES (NULL,'%s','%s','%s','%d','%d','%d')\
	", Player[playerid][P_NAME], string, Player[playerid][P_IP], gettime(), response, skin);
	mysql_query(connect, string);
	Player[playerid][P_ID] = cache_insert_id();
	format(string, sizeof string, "SELECT * FROM `users` WHERE `id`='%d'", Player[playerid][P_ID]);
	mysql_tquery(connect, string, "LoadPlayerData", "d", playerid);
	SendClientMessage(playerid, 0x527DBDFF, "Вы успешно прошли регистрацию");
    return 1;
}

// - Авторизация

DialogCreate:PlayerLoginText(playerid)
{
 	new string[100 + MAX_PLAYER_NAME];
    format(string, sizeof string, "{FFFFFF}\
		Аккаунт {B219D8}%s{FFFFFF} зарегестрирован!\n\
		Чтобы авторизоваться введите пароль:\
	", Player[playerid][P_NAME]);
    Dialog_Open(playerid, "PlayerLogin", DIALOG_STYLE_PASSWORD, "Авторизация", string, "Ввод", "Выход");
    return 1;
}

DialogResponse:PlayerLogin(playerid, response, listitem, inputtext[])
{
	if(!response) {
		SendClientMessage(playerid, 0xE7120EFF, "Вы прервали регистрацию!");
		return KickEx(playerid);
	}
	new string[250];
	SHA256_PassHash(inputtext, "knox-server-top", string, 64);
	mysql_format(connect, string, sizeof string, "SELECT 1 FROM `users` WHERE `name`='%s' AND `password`='%s'", Player[playerid][P_NAME], string);
	new Cache:cache = mysql_query(connect, string);
	if(cache_get_row_count(connect) <= 0) {
	    new count = GetPVarInt(playerid, "PasswordCount");
	    count++;
	    if(count >= 3) {
			SendClientMessage(playerid, 0xE7120EFF, "Вы ввели пароль неверно три раза!");
			SendClientMessage(playerid, 0xE7120EFF, "За это Вы были отключены от сервера");
			return KickEx(playerid);
		}
		format(string, sizeof string, "Вы ввели пароль неверно. Попыток: %d", 3 - count);
		SendClientMessage(playerid, 0xE7120EFF, string);
		SetPVarInt(playerid, "PasswordCount", count);
		Dialog_Show(playerid, "PlayerLoginText");
		return cache_delete(cache);
	}
	cache_delete(cache);
	format(string, sizeof string, "SELECT * FROM `users` WHERE `name`='%s'", Player[playerid][P_NAME]);
	mysql_tquery(connect, string, "LoadPlayerData", "d", playerid);
    return 1;
}

DialogResponse:SendReport(playerid, response, listitem, inputtext[])
{
	if(!response) return 0;
	if(strlen(inputtext) < 3) return SendClientMessage(playerid, 0xBEBEBEFF, "Ваша жалоба/вопрос слишком коротка.");
 	new string[MAX_CHATBUBBLE_LENGTH];
 	format(string, sizeof string, "[report] %s[%d]: %s", Player[playerid][P_NAME], playerid, inputtext);
	SendAdminMessage(0xEA3752FF, string);
	SendClientMessage(playerid, 0x527DBDFF, "Ваша жалоба/вопрос была отправлена администрации.");
	SetPVarInt(playerid, "report_time_block", gettime() + 5 * 60);
	return 1;
}

// ============================== [ Флаги ] ====================================

flags:s(CMD_CHAT);
flags:me(CMD_CHAT);
flags:do(CMD_CHAT);
flags:try(CMD_CHAT);

flags:a(CMD_MODER);
flags:kick(CMD_MODER);
flags:mute(CMD_MODER);
flags:unmute(CMD_MODER);
flags:ban(CMD_MODER);
flags:unban(CMD_MODER);
flags:offban(CMD_MODER);
flags:slap(CMD_MODER);
flags:veh(CMD_MODER);
flags:answer(CMD_MODER);

// ============================== [ Команды ] ==================================

cmd:admins(playerid)
{
	new string[400], count = 0;
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(!IsPlayerConnected(i)) continue;
		if(Player[i][P_ADM_LVL] < 1) continue;
		if(!IsPlayerAdminLogin(i)) continue;
		format(string, sizeof string, "%s%s[%d] - %dlvl\n", string, Player[i][P_NAME], i, Player[i][P_ADM_LVL]);
		count++;
	}
	if(count == 0) return SendClientMessage(playerid, 0xBEBEBEFF, "В данный момент, информация не доступна.");
	new caption[36];
	format(caption, sizeof caption, "Администраторы онлайн: %d", count);
	Dialog_Message(playerid, caption, string, "Ok");
	return 1;
}

cmd:report(playerid)
{
	if(GetPVarInt(playerid, "report_time_block") > gettime()) return SendClientMessage(playerid, 0xBEBEBEFF, "Вам недоступен на данный момент репорт.");
	Dialog_Open(playerid, "SendReport", DIALOG_STYLE_INPUT, "Жалоба/Вопрос", "{FFFFFF}\
		Пишите свою жалобу или вопрос вдумчиво и кратко описывайте свои мысли\n\
		{CD1445}Иначе Вы можете получить блокировку чата!\
	", "Отправить", "Выход");
 	return 1;
}

// - Транспот

cmd:engine(playerid)
{
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return 0;
	new veh = GetPlayerVehicleID(playerid);
	if(VehEngine{veh} == 1)
	{
	    callcmd::me(playerid, "заглушил двигаль");
	    SetVehicleEngine(veh, 0);
	}
	else
	{
	    callcmd::me(playerid, "пытается завести машину");
	    SetTimerEx("VehicleEngineTimer", (random(2) + 1) * 1000, false, "dd", playerid, veh);
	}
	return 1;
}

cmd:light(playerid)
{
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return 0;
	new veh = GetPlayerVehicleID(playerid);
	SetVehicleLight(veh, (VehLight{veh} == 1) ? 0 : 1);
	return 1;
}

public: VehicleEngineTimer(playerid, veh)
{
    callcmd::me(playerid, "завел машину");
    SetVehicleEngine(veh, 1);
	return 1;
}

// - Чат

cmd:s(playerid, params[])
{
	new string[MAX_CHATBUBBLE_LENGTH];
	format(string, sizeof string, "%s кричит: %s", Player[playerid][P_NAME], params);
    ProxDetector(playerid, 30.0, string);
	return 1;
}

cmd:me(playerid, params[])
{
	new string[MAX_CHATBUBBLE_LENGTH];
	format(string, sizeof string, "%s %s", Player[playerid][P_NAME], params);
    ProxDetector(playerid, 20.0, string, 0xE46EEAFF, 0xE46EEAFF);
	return 1;
}

cmd:do(playerid, params[])
{
	new string[MAX_CHATBUBBLE_LENGTH];
	format(string, sizeof string, "%s (( %s ))", params, Player[playerid][P_NAME]);
    ProxDetector(playerid, 20.0, string, 0xE46EEAFF, 0xE46EEAFF);
	return 1;
}

cmd:try(playerid, params[])
{
	new string[MAX_CHATBUBBLE_LENGTH];
	if(random(2)) format(string, sizeof string, "%s: %s [ {B0EA65}УДАЧНО{FFFFFF} ]", Player[playerid][P_NAME], params);
	else format(string, sizeof string, "%s: %s [ {EA294D}НЕ УДАЧНО{FFFFFF} ]", Player[playerid][P_NAME], params);
    ProxDetector(playerid, 20.0, string, -1, -1);
	return 1;
}

cmd:time(playerid)
{
 	SendClientMessage(playerid, -1, date(.timestamp = gettime()));
	return 1;
}

// - Админ-команды

cmd:alogin(playerid)
{
	if(Player[playerid][P_ADM_LVL] == 0) return 0;
	if(IsPlayerAdminLogin(playerid))
	{
        PlayerAdminLogin{playerid} = 0;
        SendClientMessage(playerid, 0x527DBDFF, "Вы завершили админ дежурство");
        new string[34 + MAX_PLAYER_NAME];
        format(string, sizeof string, "Администратор %s покинул дежурство", Player[playerid][P_NAME]);
        SendAdminMessage(0xEA3752FF, string);
	}
	else
	{
	    Dialog_Show(playerid, "AdminLoginText");
 	}
	return 1;
}

cmd:a(playerid, params[])
{
	new string[MAX_CHATBUBBLE_LENGTH];
	if(strlen(params) < 1) return SendUseCommand(playerid, "Использование: /a [ текст ]");
    format(string, sizeof string, "[adm]%s: %s", Player[playerid][P_NAME], params);
    SendAdminMessage(0xEA3752FF, string);
	return 1;
}

cmd:kick(playerid, params[])
{
	new user, reason[128];
	if(sscanf(params, "us[128]", user, reason)) return SendUseCommand(playerid, "Использование: /kick [ id ] [ причина ]");
	if(user == INVALID_PLAYER_ID) return SendInvalidPlayer(playerid);
	new string[144];
	format(string, sizeof string, "{FFFFFF}\
		Вас отключил от сервера администратор: %s\n\
		Причина: %s\
	", Player[playerid][P_NAME], reason);
	Dialog_Message(user, "Сообщение сервера", string, "Ok");
    format(string, sizeof string, "Админ %s[%d] кикнул %s[%d] | Причина: %s", Player[playerid][P_NAME], playerid, Player[user][P_NAME], user, reason);
    SendAdminMessage(0xEA3752FF, string);
    KickEx(user);
	return 1;
}

cmd:ban(playerid, params[])
{
	new user, day, reason[128];
	if(sscanf(params, "uds[128]", user, day, reason)) return SendUseCommand(playerid, "Использование: /ban [ id ] [ время(дни) ] [ причина ]");
	if(user == INVALID_PLAYER_ID) return SendInvalidPlayer(playerid);
	if(day < 1 || day > 360) return SendClientMessage(playerid, 0xBEBEBEFF, "Время не может быть меньше 1 или больше 360 дней");
	new string[240];
	new time = gettime();
	new lost = time + (day * 3600 * 24);
	format(string, sizeof string, "{FFFFFF}\
		Вас заблокировал администратор: %s\n\
		На %d дней(%s)\n\
		Причина: %s\
	", Player[playerid][P_NAME], day, date(.timestamp = lost), reason);
	Dialog_Message(user, "Сообщение сервера", string, "Ok");
    format(string, sizeof string, "Админ %s[%d] заблокировал %s[%d] на %d дней | Причина: %s", Player[playerid][P_NAME], playerid, Player[user][P_NAME], user, day, reason);
    SendAdminMessage(0xEA3752FF, string);
    KickEx(user);
	mysql_format(connect, string, sizeof string, "\
		INSERT INTO `ban_users`(`user`,`user_ip`,`admin`,`admin_ip`,`data`,`lost`,`reason`) VALUES ('%d','%s','%d','%s','%d','%d','%s')\
	", Player[user][P_ID], Player[user][P_IP], Player[playerid][P_ID], Player[playerid][P_IP], time, lost, reason);
	mysql_tquery(connect, string);
	return 1;
}

cmd:offban(playerid, params[])
{
	new user[MAX_PLAYER_NAME], day, reason[128];
	if(sscanf(params, "s[24]ds[128]", user, day, reason)) return SendUseCommand(playerid, "Использование: /offban [ имя ] [ время(дни) ] [ причина ]");
	if(day < 1 || day > 360) return SendClientMessage(playerid, 0xBEBEBEFF, "Время не может быть меньше 1 или больше 360 дней");
	new string[240];
	new time = gettime();
	new lost = time + (day * 3600 * 24);
	new player;
	if(!sscanf(user, "u", player))
	{
		if(player != INVALID_PLAYER_ID) return SendClientMessage(playerid, 0xBEBEBEFF, "Игрок онлайн!");
	}
	mysql_format(connect, string, sizeof string, "SELECT `id` FROM `users` WHERE `name`='%s'", user);
	new Cache:cache = mysql_query(connect, string);
	if(cache_get_row_count(connect) <= 0) {
	    SendClientMessage(playerid, 0xBEBEBEFF, "Игрок не найден!");
		return cache_delete(cache);
	}
	new id = cache_get_field_content_int(0, "id");
	cache_delete(cache);
    format(string, sizeof string, "Админ %s[%d] заблокировал оффлайн %s на %d дней | Причина: %s", Player[playerid][P_NAME], playerid, user, day, reason);
    SendAdminMessage(0xEA3752FF, string);
	mysql_format(connect, string, sizeof string, "\
		INSERT INTO `ban_users`(`user`,`user_ip`,`admin`,`admin_ip`,`data`,`lost`,`reason`) VALUES ('%d','none','%d','%s','%d','%d','%s')\
	", id, Player[playerid][P_ID], Player[playerid][P_IP], time, lost, reason);
	mysql_tquery(connect, string);
	return 1;
}

cmd:unban(playerid, params[])
{
	new len = strlen(params);
	new string[108 + MAX_PLAYER_NAME];
	if(len < 4 || len > MAX_PLAYER_NAME) return SendClientMessage(playerid, 0xBEBEBEFF, "Никнайм игрока неверен!");
	mysql_format(connect, string, sizeof string, "\
		SELECT `users`.`id` FROM `users`,`ban_users` WHERE `users`.`name`='%s' AND `ban_users`.`user`=`users`.`id`\
	", params);
	new Cache:cache = mysql_query(connect, string);
	if(cache_get_row_count(connect) <= 0) {
	    SendClientMessage(playerid, 0xBEBEBEFF, "Игрок не найден или не заблокирован!");
		return cache_delete(cache);
	}
	new id = cache_get_field_content_int(0, "id");
	cache_delete(cache);
	format(string, sizeof string, "DELETE FROM `ban_users` WHERE `user`='%d'", id);
 	mysql_tquery(connect, string);
 	format(string, sizeof string, "Админ %s[%d] разблокировал %s", Player[playerid][P_NAME], playerid, params);
    SendAdminMessage(0xEA3752FF, string);
	return 1;
}

cmd:mute(playerid, params[])
{
	new user, time, reason[128];
	new string[144];
	if(sscanf(params, "uds[128]", user, time, reason)) return SendUseCommand(playerid, "Использование: /mute [ id ] [ время(минуты) ] [ причина ]");
	if(user == INVALID_PLAYER_ID) return SendInvalidPlayer(playerid);
 	if(time < 1 || time > 180) return SendClientMessage(playerid, 0xBEBEBEFF, "Время не может быть меньше 1 или больше 180 минут");
 	if(Player[user][P_MUTE_TIME] != 0) return SendClientMessage(playerid, 0xBEBEBEFF, "У игрока уже заблокирован чат");
	Player[user][P_MUTE_TIME] = time * 60;
	
    format(string, sizeof string, "Админ %s[%d] заблокировал чат %s[%d] на %d мин. | Причина: %s", Player[playerid][P_NAME], playerid, Player[user][P_NAME], user, time, reason);
    SendAdminMessage(0xEA3752FF, string);
    
    format(string, sizeof string, "Вам заблокировал чат %s на %d мин. | Причина: %s", Player[playerid][P_NAME], time, reason);
    SendClientMessage(user, 0xEA3752FF, string);
	return 1;
}

cmd:unmute(playerid, params[])
{
	new user;
	if(sscanf(params, "u", user)) return SendUseCommand(playerid, "Использование: /unmute [ id ]");
	if(user == INVALID_PLAYER_ID) return SendInvalidPlayer(playerid);
 	if(Player[user][P_MUTE_TIME] == 0) return SendClientMessage(playerid, 0xBEBEBEFF, "У игрока не заблокирован чат");
 	Player[user][P_MUTE_TIME] = 0;
 	
	new string[144];

    format(string, sizeof string, "Админ %s[%d] разблокировал чат %s[%d]", Player[playerid][P_NAME], playerid, Player[user][P_NAME], user);
    SendAdminMessage(0xEA3752FF, string);
    
    format(string, sizeof string, "Вам разблокировал чат %s", Player[playerid][P_NAME]);
    SendClientMessage(user, 0xEA3752FF, string);
	return 1;
}

cmd:slap(playerid, params[])
{
	new user;
	if(sscanf(params, "u", user)) return SendUseCommand(playerid, "Использование: /slap [ id ]");
	if(user == INVALID_PLAYER_ID) return SendInvalidPlayer(playerid);
	new Float:x, Float:y, Float:z;
	GetPlayerPos(user, x, y, z);
	SetPlayerPos(user, x, y, z + 2.0);

	new string[144];

    format(string, sizeof string, "Админ %s[%d] дал пинка %s[%d]", Player[playerid][P_NAME], playerid, Player[user][P_NAME], user);
    SendAdminMessage(0xEA3752FF, string);

    format(string, sizeof string, "Вам дал пинка администратор %s", Player[playerid][P_NAME]);
    SendClientMessage(user, 0xEA3752FF, string);
	return 1;
}

cmd:veh(playerid, params[])
{
	new model, col1, col2;
	if(sscanf(params, "ddd", model, col1, col2)) return SendUseCommand(playerid, "Использование: /veh [ модель ] [ цвет 1 ] [ цвет 2 ]");
 	if(model < 400 || model > 611) return SendClientMessage(playerid, 0xBEBEBEFF, "Модель транспорта должна быть больше 400 и меньше 611");
 	if(col1 < 0 || col1 > 255 || col2 < 0 || col2 > 255) return SendClientMessage(playerid, 0xBEBEBEFF, "Цвет транспорта должен быть больше 0 и меньше 255");
 	new Float:x, Float:y, Float:z, Float:a;
 	GetPlayerPos(playerid, x, y, z);
 	GetPlayerFacingAngle(playerid, a);
 	new veh = CreateVehicle(model, x, y, z, a, col1, col2, -1);
 	PutPlayerInVehicle(playerid, veh, 0);
 	SetVehicleEngine(veh, 1);
	return 1;
}

cmd:answer(playerid, params[])
{
	new user, text[128];
    if(sscanf(params, "us[128]", user, text)) return SendUseCommand(playerid, "Использование: /answer [ id ] [ текст ]");
	if(user == INVALID_PLAYER_ID) return SendInvalidPlayer(playerid);
    
    new string[144];

    format(string, sizeof string, "%s[%d] ответил %s[%d]: %s", Player[playerid][P_NAME], playerid, Player[user][P_NAME], user, text);
    SendAdminMessage(0xEA3752FF, string);

    format(string, sizeof string, "Вам ответил администратор %s: %s", Player[playerid][P_NAME], text);
    SendClientMessage(user, 0xEA3752FF, string);
    
	return 1;
}

