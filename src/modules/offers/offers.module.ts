import { Module } from '@nestjs/common';
import { ShopsModule } from '../shops/shops.module';
import { OffersController } from './offers.controller';
import { OffersService } from './offers.service';
import { OffersRepository } from './repositories/offers.repository';

@Module({
  imports: [ShopsModule],
  controllers: [OffersController],
  providers: [OffersService, OffersRepository],
  exports: [OffersService, OffersRepository],
})
export class OffersModule {}
