import { Injectable } from '@nestjs/common';
import { AuthenticatedUser } from '../../common/decorators/current-user.decorator';
import { DashboardRepository } from './repositories/dashboard.repository';

@Injectable()
export class DashboardService {
  constructor(private readonly dashboardRepository: DashboardRepository) {}

  async merchantSummary(user: AuthenticatedUser) {
    const rows = await this.dashboardRepository.merchantSummary(user.sub);
    return Array.isArray(rows) ? rows[0] : rows;
  }
}
