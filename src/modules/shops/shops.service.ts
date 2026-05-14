import { Injectable, NotFoundException } from '@nestjs/common';
import { AppRole } from '../../common/constants/roles';
import { CreateShopDto } from './dto/create-shop.dto';
import { NearbyShopsQueryDto } from './dto/nearby-shops-query.dto';
import { UpdateShopDto } from './dto/update-shop.dto';
import { ShopsRepository } from './repositories/shops.repository';
import { AuthenticatedUser } from '../../common/decorators/current-user.decorator';
import { StorageService, UploadedImageFile } from '../storage/storage.service';

@Injectable()
export class ShopsService {
  constructor(
    private readonly shopsRepository: ShopsRepository,
    private readonly storageService: StorageService,
  ) {}

  create(dto: CreateShopDto, user: AuthenticatedUser) {
    return this.shopsRepository.create({
      ownerId: user.sub,
      name: dto.name,
      description: dto.description,
      address: dto.address,
      phone: dto.phone,
      latitude: dto.latitude,
      longitude: dto.longitude,
    });
  }

  async findById(id: string) {
    const shop = await this.shopsRepository.findById(id);

    if (!shop) {
      throw new NotFoundException('Shop not found');
    }

    return shop;
  }

  findNearby(query: NearbyShopsQueryDto) {
    return this.shopsRepository.findNearby(
      query.latitude,
      query.longitude,
      query.radiusKm,
    );
  }

  async assertCanManageShop(shopId: string, user: AuthenticatedUser) {
    if (user.role === AppRole.admin) {
      return;
    }

    const shop = await this.shopsRepository.findOwnedById(shopId, user.sub);

    if (!shop) {
      throw new NotFoundException('Shop not found for this merchant');
    }
  }

  async update(id: string, dto: UpdateShopDto, user: AuthenticatedUser) {
    await this.assertCanManageShop(id, user);

    return this.shopsRepository.update(id, {
      name: dto.name,
      description: dto.description,
      address: dto.address,
      phone: dto.phone,
      shopImageUrl: dto.shopImageUrl,
      latitude: dto.latitude,
      longitude: dto.longitude,
    });
  }

  async uploadImage(
    id: string,
    file: UploadedImageFile,
    user: AuthenticatedUser,
  ) {
    await this.assertCanManageShop(id, user);

    const image = await this.storageService.uploadImage(
      file,
      'local-vyapari/shops',
    );
    const shop = await this.shopsRepository.updateImage(id, image.url);

    return { shop, image };
  }
}
