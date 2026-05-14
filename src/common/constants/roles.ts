export const AppRole = {
  customer: 'customer',
  merchant: 'merchant',
  admin: 'admin',
} as const;

export type UserRole = (typeof AppRole)[keyof typeof AppRole];

export const USER_ROLES = Object.values(AppRole);
