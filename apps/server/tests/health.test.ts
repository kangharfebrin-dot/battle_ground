import request from 'supertest';
import { createApp } from '../src/app';

describe('Express Backend Health API', () => {
  const app = createApp();

  describe('GET /api/v1/health', () => {
    it('harus mengembalikan status 200 dan payload HealthStatusResponse yang valid', async () => {
      const response = await request(app).get('/api/v1/health');

      expect(response.status).toBe(200);
      expect(response.headers['content-type']).toMatch(/json/);
      expect(response.body).toHaveProperty('status', 'ok');
      expect(response.body).toHaveProperty('service', 'battleground-server');
      expect(response.body).toHaveProperty('timestamp');
      expect(response.body).toHaveProperty('uptime');
      expect(typeof response.body.uptime).toBe('number');
      expect(response.body).toHaveProperty('environment');
      expect(response.body).toHaveProperty('version', '0.1.0');

      // Validasi format ISO timestamp
      expect(new Date(response.body.timestamp).toISOString()).toBe(response.body.timestamp);
    });

    it('harus menyertakan security headers dari helmet', async () => {
      const response = await request(app).get('/api/v1/health');
      expect(response.headers).toHaveProperty('x-content-type-options', 'nosniff');
    });
  });

  describe('Handling Unknown Routes', () => {
    it('harus mengembalikan HTTP 404 untuk rute yang tidak terdaftar', async () => {
      const response = await request(app).get('/api/v1/non-existent-route');

      expect(response.status).toBe(404);
      expect(response.body).toEqual({
        error: {
          message: 'Route Not Found'
        }
      });
    });
  });
});

