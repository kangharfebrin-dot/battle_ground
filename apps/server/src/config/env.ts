import dotenv from 'dotenv';
import path from 'path';

// Load .env from root or current directory
dotenv.config({ path: path.resolve(__dirname, '../../../../.env') });
dotenv.config();

export interface ServerConfig {
  port: number;
  nodeEnv: string;
  corsOrigin: string;
}

export function loadConfig(): ServerConfig {
  const port = parseInt(process.env.PORT || '4000', 10);
  if (isNaN(port) || port <= 0 || port > 65535) {
    throw new Error(`Invalid PORT configuration: "${process.env.PORT}". Must be between 1 and 65535.`);
  }

  return {
    port,
    nodeEnv: process.env.NODE_ENV || 'development',
    corsOrigin: process.env.CORS_ORIGIN || '*'
  };
}

