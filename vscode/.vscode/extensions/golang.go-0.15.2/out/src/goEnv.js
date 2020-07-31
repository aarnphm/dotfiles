/*---------------------------------------------------------
 * Copyright (C) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See LICENSE in the project root for license information.
 *--------------------------------------------------------*/
'use strict';
Object.defineProperty(exports, "__esModule", { value: true });
exports.toolExecutionEnvironment = exports.toolInstallationEnvironment = void 0;
const vscode = require("vscode");
const util_1 = require("./util");
// toolInstallationEnvironment returns the environment in which tools should
// be installed. It always returns a new object.
function toolInstallationEnvironment() {
    const env = newEnvironment();
    // If the go.toolsGopath is set, use its value as the GOPATH for `go` processes.
    // Else use the Current Gopath
    let toolsGopath = util_1.getToolsGopath();
    if (toolsGopath) {
        // User has explicitly chosen to use toolsGopath, so ignore GOBIN.
        env['GOBIN'] = '';
    }
    else {
        toolsGopath = util_1.getCurrentGoPath();
    }
    if (!toolsGopath) {
        const msg = 'Cannot install Go tools. Set either go.gopath or go.toolsGopath in settings.';
        vscode.window.showInformationMessage(msg, 'Open User Settings', 'Open Workspace Settings').then((selected) => {
            switch (selected) {
                case 'Open User Settings':
                    vscode.commands.executeCommand('workbench.action.openGlobalSettings');
                    break;
                case 'Open Workspace Settings':
                    vscode.commands.executeCommand('workbench.action.openWorkspaceSettings');
                    break;
            }
        });
        return;
    }
    env['GOPATH'] = toolsGopath;
    return env;
}
exports.toolInstallationEnvironment = toolInstallationEnvironment;
// toolExecutionEnvironment returns the environment in which tools should
// be executed. It always returns a new object.
function toolExecutionEnvironment() {
    const env = newEnvironment();
    const gopath = util_1.getCurrentGoPath();
    if (gopath) {
        env['GOPATH'] = gopath;
    }
    return env;
}
exports.toolExecutionEnvironment = toolExecutionEnvironment;
function newEnvironment() {
    const toolsEnvVars = util_1.getGoConfig()['toolsEnvVars'];
    const env = Object.assign({}, process.env, toolsEnvVars);
    // The http.proxy setting takes precedence over environment variables.
    const httpProxy = vscode.workspace.getConfiguration('http', null).get('proxy');
    if (httpProxy && typeof httpProxy === 'string') {
        env['http_proxy'] = httpProxy;
        env['HTTP_PROXY'] = httpProxy;
        env['https_proxy'] = httpProxy;
        env['HTTPS_PROXY'] = httpProxy;
    }
    return env;
}
//# sourceMappingURL=goEnv.js.map