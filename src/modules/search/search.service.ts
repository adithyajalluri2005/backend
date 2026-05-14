import { Injectable } from '@nestjs/common';
import { AuthenticatedUser } from '../../common/decorators/current-user.decorator';
import { CreateSearchHistoryDto } from './dto/create-search-history.dto';
import { ProductsNearbyQueryDto } from './dto/products-nearby-query.dto';
import { SearchRepository } from './repositories/search.repository';

@Injectable()
export class SearchService {
  constructor(private readonly searchRepository: SearchRepository) {}

  productsNearby(query: ProductsNearbyQueryDto) {
    return this.searchRepository.productsNearby(
      query.latitude,
      query.longitude,
      query.radiusKm,
      query.q,
    );
  }

  saveHistory(dto: CreateSearchHistoryDto, user: AuthenticatedUser) {
    return this.searchRepository.saveHistory(user.sub, dto.query);
  }

  listHistory(user: AuthenticatedUser) {
    return this.searchRepository.listHistory(user.sub);
  }

  clearHistory(user: AuthenticatedUser) {
    return this.searchRepository.clearHistory(user.sub);
  }
}
