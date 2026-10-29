import { Request, Response } from 'express';
import { HealthStatusResponse } from '@battleground/shared';

const SERVER_START_TIME = Date.now();

export const getHealth = (_req: Request, res: Response<HealthStatusResponse>): void => {
  const uptimeSeconds = Math.floor((Date.now() - SERVER_START_TIME) / 1000);

  const payload: HealthStatusResponse = {
    status: 'ok',
    service: 'battleground-server',
    timestamp: new Date().toISOString(),
    uptime: uptimeSeconds,
    environment: process.env.NODE_ENV || 'development',
    version: '0.1.0'
  };

  res.status(200).json(payload);
};

