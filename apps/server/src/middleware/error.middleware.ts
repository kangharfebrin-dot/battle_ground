import { Request, Response, NextFunction } from 'express';

export const errorHandler = (
  err: Error,
  _req: Request,
  res: Response,
  _next: NextFunction
): void => {
  const isProduction = process.env.NODE_ENV === 'production';

  // Log error tanpa membocorkan kredensial, token, atau informasi privat
  console.error('[ServerError]', {
    name: err.name,
    message: err.message,
    timestamp: new Date().toISOString()
  });

  res.status(500).json({
    error: {
      message: isProduction ? 'Internal Server Error' : err.message
    }
  });
};

