# Nettochan!
A Discord bot that provides Japanese word definitions from Jisho

# Adding to a Server
If you would like to just simply add the public version of the bot to your server, authorize it using this link: [here](https://discordapp.com/oauth2/authorize?&client_id=229744143989997568&scope=bot)
I recommend this because it keeps the bot on the most up to date stable release and does not require you to continue to update it.
However, if it gets used too much, I may have to take it down (doubt that'll happen, lol).

# Building
If you would like to build the bot yourself, you can do so by cloning this repo and building it with DUB and DMD.
DMD can be found [here](https://dlang.org/download.html) and DUB can be found [here](https://code.dlang.org/download).
If you are running on Ubuntu (the only alternate version besides Windows that I have tested), you can use the APT repo [here](http://d-apt.sourceforge.net/) to download and install both of these on the command line.

You will need a couple libraries installed on Ubuntu to properly build the application:
`sudo apt-get install libssl-dev`
`sudo apt-get install libevent-dev`
`sudo add-apt-repository ppa:chris-lea/libsodium`
`sudo apt-get update`
`sudo apt-get install libsodium-dev`


To build, simply change directory into the cloned repo and run `dub build`.
Note: You may need more than 512MB of ram to build the application. However, you do not need more than 512MB to run Netto-chan. In order to build, create a temporary swap of about 4GB just so you insure you will have enough memory to build.

Finally, you will need a bot profile set up, which can be done [here](https://discordapp.com/developers/applications/me).

The usage of the bot is pretty simple: run `nettochan-bot <BOT TOKEN>` and you should be good to go!
