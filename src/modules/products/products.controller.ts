import {
  Body,
  Controller,
  Get,
  Delete,
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
import { CreateProductDto } from './dto/create-product.dto';
import { ProductQueryDto } from './dto/product-query.dto';
import { UpdateProductDto } from './dto/update-product.dto';
import { ProductsService } from './products.service';
import type { UploadedImageFile } from '../storage/storage.service';

@Controller('products')
export class ProductsController {
  constructor(private readonly productsService: ProductsService) {}

  @Post()
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(AppRole.merchant, AppRole.admin)
  async create(
    @Body() dto: CreateProductDto,
    @CurrentUser() user: AuthenticatedUser,
  ) {
    return apiResponse(
      'Product created',
      await this.productsService.create(dto, user),
    );
  }

  @Get()
  async findMany(@Query() query: ProductQueryDto) {
    return apiResponse(
      'Products fetched',
      await this.productsService.findMany(query),
    );
  }

  @Get(':id')
  async findById(@Param('id') id: string) {
    return apiResponse(
      'Product fetched',
      await this.productsService.findById(id),
    );
  }

  @Patch(':id')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(AppRole.merchant, AppRole.admin)
  async update(
    @Param('id') id: string,
    @Body() dto: UpdateProductDto,
    @CurrentUser() user: AuthenticatedUser,
  ) {
    return apiResponse(
      'Product updated',
      await this.productsService.update(id, dto, user),
    );
  }

  @Delete(':id')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(AppRole.merchant, AppRole.admin)
  async remove(
    @Param('id') id: string,
    @CurrentUser() user: AuthenticatedUser,
  ) {
    return apiResponse(
      'Product deleted',
      await this.productsService.remove(id, user),
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
      'Product image uploaded',
      await this.productsService.uploadImage(id, file, user),
    );
  }
}
