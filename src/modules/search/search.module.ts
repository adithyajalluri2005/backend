import { Module } from '@nestjs/common';
import { SearchRepository } from './repositories/search.repository';
import { SearchController } from './search.controller';
import { SearchService } from './search.service';

@Module({
  controllers: [SearchController],
  providers: [SearchService, SearchRepository],
})
export class SearchModule {}
