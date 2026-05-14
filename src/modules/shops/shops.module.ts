import { Module } from '@nestjs/common';
import { StorageModule } from '../storage/storage.module';
import { ShopsRepository } from './repositories/shops.repository';
import { ShopsController } from './shops.controller';
import { ShopsService } from './shops.service';

@Module({
  imports: [StorageModule],
  controllers: [ShopsController],
  providers: [ShopsService, ShopsRepository],
  exports: [ShopsService, ShopsRepository],
})
export class ShopsModule {}
