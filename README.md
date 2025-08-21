# CGOML
 A pretty terrible Generals Online compatible mod loader. Its basically meant to be a very shitty replacement for GenLauncher until Generals Online actually supports Genlauncher.
You can download Generals Online from the [official website](https://www.playgenerals.online/). If i'm being honest, don't use this, it's extremely bad. It was intended solely for my friends.

 
# HOW TO USE

# Compiling
To compile you must first install AutoHotkey V2, which you can download from [here](https://www.autohotkey.com/v2/). Then, right click on the .ahk files to either compile with GUI or just compile.

# Setting Up

You can download either the source code and compile which I have already explained or just download the releases. Once done, extract the files into your fresh generals installation that also has Generals Online installed.

Before use, the mods to be used by the launcher require light setup. First you must go into the `CGOML Files` folder and find the `INI` folder. Inside should be `mods.ini`. To add a mod, you can use the example mod listings inside.

The header text should be replaced with the mod folder name and then the string should be changed as the actual mod name.

After doing that, make sure to make a folder in the `Mod Files` and name it the same as you did the heading in the `mods.ini` file. After doing that, you should stick the mod files inside that folder you created. IMPORTANT: You must have the `.big` files have their extentions renamed to `.gib` as it is need to avoid generals from loading the files when you dont want them to. A more convienient option is to just copy the mod files from GenLaunchers `GLM` folder.

# Using

After doing the previous setting up, you can now run the mod loader and it will list the mods you have defined in `mods.ini`. After playing a mod, it will show that option as green to symbolise the mod still being loaded. When choosing a different mod, the previous mods files will be removed and the new ones will be installed.
