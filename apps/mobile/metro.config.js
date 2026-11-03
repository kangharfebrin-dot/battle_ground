// Learn more https://docs.expo.io/guides/customizing-metro
const { getDefaultConfig } = require('expo/metro-config');
const path = require('path');

const projectRoot = __dirname;
const monorepoRoot = path.resolve(projectRoot, '../..');

const config = getDefaultConfig(projectRoot);

// Pastikan semua default watchFolders dipertahankan, lalu tambahkan root monorepo
config.watchFolders = Array.from(
  new Set([...(config.watchFolders || [projectRoot]), monorepoRoot])
);

// Pastikan module resolution mencakup direktori lokal dan root monorepo
config.resolver.nodeModulesPaths = Array.from(
  new Set([
    ...(config.resolver.nodeModulesPaths || []),
    path.resolve(projectRoot, 'node_modules'),
    path.resolve(monorepoRoot, 'node_modules')
  ])
);

module.exports = config;
