import {
  Controller,
  Delete,
  Get,
  Param,
  Post,
  UseGuards,
} from '@nestjs/common';
import { CurrentUser } from '../../common/decorators/current-user.decorator';
import type { AuthenticatedUser } from '../../common/decorators/current-user.decorator';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { apiResponse } from '../../utils/response.util';
import { SavedService } from './saved.service';

@Controller('saved')
@UseGuards(JwtAuthGuard)
export class SavedController {
  constructor(private readonly savedService: SavedService) {}

  @Post('shops/:shopId')
  async saveShop(
    @Param('shopId') shopId: string,
    @CurrentUser() user: AuthenticatedUser,
  ) {
    return apiResponse(
      'Shop saved',
      await this.savedService.saveShop(shopId, user),
    );
  }

  @Delete('shops/:shopId')
  async removeShop(
    @Param('shopId') shopId: string,
    @CurrentUser() user: AuthenticatedUser,
  ) {
    await this.savedService.removeShop(shopId, user);
    return apiResponse('Saved shop removed', { shopId });
  }

  @Get('shops')
  async listShops(@CurrentUser() user: AuthenticatedUser) {
    return apiResponse(
      'Saved shops fetched',
      await this.savedService.listShops(user),
    );
  }

  @Post('products/:productId')
  async saveProduct(
    @Param('productId') productId: string,
    @CurrentUser() user: AuthenticatedUser,
  ) {
    return apiResponse(
      'Product saved',
      await this.savedService.saveProduct(productId, user),
    );
  }

  @Delete('products/:productId')
  async removeProduct(
    @Param('productId') productId: string,
    @CurrentUser() user: AuthenticatedUser,
  ) {
    await this.savedService.removeProduct(productId, user);
    return apiResponse('Saved product removed', { productId });
  }

  @Get('products')
  async listProducts(@CurrentUser() user: AuthenticatedUser) {
    return apiResponse(
      'Saved products fetched',
      await this.savedService.listProducts(user),
    );
  }
}
