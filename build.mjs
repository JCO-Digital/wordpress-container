#!/usr/bin/env node
import * as esbuild from 'esbuild';
import {sassPlugin} from 'esbuild-sass-plugin';
import {readdirSync, existsSync} from "fs";
import {join, parse} from "path";


const jcorePath = join('wp-content/themes', process.env.npm_package_config_parent ?? 'jcore2');
const childPath = join('wp-content/themes', process.env.npm_package_config_theme ?? 'jcore2-child');

const options = {
    bundle: true,
    minify: true,
    write: true,
    sourcemap: true,
    logLevel: 'info',
    entryNames: '[name]',
    external: ['*.png', '*.svg', '*.jpg', '*.jpeg', '*.css']
};

const childJs = {
    ...options,
    entryPoints: deDupe([...getFiles(join(childPath, 'js')), ...getFiles(join(jcorePath, 'js'))]),
    loader: {'.js': 'jsx'},
    outdir: join(childPath, 'dist/js'),
};
const childSass = {
    ...options,
    entryPoints: deDupe([...getFiles(join(childPath, 'scss')), ...getFiles(join(jcorePath, 'scss'))]),
    plugins: [sassPlugin()],
    outdir: join(childPath, 'dist/css'),
};

if (process.argv[2] === 'build') {
    await esbuild.build(childJs);
    await esbuild.build(childSass);
} else if (process.argv[2] === 'watch') {
    await (await esbuild.context(childJs)).watch();
    await (await esbuild.context(childSass)).watch();
}

/**
 * Get all files that needs to be passed to esbuild from the given path.
 *
 * @param path
 * @returns {*[]}
 */
function getFiles(path) {
    const files = [];
    if (existsSync(path)) {
        for (const file of readdirSync(path)) {
            // Only add files not starting with _ and that has an extension.
            if (file.substring(0, 1) !== '_' && file.split('.').length > 1) {
                files.push(join(path, file));
            }
        }
    }
    return files;
}

/**
 * Remove duplicate filenames from list to allow "overwrites".
 * @param files array<string>
 * @return array<string>
 */
function deDupe(files) {
    const names = [];
    return files.filter(file => {
        const path = parse(file);
        if (! names.includes(path.name)) {
            names.push(path.name);
            return true;
        }
        return false;
    })
}