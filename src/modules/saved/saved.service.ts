import { Injectable } from '@nestjs/common';
import { AuthenticatedUser } from '../../common/decorators/current-user.decorator';
import { SavedRepository } from './repositories/saved.repository';

@Injectable()
export class SavedService {
  constructor(private readonly savedRepository: SavedRepository) {}

  saveShop(shopId: string, user: AuthenticatedUser) {
    return this.savedRepository.saveShop(user.sub, shopId);
  }

  removeShop(shopId: string, user: AuthenticatedUser) {
    return this.savedRepository.removeShop(user.sub, shopId);
  }

  listShops(user: AuthenticatedUser) {
    return this.savedRepository.listShops(user.sub);
  }

  saveProduct(productId: string, user: AuthenticatedUser) {
    return this.savedRepository.saveProduct(user.sub, productId);
  }

  removeProduct(productId: string, user: AuthenticatedUser) {
    return this.savedRepository.removeProduct(user.sub, productId);
  }

  listProducts(user: AuthenticatedUser) {
    return this.savedRepository.listProducts(user.sub);
  }
}
