import { createApp } from './app';
import { loadConfig } from './config/env';

const config = loadConfig();
const app = createApp();

const server = app.listen(config.port, () => {
  console.log(`[BattleGround Server] Running on http://localhost:${config.port} (env: ${config.nodeEnv})`);
  console.log(`[BattleGround Server] Health check available at: http://localhost:${config.port}/api/v1/health`);
});

const gracefulShutdown = (signal: string) => {
  console.log(`[BattleGround Server] Received ${signal}. Shutting down gracefully...`);
  server.close(() => {
    console.log('[BattleGround Server] HTTP server closed cleanly.');
    process.exit(0);
  });

  // Force close if graceful shutdown takes too long (10s)
  setTimeout(() => {
    console.error('[BattleGround Server] Could not close connections in time, forcefully shutting down');
    process.exit(1);
  }, 10000);
};

process.on('SIGTERM', () => gracefulShutdown('SIGTERM'));
process.on('SIGINT', () => gracefulShutdown('SIGINT'));

