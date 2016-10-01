import
    std.json,
    std.conv,
    std.array,
    std.stdio,
    std.algorithm,
    std.string,
    std.format,
    std.process,
    core.time;

import
    dscord.core,
    dscord.util.process,
    dscord.bot;

import
    vibe.vibe;

static import
    std.experimental.logger;

class NettoPlugin : Plugin {
    this() {
        super();
    }

    @Command("def")
    void onDefCommand(CommandEvent event) {
        int choke = -1;

        if(event.args.length < 1) {
            event.msg.reply("```md\n# USAGE: ~!def [word] ([entry #])\n```");
            return;
        }

        if(event.args.length == 2 && event.args[1] != null && isNumeric(event.args[1])) choke = to!int(strip(event.args[1])) - 1;

        string response = lookupWord(event.args[0], choke);

        event.msg.reply("```md\n" ~ response ~ "\n```");
    }

    string joinJSONStringArr(JSONValue[] arr, string connector) {
        string result = "";

        for(int v = 0; v < arr.length; v++) {
            if(arr[v].str == "Wikipedia definition") arr[v].str = "Wikipedia";

            (v == arr.length - 1) ? result ~= arr[v].str : result ~= arr[v].str ~ connector;
        }

        return result;
    }

    string lookupWord(string search, int choke) {
        JSONValue j;
        string response = "";

        requestHTTP("http://jisho.org/api/v1/search/words?keyword=" ~ search,
            (scope req) {

            },
            (scope res) {
                response = res.bodyReader.readAllUTF8();
                j = parseJSON(response);
            }
        );

        JSONValue data = j["data"];

        string result;

        if(data.array.length < 1) {
            result = "# ERROR! Could not find definition for '" ~ search ~ "'";
            return result;
        }

        if(choke == data.array.length) {
            result = "# ERROR! Out of bounds!";
            return result;
        }

        if(choke < 0) result = "# " ~ to!string(data.array.length) ~ " results in Jisho search for '" ~ search ~ "':\n";
        else result = "# Result #" ~ to!string(choke + 1) ~ " in Jisho search for '" ~ search ~ "':\n";

        for(int v = ((choke > 0) ? choke : 0); v < ((choke > 0) ? choke + 1 : data.array.length); v++) {
            result ~= "[" ~ to!string(v + 1) ~ ".] ";
            string[] words;
            for(int vj = 0; vj < data[v]["japanese"].array.length; vj++) {
                string word = "";
                string reading = "";
                bool common;

                if("is_common" in data[v] && data[v]["is_common"].type == JSON_TYPE.TRUE) common = true;

                if("reading" in data[v]["japanese"][vj]) reading = data[v]["japanese"][vj]["reading"].str;

                if("word" in data[v]["japanese"][vj]) word = data[v]["japanese"][vj]["word"].str;

                if(reading != "" && word != "") {
                    words ~= "<" ~ word ~ " (" ~ reading ~ ")" ~ (common ? " [common]" : "") ~ ">";
                }else if(word != "") {
                    words ~= "<" ~ word ~ (common ? " [common]" : "") ~ ">";
                }else if(reading != "") {
                    words ~= "<" ~ reading ~ (common ? " [common]" : "") ~ ">";
                }else {
                    result = "# ERROR! Could not lookup reading or definition for '" ~ search ~ "'";
                    return result;
                }
            }

            result ~= words.join(", ") ~ "\n";

            for(int vs = 0; vs < data[v]["senses"].array.length; vs++) {
                string types = joinJSONStringArr(data[v]["senses"][vs]["parts_of_speech"].array, ", ");
                string definitions = joinJSONStringArr(data[v]["senses"][vs]["english_definitions"].array, ", ");

                if(types == "") result ~= ">>[" ~ to!string(vs + 1) ~ ".]() " ~ definitions ~ "\n";
                else result ~= ">>[" ~ to!string(vs + 1) ~ ".](" ~ types ~ ") " ~ definitions ~ "\n";
            }

            if(result.length >= 1500) {
                result ~= "\n# This entry was cut short\n# Use '~!def " ~ search ~ " [1-" ~ to!string(data.array.length) ~ "]' for a specific entry";
                break;
            }
        }

        return result;
    }
}

void main(string[] args) {
  if (args.length <= 1) {
    writefln("Usage: %s <token>", args[0]);
    return;
  }

  BotConfig config;
  config.token = args[1];
  config.cmdPrefix = "~!";
  config.cmdRequireMention = false;
  Bot bot = new Bot(config, std.experimental.logger.LogLevel.trace);
  bot.loadPlugin(new NettoPlugin);
  bot.run();
  runEventLoop();
  return;
}