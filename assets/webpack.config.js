// Native
const { resolve } = require('path')
// Third-Party
const CopyWebpackPlugin = require('copy-webpack-plugin')
// https://github.com/privatenumber/esbuild-loader
const { ESBuildMinifyPlugin } = require('esbuild-loader')
const { sync } = require('glob')

module.exports = (env, options) => {
  const devMode = options.mode !== 'production'

  return {
    devtool: devMode ? 'eval-cheap-module-source-map' : undefined,
    entry: {
      app: sync('./vendor/**/*.js').concat(['./js/app.js']),
    },
    module: {
      rules: [
        {
          exclude: /node_modules/,
          loader: 'esbuild-loader',
          test: /\.js$/,
        },
      ],
    },
    optimization: {
      minimizer: [
        new ESBuildMinifyPlugin({
          target: 'es2015',
        }),
      ],
    },
    output: {
      filename: '[name].js',
      path: resolve(__dirname, '../priv/static/js'),
      publicPath: '/js/',
    },
    plugins: [
      new CopyWebpackPlugin({ patterns: [{ from: 'static/', to: '../' }] }),
    ],
  }
}
