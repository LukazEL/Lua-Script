-- Lua pack by LukazEL

-- Lua UPDATE

local script_url = "https://raw.githubusercontent.com/LukazEL/Lua-Script/master/autorun.lua"
local ver_url = "https://pastebin.com/raw/v8YdZsen"  
local ver_cur = 1.0

aimware_conf_error = 0
function error_check() -- checks for common errors
  if not gui.GetValue("lua_allow_http") then
    draw.Text( 0, 0, "Please enable LUA http connections." );
    aimware_conf_error = 1
  end
  if not gui.GetValue("lua_allow_cfg") then
    draw.Text( 0, 15, "Please enable script editing from lua." );
    aimware_conf_error = 1
  end
end

callbacks.Register( "Draw", error_check )

local script_data = http.Get(script_url)
local version_get = http.Get(ver_url)


function main()
  if aimware_conf_error == 1 then
    return
  end
  if version_get ~= ver_cur then
    local update_script_query = file.Open(GetScriptName(), "w");
    update_script_query:Write(script_data);
    update_script_query:Close();
  end
end

callbacks.Register( "Draw", main )

-- stuff
local draw_Line, draw_TextShadow, draw_Color, draw_Text, g_tickinterval, string_format, http_Get, string_gsub, file_Open, math_exp, math_rad, math_max, math_abs, math_tan, math_sin, math_cos, math_fmod, draw_GetTextSize, draw_FilledRect, draw_RoundedRect, draw_RoundedRectFill, draw_CreateFont, draw_SetFont, client_WorldToScreen, draw_GetScreenSize, client_GetConVar, client_SetConVar, client_exec, PlayerNameByUserID, PlayerIndexByUserID, entities_GetByIndex, GetLocalPlayer, gui_SetValue, gui_GetValue, LocalPlayerIndex, c_AllowListener, cb_Register, g_tickcount, g_realtime, g_curtime, g_absoluteframetime, math_floor, math_sqrt, GetPlayerResources, entities_FindByClass, IsButtonPressed, client_ChatSay, table_insert, table_remove, vector_Distance = draw.Line, draw.TextShadow, draw.Color, draw.Text, globals.TickInterval, string.format, http.Get, string.gsub, file.Open, math.exp, math.rad, math.max, math.abs, math.tan, math.sin, math.cos, math.fmod, draw.GetTextSize, draw.FilledRect, draw.RoundedRect, draw.RoundedRectFill, draw.CreateFont, draw.SetFont, client.WorldToScreen, draw.GetScreenSize, client.GetConVar, client.SetConVar, client.Command, client.GetPlayerNameByUserID, client.GetPlayerIndexByUserID, entities.GetByIndex, entities.GetLocalPlayer, gui.SetValue, gui.GetValue, client.GetLocalPlayerIndex, client.AllowListener, callbacks.Register, globals.TickCount, globals.RealTime, globals.CurTime, globals.AbsoluteFrameTime, math.floor, math.sqrt, entities.GetPlayerResources, entities.FindByClass, input.IsButtonPressed, client.ChatSay, table.insert, table.remove, vector.Distance

-- Auto Buy 

local MSC_PART_3_REF = gui.Reference("SETTINGS","Miscellaneous");

local Autobuy_Groupbox = gui.Groupbox( MSC_PART_3_REF, "Autobuy", 0, 570, 213, 180 );
local Autobuy_Enable = gui.Checkbox( Autobuy_Groupbox, "lua_autobuy_enable", "Enable", 0 );

local Autobuy_PrimaryWeapon = gui.Combobox( Autobuy_Groupbox, "lua_autobuy_primaryweapon", "Primary Weapon", "Off", "Auto", "Scout", "AWP", "Rifle", "Famas : Galil AR", "AUG : SG 553", "MP9 : MAC-10", "MP7 : MP5-SD", "UMP-45", "P90", "PP-Bizon", "Nova", "XM1014", "MAG-7 : Sawed-Off", "M249", "Negev" );
local Autobuy_SecondaryWeapon = gui.Combobox( Autobuy_Groupbox, "lua_autobuy_secondaryweapon", "Secondary Weapon", "Off", "Dual Berettas", "P250", "Five-Seven : CZ75-Auto : Tec-9", "Desert Eagle : R8 Revolver" );

local Autobuy_Armor = gui.Combobox( Autobuy_Groupbox, "lua_autobuy_armor", "Armor", "Off", "Kevlar", "Kevlar + Helmet" );
local Autobuy_Defuser = gui.Checkbox( Autobuy_Groupbox, "lua_autobuy_defuser", "Defuser", 0 );
local Autobuy_Taser = gui.Checkbox( Autobuy_Groupbox, "lua_autobuy_taser", "Taser", 0 );

local Autobuy_HEGrenade = gui.Checkbox( Autobuy_Groupbox, "lua_autobuy_hegrenade", "HE Grenade", 0 );
local Autobuy_Smoke = gui.Checkbox( Autobuy_Groupbox, "lua_autobuy_smoke", "Smoke", 0 );
local Autobuy_Molotov = gui.Checkbox( Autobuy_Groupbox, "lua_autobuy_molotov", "Molotov", 0 );
local Autobuy_Flashbang = gui.Checkbox( Autobuy_Groupbox, "lua_autobuy_flashbang", "Flashbang", 0 );
local Autobuy_Decoy = gui.Checkbox( Autobuy_Groupbox, "lua_autobuy_decoy", "Decoy", 0 );

local Money = 0

local function LocalPlayerMoney()
	if Autobuy_Enable:GetValue() then
		if entities.GetLocalPlayer() ~= nil then
			Money = entities.GetLocalPlayer():GetProp( "m_iAccount" )
		end
	end
end

local function Autobuy( Event )

	local PrimaryWeapon = Autobuy_PrimaryWeapon:GetValue()
	local SecondaryWeapon = Autobuy_SecondaryWeapon:GetValue()
	local Armor = Autobuy_Armor:GetValue()

	if Autobuy_Enable:GetValue() then

		if Event:GetName() ~= "player_spawn" then
			return;
		end

		local INT_UID = Event:GetInt( "userid" );
		local PlayerIndex = client.GetPlayerIndexByUserID( INT_UID );
		
		if client.GetLocalPlayerIndex() == PlayerIndex then
			ME = true
		else
			ME = false
		end

		if ME and Money == 0 then
			-- Primary Weapon
			if PrimaryWeapon == 1 then client.Command( "buy scar20", true ); -- Auto
			elseif PrimaryWeapon == 2 then client.Command( "buy ssg08", true ); -- Scout
			elseif PrimaryWeapon == 3 then client.Command( "buy awp", true ); -- AWP
			elseif PrimaryWeapon == 4 then client.Command( "buy ak47", true ); -- Rifle
			elseif PrimaryWeapon == 5 then client.Command( "buy famas", true ); -- Famas : Galil AR
			elseif PrimaryWeapon == 6 then client.Command( "buy aug", true ); -- AUG : SG 553
			elseif PrimaryWeapon == 7 then client.Command( "buy mac10", true ); --  MP9 : MAC-10
			elseif PrimaryWeapon == 8 then client.Command( "buy mp7", true ); -- MP7 : MP5-SD
			elseif PrimaryWeapon == 9 then client.Command( "buy ump45", true ); -- UMP-45
			elseif PrimaryWeapon == 10 then client.Command( "buy p90", true ); -- P90
			elseif PrimaryWeapon == 11 then client.Command( "buy bizon", true ); -- PP-Bizon
			elseif PrimaryWeapon == 12 then client.Command( "buy nova", true ); -- Nova
			elseif PrimaryWeapon == 13 then client.Command( "buy xm1014", true ); -- XM1014
			elseif PrimaryWeapon == 14 then client.Command( "buy mag7", true ); -- MAG-7 : Sawed-Off
			elseif PrimaryWeapon == 15 then client.Command( "buy m249", true ); -- M249
			elseif PrimaryWeapon == 16 then client.Command( "buy negev", true ); -- Negev
			end
			-- Secondary Weapon
			if SecondaryWeapon == 1 then client.Command( "buy elite", true ); -- Dual Berettas
			elseif SecondaryWeapon == 2 then client.Command( "buy p250", true ); -- P250
			elseif SecondaryWeapon == 3 then client.Command( "buy tec9", true ); -- Five-Seven : CZ75-Auto : Tec-9
			elseif SecondaryWeapon == 4 then client.Command( "buy deagle", true ); -- Desert Eagle : R8 Revolver
			end
			-- Taser
			if Autobuy_Taser:GetValue() then
				client.Command( "buy taser", true );
			end
		elseif ME and Money <= 800 then
			-- Secondary Weapon
			if SecondaryWeapon == 1 then client.Command( "buy elite", true ); -- Dual Berettas
			elseif SecondaryWeapon == 2 then client.Command( "buy p250", true ); -- P250
			elseif SecondaryWeapon == 3 then client.Command( "buy tec9", true ); -- Five-Seven : CZ75-Auto : Tec-9
			elseif SecondaryWeapon == 4 then client.Command( "buy deagle", true ); -- Desert Eagle : R8 Revolver
			end
			-- Taser
			if Autobuy_Taser:GetValue() then
				client.Command( "buy taser", true );
			end
		elseif ME and Money > 800 then
			-- Primary Weapon
			if PrimaryWeapon == 1 then client.Command( "buy scar20", true ); -- Auto
			elseif PrimaryWeapon == 2 then client.Command( "buy ssg08", true ); -- Scout
			elseif PrimaryWeapon == 3 then client.Command( "buy awp", true ); -- AWP
			elseif PrimaryWeapon == 4 then client.Command( "buy ak47", true ); -- Rifle
			elseif PrimaryWeapon == 5 then client.Command( "buy famas", true ); -- Famas : Galil AR
			elseif PrimaryWeapon == 6 then client.Command( "buy aug", true ); -- AUG : SG 553
			elseif PrimaryWeapon == 7 then client.Command( "buy mac10", true ); --  MP9 : MAC-10
			elseif PrimaryWeapon == 8 then client.Command( "buy mp7", true ); -- MP7 : MP5-SD
			elseif PrimaryWeapon == 9 then client.Command( "buy ump45", true ); -- UMP-45
			elseif PrimaryWeapon == 10 then client.Command( "buy p90", true ); -- P90
			elseif PrimaryWeapon == 11 then client.Command( "buy bizon", true ); -- PP-Bizon
			elseif PrimaryWeapon == 12 then client.Command( "buy nova", true ); -- Nova
			elseif PrimaryWeapon == 13 then client.Command( "buy xm1014", true ); -- XM1014
			elseif PrimaryWeapon == 14 then client.Command( "buy mag7", true ); -- MAG-7 : Sawed-Off
			elseif PrimaryWeapon == 15 then client.Command( "buy m249", true ); -- M249
			elseif PrimaryWeapon == 16 then client.Command( "buy negev", true ); -- Negev
			end
			-- Secondary Weapon
			if SecondaryWeapon == 1 then client.Command( "buy elite", true ); -- Dual Berettas
			elseif SecondaryWeapon == 2 then client.Command( "buy p250", true ); -- P250
			elseif SecondaryWeapon == 3 then client.Command( "buy tec9", true ); -- Five-Seven : CZ75-Auto : Tec-9
			elseif SecondaryWeapon == 4 then client.Command( "buy deagle", true ); -- Desert Eagle : R8 Revolver
			end

			-- Armor
			if Armor == 1 then client.Command( "buy vest", true );
			elseif Armor == 2 then client.Command( "buy vesthelm", true );
			end
			-- Defuser
			if Autobuy_Defuser:GetValue() then
				client.Command( "buy defuser", true );
			end
			-- Taser
			if Autobuy_Taser:GetValue() then
				client.Command( "buy taser", true );
			end

			-- HE Grenade
			if Autobuy_HEGrenade:GetValue() then
				client.Command( "buy hegrenade", true );
			end
			-- Smoke
			if Autobuy_Smoke:GetValue() then
				client.Command( "buy smokegrenade", true );
			end
			-- Molotov
			if Autobuy_Molotov:GetValue() then
				client.Command( "buy molotov", true );
			end
			-- Flashbang
			if Autobuy_Flashbang:GetValue() then
				client.Command( "buy flashbang", true );
			end
			-- Decoy
			if Autobuy_Decoy:GetValue() then
				client.Command( "buy decoy", true );
			end
		end

	end

end

client.AllowListener( "player_spawn" )

callbacks.Register( "Draw", "Local Player Money", LocalPlayerMoney )
callbacks.Register( "FireGameEvent", "Autobuy", Autobuy )

-- manual aa


local gui_set = gui.SetValue;
local gui_get = gui.GetValue;
local LeftKey = 0;
local BackKey = 0;
local RightKey = 0;
local rage_ref = gui.Reference("RAGE", "MAIN", "Anti-Aim Main");
local check_indicator = gui.Checkbox( rage_ref, "Enable", "Manual AA", false)
local AntiAimleft = gui.Keybox(rage_ref, "Anti-Aim_left", "Left Keybind", 0);
local AntiAimRight = gui.Keybox(rage_ref, "Anti-Aim_Right", "Right Keybind", 0);
local AntiAimBack = gui.Keybox(rage_ref, "Anti-Aim_Back", "Back Keybind", 0);

local rifk7_font = draw.CreateFont("Verdana", 20, 700)
local damage_font = draw.CreateFont("Verdana", 15, 700)

local arrow_font = draw.CreateFont("Marlett", 45, 700)
local normal = draw.CreateFont("Arial")

local function main()
    if AntiAimleft:GetValue() ~= 0 then
        if input.IsButtonPressed(AntiAimleft:GetValue()) then
            LeftKey = LeftKey + 1;
            BackKey = 0;
            RightKey = 0;
        end
    end
    if AntiAimBack:GetValue() ~= 0 then
        if input.IsButtonPressed(AntiAimBack:GetValue()) then
            BackKey = BackKey + 1;
            LeftKey = 0;
            RightKey = 0;
        end
    end
    if AntiAimRight:GetValue() ~= 0 then
        if input.IsButtonPressed(AntiAimRight:GetValue()) then
            RightKey = RightKey + 1;
            LeftKey = 0;
            BackKey = 0;
        end
    end
end


function CountCheck()
   if ( LeftKey == 1 ) then
        BackKey = 0;
        RightKey = 0;
   elseif ( BackKey == 1 ) then
        LeftKey = 0;
        RightKey = 0;
    elseif ( RightKey == 1 ) then
        LeftKey = 0;
        BackKey = 0;
    elseif ( LeftKey == 2 ) then
        LeftKey = 0;
        BackKey = 0;
        RightKey = 0;
   elseif ( BackKey == 2 ) then
        LeftKey = 0;
        BackKey = 0;
        RightKey = 0;
   elseif ( RightKey == 2 ) then
        LeftKey = 0;
        BackKey = 0;
        RightKey = 0;
   end        
end

function SetLeft()
   gui_set("rbot_antiaim_stand_real_add", -90);
    gui_set("rbot_antiaim_move_real_add", -90);
    gui_set("rbot_antiaim_autodir", false);
end

function SetBackWard()
   gui_set("rbot_antiaim_stand_real_add", 0);
    gui_set("rbot_antiaim_move_real_add", 0);
    gui_set("rbot_antiaim_autodir", false);
end

function SetRight()
   gui_set("rbot_antiaim_stand_real_add", 90);
    gui_set("rbot_antiaim_move_real_add", 90);
    gui_set("rbot_antiaim_autodir", false);
end

function SetAuto()
   gui_set("rbot_antiaim_stand_real_add", 0);
    gui_set("rbot_antiaim_move_real_add", 0);
    gui_set("rbot_antiaim_autodir", true);
end

function draw_indicator()

    local active = check_indicator:GetValue()

    if active then


        local w, h = draw.GetScreenSize();
        draw.SetFont(rifk7_font)
        if (LeftKey == 1) then
            SetLeft();
            draw.Color(129, 255, 254, 255);
            draw.Text(15, h - 560, "MANUAL");
            draw.TextShadow(15, h - 560, "MANUAL");
			draw.SetFont(arrow_font)
			draw.Text( w/2 - 100, h/2 - 21, "3");
			draw.TextShadow( w/2 - 100, h/2 - 21, "3");
			draw.SetFont(rifk7_font)
        elseif (BackKey == 1) then
            SetBackWard();
            draw.Color(129, 255, 254, 255);
            draw.Text(15, h - 560, "MANUAL");
            draw.TextShadow(15, h - 560, "MANUAL");
			draw.SetFont(arrow_font)
			draw.Text( w/2 - 21, h/2 + 60, "6");
			draw.TextShadow( w/2 - 21, h/2 + 60, "6");
			draw.SetFont(rifk7_font)
        elseif (RightKey == 1) then
            SetRight();
            draw.Color(129, 255, 254, 255);
            draw.Text(15, h - 560, "MANUAL");
            draw.TextShadow(15, h - 560, "MANUAL");
			draw.SetFont(arrow_font)
			draw.Text( w/2 + 60, h/2 - 21, "4");
			draw.TextShadow( w/2 + 60, h/2 - 21, "4");
			draw.SetFont(rifk7_font)
        elseif ((LeftKey == 0) and (BackKey == 0) and (RightKey == 0)) then
            SetAuto();
            draw.Color(107, 244, 65, 255);
            draw.Text(15, h - 560, "AUTO");
            draw.TextShadow(15, h - 560, "AUTO");
        end
        draw.SetFont(normal)
    end
end

callbacks.Register( "Draw", "main", main);
callbacks.Register( "Draw", "CountCheck", CountCheck);
callbacks.Register( "Draw", "SetLeft", SetLeft);
callbacks.Register( "Draw", "SetBackWard", SetBackWard);
callbacks.Register( "Draw", "SetRight", SetRight);
callbacks.Register( "Draw", "SetAuto", SetAuto);
callbacks.Register( "Draw", "draw_indicator", draw_indicator);

-- galaxy skybox

function SkyBox()
    if (client.GetConVar("sv_skyname") ~= "sky_descent" and gui.GetValue("msc_restrict") ~= 1) then
        client.SetConVar("sv_skyname", "sky_descent")    
    end
end

callbacks.Register("Draw", "SkyBox", SkyBox)

-- PressBox

local vis_main = gui.Reference('SETTINGS', "Miscellaneous")
local box = gui.Groupbox( vis_main, "Extra Stuff", 0, 380, 213, 170 );
local FullbrightCheckbox = gui.Checkbox(box, "lua_fullbright", "Full Brightness", 0 );
local ERadar = gui.Checkbox(box, "lua_engine_radar", "Engine Radar", 0)
local RainbowMenu = gui.Checkbox(box, "lua_rainbowmenu", "Rainbow Menu", 0 );
local AWMetallicHitsound = gui.Checkbox(box, "lua_metallichitsound", "Metallic Hitsound", 0 );
local DamageSay = gui.Checkbox(box, "lua_damagesay", "Damage Log", 0 );
local K_O_L_H = gui.Checkbox(box, "lua_knifelefthand", "Knife On Left Hand", 0)

-- Engine Radar

function engineradar() if ERadar:GetValue() then ERval = 1 else ERval = 0 end for a, b in pairs(entities_FindByClass("CCSPlayer")) do b:SetProp("m_bSpotted", ERval) end end cb_Register("Draw", engineradar)

-- Fullbright

local function Fullbright()
	
	if FullbrightCheckbox:GetValue() then
		client.SetConVar( "mat_fullbright", 1, true )
	else
		client.SetConVar( "mat_fullbright", 0, true )
	end
	
end

callbacks.Register( "Draw", "FullBrightness", Fullbright )

-- RainbowMenu 

function rainbowmenu()   
	
   local speed = 1
   local r = math.floor(math.sin(globals.RealTime() * speed) * 111 + 128)
   local g = math.floor(math.sin(globals.RealTime() * speed + 2) * 127 + 128)
   local b = math.floor(math.sin(globals.RealTime() * speed + 4) * 127 + 128)
   local a = 255
   
   if RainbowMenu:GetValue() then 
   for k,v in pairs({  "clr_esp_crosshair",
                       "clr_esp_crosshair_recoil",
					   "clr_gui_window_header_tab1",
					   "clr_gui_window_header_tab2",
					   "clr_gui_slider_bar3",
					   "clr_gui_slider_bar2",
					   "clr_gui_checkbox_on",
					   "clr_gui_checkbox_on_hover"}) do
					   
       gui.SetValue(v, r,g,b,a)
       end
	    gui.SetValue("v, r,g,b,a")   
	  else
	   gui.SetValue(0)
      
	  
   end
end

callbacks.Register( "Draw", "owo", rainbowmenu);

-- HitSound GS

local function MetallicHitsound( Event )

	if AWMetallicHitsound:GetValue() then

		if gui.GetValue( "msc_hitmarker_enable" ) then
			gui.SetValue( "msc_hitmarker_volume", 0 );
		end

		if ( Event:GetName() == "player_hurt" ) then

			local ME = client.GetLocalPlayerIndex();

			local INT_UID = Event:GetInt( "userid" );
			local INT_ATTACKER = Event:GetInt( "attacker" );

			local NAME_Victim = client.GetPlayerNameByUserID( INT_UID );
			local INDEX_Victim = client.GetPlayerIndexByUserID( INT_UID );

			local NAME_Attacker = client.GetPlayerNameByUserID( INT_ATTACKER );
			local INDEX_Attacker = client.GetPlayerIndexByUserID( INT_ATTACKER );

			if ( INDEX_Attacker == ME and INDEX_Victim ~= ME ) then
				client.Command( "play buttons\\arena_switch_press_02.wav", true );
			end
	 
		end
	
	end

end

client.AllowListener( "player_hurt" );

callbacks.Register( "FireGameEvent", "Metallic Hitsound", MetallicHitsound );

-- Log Damage

hitPlayerName = "";
hitDmg = "";
hitSpot = "";
hitHealthRemaining = "";

local hurt_time = 0;
local alpha = 0;

local eventArray = {};
eventMsg = "";

local function HitGroup( INT_HITGROUP )
    if INT_HITGROUP == 0 then
        return "body";
    elseif INT_HITGROUP == 1 then
        return "head";
    elseif INT_HITGROUP == 2 then
        return "chest";
    elseif INT_HITGROUP == 3 then
        return "stomach";
    elseif INT_HITGROUP == 4 then 
        return "left arm";
    elseif INT_HITGROUP == 5 then 
        return "right arm";
    elseif INT_HITGROUP == 6 then 
        return "left leg";
    elseif INT_HITGROUP == 7 then 
        return "right leg";
    elseif INT_HITGROUP == 10 then 
        return "body";
    end
end

local function EventLogger( Event, Entity )

    if DamageSay:GetValue() then

        if ( Event:GetName() == 'player_hurt' ) then
            local ME = client.GetLocalPlayerIndex();

            local INT_UID = Event:GetInt( 'userid' );
            local INT_ATTACKER = Event:GetInt( 'attacker' );
            local INT_DMG = Event:GetString( 'dmg_health' );
            local INT_HEALTH = Event:GetString( 'health' );
            local INT_HITGROUP = Event:GetInt( 'hitgroup' );

            local INDEX_ATTACKER = client.GetPlayerIndexByUserID( INT_ATTACKER );
            local INDEX_VICTIM = client.GetPlayerIndexByUserID( INT_UID );
            local NAME_Victim = client.GetPlayerNameByUserID( INT_UID );

            if ( INDEX_ATTACKER == ME and INDEX_Victim ~= ME ) then
                hitPlayerName = NAME_Victim;
                hitDmg = INT_DMG;
                hitSpot = INT_HITGROUP;
                hitHealthRemaining = INT_HEALTH;
            
                hurt_time = globals.RealTime();
            
                eventMsg = string.format( "Hit %s in the %s for %s damage (%s health remaining)\n", hitPlayerName, HitGroup(hitSpot), hitDmg, hitHealthRemaining);
			    print(eventMsg)
                table.insert(eventArray, eventMsg);
            end

        end

    end

end

local function DrawLogs()

    if DamageSay:GetValue() then

        local screenCenterX, screenCenterY = draw.GetScreenSize();
    
        local step = 255 / 4.0 * globals.FrameTime()

        if hurt_time + 5.0 > globals.RealTime() then
            alpha = 255
        else
            alpha = alpha - step
        end
    
        local myfragcounter = 0;

        for i,y in ipairs(eventArray) do
            if y ~= nil then
                draw.Color( 255, 255, 255, alpha)
                if (alpha > 0 ) then
                    draw.Text( 5, 5 + myfragcounter * 10, y );
                    myfragcounter = myfragcounter + 1;
                end
             end
         end

        if ( alpha < 0 ) then
                table.remove( eventArray, i );
        end

    end

end

client.AllowListener( 'player_hurt' );
callbacks.Register( 'Draw', 'DrawLogs', DrawLogs );
callbacks.Register( 'FireGameEvent', 'EventsLogger', EventLogger );

-- Knife on left hand

local cb_register = callbacks.Register

function on_knife_righthand()
if not K_O_L_H:GetValue() then return end if entities.GetLocalPlayer() == nil or entities.GetLocalPlayer():GetHealth() <= 0 then client_exec("cl_righthand 1", true) return end
local wep = entities.GetLocalPlayer():GetPropEntity("m_hActiveWeapon") if wep == nil then return end local cwep = wep:GetClass()
if cwep == "CKnife" then client_exec("cl_righthand 0", true) else client_exec("cl_righthand 1", true) end end
callbacks.Register("Draw", on_knife_righthand) 

-- disable fakelag / fakelag extra

local SetValue = gui.SetValue;
local GetValue = gui.GetValue;

local Version = "6"

local MSC_FAKELAG_REF = gui.Reference( "MISC", "ENHANCEMENT", "Fakelag" );

local FAKELAG_SMART_MODE_TEXT = gui.Text( MSC_FAKELAG_REF, "Fakelag Smart Mode" )
local FAKELAG_SMART_MODE = gui.Checkbox( MSC_FAKELAG_REF, "lua_fakelag_smartmode_enable", "Enable", 0 );
local FAKELAG_SMART_MODE_STANDING = gui.Combobox( MSC_FAKELAG_REF, "lua_fakelag_standing", "While Standing", "Off", "Factor", "Switch", "Adaptive", "Random", "Peek", "Rapid Peek" );
local FAKELAG_SMART_MODE_STANDING_FACTOR = gui.Slider( MSC_FAKELAG_REF, "lua_fakelag_standing_factor", "Factor", 15, 1, 62 );
local FAKELAG_SMART_MODE_MOVING = gui.Combobox( MSC_FAKELAG_REF, "lua_fakelag_moving", "While Moving", "Off", "Factor", "Switch", "Adaptive", "Random", "Peek", "Rapid Peek" );
local FAKELAG_SMART_MODE_MOVING_FACTOR = gui.Slider( MSC_FAKELAG_REF, "lua_fakelag_moving_factor", "Factor", 15, 1, 62 );
local FAKELAG_SMART_MODE_INAIR = gui.Combobox( MSC_FAKELAG_REF, "lua_fakelag_inair", "While In Air", "Off", "Factor", "Switch", "Adaptive", "Random", "Peek", "Rapid Peek" );
local FAKELAG_SMART_MODE_INAIR_FACTOR = gui.Slider( MSC_FAKELAG_REF, "lua_fakelag_inair_factor", "Factor", 15, 1, 62 );

local FAKELAG_EXTRA_TEXT = gui.Text( MSC_FAKELAG_REF, "Fakelag Extra" );
local FAKELAG_EXTRA = gui.Checkbox( MSC_FAKELAG_REF, "lua_fakelag_extra_enable", "Enable", 0 );
local FAKELAG_ON_SLOWWALK = gui.Checkbox( MSC_FAKELAG_REF, "lua_fakelag_slowwalk", "Disable On Slow Walk", 0 );
local FAKELAG_ON_KNIFE = gui.Checkbox( MSC_FAKELAG_REF, "lua_fakelag_knife", "Disable On Knife", 0 );
local FAKELAG_ON_TASER = gui.Checkbox( MSC_FAKELAG_REF, "lua_fakelag_taser", "Disable On Taser", 0 );
local FAKELAG_ON_GRENADE = gui.Checkbox( MSC_FAKELAG_REF, "lua_fakelag_grenade", "Disable On Grenade", 0 );
local FAKELAG_ON_PISTOL = gui.Checkbox( MSC_FAKELAG_REF, "lua_fakelag_pistol", "Disable On Pistol", 0 );
local FAKELAG_ON_REVOLVER = gui.Checkbox( MSC_FAKELAG_REF, "lua_fakelag_revolver", "Disable On Revolver", 0 );
local FAKELAG_ON_PING = gui.Checkbox( MSC_FAKELAG_REF, "lua_fakelag_ping", "Disable Fakelag On Ping", 0 )
local FAKELAG_ON_PING_AMOUNT = gui.Slider( MSC_FAKELAG_REF, "lua_fakelag_ping_amount", "Amount", 120, 0, 1000 )

local Ping = 0
local Time = 0

callbacks.Register( 'Draw',  function()

	if entities.GetLocalPlayer() == nil then
		return
	end

	local LocalPlayerEntity = entities.GetLocalPlayer();
	local WeaponID = LocalPlayerEntity:GetWeaponID();
	local WeaponType = LocalPlayerEntity:GetWeaponType();

	if ( WeaponType == 0 and WeaponID ~= 31 ) then Knife = true else Knife = false end
	if ( WeaponType == 1 and WeaponID ~= 64 ) then Pistol = true else Pistol = false end
	if WeaponID == 31 then Taser = true else Taser = false end
	if WeaponType == 9 then Grenade = true else Grenade = false end
	if WeaponID == 64 then Revolver = true else Revolver = false end

end
)

local function FakelagExtra()

	if FAKELAG_EXTRA:GetValue() then
		
		if ( FAKELAG_ON_KNIFE:GetValue() and Knife ) or -- On Knife
		   ( FAKELAG_ON_TASER:GetValue() and Taser ) or -- On Taser
		   ( FAKELAG_ON_GRENADE:GetValue() and Grenade ) or -- On Grenade
		   ( FAKELAG_ON_PISTOL:GetValue() and Pistol ) or -- On Pistol
		   ( FAKELAG_ON_REVOLVER:GetValue() and Revolver ) then -- On Revolver
			SetValue( "msc_fakelag_enable", 0 );
		else
			SetValue( "msc_fakelag_enable", 1 );
		end

	end

end

local function FakelagOnPing()

	if FAKELAG_EXTRA:GetValue() then
		if FAKELAG_ON_PING:GetValue() then

			if entities.GetPlayerResources() ~= nil then
				Ping = entities.GetPlayerResources():GetPropInt( "m_iPing", client.GetLocalPlayerIndex() );
			end
			FakelagOnPingAmount = math.floor( FAKELAG_ON_PING_AMOUNT:GetValue() )

			if ( Ping >= FakelagOnPingAmount ) or
			   ( FAKELAG_EXTRA:GetValue() and FAKELAG_ON_KNIFE:GetValue() and Knife ) or
			   ( FAKELAG_EXTRA:GetValue() and FAKELAG_ON_TASER:GetValue() and Taser ) or
			   ( FAKELAG_EXTRA:GetValue() and FAKELAG_ON_GRENADE:GetValue() and Grenade ) or
			   ( FAKELAG_EXTRA:GetValue() and FAKELAG_ON_PISTOL:GetValue() and Pistol ) or
			   ( FAKELAG_EXTRA:GetValue() and FAKELAG_ON_REVOLVER:GetValue() and Revolver ) then
				SetValue( "msc_fakelag_enable", 0 );
			else
				SetValue( "msc_fakelag_enable", 1 );
			end

		end
	end

end		

local function FakelagOnSlowWalk()

	if FAKELAG_EXTRA:GetValue() then

		if GetValue( "msc_slowwalk" ) ~= 0 then
			SlowWalkFakelagOff = input.IsButtonDown( GetValue( "msc_slowwalk" ) )
		end

		if FAKELAG_ON_SLOWWALK:GetValue() and GetValue( "msc_slowwalk" ) ~= 0 then
			if ( SlowWalkFakelagOff ) or
			   ( FAKELAG_EXTRA:GetValue() and FAKELAG_ON_KNIFE:GetValue() and Knife ) or
			   ( FAKELAG_EXTRA:GetValue() and FAKELAG_ON_TASER:GetValue() and Taser ) or
			   ( FAKELAG_EXTRA:GetValue() and FAKELAG_ON_GRENADE:GetValue() and Grenade ) or
			   ( FAKELAG_EXTRA:GetValue() and FAKELAG_ON_PISTOL:GetValue() and Pistol ) or
			   ( FAKELAG_EXTRA:GetValue() and FAKELAG_ON_REVOLVER:GetValue() and Revolver ) or
			   ( FAKELAG_EXTRA:GetValue() and FAKELAG_ON_PING:GetValue() and Ping >= FakelagOnPingAmount ) then
				SetValue( "msc_fakelag_enable", 0 );
			else
				SetValue( "msc_fakelag_enable", 1 );
			end
		end

	end

end

local function FakelagSmartMode()

	if FAKELAG_SMART_MODE:GetValue() then

		local FAKELAG_STANDING = FAKELAG_SMART_MODE_STANDING:GetValue();
		local FAKELAG_MOVING = FAKELAG_SMART_MODE_MOVING:GetValue();
		local FAKELAG_INAIR = FAKELAG_SMART_MODE_INAIR:GetValue();

		local FAKELAG_STANDING_FACTOR = math.floor( FAKELAG_SMART_MODE_STANDING_FACTOR:GetValue() )
		local FAKELAG_MOVING_FACTOR = math.floor( FAKELAG_SMART_MODE_MOVING_FACTOR:GetValue() )
		local FAKELAG_INAIR_FACTOR = math.floor( FAKELAG_SMART_MODE_INAIR_FACTOR:GetValue() )

		if entities.GetLocalPlayer() ~= nil then

			local LocalPlayerEntity = entities.GetLocalPlayer();
			local fFlags = LocalPlayerEntity:GetProp( "m_fFlags" );

			local VelocityX = LocalPlayerEntity:GetPropFloat( "localdata", "m_vecVelocity[0]" );
			local VelocityY = LocalPlayerEntity:GetPropFloat( "localdata", "m_vecVelocity[1]" );

			local Velocity = math.sqrt( VelocityX^2 + VelocityY^2 );

			-- Standing
			if ( Velocity == 0 and ( fFlags == 257 or fFlags == 261 or fFlags == 263 ) ) then
				Standing = true
			else
				Standing = false
			end

			-- Moving
			if ( Velocity > 0 and ( fFlags == 257 or fFlags == 261 or fFlags == 263 ) ) then
				Moving = true
			else
				Moving = false
			end

			-- In Air
			if fFlags == 256 or fFlags == 262 then
				InAir = true
				Time = globals.CurTime();
			else
				InAir = false
			end
		end

		if Standing and Time + 0.2 < globals.CurTime() then
			if ( FAKELAG_STANDING == 0 ) or
			   ( FAKELAG_EXTRA:GetValue() and FAKELAG_ON_KNIFE:GetValue() and Knife ) or
			   ( FAKELAG_EXTRA:GetValue() and FAKELAG_ON_TASER:GetValue() and Taser ) or
			   ( FAKELAG_EXTRA:GetValue() and FAKELAG_ON_GRENADE:GetValue() and Grenade ) or
			   ( FAKELAG_EXTRA:GetValue() and FAKELAG_ON_PISTOL:GetValue() and Pistol ) or
			   ( FAKELAG_EXTRA:GetValue() and FAKELAG_ON_REVOLVER:GetValue() and Revolver ) or
			   ( FAKELAG_EXTRA:GetValue() and FAKELAG_ON_PING:GetValue() and Ping >= FakelagOnPingAmount ) or
			   ( FAKELAG_EXTRA:GetValue() and FAKELAG_ON_SLOWWALK:GetValue() and GetValue( "msc_slowwalk" ) ~= 0 and SlowWalkFakelagOff ) then
				SetValue( "msc_fakelag_enable", 0 );
			else
				SetValue( "msc_fakelag_enable", 1 );
			end
			if FAKELAG_STANDING > 0 then
				STANDING_MODE = ( FAKELAG_STANDING - 1 )
			end
			SetValue( "msc_fakelag_mode", STANDING_MODE );
			SetValue( "msc_fakelag_value", FAKELAG_STANDING_FACTOR );
		end

		if Moving and Time + 0.2 < globals.CurTime() then
			if ( FAKELAG_MOVING == 0 ) or
			   ( FAKELAG_EXTRA:GetValue() and FAKELAG_ON_KNIFE:GetValue() and Knife ) or
			   ( FAKELAG_EXTRA:GetValue() and FAKELAG_ON_TASER:GetValue() and Taser ) or
			   ( FAKELAG_EXTRA:GetValue() and FAKELAG_ON_GRENADE:GetValue() and Grenade ) or
			   ( FAKELAG_EXTRA:GetValue() and FAKELAG_ON_PISTOL:GetValue() and Pistol ) or
			   ( FAKELAG_EXTRA:GetValue() and FAKELAG_ON_REVOLVER:GetValue() and Revolver ) or
			   ( FAKELAG_EXTRA:GetValue() and FAKELAG_ON_PING:GetValue() and Ping >= FakelagOnPingAmount ) or
			   ( FAKELAG_EXTRA:GetValue() and FAKELAG_ON_SLOWWALK:GetValue() and GetValue( "msc_slowwalk" ) ~= 0 and SlowWalkFakelagOff ) then
				SetValue( "msc_fakelag_enable", 0 );
			else
				SetValue( "msc_fakelag_enable", 1 );
			end
			if FAKELAG_MOVING > 0 then
				MOVING_MODE = ( FAKELAG_MOVING - 1 )
			end
			SetValue( "msc_fakelag_mode", MOVING_MODE );
			SetValue( "msc_fakelag_value", FAKELAG_MOVING_FACTOR );
		end

		if InAir then
			if ( FAKELAG_INAIR == 0 ) or
			   ( FAKELAG_EXTRA:GetValue() and FAKELAG_ON_KNIFE:GetValue() and Knife ) or
			   ( FAKELAG_EXTRA:GetValue() and FAKELAG_ON_TASER:GetValue() and Taser ) or
			   ( FAKELAG_EXTRA:GetValue() and FAKELAG_ON_GRENADE:GetValue() and Grenade ) or
			   ( FAKELAG_EXTRA:GetValue() and FAKELAG_ON_PISTOL:GetValue() and Pistol ) or
			   ( FAKELAG_EXTRA:GetValue() and FAKELAG_ON_REVOLVER:GetValue() and Revolver ) or
			   ( FAKELAG_EXTRA:GetValue() and FAKELAG_ON_PING:GetValue() and Ping >= FakelagOnPingAmount ) or
			   ( FAKELAG_EXTRA:GetValue() and FAKELAG_ON_SLOWWALK:GetValue() and GetValue( "msc_slowwalk" ) ~= 0 and SlowWalkFakelagOff ) then
				SetValue( "msc_fakelag_enable", 0 );
			else
				SetValue( "msc_fakelag_enable", 1 );
			end
			if FAKELAG_INAIR > 0 then
				INAIR_MODE = ( FAKELAG_INAIR - 1 )
			end
			SetValue( "msc_fakelag_mode", INAIR_MODE );
			SetValue( "msc_fakelag_value", FAKELAG_INAIR_FACTOR );
		end

	end

end

callbacks.Register( 'Draw', FakelagExtra )
callbacks.Register( 'Draw', FakelagOnPing )
callbacks.Register( 'Draw', FakelagOnSlowWalk )
callbacks.Register( 'Draw', FakelagSmartMode )

-- Updater
callbacks.Register( "Draw", Updater )

-- Taser Range

local function distance3d(x1, y1, z1, x2, y2, z2)
   return math.sqrt((x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) + (z2-z1)*(z2-z1))
end



local msc_p2 = gui.Reference("MISC", "AUTOMATION", "Other")
local GroupBox = gui.Groupbox( msc_p2, "Zeus Range", 0, 75, 213, 150 );
local ActiveCheckBox = gui.Checkbox(GroupBox, "Active", "Activate", false)
local Tyleline = gui.Combobox( GroupBox, 'Type_line',"Type line", "Single line","Multi line")
local colortype = gui.Combobox( GroupBox, 'Type_color',"Color", "Single color","Multi color")
local function lerp_pos(x1, y1, z1, x2, y2, z2, percentage)
   local x = (x2 - x1) * percentage + x1
   local y = (y2 - y1) * percentage + y1
   local z = (z2 - z1) * percentage + z1
   return x, y, z
end

local function trace_line_skip_teammates( x1, y1, z1, x2, y2, z2, max_traces)

   local max_traces = max_traces or 10
   local fraction, entindex_hit = 0, -1
   local x_hit, y_hit, z_hit = x1, y1, z1

   local i=1
   while (entindex_hit == -1 ) and 1 > fraction and max_traces >= i do
   fraction, entindex_hit = engine.TraceLine( x_hit, y_hit, z_hit, x2, y2, z2,3)

       x_hit, y_hit, z_hit = lerp_pos(x_hit, y_hit, z_hit, x2, y2, z2, 1)

       i = i + 1
   end

   local traveled_total = distance3d(x1, y1, z1, x_hit, y_hit, z_hit)
   local total_distance = distance3d(x1, y1, z1, x2, y2, z2)

   return traveled_total/total_distance, entindex_hit
end

local function hsv_to_rgb(h, s, v, a)
 local r, g, b

 local i = math.floor(h * 6);
 local f = h * 6 - i;
 local p = v * (1 - s);
 local q = v * (1 - f * s);
 local t = v * (1 - (1 - f) * s);

 i = i % 6

 if i == 0 then r, g, b = v, t, p
 elseif i == 1 then r, g, b = q, v, p
 elseif i == 2 then r, g, b = p, v, t
 elseif i == 3 then r, g, b = p, q, v
 elseif i == 4 then r, g, b = t, p, v
 elseif i == 5 then r, g, b = v, p, q
 end

 return r * 255, g * 255, b * 255, a * 255
end




local weapon_name_prev = nil
local last_switch = 0
local accuracy = 2.5

local is_taser;
local is_knife;
local function on_item_equip(Event)

   if (Event:GetName() ~= 'item_equip') then
       return;
   end

   local local_player, userid, item, weptype = client.GetLocalPlayerIndex(), Event:GetInt('userid'), Event:GetString('item'), Event:GetInt('weptype');


   if (local_player == client.GetPlayerIndexByUserID(userid)) then
       if (item == "taser" ) then
          is_taser=true;
          is_knife=false;
       elseif (item=="knife")then
       is_knife=true;
        is_taser=false;
       else 
       is_knife=false;
           is_taser=false;
       end
   end
end


client.AllowListener('item_equip');
callbacks.Register("FireGameEvent", "on_item_equip", on_item_equip);


local function on_paint()

if ActiveCheckBox:GetValue() then
   local local_player = entities.GetLocalPlayer();
   local curtime = globals.CurTime()



   local ranges
   local ranges_opacities
   if  is_taser then
       ranges = {167}
       ranges_opacities = {1}
elseif is_knife then
       ranges = {32}
       ranges_opacities = {1}
   end

   if ranges == nil then
       return
   end
    local Entity = entities.GetLocalPlayer();
     local Alive = Entity:IsAlive();
     if (Alive ~=true) then
     return
     
     end
   local local_x, local_y, local_z = Entity:GetAbsOrigin()
   local_z=local_z+45
   local vo_z = Entity:GetProp("localdata", "m_vecViewOffset[2]")-40
local range
local range2 
fade_multiplier = 1
if (Tyleline:GetValue() ==0) then
   for i=1, #ranges do
       range2=  ranges[i]
       range = ranges[i]
       
       local opacity_multiplier = ranges_opacities[i] * fade_multiplier

       local previous_world_x, previous_world_y

       for rot=0, 360, accuracy do
           local rot_temp = math.rad(rot)
           local temp_x, temp_y, temp_z = local_x + range * math.cos(rot_temp), local_y + range * math.sin(rot_temp), local_z
       
           local fraction, entindex_hit = trace_line_skip_teammates( local_x, local_y, local_z, temp_x, temp_y, temp_z)

           --local fraction_x, fraction_y = local_x+(temp_x-local_x)*fraction, local_y+(temp_y-local_y)*fraction
           local fraction_x, fraction_y = lerp_pos(local_x, local_y, local_z, temp_x, temp_y, temp_z, fraction)
           local world_x, world_y = client.WorldToScreen( fraction_x, fraction_y, temp_z+(range2-range))

           local hue_extra = globals.RealTime() % 8 / 8
           local r, g, b = hsv_to_rgb(rot/360+hue_extra, 1, 1, 255)

           local fraction_multiplier = 1
           if fraction > 0.9 then
               fraction_multiplier = 0.6
           end

           if world_x ~= nil and previous_world_x ~= nil then
           if colortype:GetValue()==1 then
           draw.Color( r, g, b, 255*opacity_multiplier*fraction_multiplier)
           end
               draw.Line( world_x, world_y, previous_world_x, previous_world_y )
           
                        
           end
           previous_world_x, previous_world_y = world_x, world_y
       end
   end
else 
   for i=1, #ranges do
       range2=  ranges[i]
       range = ranges[i]
       end
       
   while range >5 do
   for i=1, #ranges do
   
       
       local opacity_multiplier = ranges_opacities[i] * fade_multiplier

       local previous_world_x, previous_world_y

       for rot=0, 360, accuracy do
           local rot_temp = math.rad(rot)
           local temp_x, temp_y, temp_z = local_x + range * math.cos(rot_temp), local_y + range * math.sin(rot_temp), local_z
       
           local fraction, entindex_hit = trace_line_skip_teammates( local_x, local_y, local_z, temp_x, temp_y, temp_z)

           --local fraction_x, fraction_y = local_x+(temp_x-local_x)*fraction, local_y+(temp_y-local_y)*fraction
           local fraction_x, fraction_y = lerp_pos(local_x, local_y, local_z, temp_x, temp_y, temp_z, fraction)
           local world_x, world_y = client.WorldToScreen( fraction_x, fraction_y, temp_z+(range2-range))

           local hue_extra = globals.RealTime() % 8 / 8
           local r, g, b = hsv_to_rgb(rot/360+hue_extra, 1, 1, 255)

           local fraction_multiplier = 1
           if fraction > 0.9 then
               fraction_multiplier = 0.6
           end

           if world_x ~= nil and previous_world_x ~= nil then
                   if colortype:GetValue()==1 then
           draw.Color( r, g, b, 255*opacity_multiplier*fraction_multiplier)
           end
               draw.Line( world_x, world_y, previous_world_x, previous_world_y )
           
                        
           end
           previous_world_x, previous_world_y = world_x, world_y
       end
   end
       for i=1, #ranges do
   
   
       local opacity_multiplier = ranges_opacities[i] * fade_multiplier

       local previous_world_x, previous_world_y

       for rot=0, 360, accuracy do
           local rot_temp = math.rad(rot)
           local temp_x, temp_y, temp_z = local_x + range * math.cos(rot_temp), local_y + range * math.sin(rot_temp), local_z
       
           local fraction, entindex_hit = trace_line_skip_teammates( local_x, local_y, local_z, temp_x, temp_y, temp_z)

           --local fraction_x, fraction_y = local_x+(temp_x-local_x)*fraction, local_y+(temp_y-local_y)*fraction
           local fraction_x, fraction_y = lerp_pos(local_x, local_y, local_z, temp_x, temp_y, temp_z, fraction)
           local world_x, world_y = client.WorldToScreen( fraction_x, fraction_y, temp_z+(range-range2))

           local hue_extra = globals.RealTime() % 8 / 8
           local r, g, b = hsv_to_rgb(rot/360+hue_extra, 1, 1, 255)

           local fraction_multiplier = 1
           if fraction > 0.9 then
               fraction_multiplier = 0.6
           end

           if world_x ~= nil and previous_world_x ~= nil then
                   if colortype:GetValue()==1 then
           draw.Color( r, g, b, 255*opacity_multiplier*fraction_multiplier)
           end
               draw.Line( world_x, world_y, previous_world_x, previous_world_y )
           
                        
           end
           previous_world_x, previous_world_y = world_x, world_y
       end
   end
   range =range-10
   end

   

   end
end
end



callbacks.Register( "Draw", "on_paint", on_paint);

-- Fixed R8 [FAKEDUCK]

local cb = gui.Checkbox(gui.Reference("RAGE", "WEAPON", "REVOLVER", "Accuracy"), "rbot_revolver_autocock_ex", "Fixed Auto-Revolver", false)

local cnt = 0
local function on_create_move(cmd)
    local me = entities.GetLocalPlayer()
    if cb:GetValue() and me ~= nil then
        local wep = me:GetPropEntity("m_hActiveWeapon")

        if wep ~= nil and wep:GetWeaponID() == 64 then
            cnt = cnt + 1
            if cnt <= 15 then
                cmd:SetButtons(cmd:GetButtons() | (1 << 0))
            else
                cnt = 0
                
                local m_flPostponeFireReadyTime = wep:GetPropFloat("m_flPostponeFireReadyTime")
                if m_flPostponeFireReadyTime > 0 and m_flPostponeFireReadyTime < globals.CurTime() then
                    cmd:SetButtons(cmd:GetButtons() & ~(1 << 0))
                end
            end
        end
    end
end

callbacks.Register("CreateMove", on_create_move)

-- By LukazEL#5695
