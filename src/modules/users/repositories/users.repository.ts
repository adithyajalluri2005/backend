import { Injectable } from '@nestjs/common';
import { Prisma, User } from '@prisma/client';
import type { UserRole } from '../../../common/constants/roles';
import { PrismaService } from '../../../prisma/prisma.service';

export type UserWithPassword = User & { passwordHash?: string | null };

@Injectable()
export class UsersRepository {
  constructor(private readonly prisma: PrismaService) {}

  findById(id: string) {
    return this.prisma.user.findUnique({ where: { id } });
  }

  async findByEmail(email: string): Promise<UserWithPassword | null> {
    const users = await this.prisma.$queryRaw<UserWithPassword[]>`
      SELECT
        id,
        full_name,
        email,
        phone_number,
        role,
        is_phone_verified,
        created_at AS "createdAt",
        updated_at AS "updatedAt",
        password_hash AS "passwordHash"
      FROM users
      WHERE email = ${email}
      LIMIT 1
    `;

    return users[0] ?? null;
  }

  create(data: {
    email: string;
    passwordHash: string;
    name?: string;
    phone?: string;
    role: UserRole;
  }): Promise<UserWithPassword> {
    return this.prisma.$queryRaw<UserWithPassword[]>`
      INSERT INTO users (full_name, email, phone_number, role, password_hash)
      VALUES (${data.name ?? 'User'}, ${data.email}, ${data.phone ?? data.email}, ${data.role}, ${data.passwordHash})
      RETURNING
        id,
        full_name,
        email,
        phone_number,
        role,
        is_phone_verified,
        created_at AS "createdAt",
        updated_at AS "updatedAt",
        password_hash AS "passwordHash"
    `.then((users) => users[0]);
  }

  update(id: string, data: Prisma.UserUpdateInput) {
    return this.prisma.user.update({ where: { id }, data });
  }
}
