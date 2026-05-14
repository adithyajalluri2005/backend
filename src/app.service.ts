import { Injectable } from '@nestjs/common';

@Injectable()
export class AppService {
  health() {
    return {
      service: 'local-vyapari-api',
      status: 'ok',
      uptime: process.uptime(),
    };
  }
}
