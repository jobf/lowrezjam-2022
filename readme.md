
# Install

```shell
# gl
haxelib git peote-view https://github.com/maitag/peote-view.git

# glyph
haxelib install json2object
haxelib git peote-text https://github.com/maitag/peote-text.git

# physics
haxelib install hxmath
haxelib git echo https://github.com/AustinEast/echo.git

# input (keyboard/game controller)
haxelib git input2action https://github.com/maitag/input2action.git

# tile maps
haxelib git deepnightLibs https://github.com/deepnight/deepnightLibs.git
haxelib git ldtk-haxe-api https://github.com/deepnight/ldtk-haxe-api.git

# tyke (jam branch)
haxelib git tyke https://github.com/jobf/tyke.git feature/lowresjam-2022
```

# Run

```shell
# hashlink
./hl-run

# web debug (useful for debugging if hashlink won't debug)
./web-debug
```

# Editing levels

For quicker level editing feedback, run with compiler flag `-D editinglevels`.

Now whenever you save the level in ldtk you can simply press `r` while in the GetawayScene to restart the level and reload the latest version of the levels.

Example in `hl-edit-debug` script.
