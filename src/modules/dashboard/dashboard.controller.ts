import { Controller, Get, UseGuards } from '@nestjs/common';
import { AppRole } from '../../common/constants/roles';
import { CurrentUser } from '../../common/decorators/current-user.decorator';
import type { AuthenticatedUser } from '../../common/decorators/current-user.decorator';
import { Roles } from '../../common/decorators/roles.decorator';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { RolesGuard } from '../../common/guards/roles.guard';
import { apiResponse } from '../../utils/response.util';
import { DashboardService } from './dashboard.service';

@Controller('merchant/dashboard')
@UseGuards(JwtAuthGuard, RolesGuard)
@Roles(AppRole.merchant, AppRole.admin)
export class DashboardController {
  constructor(private readonly dashboardService: DashboardService) {}

  @Get()
  async summary(@CurrentUser() user: AuthenticatedUser) {
    return apiResponse(
      'Merchant dashboard fetched',
      await this.dashboardService.merchantSummary(user),
    );
  }
}
