import {
  Body,
  Controller,
  Delete,
  Get,
  Post,
  Query,
  UseGuards,
} from '@nestjs/common';
import { CurrentUser } from '../../common/decorators/current-user.decorator';
import type { AuthenticatedUser } from '../../common/decorators/current-user.decorator';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { apiResponse } from '../../utils/response.util';
import { CreateSearchHistoryDto } from './dto/create-search-history.dto';
import { ProductsNearbyQueryDto } from './dto/products-nearby-query.dto';
import { SearchService } from './search.service';

@Controller('search')
export class SearchController {
  constructor(private readonly searchService: SearchService) {}

  @Get('products-nearby')
  async productsNearby(@Query() query: ProductsNearbyQueryDto) {
    return apiResponse(
      'Nearby products fetched',
      await this.searchService.productsNearby(query),
    );
  }

  @Post('history')
  @UseGuards(JwtAuthGuard)
  async saveHistory(
    @Body() dto: CreateSearchHistoryDto,
    @CurrentUser() user: AuthenticatedUser,
  ) {
    return apiResponse(
      'Search history saved',
      await this.searchService.saveHistory(dto, user),
    );
  }

  @Get('history')
  @UseGuards(JwtAuthGuard)
  async history(@CurrentUser() user: AuthenticatedUser) {
    return apiResponse(
      'Search history fetched',
      await this.searchService.listHistory(user),
    );
  }

  @Delete('history')
  @UseGuards(JwtAuthGuard)
  async clearHistory(@CurrentUser() user: AuthenticatedUser) {
    return apiResponse(
      'Search history cleared',
      await this.searchService.clearHistory(user),
    );
  }
}
