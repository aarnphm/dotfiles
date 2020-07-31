"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const palette_1 = require("../palette");
const default_1 = require("./default");
const italic_1 = require("./italic");
const colorful_1 = require("./colorful");
const colorfulItalic_1 = require("./colorfulItalic");
function getSyntax(configuration, variant) {
    let palette = palette_1.getPalette(configuration, variant);
    let syntax;
    if (configuration.colorfulSyntax === false) {
        if (configuration.italicKeywords === true) {
            syntax = italic_1.getItalicSyntax(palette, configuration.italicComments);
        }
        else {
            syntax = default_1.getDefaultSyntax(palette, configuration.italicComments);
        }
    }
    else {
        if (configuration.italicKeywords === true) {
            syntax = colorfulItalic_1.getColorfulItalicSyntax(palette, configuration.italicComments);
        }
        else {
            syntax = colorful_1.getColorfulSyntax(palette, configuration.italicComments);
        }
    }
    return syntax;
}
exports.getSyntax = getSyntax;
//# sourceMappingURL=index.js.map