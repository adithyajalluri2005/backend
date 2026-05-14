import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../../prisma/prisma.service';

interface CreateShopData {
  ownerId: string;
  name: string;
  description?: string;
  address: string;
  phone?: string;
  latitude: number;
  longitude: number;
}

interface UpdateShopData {
  name?: string;
  description?: string;
  address?: string;
  phone?: string;
  shopImageUrl?: string;
  latitude?: number;
  longitude?: number;
}

@Injectable()
export class ShopsRepository {
  constructor(private readonly prisma: PrismaService) {}

  async create(data: CreateShopData) {
    const shops = await this.prisma.$queryRaw<{ id: string }[]>`
      INSERT INTO shops (
        owner_id,
        shop_name,
        description,
        phone_number,
        address,
        location,
        verification_status,
        is_active
      )
      VALUES (
        ${data.ownerId}::uuid,
        ${data.name},
        ${data.description ?? null},
        ${data.phone ?? ''},
        ${data.address},
        ST_SetSRID(ST_MakePoint(${data.longitude}, ${data.latitude}), 4326)::geography,
        'pending',
        true
      )
      RETURNING id
    `;

    return this.findById(shops[0].id);
  }

  findById(id: string) {
    return this.prisma.shop.findFirst({
      where: { id, isActive: true },
      include: {
        products: { where: { isActive: true }, take: 20 },
      },
    });
  }

  findOwnedById(id: string, ownerId: string) {
    return this.prisma.shop.findFirst({
      where: { id, ownerId, isActive: true },
    });
  }

  findNearby(latitude: number, longitude: number, radiusKm: number) {
    return this.prisma.$queryRaw`
      SELECT
        s.id,
        s.shop_name AS name,
        s.description,
        s.address,
        s.phone_number AS phone,
        ST_Y(s.location::geometry) AS latitude,
        ST_X(s.location::geometry) AS longitude,
        ROUND((ST_Distance(s.location::geography, ST_SetSRID(ST_MakePoint(${longitude}, ${latitude}), 4326)::geography) / 1000)::numeric, 2) AS "distanceKm",
        COALESCE(
          json_agg(DISTINCT o.*) FILTER (
            WHERE o.id IS NOT NULL
              AND o.is_active = true
              AND o.start_time <= NOW()
              AND o.end_time >= NOW()
          ),
          '[]'
        ) AS offers
      FROM shops s
      LEFT JOIN products p ON p.shop_id = s.id
      LEFT JOIN offers o ON o.product_id = p.id
      WHERE s.is_active = true
        AND s.location IS NOT NULL
        AND ST_DWithin(
          s.location::geography,
          ST_SetSRID(ST_MakePoint(${longitude}, ${latitude}), 4326)::geography,
          ${radiusKm * 1000}
        )
      GROUP BY s.id
      ORDER BY "distanceKm" ASC
    `;
  }

  async update(id: string, data: UpdateShopData) {
    await this.prisma.shop.update({
      where: { id },
      data: {
        shop_name: data.name,
        description: data.description,
        address: data.address,
        phone_number: data.phone,
        shop_image_url: data.shopImageUrl,
      },
    });

    if (data.latitude !== undefined && data.longitude !== undefined) {
      await this.prisma.$executeRaw`
        UPDATE shops
        SET location = ST_SetSRID(ST_MakePoint(${data.longitude}, ${data.latitude}), 4326)::geography
        WHERE id = ${id}::uuid
      `;
    }

    return this.findById(id);
  }

  updateImage(id: string, imageUrl: string) {
    return this.prisma.shop.update({
      where: { id },
      data: { shop_image_url: imageUrl },
      include: {
        products: { where: { isActive: true }, take: 20 },
      },
    });
  }
}
