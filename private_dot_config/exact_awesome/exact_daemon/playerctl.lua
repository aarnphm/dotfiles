-- Provides:
-- daemon::spotify
--   artist (string)
--   title  (string)
--   status (string)

local awful = require("awful")

local function emit_player_status()
    local status_cmd = "playerctl status -F"

    -- Follow status
    awful.spawn.easy_async_with_shell({"pkill", "--full", "--uid", os.getenv("USER"), "^playerctl status"},
        function()
            awful.spawn.with_line_callback(status_cmd, {
                    stdout = function(line)
                        local playing = false
                        if line:find("Playing") then
                            playing = true
                        else
                            playing = false
                        end
                        awesome.emit_signal("daemon::playerctl::status", playing)
                    end
                })
            collectgarbage("collect")
        end
        )
end

local function emit_player_info()

    -- Command that lists artist and title in a format to find and follow
    local song_follow_cmd =
    "playerctl metadata --format 'artist_{{artist}}title_{{title}}' -F"

    -- Follow title
    awful.spawn.easy_async({"pkill", "--full", "--uid", os.getenv("USER"), "^playerctl metadata"},
        function()
            awful.spawn.with_line_callback(song_follow_cmd, {
                    stdout = function(line)
                        -- Get title and artist
                        local artist = line:match('artist_(.*)title_')
                        local title = line:match('title_(.*)')
                        -- If the title is nil or empty then the players stopped
                        if title and title ~= "" then
                            awesome.emit_signal("daemon::playerctl::title_artist_album", title, artist)
                        else
                            awesome.emit_signal("daemon::playerctl::player_stopped")
                        end
                        collectgarbage("collect")
                    end
                })
            collectgarbage("collect")
        end
        )
end

emit_player_status()
emit_player_info()
