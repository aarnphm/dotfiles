local naughty = require("naughty")

awesome.connect_signal("components::playerctl::title_artist_album",
                       function(title, artist, art_path)
    naughty.notification({title = title, text = artist, image = art_path})
end)
