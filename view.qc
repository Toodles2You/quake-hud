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

// everything beyond this point is FTE and DP compatibility stuff
// if you're using a QSS fork, don't worry about it

#ifdef CSQC_SIMPLE

void() clearscene = #300;
void(float mask) addentities = #301;
float(float property, ...) setproperty = #303;
void() renderscene = #304;

const float MASK_ENGINE = 1;
const float MASK_VIEWMODEL = 2;

const float VF_MIN = 1;
const float VF_SIZE = 4;
const float VF_DRAWENGINESBAR = 20;
const float VF_DRAWCROSSHAIR = 21;

#endif /* CSQC_SIMPLE */

static float ancient_api;
static float showscores;

void(float vwidth, float vheight, float notmenu) CSQC_UpdateView =
{
	local vector virtsize;

	virtsize_x = vwidth;
	virtsize_y = vheight;
	virtsize_z = 0;

	clearscene ();
	addentities (MASK_ENGINE | MASK_VIEWMODEL);
	setproperty (VF_MIN, '0 0 0');
	setproperty (VF_SIZE, virtsize);
	setproperty (VF_DRAWENGINESBAR, FALSE);
	setproperty (VF_DRAWCROSSHAIR, TRUE);
	renderscene ();

	if (ancient_api)
	{
#pragma warning disable F333
		virtsize_x = cvar ("vid_conwidth");
		virtsize_y = cvar ("vid_conheight");
#pragma warning enable F333
	}

	if (!intermission)
	{
		intermission_time = time;
		CSQC_DrawHud (virtsize, showscores);
	}
	CSQC_DrawScores (virtsize, showscores);
};

__wrap float(string cmdstr) CSQC_ConsoleCommand =
{
	local string cmd;

	if (prior (cmdstr))
		return TRUE;

	tokenize_console (cmdstr);
	cmd = argv (0);

	if (cmd == "+showscores")
		showscores = TRUE;
	else if (cmd == "-showscores")
		showscores = FALSE;
	else
		return FALSE;

	return TRUE;
};

__wrap void(float apilevel, string enginename, float engineversion) CSQC_Init =
{
	ancient_api = (!apilevel && !enginename && !engineversion);

	prior (apilevel, enginename, engineversion);

	registercommand ("+showscores");
	registercommand ("-showscores");
};
