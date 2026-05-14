import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../../prisma/prisma.service';

@Injectable()
export class DashboardRepository {
  constructor(private readonly prisma: PrismaService) {}

  merchantSummary(ownerId: string) {
    return this.prisma.$queryRaw`
      SELECT
        COUNT(DISTINCT s.id)::int AS "totalShops",
        COUNT(DISTINCT p.id)::int AS "totalProducts",
        COUNT(DISTINCT o.id)::int AS "totalOffers",
        COUNT(DISTINCT o.id) FILTER (
          WHERE o.is_active = true AND o.start_time <= NOW() AND o.end_time >= NOW()
        )::int AS "activeOffers",
        COALESCE(
          json_agg(
            DISTINCT jsonb_build_object(
              'id', s.id,
              'name', s.shop_name,
              'products', (
                SELECT COUNT(*)::int FROM products p2
                WHERE p2.shop_id = s.id AND p2.is_active = true
              ),
              'activeOffers', (
                SELECT COUNT(*)::int
                FROM products p3
                INNER JOIN offers o3 ON o3.product_id = p3.id
                WHERE p3.shop_id = s.id
                  AND o3.is_active = true
                  AND o3.start_time <= NOW()
                  AND o3.end_time >= NOW()
              )
            )
          ) FILTER (WHERE s.id IS NOT NULL),
          '[]'
        ) AS shops
      FROM shops s
      LEFT JOIN products p ON p.shop_id = s.id AND p.is_active = true
      LEFT JOIN offers o ON o.product_id = p.id
      WHERE s.owner_id = ${ownerId}::uuid AND s.is_active = true
    `;
  }
}
