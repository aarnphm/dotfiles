"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const palette_1 = require("../palette");
const flat_1 = require("./flat");
const highContrast_1 = require("./highContrast");
const material_1 = require("./material");
function getWorkbench(configuration, variant) {
    let palette = palette_1.getPalette(configuration, variant);
    if (variant === "dark") {
        switch (configuration.darkWorkbench) {
            case "material":
                return material_1.materialWorkbench(palette, configuration, "dark");
            case "flat":
                return flat_1.flatWorkbench(palette, configuration, "dark");
            case "high-contrast":
                return highContrast_1.highContrastWorkbench(palette, configuration, "dark");
            default:
                return material_1.materialWorkbench(palette, configuration, "dark");
        }
    }
    else {
        switch (configuration.lightWorkbench) {
            case "material":
                return material_1.materialWorkbench(palette, configuration, "light");
            case "flat":
                return flat_1.flatWorkbench(palette, configuration, "light");
            case "high-contrast":
                return highContrast_1.highContrastWorkbench(palette, configuration, "light");
            default:
                return material_1.materialWorkbench(palette, configuration, "light");
        }
    }
}
exports.getWorkbench = getWorkbench;
//# sourceMappingURL=index.js.map