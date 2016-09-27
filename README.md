# Nettochan!
A Discord bot that provides Japanese word definitions from Jisho

# Adding to a Server
If you would like to just simply add the public version of the bot to your server, authorize it using this link: [here](https://discordapp.com/oauth2/authorize?&client_id=229744143989997568&scope=bot)
I recommend this because it keeps the bot on the most up to date stable release and does not require you to continue to update it.
However, if it gets used too much, I may have to take it down (doubt that'll happen, lol).

# Building
If you would like to build the bot yourself, you can do so by cloning this repo and building it with DUB and DMD.
DMD can be found [here](https://dlang.org/download.html) and DUB can be found [here](https://code.dlang.org/download).
If you are running on Ubuntu (the only version alternate version besides Windows that I have tested), you can use the APT repo [here](http://d-apt.sourceforge.net/) to download and install both of these on the command line.

To build, simply change directory into the cloned repo and run `dub build`.

Finally, you will need a bot profile set up, which can be done [here](https://discordapp.com/developers/applications/me).

The usage of the bot is pretty simple: run `nettochan-bot <BOT TOKEN>` and you should be good to go!
