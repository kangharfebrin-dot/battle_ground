export interface HealthStatusResponse {
  status: 'ok' | 'degraded' | 'down';
  service: string;
  timestamp: string;
  uptime: number;
  environment: string;
  version: string;
}

export interface ApiErrorResponse {
  error: {
    message: string;
    code?: string;
  };
}

