const QRCode = require('qrcode');
const crypto = require("crypto");
const _ = require("lodash");
const path = require("path");
const rimraf = require("rimraf");

function generateId() {
    return crypto.randomBytes(2).toString('hex');
}

const qrs = {
    "VAR": "VAR",
    "EQUALS": "=",
    "IS_EQUAL": "==",
    "PLUS": "+",
    "MINUS": "-",
    "MULTIPLY": "*",
    "DIVIDE": "/",
    "LARGER": ">",
    "SMALER": "<",
    "NOT": "!",
    "AND": "&&",
    "OR": "||",
    "IF": "IF",
    "ELSE": "ELSE",
    "END": "END",
    "RETURN": "RETURN",
    "a": "a",
    "b": "b",
    "c": "c",
    "d": "d",
    "FUNC": "FUNC",
    "PRINT": "PRINT",
    "CALL": "CALL",
    "REPEAT": "REPEAT",
    "SPACE": " ",
    "LEFT_BRACKET": "(",
    "RIGHT_BRACKET": ")",
};
const qrsColor = {
    "END": "#9a0007ff",
    "SMALER": "#eea000ff",
    "LARGER": "#eea000ff",
    "PLUS": "#eea000ff",
    "MINUS": "#eea000ff",
    "DIVIDE": "#eea000ff",
    "MULTIPLY": "#eea000ff",
    "NOT": "#eea000ff",
    "AND": "#eea000ff",
    "OR": "#eea000ff",
    "IS_EQUAL": "#eea000ff",
    "EQUALS": "#311b92ff",
    "VAR": "#311b92ff",
    "a": "#c62828ff",
    "b": "#c62828ff",
    "c": "#c62828ff",
    "RETURN": "#283593ff",
    "LEFT_BRACKET": "#455a64ff",
    "RIGHT_BRACKET": "#455a64ff",
    "SPACE": "#455a64ff",
};
const nums = Array.from(Array(10).keys());
const mainQROptions = {
    margin: 0,
    scale: 16,
    color: {
        dark: "#0069c0ff", // dark blue
        // dark: "#9a0007ff", // dark red
        // light: "#ffffffff", // white
        // light: "#6ec6ffff", // light blue
        light: "#ffffff00", // transparent
    }
};
rimraf('./QRs/*', function () {
    Array.from(Array(6).keys()).forEach(k => {
        _.forEach(qrs, (value, key) => {
            const qrOptions = {
                ...mainQROptions,
                color: {
                    ...mainQROptions.color,
                    dark: qrsColor[key] || mainQROptions.color.dark
                }
            };
            const id = generateId();
            QRCode.toFile(path.resolve(`./QRs/${key}_${k}.png`), `${id};${value}`, qrOptions);
        });
        _.forEach(nums, (n) => {
            const qrOptions = {
                ...mainQROptions,
                color: {
                    ...mainQROptions.color,
                    dark: "#2e7d32ff"
                }
            };
            const id = generateId();
            QRCode.toFile(path.resolve(`./QRs/${n}_${k}.png`), `${id};${n}`, qrOptions);
        });         
    });
});
