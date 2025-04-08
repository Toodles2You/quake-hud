/*  Copyright (C) 1996-2022 id Software LLC

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    See file, 'COPYING', for details.
*/

#pragma noref 1

#define CSQC
#define CSQC_SIMPLE

/*
==============================================================================

SOURCE FOR GLOBALVARS_T C STRUCTURE

==============================================================================
*/

// system globals
entity self;
entity other;
entity world;
float time;
float frametime;

float force_retouch; // force all entities to touch triggers next frame

string mapname;

float deathmatch;
float coop;
float teamplay;

// propagated from level to level, used to keep track of completed episodes
float serverflags;

float total_secrets;
float total_monsters;

float found_secrets;
float killed_monsters;

// parms are used to encode information about clients across level changes
float parm1, parm2, parm3, parm4, parm5, parm6, parm7, parm8, parm9, parm10;
float parm11, parm12, parm13, parm14, parm15, parm16;

// global variables set by built in functions

// makevectors
vector v_forward, v_up, v_right;

// traceline
float trace_allsolid;
float trace_startsolid;
float trace_fraction;
vector trace_endpos;
vector trace_plane_normal;
float trace_plane_dist;
entity trace_ent;
float trace_inopen;
float trace_inwater;

entity msg_entity; // destination of single entity writes

// required prog functions

void() main; // only for testing

void() StartFrame;

void() PlayerPreThink;
void() PlayerPostThink;

void() ClientKill;
void() ClientConnect;
void() PutClientInServer;
void() ClientDisconnect;

// called when a client first connects to a server.
// sets parms so they can be saved off for restarts
void() SetNewParms;

// call to set parms for self so they can be saved for a level transition
void() SetChangeParms;

void end_sys_globals; // flag for structure dumping

/*
==============================================================================

SOURCE FOR ENTVARS_T C STRUCTURE

==============================================================================
*/

// system fields

.float modelindex;
.vector absmin, absmax;

.float ltime; // local time for entity
.float movetype;
.float solid;

.vector origin;
.vector oldorigin;
.vector velocity;
.vector angles;
.vector avelocity;

.vector punchangle; // temp angle adjust from damage or recoil

.string classname;
.string model;
.float frame;
.float skin;
.float effects;

.vector mins, maxs;
.vector size;

.void() touch;
.void() use;
.void() think;
.void() blocked; // for doors or plats, called when can't push other

.float nextthink;
.entity groundentity;

// stats
.float health;
.float frags;
.float weapon;
.string weaponmodel;
.float weaponframe;
.float currentammo;
.float ammo_shells, ammo_nails, ammo_rockets, ammo_cells;

.float items;

.float takedamage;
.entity chain;
.float deadflag;

.vector view_ofs;

.float button0; // fire
.float button1; // use
.float button2; // jump

.float impulse; // weapon changes

.float fixangle;
.vector v_angle; // view / targeting angle for players
.float idealpitch; // calculated pitch angle for lookup up slopes

.string netname;

.entity enemy;

.float flags;

.float colormap;
.float team;

.float max_health;

.float teleport_time; // don't back up

.float armortype; // save this fraction of incoming damage
.float armorvalue;

.float waterlevel; // 0 = not in, 1 = feet, 2 = wast, 3 = eyes
.float watertype; // a contents value

.float ideal_yaw;
.float yaw_speed;

.entity aiment;

.entity goalentity; // a movetarget or an enemy

.float spawnflags;

.string target;
.string targetname;

// damage is accumulated through a frame. and sent as one single message,
// so the super shotgun doesn't generate huge messages
.float dmg_take;
.float dmg_save;
.entity dmg_inflictor;

.entity owner;
.vector movedir; // mostly for doors, but also used for waterjump

.string message;

.float sounds;

.string noise, noise1, noise2, noise3;

void end_sys_fields; // flag for structure dumping

/*
==============================================================================

VARS NOT REFERENCED BY C CODE

==============================================================================
*/

// constants

float FALSE = 0;
float TRUE = 1;

float IT_AXE = 4096;
float IT_SHOTGUN = 1;
float IT_SUPER_SHOTGUN = 2;
float IT_NAILGUN = 4;
float IT_SUPER_NAILGUN = 8;
float IT_GRENADE_LAUNCHER = 16;
float IT_ROCKET_LAUNCHER = 32;
float IT_LIGHTNING = 64;
float IT_EXTRA_WEAPON = 128;

float IT_SHELLS = 256;
float IT_NAILS = 512;
float IT_ROCKETS = 1024;
float IT_CELLS = 2048;

float IT_ARMOR1 = 8192;
float IT_ARMOR2 = 16384;
float IT_ARMOR3 = 32768;
float IT_SUPERHEALTH = 65536;

float IT_KEY1 = 131072;
float IT_KEY2 = 262144;

float IT_INVISIBILITY = 524288;
float IT_INVULNERABILITY = 1048576;
float IT_SUIT = 2097152;
float IT_QUAD = 4194304;

float IT2_RUNE1 = 32;
float IT2_RUNE2 = 64;
float IT2_RUNE3 = 128;
float IT2_RUNE4 = 256;

float STAT_HEALTH = 0;
float STAT_AMMO = 3;
float STAT_ARMOR = 4;
float STAT_SHELLS = 6;
float STAT_NAILS = 7;
float STAT_ROCKETS = 8;
float STAT_CELLS = 9;
float STAT_ACTIVEWEAPON = 10;
float STAT_TOTALSECRETS = 11;
float STAT_TOTALMONSTERS = 12;
float STAT_FOUNDSECRETS = 13;
float STAT_KILLEDMONSTERS = 14;
float STAT_ITEMS = 15;

// globals

float intermission_time;
float intermission;
float player_localentnum;

// builtin functions

void() break = #6;
void(string e) error = #10;

void() traceon = #29; // turns statment trace on
void() traceoff = #30;
float(float v) rint = #36;
float(float v) floor = #37;
float(float v) ceil = #38;
float(float f) fabs = #43;
float(string s) cvar = #45;

float(string extname) checkextension = #99;

float(string s) strlen = #114;
string(string s1, optional string s2, optional string s3, optional string s4, optional string s5, optional string s6, optional string s7, optional string s8) strcat = #115;

float(float number, float quantity) bitshift = #218;

string(string name, optional float flags) precache_pic = #317;
float(vector position, float character, vector size, vector rgb, float alpha, optional float drawflag) drawcharacter = #320;
float(vector position, string pic, vector size, vector rgb, float alpha, optional float drawflag) drawpic = #322;
float(vector position, string text, vector size, vector rgb, float alpha, optional float drawflag) drawstring = #326;
float(vector position, string text, vector size, vector rgb, float alpha, optional float drawflag) drawrawstring = #321;

float(float stnum, optional float firstbit, optional float bitcount) getstatf = #331;

void(string cmdname, optional string desc) registercommand = #352;

string(float n) argv = #442;

float(string str) tokenize_console = #514;

string(string fmt, ...) sprintf = #627;

#pragma noref 0
