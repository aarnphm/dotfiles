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
/*---------------------------------------------------------
 * Copyright (C) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See LICENSE in the project root for license information.
 *--------------------------------------------------------*/
const assert = require("assert");
const fs = require("fs-extra");
const path = require("path");
const vscode = require("vscode");
const telemetry_1 = require("../../src/telemetry");
// Env is a collection of test related variables
// that define the test environment such as vscode workspace.
class Env {
    constructor(projectDir) {
        if (!projectDir) {
            assert.fail('project directory cannot be determined');
        }
        this.workspaceDir = path.resolve(projectDir, 'test/gopls/testfixtures/src/workspace');
        this.fixturesRoot = path.resolve(projectDir, 'test/fixtures');
        this.extension = vscode.extensions.getExtension(telemetry_1.extensionId);
        // Ensure the vscode extension host is configured as expected.
        const workspaceFolder = path.resolve(vscode.workspace.workspaceFolders[0].uri.fsPath);
        if (this.workspaceDir !== workspaceFolder) {
            assert.fail(`specified workspaceDir: ${this.workspaceDir} does not match the workspace folder: ${workspaceFolder}`);
        }
    }
    setup() {
        return __awaiter(this, void 0, void 0, function* () {
            const wscfg = vscode.workspace.getConfiguration('go');
            if (!wscfg.get('useLanguageServer')) {
                wscfg.update('useLanguageServer', true, vscode.ConfigurationTarget.Workspace);
            }
            yield this.reset();
            yield this.extension.activate();
            yield sleep(2000); // allow extension host + gopls to start.
        });
    }
    reset(fixtureDirName) {
        return __awaiter(this, void 0, void 0, function* () {
            try {
                // clean everything except the .gitignore file
                // needed to keep the empty directory in vcs.
                yield fs.readdir(this.workspaceDir).then((files) => {
                    return Promise.all(files.filter((filename) => filename !== '.gitignore').map((file) => {
                        fs.remove(path.resolve(this.workspaceDir, file));
                    }));
                });
                if (!fixtureDirName) {
                    return;
                }
                const src = path.resolve(this.fixturesRoot, fixtureDirName);
                const dst = this.workspaceDir;
                yield fs.copy(src, dst, { recursive: true });
            }
            catch (err) {
                assert.fail(err);
            }
        });
    }
    // openDoc opens the file in the workspace with the given path (paths
    // are the path elements of a file).
    openDoc(...paths) {
        return __awaiter(this, void 0, void 0, function* () {
            const uri = vscode.Uri.file(path.resolve(this.workspaceDir, ...paths));
            const doc = yield vscode.workspace.openTextDocument(uri);
            return { uri, doc };
        });
    }
}
function sleep(ms) {
    return __awaiter(this, void 0, void 0, function* () {
        return new Promise((resolve) => setTimeout(resolve, ms));
    });
}
suite('Go Extension Tests With Gopls', function () {
    this.timeout(1000000);
    const projectDir = path.join(__dirname, '..', '..', '..');
    const env = new Env(projectDir);
    suiteSetup(() => __awaiter(this, void 0, void 0, function* () { yield env.setup(); }));
    suiteTeardown(() => __awaiter(this, void 0, void 0, function* () { yield env.reset(); }));
    test('HoverProvider', () => __awaiter(this, void 0, void 0, function* () {
        yield env.reset('gogetdocTestData');
        const { uri, doc } = yield env.openDoc('test.go');
        // TODO(hyangah): find a way to wait for the language server to complete processing.
        const testCases = [
            // [new vscode.Position(3,3), '/usr/local/go/src/fmt'],
            ['keyword', new vscode.Position(0, 3), null, null],
            ['inside a string', new vscode.Position(23, 14), null, null],
            ['just a }', new vscode.Position(20, 0), null, null],
            ['inside a number', new vscode.Position(28, 16), null, null],
            ['func main()', new vscode.Position(22, 5), 'func main()', null],
            ['import "math"', new vscode.Position(40, 23), 'package math', '`math` on'],
            ['func Println()', new vscode.Position(19, 6), 'func fmt.Println(a ...interface{}) (n int, err error)', 'Println formats '],
            ['func print()', new vscode.Position(23, 4), 'func print(txt string)', 'This is an unexported function ']
        ];
        const promises = testCases.map(([name, position, expectedSignature, expectedDoc]) => __awaiter(this, void 0, void 0, function* () {
            const hovers = yield vscode.commands.executeCommand('vscode.executeHoverProvider', uri, position);
            if (expectedSignature === null && expectedDoc === null) {
                assert.equal(hovers.length, 0, `check hovers over ${name} failed: unexpected non-empty hover message.`);
                return;
            }
            const hover = hovers[0];
            assert.equal(hover.contents.length, 1, `check hovers over ${name} failed: unexpected number of hover messages.`);
            const gotMessage = hover.contents[0].value;
            assert.ok(gotMessage.includes('```go\n' + expectedSignature + '\n```')
                && (!expectedDoc || gotMessage.includes(expectedDoc)), `check hovers over ${name} failed: got ${gotMessage}`);
        }));
        return Promise.all(promises);
    }));
});
//# sourceMappingURL=extension.test.js.map