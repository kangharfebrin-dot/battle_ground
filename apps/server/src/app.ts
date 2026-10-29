import express, { Express } from 'express';
import cors from 'cors';
import helmet from 'helmet';
import { loadConfig } from './config/env';
import healthRoutes from './routes/health.routes';
import { errorHandler } from './middleware/error.middleware';
import { notFoundHandler } from './middleware/notFound.middleware';

export function createApp(): Express {
  const config = loadConfig();
  const app = express();

  // Security Headers
  app.use(helmet());

  // CORS Configuration
  app.use(
    cors({
      origin: config.corsOrigin === '*' ? true : config.corsOrigin,
      credentials: true
    })
  );

  // Body Parser with strict limit (10kb) to prevent payload exhaustion
  app.use(express.json({ limit: '10kb' }));

  // Routes
  app.use('/api/v1', healthRoutes);

  // 404 Handler
  app.use(notFoundHandler);

  // Centralized Error Handler
  app.use(errorHandler);

  return app;
}

