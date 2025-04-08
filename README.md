# Quake CSQC HUD

This repository contains a QuakeC implementation of the Quake singleplayer HUD. 
This includes the status bar and the intermission screen. It's mostly accurate 
to the original, with some minor improvements.  

This code is based on that included in 
[Spike's QC DevKit](https://triptohell.info/moodles/qss/).  

## Building and running

You'll need [FTEQCC](https://www.fteqcc.org/) to compile this, and an engine 
capable of running CSQC. Be sure to explicitly point FTEQCC to the src file 
by passing `-srcfile csprogs.src`.  

## Integrating into your mod

Start by copying `hud.qc`, `view.qc` and `csprogs.src` into your mod `src` 
folder.  

If you're using FTEQW or a QSS fork, run your mod, and enter the command 
`pr_dumpplatform -Ocsdefs -Tcs`. This overwrites `csdefs.qc` with a new file 
that includes all of the engine's available CSQC extensions.  

Note that QSS forks don't dump the following required globals, so add them at 
the bottom of the file:  

```
float intermission_time;
float intermission;
```

You'll also need to move all of your item flags from `defs.qc` to their own QC 
file, so they can be accessed by both the game and HUD. I recommend naming it 
something like `constant.qc`.  

Add the following flags to it, as well:  

```
float IT2_RUNE1 = 32;
float IT2_RUNE2 = 64;
float IT2_RUNE3 = 128;
float IT2_RUNE4 = 256;
```

Finally, add the name of this new QC file to `progs.src` and `csprogs.src` 
after the defs files.  

## License

This code is released under the GPLv2 license. See `COPYING.txt` for more 
details.  
