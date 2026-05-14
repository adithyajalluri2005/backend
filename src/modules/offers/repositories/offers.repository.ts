import { Injectable } from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { PrismaService } from '../../../prisma/prisma.service';

@Injectable()
export class OffersRepository {
  constructor(private readonly prisma: PrismaService) {}

  create(data: Prisma.OfferUncheckedCreateInput) {
    return this.prisma.offer.create({
      data,
      include: { product: { include: { shop: true } } },
    });
  }

  findActive() {
    const now = new Date();

    return this.prisma.offer.findMany({
      where: {
        isActive: true,
        start_time: { lte: now },
        end_time: { gte: now },
      },
      orderBy: { end_time: 'asc' },
      include: {
        product: { include: { shop: true } },
      },
    });
  }

  findById(id: string) {
    return this.prisma.offer.findUnique({
      where: { id },
      include: { product: { include: { shop: true } } },
    });
  }

  deactivate(id: string) {
    return this.prisma.offer.update({
      where: { id },
      data: { isActive: false },
      include: { product: { include: { shop: true } } },
    });
  }
}
