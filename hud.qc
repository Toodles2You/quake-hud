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

static const string sb_nums[] =
{
	"gfx/num_0",
	"gfx/num_1",
	"gfx/num_2",
	"gfx/num_3",
	"gfx/num_4",
	"gfx/num_5",
	"gfx/num_6",
	"gfx/num_7",
	"gfx/num_8",
	"gfx/num_9"
};

static const string sb_anums[] =
{
	"gfx/anum_0",
	"gfx/anum_1",
	"gfx/anum_2",
	"gfx/anum_3",
	"gfx/anum_4",
	"gfx/anum_5",
	"gfx/anum_6",
	"gfx/anum_7",
	"gfx/anum_8",
	"gfx/anum_9",
};

static const string sb_items[] =
{
	"key1",
	"key2",
	"invis",
	"invuln",
	"suit",
	"quad",
};

static const string sb_aitems[] =
{
	"key1",
	"key2",
	"invis",
	"invul",
	"suit",
	"quad",
};

static const string sb_sb[] =
{
	"gfx/sb_",
	"gfx/sba1_",
	"gfx/sba2_",
	"gfx/sba3_",
	"gfx/sba4_",
	"gfx/sba5_",
};

static const string sb_runes[] =
{
	"gfx/sb_sigil1",
	"gfx/sb_sigil2",
	"gfx/sb_sigil3",
	"gfx/sb_sigil4",
};

static const string sb_weapons[] =
{
	"shotgun",
	"sshotgun",
	"nailgun",
	"snailgun",
	"rlaunch",
	"srlaunch",
	"lightng",
};

static const string sb_faces[] =
{
	"gfx/face5",
	"gfx/face4",
	"gfx/face3",
	"gfx/face2",
	"gfx/face1",
	"gfx/face_p5",
	"gfx/face_p4",
	"gfx/face_p3",
	"gfx/face_p2",
	"gfx/face_p1",
	"gfx/face_inv2",
	"gfx/face_quad",
	"gfx/face_invis",
	"gfx/face_invul2",
};

static const string sb_inventory[] =
{
	"gfx/inv_",
	"gfx/inv2_",
	"gfx/inva1_",
	"gfx/inva2_",
	"gfx/inva3_",
	"gfx/inva4_",
	"gfx/inva5_",
};

static float stat_items;
static float stat_items2;
static float stat_health;
static float item_gettime[23];
static float faceanimtime;

static void() Sbar_Init =
{
	local float i, j;

	precache_pic ("gfx/sbar", TRUE);
	precache_pic ("gfx/ibar", TRUE);
	precache_pic ("gfx/scorebar", TRUE);

	for (i = 0; i < sb_nums.length; i++)
	{
		precache_pic (sb_nums[i], TRUE);
		precache_pic (sb_anums[i], TRUE);
	}
	precache_pic ("gfx/num_minus", TRUE);
	precache_pic ("gfx/anum_minus", TRUE);
	precache_pic ("gfx/num_colon", TRUE);
	precache_pic ("gfx/num_slash", TRUE);

	precache_pic ("gfx/sb_armor1", TRUE);
	precache_pic ("gfx/sb_armor2", TRUE);
	precache_pic ("gfx/sb_armor3", TRUE);
	precache_pic ("gfx/disc", TRUE);

	precache_pic ("gfx/sb_shells", TRUE);
	precache_pic ("gfx/sb_nails", TRUE);
	precache_pic ("gfx/sb_rocket", TRUE);
	precache_pic ("gfx/sb_cells", TRUE);
	
	for (i = 0; i < sb_items.length; i++)
		precache_pic (strcat (sb_sb[0], sb_items[i]), TRUE);

	for (i = 0; i < sb_aitems.length; i++)
		for (j = 1; j < sb_sb.length; j++)
			precache_pic (strcat (sb_sb[j], sb_aitems[i]), TRUE);

	for (i = 0; i < sb_runes.length; i++)
		precache_pic (sb_runes[i], TRUE);

	for (i = 0; i < sb_weapons.length; i++)
		for (j = 0; j < sb_inventory.length; j++)
			precache_pic (strcat (sb_inventory[j], sb_weapons[i]), TRUE);

	for (i = 0; i < sb_faces.length; i++)
		precache_pic (sb_faces[i], TRUE);

	precache_pic ("gfx/complete.lmp", FALSE);
	precache_pic ("gfx/inter.lmp", FALSE);
};

static void() Sbar_UpdateStats =
{
	local float prev_items, prev_health, f;

	prev_items = stat_items;
	stat_items = getstatf (STAT_ITEMS, 0, 23);
	stat_items2 = getstatf (STAT_ITEMS, 23, 9);

	if (stat_items != prev_items)
		for (f = 0; f < 23; f++)
			if ((stat_items & (1 << f)) && !(prev_items & (1 << f)))
				item_gettime[f] = time;

	prev_health = stat_health;
	stat_health = getstatf (STAT_HEALTH);

	if (prev_health - stat_health > 1)
		faceanimtime = time + 0.2;
};

static void(vector pos, float value, float red) Sbar_Digit =
{
	local string num;
	value = floor (value) % 10;
	if (red)
		num = sb_anums[value];
	else
		num = sb_nums[value];
	drawpic (pos, num, '24 24 0', '1 1 1', 1);
};

static void(vector pos, float value, float right, float threshold) Sbar_Number =
{
	threshold = (value <= threshold);
	if (value >= 100)
	{
		Sbar_Digit (pos, value / 100, threshold);
		pos_x += 24;
	}
	else if (right)
		pos_x += 24;
	if (value >= 10)
	{
		Sbar_Digit (pos, value / 10, threshold);
		pos_x += 24;
	}
	else if (right)
		pos_x += 24;
	Sbar_Digit (pos, value, threshold);
};

static void(vector pos, float value) drawdigit =
{
	drawcharacter (pos, 18 + (floor (value) % 10), '8 8 0', '1 1 1', 1);
};

static void(vector pos, float value, float right) drawnumber =
{
	if (value >= 100)
	{
		drawdigit (pos, value / 100);
		pos_x += 8;
	}
	else if (right)
		pos_x += 8;
	if (value >= 10)
	{
		drawdigit (pos, value / 10);
		pos_x += 8;
	}
	else if (right)
		pos_x += 8;
	drawdigit (pos, value);
};

static void(vector pos, string str) drawcenterstring =
{
	pos_x -= strlen (str) * 4;
	drawrawstring (pos, str, '8 8 0', '1 1 1', 1);
};

static void(vector pos) Sbar_Scoreboard =
{
	local float dividend, total, secs, mins;
	local string s;

	drawpic (pos, "gfx/scorebar", '320 24 0', '1 1 1', 1);

	dividend = getstatf (STAT_KILLEDMONSTERS);
	total = getstatf (STAT_TOTALMONSTERS);
	s = sprintf ("Monsters:%3.0f/%3.0f", dividend, total);
	drawrawstring (pos + '8 4 0', s, '8 8 0', '1 1 1', 1);

	dividend = getstatf (STAT_FOUNDSECRETS);
	total = getstatf (STAT_TOTALSECRETS);
	s = sprintf ("Secrets :%3.0f/%3.0f", dividend, total);
	drawrawstring (pos + '8 12 0', s, '8 8 0', '1 1 1', 1);

	mins = floor (time / 60);
	secs = floor (time - mins * 60);
	s = sprintf ("Time :%3.0f:%02.0f", mins, secs);
	drawrawstring (pos + '184 4 0', s, '8 8 0', '1 1 1', 1);

	drawcenterstring (pos + '232 12 0', world.message);
};

static void(float num, vector pos, float fat) Sbar_Weapon =
{
	local string prefix;
	local float flash, active;
	local vector size;

	flash = (time - item_gettime[num]) * 10;
	if (flash >= 10)
	{
		active = getstatf (STAT_ACTIVEWEAPON) == (IT_SHOTGUN << num);
		prefix = sb_inventory[active];
	}
	else
		prefix = sb_inventory[2 + (flash % 5)];

	size = '24 16 0';
	if (fat)
		size_x *= 2;

	drawpic (pos, strcat (prefix, sb_weapons[num]), size, '1 1 1', 1);
};

static void(float num, vector pos) Sbar_Item =
{
	local string s;
	local float flash;

	flash = (time - item_gettime[17 + num]) * 10;
	if (flash >= 10)
		s = strcat (sb_sb[0], sb_items[num]);
	else
		s = strcat (sb_sb[1 + (flash % 5)], sb_aitems[num]);

	drawpic (pos, s, '16 16 0', '1 1 1', 1);
};

static void(vector pos) Sbar_Inventory =
{
	local float i;
	local vector pos2;

	drawpic (pos, "gfx/ibar", '320 24 0', '1 1 1', 1);

	pos2 = pos + '0 8 0';
	for (i = 0; i < sb_weapons.length; i++, pos2_x += 24)
		if (stat_items & (IT_SHOTGUN << i))
			Sbar_Weapon (i, pos2, (IT_SHOTGUN << i) == IT_LIGHTNING);

	pos2 = pos + '10 0 0';
	for (i = STAT_SHELLS; i <= STAT_CELLS; i++, pos2_x += 48)
		drawnumber (pos2, getstatf (i), TRUE);

	pos2 = pos + '192 8 0';
	for (i = 0; i < sb_items.length; i++, pos2_x += 16)
		if (stat_items & (IT_KEY1 << i))
			Sbar_Item (i, pos2);

	pos2 = pos + '288 8 0';
	for (i = 0; i < sb_runes.length; i++, pos2_x += 8)
		if (stat_items2 & (IT2_RUNE1 << i))
			drawpic (pos2, sb_runes[i], '8 16 0', '1 1 1', 1);
};

static void(vector pos) Sbar_Face =
{
	local string face;
	local float frame;

	if (stat_items & IT_INVISIBILITY)
	{
		if (stat_items & IT_INVULNERABILITY)
			face = "gfx/face_inv2";
		else
			face = "gfx/face_invis";
	}
	else if (stat_items & IT_QUAD)
		face = "gfx/face_quad";
	else if (stat_items & IT_INVULNERABILITY)
		face = "gfx/face_invul2";
	else
	{
		frame = stat_health / 20;
		if (frame < 0)
			frame = 0;
		else if (frame > 4)
			frame = 4;
		if (faceanimtime > time)
			frame += 5;
		face = sb_faces[frame];
	}

	drawpic (pos, face, '24 24 0', '1 1 1', 1);
};

static void(vector pos) Sbar_Status =
{
	local float value, threshold;
	local string icon;

	drawpic (pos, "gfx/sbar", '320 24 0', '1 1 1', 1);

	icon = "";

	if (stat_items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3 | IT_INVULNERABILITY))
	{
		if (stat_items & IT_INVULNERABILITY)
		{
			value = 666;
			icon = "gfx/disc";
		}
		else
		{
			value = getstatf (STAT_ARMOR);
			if (stat_items & IT_ARMOR3)
				icon = "gfx/sb_armor3";
			else if (stat_items & IT_ARMOR2)
				icon = "gfx/sb_armor2";
			else if (stat_items & IT_ARMOR1)
				icon = "gfx/sb_armor1";
		}
		Sbar_Number (pos + '24 0 0', value, TRUE, -1);
		drawpic (pos, icon, '24 24 0', '1 1 1', 1);
	}

	Sbar_Face (pos + '112 0 0');
	Sbar_Number (pos + '136 0 0', stat_health, TRUE, 25);

	if (stat_items & (IT_SHELLS | IT_NAILS | IT_ROCKETS | IT_CELLS))
	{
		value = getstatf (STAT_AMMO);
		if (stat_items & IT_SHELLS)
			icon = "gfx/sb_shells";
		else if (stat_items & IT_NAILS)
			icon = "gfx/sb_nails";
		else if (stat_items & IT_ROCKETS)
			icon = "gfx/sb_rocket";
		else if (stat_items & IT_CELLS)
			icon = "gfx/sb_cells";
		if (stat_items & IT_NAILS)
			threshold = 30;
		else if (stat_items & IT_CELLS)
			threshold = 20;
		else
			threshold = 10;
		Sbar_Number (pos + '248 0 0', value, TRUE, threshold);
		drawpic (pos + '224 0 0', icon, '24 24 0', '1 1 1', 1);
	}
};

static void(vector virtsize, float showscores) Sbar_Draw =
{
	local vector pos;
	local float viewsize;

	pos_x = (virtsize_x - 320) * 0.5;
	pos_y = virtsize_y;
	pos_z = 0;

	Sbar_UpdateStats ();

	viewsize = cvar ("viewsize");

	if (viewsize < 110)
		Sbar_Inventory (pos - '0 48 0');

	if (showscores || stat_health <= 0)
		Sbar_Scoreboard (pos - '0 24 0');
	else if (viewsize < 120)
		Sbar_Status (pos - '0 24 0');
};

static void(vector virtsize, float showscores) Sbar_IntermissionOverlay =
{
	local vector pos;
	local float secs;

	pos_x = (virtsize_x - 320) * 0.5;
	pos_y = (virtsize_y - 200) * 0.5;
	pos_z = 0;

	drawpic (pos + '64 24 0', "gfx/complete.lmp", '192 24 0', '1 1 1', 1);
	drawpic (pos + '24 56 0', "gfx/inter.lmp", '160 144 0', '1 1 1', 1);

	Sbar_Number (pos + '160 64 0', intermission_time / 60, TRUE, -1);
	drawpic (pos + '232 64 0', "gfx/num_colon", '16 24 0', '1 1 1', 1);
	secs = intermission_time % 60;
	Sbar_Digit (pos + '248 64 0', secs / 10, FALSE);
	Sbar_Digit (pos + '272 64 0', secs % 10, FALSE);

	Sbar_Number (pos + '160 104 0', getstatf (STAT_FOUNDSECRETS), TRUE, -1);
	drawpic (pos + '232 104 0', "gfx/num_slash", '16 24 0', '1 1 1', 1);
	Sbar_Number (pos + '248 104 0', getstatf (STAT_TOTALSECRETS), FALSE, -1);

	Sbar_Number (pos + '160 144 0', getstatf (STAT_KILLEDMONSTERS), TRUE, -1);
	drawpic (pos + '232 144 0', "gfx/num_slash", '16 24 0', '1 1 1', 1);
	Sbar_Number (pos + '248 144 0', getstatf (STAT_TOTALMONSTERS), FALSE, -1);
};

void(float apilevel, string enginename, float engineversion) CSQC_Init =
{
	Sbar_Init ();
};

void(vector virtsize, float showscores) CSQC_DrawHud =
{
	Sbar_Draw (virtsize, showscores);
};

void(vector virtsize, float showscores) CSQC_DrawScores =
{
	if (intermission)
		Sbar_IntermissionOverlay (virtsize, showscores);
};

float(string cmdstr) CSQC_ConsoleCommand =
{
	return FALSE;
};

float(float evtype, float scanx, float chary, float devid) CSQC_InputEvent =
{
	return FALSE;
}
