var path = require("path")
var webpack = require("webpack")

module.exports = {
  entry: "./src/orioneum.js",
  output: {
    path: path.resolve(__dirname, "dist"),
    filename: 'orioneum.js',
    publicPath: 'dist/'
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /(node_modules)/,
        use: [
          {
            loader: 'babel-loader',
            options: {
              presets: ['@babel/preset-env']
            }
          }
        ]
      }
    ]
  }
}
