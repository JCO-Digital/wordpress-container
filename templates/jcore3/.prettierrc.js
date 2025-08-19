const defaultConfig = require("@wordpress/prettier-config");
const config = {
  ...defaultConfig,
  plugins: [...(defaultConfig.plugins ?? []), "@zackad/prettier-plugin-twig"],
  }
module.exports = config;
