import { Injectable } from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { PrismaService } from '../../../prisma/prisma.service';
import { ProductQueryDto } from '../dto/product-query.dto';

@Injectable()
export class ProductsRepository {
  constructor(private readonly prisma: PrismaService) {}

  create(data: Prisma.ProductUncheckedCreateInput) {
    return this.prisma.product.create({
      data,
      include: { shop: true, category: true, offers: true },
    });
  }

  async findMany(query: ProductQueryDto) {
    const where: Prisma.ProductWhereInput = {
      isActive: true,
      ...(query.shopId ? { shopId: query.shopId } : {}),
      ...(query.categoryId ? { categoryId: query.categoryId } : {}),
      ...(query.q
        ? {
            OR: [
              { product_name: { contains: query.q, mode: 'insensitive' } },
              { description: { contains: query.q, mode: 'insensitive' } },
            ],
          }
        : {}),
    };
    const skip = (query.page - 1) * query.limit;

    const [items, total] = await Promise.all([
      this.prisma.product.findMany({
        where,
        skip,
        take: query.limit,
        orderBy: { createdAt: 'desc' },
        include: {
          shop: true,
          category: true,
          offers: {
            where: {
              isActive: true,
              start_time: { lte: new Date() },
              end_time: { gte: new Date() },
            },
          },
        },
      }),
      this.prisma.product.count({ where }),
    ]);

    return { items, total };
  }

  findById(id: string) {
    return this.prisma.product.findFirst({
      where: { id, isActive: true },
      include: {
        shop: true,
        category: true,
        offers: {
          where: {
            isActive: true,
            start_time: { lte: new Date() },
            end_time: { gte: new Date() },
          },
        },
      },
    });
  }

  update(id: string, data: Prisma.ProductUpdateInput) {
    return this.prisma.product.update({
      where: { id },
      data,
      include: { shop: true, category: true, offers: true },
    });
  }

  softDelete(id: string) {
    return this.prisma.product.update({
      where: { id },
      data: { isActive: false },
    });
  }

  updateImage(id: string, imageUrl: string) {
    return this.prisma.product.update({
      where: { id },
      data: { imageUrl },
      include: { shop: true, category: true, offers: true },
    });
  }
}
