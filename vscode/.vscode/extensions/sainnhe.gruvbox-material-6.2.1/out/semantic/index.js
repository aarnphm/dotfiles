"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const palette_1 = require("../palette");
const default_1 = require("./default");
const colorful_1 = require("./colorful");
function getSemantic(configuration, variant) {
    let palette = palette_1.getPalette(configuration, variant);
    let semantic;
    if (configuration.colorfulSyntax === false) {
        semantic = default_1.getDefaultSemantic(palette);
    }
    else {
        semantic = colorful_1.getColorfulSemantic(palette);
    }
    return semantic;
}
exports.getSemantic = getSemantic;
//# sourceMappingURL=index.js.map