"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const darkHard_1 = require("./material/darkHard");
const darkMedium_1 = require("./material/darkMedium");
const darkSoft_1 = require("./material/darkSoft");
const lightHard_1 = require("./material/lightHard");
const lightMedium_1 = require("./material/lightMedium");
const lightSoft_1 = require("./material/lightSoft");
const darkHard_2 = require("./mix/darkHard");
const darkMedium_2 = require("./mix/darkMedium");
const darkSoft_2 = require("./mix/darkSoft");
const lightHard_2 = require("./mix/lightHard");
const lightMedium_2 = require("./mix/lightMedium");
const lightSoft_2 = require("./mix/lightSoft");
const darkHard_3 = require("./original/darkHard");
const darkMedium_3 = require("./original/darkMedium");
const darkSoft_3 = require("./original/darkSoft");
const lightHard_3 = require("./original/lightHard");
const lightMedium_3 = require("./original/lightMedium");
const lightSoft_3 = require("./original/lightSoft");
function getPalette(configuration, variant) {
    let palette;
    if (variant === "dark") {
        if (configuration.darkPalette === "material") {
            switch (configuration.darkContrast) {
                case "hard": {
                    palette = darkHard_1.default;
                    break;
                }
                case "medium": {
                    palette = darkMedium_1.default;
                    break;
                }
                case "soft": {
                    palette = darkSoft_1.default;
                    break;
                }
                default: {
                    palette = darkMedium_1.default;
                }
            }
        }
        else if (configuration.darkPalette === "original") {
            switch (configuration.darkContrast) {
                case "hard": {
                    palette = darkHard_3.default;
                    break;
                }
                case "medium": {
                    palette = darkMedium_3.default;
                    break;
                }
                case "soft": {
                    palette = darkSoft_3.default;
                    break;
                }
                default: {
                    palette = darkMedium_3.default;
                }
            }
        }
        else if (configuration.darkPalette === "mix") {
            switch (configuration.darkContrast) {
                case "hard": {
                    palette = darkHard_2.default;
                    break;
                }
                case "medium": {
                    palette = darkMedium_2.default;
                    break;
                }
                case "soft": {
                    palette = darkSoft_2.default;
                    break;
                }
                default: {
                    palette = darkMedium_2.default;
                }
            }
        }
    }
    else {
        if (configuration.lightPalette === "material") {
            switch (configuration.lightContrast) {
                case "hard": {
                    palette = lightHard_1.default;
                    break;
                }
                case "medium": {
                    palette = lightMedium_1.default;
                    break;
                }
                case "soft": {
                    palette = lightSoft_1.default;
                    break;
                }
                default: {
                    palette = lightMedium_1.default;
                }
            }
        }
        else if (configuration.lightPalette === "original") {
            switch (configuration.lightContrast) {
                case "hard": {
                    palette = lightHard_3.default;
                    break;
                }
                case "medium": {
                    palette = lightMedium_3.default;
                    break;
                }
                case "soft": {
                    palette = lightSoft_3.default;
                    break;
                }
                default: {
                    palette = lightMedium_3.default;
                }
            }
        }
        else if (configuration.lightPalette === "mix") {
            switch (configuration.lightContrast) {
                case "hard": {
                    palette = lightHard_2.default;
                    break;
                }
                case "medium": {
                    palette = lightMedium_2.default;
                    break;
                }
                case "soft": {
                    palette = lightSoft_2.default;
                    break;
                }
                default: {
                    palette = lightMedium_2.default;
                }
            }
        }
    }
    return palette;
}
exports.getPalette = getPalette;
//# sourceMappingURL=index.js.map