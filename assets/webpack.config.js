// Native
const { resolve } = require('path')
// Third-Party
const CopyWebpackPlugin = require('copy-webpack-plugin')
// https://github.com/privatenumber/esbuild-loader
const { ESBuildMinifyPlugin } = require('esbuild-loader')
const { sync } = require('glob')
const MiniCssExtractPlugin = require('mini-css-extract-plugin')

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
        {
          test: /\.[s]?css$/,
          use: [
            MiniCssExtractPlugin.loader,
            'css-loader',
            'postcss-loader',
            'sass-loader',
          ],
        },
      ],
    },
    optimization: {
      minimizer: [
        new ESBuildMinifyPlugin({
          target: 'es2015',
          css: true,
        }),
      ],
    },
    output: {
      filename: '[name].js',
      path: resolve(__dirname, '../priv/static/js'),
      publicPath: '/js/',
    },
    plugins: [
      new MiniCssExtractPlugin({ filename: '../css/app.css' }),
      new CopyWebpackPlugin({ patterns: [{ from: 'static/', to: '../' }] }),
    ],
  }
}
