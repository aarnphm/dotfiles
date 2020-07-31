/*---------------------------------------------------------
 * Copyright 2020 The Go Authors. All rights reserved.
 * Licensed under the MIT License. See LICENSE in the project root for license information.
 *--------------------------------------------------------*/
'use strict';
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.formatGoVersion = exports.getActiveGoRoot = exports.getGoEnvironmentStatusbarItem = exports.chooseGoEnvironment = exports.hideGoStatusBar = exports.showGoStatusBar = exports.disposeGoStatusBar = exports.initGoStatusBar = void 0;
const vscode = require("vscode");
const goInstallTools_1 = require("./goInstallTools");
const goPath_1 = require("./goPath");
const util_1 = require("./util");
// statusbar item for switching the Go environment
let goEnvStatusbarItem;
/**
 * Initialize the status bar item with current Go binary
 */
function initGoStatusBar() {
    return __awaiter(this, void 0, void 0, function* () {
        if (!goEnvStatusbarItem) {
            goEnvStatusbarItem = vscode.window.createStatusBarItem(vscode.StatusBarAlignment.Left, 50);
        }
        // set Go version and command
        const version = yield util_1.getGoVersion();
        hideGoStatusBar();
        goEnvStatusbarItem.text = formatGoVersion(version.format());
        goEnvStatusbarItem.command = 'go.environment.choose';
        showGoStatusBar();
    });
}
exports.initGoStatusBar = initGoStatusBar;
/**
 * disable the Go environment status bar item
 */
function disposeGoStatusBar() {
    if (!!goEnvStatusbarItem) {
        goEnvStatusbarItem.dispose();
    }
}
exports.disposeGoStatusBar = disposeGoStatusBar;
/**
 * Show the Go Environment statusbar item on the statusbar
 */
function showGoStatusBar() {
    if (!!goEnvStatusbarItem) {
        goEnvStatusbarItem.show();
    }
}
exports.showGoStatusBar = showGoStatusBar;
/**
 * Hide the Go Environment statusbar item from the statusbar
 */
function hideGoStatusBar() {
    if (!!goEnvStatusbarItem) {
        goEnvStatusbarItem.hide();
    }
}
exports.hideGoStatusBar = hideGoStatusBar;
/**
 * Present a command palette menu to the user to select their go binary
 * TODO: remove temporary alert and implement correct functionality
 */
function chooseGoEnvironment() {
    vscode.window.showInformationMessage(`Current GOROOT: ${goPath_1.getCurrentGoRoot()}`);
}
exports.chooseGoEnvironment = chooseGoEnvironment;
/**
 * return reference to the statusbar item
 */
function getGoEnvironmentStatusbarItem() {
    return goEnvStatusbarItem;
}
exports.getGoEnvironmentStatusbarItem = getGoEnvironmentStatusbarItem;
function getActiveGoRoot() {
    return __awaiter(this, void 0, void 0, function* () {
        // look for current current go binary
        let goroot = goPath_1.getCurrentGoRoot();
        if (!goroot) {
            yield goInstallTools_1.updateGoVarsFromConfig();
            goroot = goPath_1.getCurrentGoRoot();
        }
        return goroot || undefined;
    });
}
exports.getActiveGoRoot = getActiveGoRoot;
function formatGoVersion(version) {
    const versionWords = version.split(' ');
    if (versionWords[0] === 'devel') {
        // Go devel +hash
        return `Go ${versionWords[0]} ${versionWords[4]}`;
    }
    else if (versionWords.length > 0) {
        // some other version format
        return `Go ${version.substr(0, 8)}`;
    }
    else {
        // default semantic version format
        return `Go ${versionWords[0]}`;
    }
}
exports.formatGoVersion = formatGoVersion;
//# sourceMappingURL=goEnvironmentStatus.js.map