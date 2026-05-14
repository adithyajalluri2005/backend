import {
  Body,
  Controller,
  Get,
  Param,
  Patch,
  Post,
  Query,
  UploadedFile,
  UseGuards,
  UseInterceptors,
} from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { AppRole } from '../../common/constants/roles';
import { CurrentUser } from '../../common/decorators/current-user.decorator';
import type { AuthenticatedUser } from '../../common/decorators/current-user.decorator';
import { Roles } from '../../common/decorators/roles.decorator';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { RolesGuard } from '../../common/guards/roles.guard';
import { apiResponse } from '../../utils/response.util';
import { CreateShopDto } from './dto/create-shop.dto';
import { NearbyShopsQueryDto } from './dto/nearby-shops-query.dto';
import { UpdateShopDto } from './dto/update-shop.dto';
import { ShopsService } from './shops.service';
import type { UploadedImageFile } from '../storage/storage.service';

@Controller('shops')
export class ShopsController {
  constructor(private readonly shopsService: ShopsService) {}

  @Post()
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(AppRole.merchant, AppRole.admin)
  async create(
    @Body() dto: CreateShopDto,
    @CurrentUser() user: AuthenticatedUser,
  ) {
    return apiResponse(
      'Shop created',
      await this.shopsService.create(dto, user),
    );
  }

  @Get('nearby')
  async nearby(@Query() query: NearbyShopsQueryDto) {
    return apiResponse(
      'Nearby shops fetched',
      await this.shopsService.findNearby(query),
    );
  }

  @Get(':id')
  async findById(@Param('id') id: string) {
    return apiResponse('Shop fetched', await this.shopsService.findById(id));
  }

  @Patch(':id')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(AppRole.merchant, AppRole.admin)
  async update(
    @Param('id') id: string,
    @Body() dto: UpdateShopDto,
    @CurrentUser() user: AuthenticatedUser,
  ) {
    return apiResponse(
      'Shop updated',
      await this.shopsService.update(id, dto, user),
    );
  }

  @Post(':id/image')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(AppRole.merchant, AppRole.admin)
  @UseInterceptors(
    FileInterceptor('file', { limits: { fileSize: 5 * 1024 * 1024 } }),
  )
  async uploadImage(
    @Param('id') id: string,
    @UploadedFile() file: UploadedImageFile,
    @CurrentUser() user: AuthenticatedUser,
  ) {
    return apiResponse(
      'Shop image uploaded',
      await this.shopsService.uploadImage(id, file, user),
    );
  }
}
