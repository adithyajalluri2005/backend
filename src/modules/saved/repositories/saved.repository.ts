import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../../prisma/prisma.service';

@Injectable()
export class SavedRepository {
  constructor(private readonly prisma: PrismaService) {}

  saveShop(userId: string, shopId: string) {
    return this.prisma.$queryRaw`
      INSERT INTO saved_shops (user_id, shop_id)
      VALUES (${userId}::uuid, ${shopId}::uuid)
      ON CONFLICT (user_id, shop_id) DO NOTHING
      RETURNING id, user_id AS "userId", shop_id AS "shopId", created_at AS "createdAt"
    `;
  }

  removeShop(userId: string, shopId: string) {
    return this.prisma.$executeRaw`
      DELETE FROM saved_shops
      WHERE user_id = ${userId}::uuid AND shop_id = ${shopId}::uuid
    `;
  }

  listShops(userId: string) {
    return this.prisma.$queryRaw`
      SELECT
        ss.id,
        ss.created_at AS "savedAt",
        json_build_object(
          'id', s.id,
          'name', s.shop_name,
          'description', s.description,
          'address', s.address,
          'phone', s.phone_number,
          'imageUrl', s.shop_image_url,
          'latitude', ST_Y(s.location::geometry),
          'longitude', ST_X(s.location::geometry)
        ) AS shop
      FROM saved_shops ss
      INNER JOIN shops s ON s.id = ss.shop_id
      WHERE ss.user_id = ${userId}::uuid AND s.is_active = true
      ORDER BY ss.created_at DESC
    `;
  }

  saveProduct(userId: string, productId: string) {
    return this.prisma.$queryRaw`
      INSERT INTO saved_products (user_id, product_id)
      VALUES (${userId}::uuid, ${productId}::uuid)
      ON CONFLICT (user_id, product_id) DO NOTHING
      RETURNING id, user_id AS "userId", product_id AS "productId", created_at AS "createdAt"
    `;
  }

  removeProduct(userId: string, productId: string) {
    return this.prisma.$executeRaw`
      DELETE FROM saved_products
      WHERE user_id = ${userId}::uuid AND product_id = ${productId}::uuid
    `;
  }

  listProducts(userId: string) {
    return this.prisma.$queryRaw`
      SELECT
        sp.id,
        sp.created_at AS "savedAt",
        json_build_object(
          'id', p.id,
          'name', p.product_name,
          'description', p.description,
          'price', p.actual_price,
          'offerPrice', p.offer_price,
          'imageUrl', p.image_url,
          'stock', p.stock_quantity
        ) AS product,
        json_build_object(
          'id', s.id,
          'name', s.shop_name,
          'address', s.address,
          'phone', s.phone_number
        ) AS shop
      FROM saved_products sp
      INNER JOIN products p ON p.id = sp.product_id
      INNER JOIN shops s ON s.id = p.shop_id
      WHERE sp.user_id = ${userId}::uuid
        AND p.is_active = true
        AND s.is_active = true
      ORDER BY sp.created_at DESC
    `;
  }
}
