import { Injectable, NotFoundException } from '@nestjs/common';
import { AuthenticatedUser } from '../../common/decorators/current-user.decorator';
import { ShopsService } from '../shops/shops.service';
import { StorageService, UploadedImageFile } from '../storage/storage.service';
import { CreateProductDto } from './dto/create-product.dto';
import { ProductQueryDto } from './dto/product-query.dto';
import { UpdateProductDto } from './dto/update-product.dto';
import { ProductsRepository } from './repositories/products.repository';

@Injectable()
export class ProductsService {
  constructor(
    private readonly productsRepository: ProductsRepository,
    private readonly shopsService: ShopsService,
    private readonly storageService: StorageService,
  ) {}

  async create(dto: CreateProductDto, user: AuthenticatedUser) {
    await this.shopsService.assertCanManageShop(dto.shopId, user);

    return this.productsRepository.create({
      shopId: dto.shopId,
      categoryId: dto.categoryId,
      product_name: dto.name,
      description: dto.description,
      imageUrl: dto.imageUrl,
      actual_price: dto.price,
      stock_quantity: dto.stock,
    });
  }

  async findMany(query: ProductQueryDto) {
    const { items, total } = await this.productsRepository.findMany(query);

    return {
      items,
      pagination: {
        page: query.page,
        limit: query.limit,
        total,
        totalPages: Math.ceil(total / query.limit),
      },
    };
  }

  async findById(id: string) {
    const product = await this.productsRepository.findById(id);

    if (!product) {
      throw new NotFoundException('Product not found');
    }

    return product;
  }

  async update(id: string, dto: UpdateProductDto, user: AuthenticatedUser) {
    const product = await this.findById(id);
    await this.shopsService.assertCanManageShop(product.shopId, user);

    return this.productsRepository.update(id, {
      category: dto.categoryId
        ? { connect: { id: dto.categoryId } }
        : undefined,
      product_name: dto.name,
      description: dto.description,
      imageUrl: dto.imageUrl,
      actual_price: dto.price,
      offer_price: dto.offerPrice,
      stock_quantity: dto.stock,
    });
  }

  async remove(id: string, user: AuthenticatedUser) {
    const product = await this.findById(id);
    await this.shopsService.assertCanManageShop(product.shopId, user);

    return this.productsRepository.softDelete(id);
  }

  async uploadImage(
    id: string,
    file: UploadedImageFile,
    user: AuthenticatedUser,
  ) {
    const product = await this.findById(id);
    await this.shopsService.assertCanManageShop(product.shopId, user);

    const image = await this.storageService.uploadImage(
      file,
      'local-vyapari/products',
    );
    const updatedProduct = await this.productsRepository.updateImage(
      id,
      image.url,
    );

    return { product: updatedProduct, image };
  }
}
