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
exports.GoRunTestCodeLensProvider = void 0;
const vscode = require("vscode");
const vscode_1 = require("vscode");
const goBaseCodelens_1 = require("./goBaseCodelens");
const goOutline_1 = require("./goOutline");
const testUtils_1 = require("./testUtils");
const util_1 = require("./util");
class GoRunTestCodeLensProvider extends goBaseCodelens_1.GoBaseCodeLensProvider {
    constructor() {
        super(...arguments);
        this.benchmarkRegex = /^Benchmark.+/;
    }
    provideCodeLenses(document, token) {
        return __awaiter(this, void 0, void 0, function* () {
            if (!this.enabled) {
                return [];
            }
            const config = util_1.getGoConfig(document.uri);
            const codeLensConfig = config.get('enableCodeLens');
            const codelensEnabled = codeLensConfig ? codeLensConfig['runtest'] : false;
            if (!codelensEnabled || !document.fileName.endsWith('_test.go')) {
                return [];
            }
            const codelenses = yield Promise.all([
                this.getCodeLensForPackage(document, token),
                this.getCodeLensForFunctions(document, token)
            ]);
            return [].concat(...codelenses);
        });
    }
    getCodeLensForPackage(document, token) {
        return __awaiter(this, void 0, void 0, function* () {
            const documentSymbolProvider = new goOutline_1.GoDocumentSymbolProvider();
            const symbols = yield documentSymbolProvider.provideDocumentSymbols(document, token);
            if (!symbols || symbols.length === 0) {
                return [];
            }
            const pkg = symbols[0];
            if (!pkg) {
                return [];
            }
            const range = pkg.range;
            const packageCodeLens = [
                new vscode_1.CodeLens(range, {
                    title: 'run package tests',
                    command: 'go.test.package'
                }),
                new vscode_1.CodeLens(range, {
                    title: 'run file tests',
                    command: 'go.test.file'
                })
            ];
            if (pkg.children.some((sym) => sym.kind === vscode.SymbolKind.Function && this.benchmarkRegex.test(sym.name))) {
                packageCodeLens.push(new vscode_1.CodeLens(range, {
                    title: 'run package benchmarks',
                    command: 'go.benchmark.package'
                }), new vscode_1.CodeLens(range, {
                    title: 'run file benchmarks',
                    command: 'go.benchmark.file'
                }));
            }
            return packageCodeLens;
        });
    }
    getCodeLensForFunctions(document, token) {
        return __awaiter(this, void 0, void 0, function* () {
            const testPromise = () => __awaiter(this, void 0, void 0, function* () {
                const testFunctions = yield testUtils_1.getTestFunctions(document, token);
                if (!testFunctions) {
                    return [];
                }
                const codelens = [];
                for (const f of testFunctions) {
                    codelens.push(new vscode_1.CodeLens(f.range, {
                        title: 'run test',
                        command: 'go.test.cursor',
                        arguments: [{ functionName: f.name }]
                    }));
                    codelens.push(new vscode_1.CodeLens(f.range, {
                        title: 'debug test',
                        command: 'go.debug.cursor',
                        arguments: [{ functionName: f.name }]
                    }));
                }
                return codelens;
            });
            const benchmarkPromise = (() => __awaiter(this, void 0, void 0, function* () {
                const benchmarkFunctions = yield testUtils_1.getBenchmarkFunctions(document, token);
                if (!benchmarkFunctions) {
                    return [];
                }
                const codelens = [];
                for (const f of benchmarkFunctions) {
                    codelens.push(new vscode_1.CodeLens(f.range, {
                        title: 'run benchmark',
                        command: 'go.benchmark.cursor',
                        arguments: [{ functionName: f.name }]
                    }));
                    codelens.push(new vscode_1.CodeLens(f.range, {
                        title: 'debug benchmark',
                        command: 'go.debug.cursor',
                        arguments: [{ functionName: f.name }]
                    }));
                }
                return codelens;
            }));
            const codelenses = yield Promise.all([testPromise(), benchmarkPromise()]);
            return [].concat(...codelenses);
        });
    }
}
exports.GoRunTestCodeLensProvider = GoRunTestCodeLensProvider;
//# sourceMappingURL=goRunTestCodelens.js.map