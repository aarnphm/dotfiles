"use strict";
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
const path = require("path");
const vscode_test_1 = require("vscode-test");
function main() {
    return __awaiter(this, void 0, void 0, function* () {
        // The folder containing the Extension Manifest package.json
        // Passed to `--extensionDevelopmentPath`
        const extensionDevelopmentPath = path.resolve(__dirname, '../../');
        try {
            // The path to the extension test script
            // Passed to --extensionTestsPath
            const extensionTestsPath = path.resolve(__dirname, './integration/index');
            // Download VS Code, unzip it and run the integration test
            yield vscode_test_1.runTests({ extensionDevelopmentPath, extensionTestsPath });
        }
        catch (err) {
            console.error('Failed to run integration tests' + err);
            process.exit(1);
        }
        // Integration tests using gopls.
        try {
            // Currently gopls requires a workspace. Code in test environment does not support
            // dynamically adding folders.
            // tslint:disable-next-line:max-line-length
            // https://github.com/microsoft/vscode/blob/890f62dfd9f3e70198931f788c5c332b3e8b7ad7/src/vs/workbench/services/workspaces/browser/abstractWorkspaceEditingService.ts#L281
            // So, we start the test extension host with a dummy workspace (test/gopls/testfixtures/src/workspace)
            // and copy necessary files to the workspace.
            const ws = path.resolve(extensionDevelopmentPath, 'test/gopls/testfixtures/src/workspace');
            yield vscode_test_1.runTests({
                extensionDevelopmentPath,
                extensionTestsPath: path.resolve(__dirname, './gopls/index'),
                launchArgs: [
                    '--disable-extensions',
                    ws // dummy workspace to start with
                ],
            });
        }
        catch (err) {
            console.error('Failed to run gopls tests' + err);
        }
    });
}
main();
//# sourceMappingURL=runTest.js.map