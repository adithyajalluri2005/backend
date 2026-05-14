import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../../prisma/prisma.service';

@Injectable()
export class SearchRepository {
  constructor(private readonly prisma: PrismaService) {}

  productsNearby(
    latitude: number,
    longitude: number,
    radiusKm: number,
    q?: string,
  ) {
    const searchPattern = q ? `%${q}%` : null;

    return this.prisma.$queryRaw`
      SELECT
        json_build_object(
          'id', p.id,
          'name', p.product_name,
          'description', p.description,
          'imageUrl', p.image_url,
          'price', p.actual_price,
          'offerPrice', p.offer_price,
          'stock', p.stock_quantity
        ) AS product,
        json_build_object(
          'id', s.id,
          'name', s.shop_name,
          'address', s.address,
          'phone', s.phone_number,
          'latitude', ST_Y(s.location::geometry),
          'longitude', ST_X(s.location::geometry)
        ) AS shop,
        COALESCE(
          json_agg(
            json_build_object(
              'id', o.id,
              'title', o.title,
              'description', o.description,
              'discountPercentage', o.discount_percentage,
              'startsAt', o.start_time,
              'endsAt', o.end_time
            )
          ) FILTER (WHERE o.id IS NOT NULL),
          '[]'
        ) AS offers,
        ROUND((ST_Distance(s.location::geography, ST_SetSRID(ST_MakePoint(${longitude}, ${latitude}), 4326)::geography) / 1000)::numeric, 2) AS "distanceKm"
      FROM products p
      INNER JOIN shops s ON s.id = p.shop_id
      LEFT JOIN offers o
        ON o.product_id = p.id
        AND o.is_active = true
        AND o.start_time <= NOW()
        AND o.end_time >= NOW()
      WHERE p.is_active = true
        AND s.is_active = true
        AND s.location IS NOT NULL
        AND (${searchPattern}::text IS NULL OR p.product_name ILIKE ${searchPattern} OR p.description ILIKE ${searchPattern})
        AND ST_DWithin(
          s.location::geography,
          ST_SetSRID(ST_MakePoint(${longitude}, ${latitude}), 4326)::geography,
          ${radiusKm * 1000}
        )
      GROUP BY p.id, s.id
      ORDER BY "distanceKm" ASC, p.product_name ASC
    `;
  }

  saveHistory(userId: string, query: string) {
    return this.prisma.search_history.create({
      data: {
        user_id: userId,
        search_query: query,
      },
    });
  }

  listHistory(userId: string) {
    return this.prisma.search_history.findMany({
      where: { user_id: userId },
      orderBy: { searched_at: 'desc' },
      take: 50,
    });
  }

  clearHistory(userId: string) {
    return this.prisma.search_history.deleteMany({
      where: { user_id: userId },
    });
  }
}
