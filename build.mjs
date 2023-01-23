#!/usr/bin/env node
import * as esbuild from 'esbuild';
import {sassPlugin} from 'esbuild-sass-plugin';
import {readdirSync, existsSync} from "fs";
import {join} from "path";

const jcorePath = 'wp-content/themes/jcore2';
const childPath = join('wp-content/themes', process.env.npm_package_config_theme ?? 'jcore2-child');

const options = {
    bundle: true,
    minify: true,
    write: true,
    sourcemap: true,
    logLevel: 'info',
    external: ['*.png', '*.svg', '*.jpg', '*.jpeg']
};
const jcoreJs = {
    ...options,
    entryPoints: getFiles(join(jcorePath, 'js')),
    loader: {'.js': 'jsx'},
    outdir: join(jcorePath, 'dist/js'),
};
const childJs = {
    ...options,
    entryPoints: getFiles(join(childPath, 'js')),
    loader: {'.js': 'jsx'},
    outdir: join(childPath, 'dist/js'),
};
const jcoreSass = {
    ...options,
    entryPoints: getFiles(join(jcorePath, 'scss')),
    plugins: [sassPlugin()],
    outdir: join(jcorePath, 'dist/css'),
};
const childSass = {
    ...options,
    entryPoints: getFiles(join(childPath, 'scss')),
    plugins: [sassPlugin()],
    outdir: join(childPath, 'dist/css'),
};

if (process.argv[2] === 'build') {
    await esbuild.build(jcoreJs);
    await esbuild.build(childJs);
    await esbuild.build(jcoreSass);
    await esbuild.build(childSass);
} else if (process.argv[2] === 'watch') {
    await (await esbuild.context(jcoreJs)).watch();
    await (await esbuild.context(childJs)).watch();
    await (await esbuild.context(jcoreSass)).watch();
    await (await esbuild.context(childSass)).watch();
}

function getFiles(path) {
    const files = [];
    if (existsSync(path)) {
        for (let file of readdirSync(path)) {
            if (file.substring(0, 1) !== '_' && file.split('.').length > 1) {
                files.push(join(path, file));
            }
        }
    }
    return files;
}
