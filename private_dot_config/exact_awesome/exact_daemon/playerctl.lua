-- Provides:
-- daemon::spotify
--   artist (string)
--   title  (string)
--   status (string)

local awful = require("awful")
local beautiful = require("beautiful")
local interval = beautiful.playerctl_position_update_interval or 1

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

    -- Progress Cmds
    local prog_cmd = "playerctl position"
    local length_cmd = "playerctl metadata mpris:length"

    awful.widget.watch(prog_cmd, interval,
        function(_, intl)
            awful.spawn.easy_async_with_shell(length_cmd, function(length)
                local length_sec = tonumber(length) -- in microseconds
                local interval_sec = tonumber(intl) -- in seconds
                if length_sec and interval_sec then
                    if interval_sec >= 0 and length_sec > 0 then
                        awesome.emit_signal("daemon::playerctl::position",
                            interval_sec, length_sec / 1000000)
                    end
                end
            end
            )
        collectgarbage("collect")
    end)

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
                            awesome.emit_signal(
                                "daemon::playerctl::title_artist_album", title,
                                artist)
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
