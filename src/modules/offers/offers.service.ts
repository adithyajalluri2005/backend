import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { AuthenticatedUser } from '../../common/decorators/current-user.decorator';
import { ShopsService } from '../shops/shops.service';
import { CreateOfferDto } from './dto/create-offer.dto';
import { OffersRepository } from './repositories/offers.repository';

@Injectable()
export class OffersService {
  constructor(
    private readonly offersRepository: OffersRepository,
    private readonly shopsService: ShopsService,
  ) {}

  async create(dto: CreateOfferDto, user: AuthenticatedUser) {
    const startsAt = new Date(dto.startsAt);
    const endsAt = new Date(dto.endsAt);

    if (endsAt <= startsAt) {
      throw new BadRequestException('endsAt must be after startsAt');
    }

    if (!dto.discountPercentage && !dto.offerPrice) {
      throw new BadRequestException('Provide discountPercentage or offerPrice');
    }

    await this.shopsService.assertCanManageShop(dto.shopId, user);

    return this.offersRepository.create({
      productId: dto.productId,
      title: dto.title,
      description: dto.description,
      discountPercentage: dto.discountPercentage,
      start_time: startsAt,
      end_time: endsAt,
    });
  }

  findActive() {
    return this.offersRepository.findActive();
  }

  async deactivate(id: string, user: AuthenticatedUser) {
    const offer = await this.offersRepository.findById(id);

    if (!offer) {
      throw new NotFoundException('Offer not found');
    }

    await this.shopsService.assertCanManageShop(offer.product.shopId, user);

    return this.offersRepository.deactivate(id);
  }
}
