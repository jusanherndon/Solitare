// Vendored Expo lives outside the app. Resolve its packages from
// vendor/expo/node_modules, but pin React to the app copy so web
// doesn't hit "Invalid hook call" from duplicate Reacts.
const path = require('path');
const { getDefaultConfig } = require('expo/metro-config');

const projectRoot = __dirname;
const expoVendor = path.resolve(projectRoot, '../../vendor/expo');
const config = getDefaultConfig(projectRoot);

config.watchFolders = [
  projectRoot,
  expoVendor,
  path.resolve(projectRoot, '../../vendor/babel-preset-expo'),
];

config.resolver.disableHierarchicalLookup = true;
config.resolver.nodeModulesPaths = [
  path.resolve(projectRoot, 'node_modules'),
  path.resolve(expoVendor, 'node_modules'),
];

config.resolver.extraNodeModules = {
  react: path.resolve(projectRoot, 'node_modules/react'),
  'react-dom': path.resolve(projectRoot, 'node_modules/react-dom'),
  'react-native': path.resolve(projectRoot, 'node_modules/react-native'),
  'react-native-web': path.resolve(projectRoot, 'node_modules/react-native-web'),
  expo: expoVendor,
};

module.exports = config;
