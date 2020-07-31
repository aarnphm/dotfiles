/*---------------------------------------------------------
 * Copyright (C) Microsoft Corporation. All rights reserved.
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
exports.offerToInstallTools = exports.updateGoVarsFromConfig = exports.promptForUpdatingTool = exports.promptForMissingTool = exports.installTool = exports.installTools = exports.installAllTools = void 0;
const cp = require("child_process");
const fs = require("fs");
const path = require("path");
const util = require("util");
const vscode = require("vscode");
const goEnv_1 = require("./goEnv");
const goEnvironmentStatus_1 = require("./goEnvironmentStatus");
const goLanguageServer_1 = require("./goLanguageServer");
const goMain_1 = require("./goMain");
const goPath_1 = require("./goPath");
const goStatus_1 = require("./goStatus");
const goTools_1 = require("./goTools");
const util_1 = require("./util");
// declinedUpdates tracks the tools that the user has declined to update.
const declinedUpdates = [];
// declinedUpdates tracks the tools that the user has declined to install.
const declinedInstalls = [];
function installAllTools(updateExistingToolsOnly = false) {
    return __awaiter(this, void 0, void 0, function* () {
        const goVersion = yield util_1.getGoVersion();
        let allTools = goTools_1.getConfiguredTools(goVersion);
        // exclude tools replaced by alternateTools.
        const alternateTools = util_1.getGoConfig().get('alternateTools');
        allTools = allTools.filter((tool) => {
            return !alternateTools[tool.name];
        });
        // Update existing tools by finding all tools the user has already installed.
        if (updateExistingToolsOnly) {
            yield installTools(allTools.filter((tool) => {
                const toolPath = util_1.getBinPath(tool.name);
                return toolPath && path.isAbsolute(toolPath);
            }), goVersion);
            return;
        }
        // Otherwise, allow the user to select which tools to install or update.
        const selected = yield vscode.window.showQuickPick(allTools.map((x) => {
            const item = {
                label: x.name,
                description: x.description
            };
            return item;
        }), {
            canPickMany: true,
            placeHolder: 'Select the tools to install/update.'
        });
        if (!selected) {
            return;
        }
        yield installTools(selected.map((x) => goTools_1.getTool(x.label)), goVersion);
    });
}
exports.installAllTools = installAllTools;
/**
 * Installs given array of missing tools. If no input is given, the all tools are installed
 *
 * @param missing array of tool names and optionally, their versions to be installed.
 *                If a tool's version is not specified, it will install the latest.
 * @param goVersion version of Go that affects how to install the tool. (e.g. modules vs legacy GOPATH mode)
 */
function installTools(missing, goVersion) {
    return __awaiter(this, void 0, void 0, function* () {
        if (!missing) {
            return;
        }
        goStatus_1.outputChannel.show();
        goStatus_1.outputChannel.clear();
        const envForTools = goEnv_1.toolInstallationEnvironment();
        const toolsGopath = envForTools['GOPATH'];
        let envMsg = `Tools environment: GOPATH=${toolsGopath}`;
        if (envForTools['GOBIN']) {
            envMsg += `, GOBIN=${envForTools['GOBIN']}`;
        }
        goStatus_1.outputChannel.appendLine(envMsg);
        let installingMsg = `Installing ${missing.length} ${missing.length > 1 ? 'tools' : 'tool'} at `;
        if (envForTools['GOBIN']) {
            installingMsg += `the configured GOBIN: ${envForTools['GOBIN']}`;
        }
        else {
            installingMsg += `${toolsGopath}${path.sep}bin`;
        }
        // If the user is on Go >= 1.11, tools should be installed with modules enabled.
        // This ensures that users get the latest tagged version, rather than master,
        // which may be unstable.
        let modulesOff = false;
        if (goVersion.lt('1.11')) {
            modulesOff = true;
        }
        else {
            installingMsg += ' in module mode.';
        }
        goStatus_1.outputChannel.appendLine(installingMsg);
        missing.forEach((missingTool) => {
            let toolName = missingTool.name;
            if (missingTool.version) {
                toolName += '@' + missingTool.version;
            }
            goStatus_1.outputChannel.appendLine('  ' + toolName);
        });
        goStatus_1.outputChannel.appendLine(''); // Blank line for spacing.
        const toInstall = [];
        for (const tool of missing) {
            // Disable modules for tools which are installed with the "..." wildcard.
            const modulesOffForTool = modulesOff || goTools_1.disableModulesForWildcard(tool, goVersion);
            const reason = installTool(tool, goVersion, envForTools, !modulesOffForTool);
            toInstall.push(Promise.resolve({ tool, reason: yield reason }));
        }
        const results = yield Promise.all(toInstall);
        const failures = [];
        for (const result of results) {
            if (result.reason === '') {
                // Restart the language server if a new binary has been installed.
                if (result.tool.name === 'gopls') {
                    goMain_1.restartLanguageServer();
                }
            }
            else {
                failures.push(result);
            }
        }
        // Report detailed information about any failures.
        goStatus_1.outputChannel.appendLine(''); // blank line for spacing
        if (failures.length === 0) {
            goStatus_1.outputChannel.appendLine('All tools successfully installed. You are ready to Go :).');
        }
        else {
            goStatus_1.outputChannel.appendLine(failures.length + ' tools failed to install.\n');
            for (const failure of failures) {
                goStatus_1.outputChannel.appendLine(`${failure.tool.name}: ${failure.reason} `);
            }
        }
    });
}
exports.installTools = installTools;
function installTool(tool, goVersion, envForTools, modulesOn) {
    return __awaiter(this, void 0, void 0, function* () {
        // Some tools may have to be closed before we reinstall them.
        if (tool.close) {
            const reason = yield tool.close();
            if (reason) {
                return reason;
            }
        }
        // Install tools in a temporary directory, to avoid altering go.mod files.
        const mkdtemp = util.promisify(fs.mkdtemp);
        const toolsTmpDir = yield mkdtemp(util_1.getTempFilePath('go-tools-'));
        const env = Object.assign({}, envForTools);
        let tmpGoModFile;
        if (modulesOn) {
            env['GO111MODULE'] = 'on';
            // Write a temporary go.mod file to avoid version conflicts.
            tmpGoModFile = path.join(toolsTmpDir, 'go.mod');
            const writeFile = util.promisify(fs.writeFile);
            yield writeFile(tmpGoModFile, 'module tools');
        }
        else {
            envForTools['GO111MODULE'] = 'off';
        }
        // Build the arguments list for the tool installation.
        const args = ['get', '-v'];
        // Only get tools at master if we are not using modules.
        if (!modulesOn) {
            args.push('-u');
        }
        // Tools with a "mod" suffix should not be installed,
        // instead we run "go build -o" to rename them.
        if (goTools_1.hasModSuffix(tool)) {
            args.push('-d');
        }
        let importPath;
        if (!modulesOn) {
            importPath = goTools_1.getImportPath(tool, goVersion);
        }
        else {
            importPath = goTools_1.getImportPathWithVersion(tool, tool.version, goVersion);
        }
        args.push(importPath);
        let output;
        let result = '';
        try {
            const opts = {
                env,
                cwd: toolsTmpDir,
            };
            const execFile = util.promisify(cp.execFile);
            const { stdout, stderr } = yield execFile(goVersion.binaryPath, args, opts);
            output = `${stdout} ${stderr}`;
            // TODO(rstambler): Figure out why this happens and maybe delete it.
            if (stderr.indexOf('unexpected directory layout:') > -1) {
                yield execFile(goVersion.binaryPath, args, opts);
            }
            else if (goTools_1.hasModSuffix(tool)) {
                const gopath = env['GOPATH'];
                if (!gopath) {
                    return `GOPATH not configured in environment`;
                }
                const outputFile = path.join(gopath, 'bin', process.platform === 'win32' ? `${tool.name}.exe` : tool.name);
                yield execFile(goVersion.binaryPath, ['build', '-o', outputFile, importPath], opts);
            }
            goStatus_1.outputChannel.appendLine(`Installing ${importPath} SUCCEEDED`);
        }
        catch (e) {
            goStatus_1.outputChannel.appendLine(`Installing ${importPath} FAILED`);
            result = `failed to install ${tool}: ${e} ${output} `;
        }
        // Delete the temporary installation directory.
        util_1.rmdirRecursive(toolsTmpDir);
        return result;
    });
}
exports.installTool = installTool;
function promptForMissingTool(toolName) {
    return __awaiter(this, void 0, void 0, function* () {
        const tool = goTools_1.getTool(toolName);
        // If user has declined to install this tool, don't prompt for it.
        if (goTools_1.containsTool(declinedInstalls, tool)) {
            return;
        }
        const goVersion = yield util_1.getGoVersion();
        if (!goVersion) {
            return;
        }
        // Show error messages for outdated tools or outdated Go versions.
        if (tool.minimumGoVersion && goVersion.lt(tool.minimumGoVersion.format())) {
            vscode.window.showInformationMessage(`You are using go${goVersion.format()}, but ${tool.name} requires at least go${tool.minimumGoVersion.format()}.`);
            return;
        }
        if (tool.maximumGoVersion && goVersion.gt(tool.maximumGoVersion.format())) {
            vscode.window.showInformationMessage(`You are using go${goVersion.format()}, but ${tool.name} only supports go${tool.maximumGoVersion.format()} and below.`);
            return;
        }
        const installOptions = ['Install'];
        let missing = yield getMissingTools(goVersion);
        if (!goTools_1.containsTool(missing, tool)) {
            return;
        }
        missing = missing.filter((x) => x === tool || tool.isImportant);
        if (missing.length > 1) {
            // Offer the option to install all tools.
            installOptions.push('Install All');
        }
        const msg = `The "${tool.name}" command is not available.
Run "go get -v ${goTools_1.getImportPath(tool, goVersion)}" to install.`;
        const selected = yield vscode.window.showInformationMessage(msg, ...installOptions);
        switch (selected) {
            case 'Install':
                yield installTools([tool], goVersion);
                break;
            case 'Install All':
                yield installTools(missing, goVersion);
                goStatus_1.hideGoStatus();
                break;
            default:
                // The user has declined to install this tool.
                declinedInstalls.push(tool);
                break;
        }
    });
}
exports.promptForMissingTool = promptForMissingTool;
function promptForUpdatingTool(toolName, newVersion) {
    return __awaiter(this, void 0, void 0, function* () {
        const tool = goTools_1.getTool(toolName);
        const toolVersion = Object.assign(Object.assign({}, tool), { version: newVersion }); // ToolWithVersion
        // If user has declined to update, then don't prompt.
        if (goTools_1.containsTool(declinedUpdates, tool)) {
            return;
        }
        const goVersion = yield util_1.getGoVersion();
        let updateMsg = `Your version of ${tool.name} appears to be out of date. Please update for an improved experience.`;
        const choices = ['Update'];
        if (toolName === `gopls`) {
            choices.push('Release Notes');
        }
        if (newVersion) {
            updateMsg = `A new version of ${tool.name} (v${newVersion}) is available. Please update for an improved experience.`;
        }
        const selected = yield vscode.window.showInformationMessage(updateMsg, ...choices);
        switch (selected) {
            case 'Update':
                yield installTools([toolVersion], goVersion);
                break;
            case 'Release Notes':
                vscode.commands.executeCommand('vscode.open', vscode.Uri.parse('https://github.com/golang/go/issues/33030#issuecomment-510151934'));
                break;
            default:
                declinedUpdates.push(tool);
                break;
        }
    });
}
exports.promptForUpdatingTool = promptForUpdatingTool;
function updateGoVarsFromConfig() {
    // FIXIT: when user changes the environment variable settings or go.gopath, the following
    // condition prevents from updating the process.env accordingly, so the extension will lie.
    // Needs to clean up.
    if (process.env['GOPATH'] && process.env['GOPROXY'] && process.env['GOBIN']) {
        return Promise.resolve();
    }
    // FIXIT: if updateGoVarsFromConfig is called again after addGoRuntimeBaseToPATH sets PATH,
    // the go chosen by getBinPath based on PATH will not change.
    const goRuntimePath = util_1.getBinPath('go', false);
    if (!goRuntimePath) {
        vscode.window.showErrorMessage(`Failed to run "go env" to find GOPATH as the "go" binary cannot be found in either GOROOT(${goPath_1.getCurrentGoRoot()}) or PATH(${goPath_1.envPath})`);
        return;
    }
    return new Promise((resolve, reject) => {
        cp.execFile(goRuntimePath, ['env', 'GOPATH', 'GOROOT', 'GOPROXY', 'GOBIN'], (err, stdout, stderr) => {
            if (err) {
                return reject();
            }
            const envOutput = stdout.split('\n');
            if (!process.env['GOPATH'] && envOutput[0].trim()) {
                process.env['GOPATH'] = envOutput[0].trim();
            }
            if (envOutput[1] && envOutput[1].trim()) {
                goPath_1.setCurrentGoRoot(envOutput[1].trim());
            }
            if (!process.env['GOPROXY'] && envOutput[2] && envOutput[2].trim()) {
                process.env['GOPROXY'] = envOutput[2].trim();
            }
            if (!process.env['GOBIN'] && envOutput[3] && envOutput[3].trim()) {
                process.env['GOBIN'] = envOutput[3].trim();
            }
            // cgo, gopls, and other underlying tools will inherit the environment and attempt
            // to locate 'go' from the PATH env var.
            addGoRuntimeBaseToPATH(path.join(goPath_1.getCurrentGoRoot(), 'bin'));
            goEnvironmentStatus_1.initGoStatusBar();
            // TODO: restart language server or synchronize with language server update.
            return resolve();
        });
    });
}
exports.updateGoVarsFromConfig = updateGoVarsFromConfig;
// PATH value cached before addGoRuntimeBaseToPath modified.
let defaultPathEnv = '';
// addGoRuntimeBaseToPATH adds the given path to the front of the PATH environment variable.
// It removes duplicates.
// TODO: can we avoid changing PATH but utilize toolExecutionEnv?
function addGoRuntimeBaseToPATH(newGoRuntimeBase) {
    if (!newGoRuntimeBase) {
        return;
    }
    let pathEnvVar;
    if (process.env.hasOwnProperty('PATH')) {
        pathEnvVar = 'PATH';
    }
    else if (process.platform === 'win32' && process.env.hasOwnProperty('Path')) {
        pathEnvVar = 'Path';
    }
    else {
        return;
    }
    if (!defaultPathEnv) { // cache the default value
        defaultPathEnv = process.env[pathEnvVar];
    }
    let pathVars = defaultPathEnv.split(path.delimiter);
    pathVars = pathVars.filter((p) => p !== newGoRuntimeBase);
    pathVars.unshift(newGoRuntimeBase);
    process.env[pathEnvVar] = pathVars.join(path.delimiter);
}
let alreadyOfferedToInstallTools = false;
function offerToInstallTools() {
    return __awaiter(this, void 0, void 0, function* () {
        if (alreadyOfferedToInstallTools) {
            return;
        }
        alreadyOfferedToInstallTools = true;
        const goVersion = yield util_1.getGoVersion();
        let missing = yield getMissingTools(goVersion);
        missing = missing.filter((x) => x.isImportant);
        if (missing.length > 0) {
            goStatus_1.showGoStatus('Analysis Tools Missing', 'go.promptforinstall', 'Not all Go tools are available on the GOPATH');
            vscode.commands.registerCommand('go.promptforinstall', () => {
                const installItem = {
                    title: 'Install',
                    command() {
                        return __awaiter(this, void 0, void 0, function* () {
                            goStatus_1.hideGoStatus();
                            yield installTools(missing, goVersion);
                        });
                    }
                };
                const showItem = {
                    title: 'Show',
                    command() {
                        goStatus_1.outputChannel.clear();
                        goStatus_1.outputChannel.appendLine('Below tools are needed for the basic features of the Go extension.');
                        missing.forEach((x) => goStatus_1.outputChannel.appendLine(x.name));
                    }
                };
                vscode.window
                    .showInformationMessage('Failed to find some of the Go analysis tools. Would you like to install them?', installItem, showItem)
                    .then((selection) => {
                    if (selection) {
                        selection.command();
                    }
                    else {
                        goStatus_1.hideGoStatus();
                    }
                });
            });
        }
        const usingSourceGraph = goPath_1.getToolFromToolPath(goLanguageServer_1.getLanguageServerToolPath()) === 'go-langserver';
        if (usingSourceGraph && goVersion.gt('1.10')) {
            const promptMsg = 'The language server from Sourcegraph is no longer under active development and it does not support Go modules as well. Please install and use the language server from Google or disable the use of language servers altogether.';
            const disableLabel = 'Disable language server';
            const installLabel = 'Install';
            const selected = yield vscode.window.showInformationMessage(promptMsg, installLabel, disableLabel);
            if (selected === installLabel) {
                yield installTools([goTools_1.getTool('gopls')], goVersion);
            }
            else if (selected === disableLabel) {
                const goConfig = util_1.getGoConfig();
                const inspectLanguageServerSetting = goConfig.inspect('useLanguageServer');
                if (inspectLanguageServerSetting.globalValue === true) {
                    goConfig.update('useLanguageServer', false, vscode.ConfigurationTarget.Global);
                }
                else if (inspectLanguageServerSetting.workspaceFolderValue === true) {
                    goConfig.update('useLanguageServer', false, vscode.ConfigurationTarget.WorkspaceFolder);
                }
            }
        }
    });
}
exports.offerToInstallTools = offerToInstallTools;
function getMissingTools(goVersion) {
    const keys = goTools_1.getConfiguredTools(goVersion);
    return Promise.all(keys.map((tool) => new Promise((resolve, reject) => {
        const toolPath = util_1.getBinPath(tool.name);
        resolve(path.isAbsolute(toolPath) ? null : tool);
    }))).then((res) => {
        return res.filter((x) => x != null);
    });
}
//# sourceMappingURL=goInstallTools.js.map