import gulp from 'gulp'
import gulp_sass from 'gulp-sass'
import dart_sass from 'sass'
import autoprefixer from 'gulp-autoprefixer'
import browserify from 'browserify'
import babel from 'babelify'
import buffer from 'gulp-buffer'
import sourcemaps from 'gulp-sourcemaps'
import log from 'gulplog'
import tap from 'gulp-tap'
import del from 'del'
import p from './package.json'

const theme = (p.theme) ? p.theme : p.name
const sass = gulp_sass(dart_sass)

const jcoreName = 'jcore2'
const childName = 'jcore2-child'
const themePath = './wp-content/themes/'
const options = { task: 'build' }

const paths = {
  styles: {
    watch: [
      themePath + theme + '/scss/**/*.scss',
      themePath + jcoreName + '/scss/**/*.scss'
    ],
    src: themePath + theme + '/scss/*.scss',
    dest: themePath + theme + '/dist/css'
  },
  childStyles: {
    watch: [
      themePath + childName + '/scss/**/*.scss',
      themePath + jcoreName + '/scss/**/*.scss'
    ],
    src: themePath + childName + '/scss/*.scss',
    dest: themePath + childName + '/dist/css'
  },
  jcoreStyles: {
    watch: themePath + jcoreName + '/scss/**/*.scss',
    src: themePath + jcoreName + '/scss/*.scss',
    dest: themePath + jcoreName + '/dist/css'
  },
  scripts: {
    watch: themePath + theme + '/js/**/*.js',
    src: themePath + theme + '/js/*.js',
    dest: themePath + theme + '/dist/js'
  },
  childScripts: {
    watch: themePath + childName + '/js/**/*.js',
    src: themePath + childName + '/js/*.js',
    dest: themePath + childName + '/dist/js'
  },
  jcoreScripts: {
    watch: themePath + jcoreName + '/js/**/*.js',
    src: themePath + jcoreName + '/js/*.js',
    dest: themePath + jcoreName + '/dist/js'
  }
}

/*
 * For small tasks you can export arrow functions
 */
export function clean () {
  return del(
    [
      paths.styles.dest,
      paths.scripts.dest,
      paths.childStyles.dest,
      paths.childScripts.dest,
      paths.jcoreStyles.dest,
      paths.jcoreScripts.dest,
    ]
  )
}

function watchFiles () {
  gulp.watch(paths.styles.watch, styles)
  gulp.watch(paths.scripts.watch, scripts)
  gulp.watch(paths.childStyles.watch, childStyles)
  gulp.watch(paths.childScripts.watch, childScripts)
  gulp.watch(paths.jcoreStyles.watch, jcoreStyles)
  gulp.watch(paths.jcoreScripts.watch, jcoreScripts)
}

export const styles = (cb) => {
  return runStyles(paths.styles)
}
export const childStyles = (cb) => {
  return runStyles(paths.childStyles)
}
export const jcoreStyles = (cb) => {
  return runStyles(paths.jcoreStyles)
}
export const scripts = (cb) => {
  return runScripts(paths.scripts)
}
export const childScripts = (cb) => {
  return runScripts(paths.childScripts)
}
export const jcoreScripts = (cb) => {
  return runScripts(paths.jcoreScripts)
}

function runStyles (path) {
  log.info('Parsing ' + path.src)
  return gulp.src(path.src, { sourcemaps: true })
    .pipe(sourcemaps.init({ loadMaps: true }))
    .pipe(sass({ precision: 10, outputStyle: 'compressed' })
      .on('error', (error) => {
        process.stderr.write(`${error.messageFormatted}\n`)
        if (options.task === 'build') {
          process.exit(1)
        }
        gulp.emit('end')
      })
    )
    .pipe(autoprefixer())
    .pipe(sourcemaps.write('./'))
    .pipe(gulp.dest(path.dest))
}

function runScripts (path) {
  return gulp.src(path.src, { read: false })
    .pipe(tap(function (file) {
      log.info('Bundling ' + file.path)
      file.contents = browserify(file.path, { debug: true })
        .transform(babel, { presets: ['@babel/preset-env', '@babel/preset-react'] })
        .bundle()
    }))
    .pipe(buffer())
    .pipe(sourcemaps.init({ loadMaps: true }))
    .pipe(sourcemaps.write('./'))
    .pipe(gulp.dest(path.dest))
}

export const build = (cb) => {
  styles()
  childStyles()
  jcoreStyles()
  scripts()
  childScripts()
  jcoreScripts()

  cb()
}

export function watch (cb) {
  options.task = 'watch'
  build(cb)

  watchFiles()
  cb()
}

export default watch
