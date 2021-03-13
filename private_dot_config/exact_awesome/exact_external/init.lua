local external_path =(...):gsub('%.init$', '')

return {
    lain = require(external_path..".lain"),
    freedesktop = require(external_path..".freedesktop"),
}
