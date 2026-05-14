import { Module } from '@nestjs/common';
import { SavedRepository } from './repositories/saved.repository';
import { SavedController } from './saved.controller';
import { SavedService } from './saved.service';

@Module({
  controllers: [SavedController],
  providers: [SavedService, SavedRepository],
})
export class SavedModule {}
