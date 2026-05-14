# Local Vyapari Backend

Production-grade NestJS API for a hyperlocal product discovery and local offers platform.

## Stack

- NestJS + TypeScript
- Prisma ORM
- PostgreSQL + PostGIS on Supabase
- JWT authentication
- DTO validation with `class-validator` and `class-transformer`

## Structure

```text
src/
├── modules/
│   ├── auth/
│   ├── users/
│   ├── shops/
│   ├── products/
│   ├── offers/
│   └── search/
├── prisma/
├── common/
├── config/
├── utils/
└── main.ts
```

## Setup

1. Install dependencies:

```bash
npm install
```

2. Create `.env` from `.env.example` and fill Supabase values:

```bash
cp .env.example .env
```

3. Pull the existing Supabase schema when `DATABASE_URL` is available:

```bash
npm run prisma:pull
```

4. Generate Prisma Client:

```bash
npm run prisma:generate
```

5. Start the API:

```bash
npm run start:dev
```

The API is served under:

```text
http://localhost:3000/api/v1
```

Swagger docs are served under:

```text
http://localhost:3000/api/docs
```

## Required Environment Variables

```text
DATABASE_URL
JWT_SECRET
SUPABASE_URL
SUPABASE_KEY
CLOUDINARY_CLOUD_NAME
CLOUDINARY_API_KEY
CLOUDINARY_API_SECRET
PORT
```

`JWT_SECRET` should be a long random value in production.

## API Endpoints

### Auth

- `POST /api/v1/auth/register`
- `POST /api/v1/auth/login`

### Shops

- `POST /api/v1/shops` requires `merchant` or `admin`
- `PATCH /api/v1/shops/:id` requires shop owner or `admin`
- `POST /api/v1/shops/:id/image` uploads shop image to Cloudinary
- `GET /api/v1/shops/:id`
- `GET /api/v1/shops/nearby?latitude=12.9716&longitude=77.5946&radiusKm=5`

### Products

- `POST /api/v1/products` requires `merchant` or `admin`
- `PATCH /api/v1/products/:id` requires product shop owner or `admin`
- `DELETE /api/v1/products/:id` soft-deletes a product
- `POST /api/v1/products/:id/image` uploads product image to Cloudinary
- `GET /api/v1/products?q=headphones&page=1&limit=20`
- `GET /api/v1/products/:id`

### Offers

- `POST /api/v1/offers` requires `merchant` or `admin`
- `PATCH /api/v1/offers/:id/deactivate` requires offer product shop owner or `admin`
- `GET /api/v1/offers/active`

### Search

- `GET /api/v1/search/products-nearby?latitude=12.9716&longitude=77.5946&radiusKm=5&q=earbuds`
- `POST /api/v1/search/history` requires JWT
- `GET /api/v1/search/history` requires JWT
- `DELETE /api/v1/search/history` requires JWT

### Saved Items

- `POST /api/v1/saved/shops/:shopId` requires JWT
- `DELETE /api/v1/saved/shops/:shopId` requires JWT
- `GET /api/v1/saved/shops` requires JWT
- `POST /api/v1/saved/products/:productId` requires JWT
- `DELETE /api/v1/saved/products/:productId` requires JWT
- `GET /api/v1/saved/products` requires JWT

### Merchant Dashboard

- `GET /api/v1/merchant/dashboard` requires `merchant` or `admin`

## Geo Search

Normal CRUD uses Prisma model APIs. Geo queries use parameterized Prisma raw SQL with PostGIS:

- `ST_DWithin` filters shops/products by radius
- `ST_Distance` returns distance in kilometers
- No unsafe raw SQL interpolation is used

The `shops.location` PostGIS column should be a `geometry(Point,4326)` or compatible geography-backed point. A recommended index:

```sql
CREATE INDEX IF NOT EXISTS shops_location_gix ON shops USING GIST (location);
```

## Password Authentication Column

The current Supabase schema pulled by Prisma uses `users.full_name`, `users.phone_number`, and string roles, but it does not expose a password column. JWT login/register in this backend expects a bcrypt hash column:

```sql
ALTER TABLE users ADD COLUMN IF NOT EXISTS password_hash text;
```

After adding it in Supabase, run:

```bash
npm run prisma:pull
npm run prisma:generate
```

The repository reads and writes `password_hash` with parameterized SQL so the rest of the Prisma model can stay aligned with your existing database.

## Cloudinary Image Uploads

Image uploads are routed through the backend so merchant ownership and file validation are enforced before Cloudinary receives the file.

Allowed formats:

- `image/jpeg`
- `image/png`
- `image/webp`

Maximum size: `5MB`.

PowerShell test examples:

```powershell
$response = Invoke-RestMethod -Method Post `
  -Uri "$base/shops/$shopId/image" `
  -Headers @{ Authorization = "Bearer $token" } `
  -Form @{ file = Get-Item "D:\images\shop.jpg" }

$response | ConvertTo-Json -Depth 10
```

```powershell
$response = Invoke-RestMethod -Method Post `
  -Uri "$base/products/$productId/image" `
  -Headers @{ Authorization = "Bearer $token" } `
  -Form @{ file = Get-Item "D:\images\product.jpg" }

$response | ConvertTo-Json -Depth 10
```

The returned Cloudinary `secure_url` is stored in:

- `shops.shop_image_url`
- `products.image_url`

## Saved Items Tables

Create these tables in Supabase before using saved shop/product APIs:

```sql
CREATE TABLE IF NOT EXISTS saved_shops (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  shop_id uuid NOT NULL REFERENCES shops(id) ON DELETE CASCADE,
  created_at timestamp DEFAULT now(),
  UNIQUE (user_id, shop_id)
);

CREATE TABLE IF NOT EXISTS saved_products (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  product_id uuid NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  created_at timestamp DEFAULT now(),
  UNIQUE (user_id, product_id)
);
```

## Roles

Supported roles:

- `customer`
- `merchant`
- `admin`

Merchant/admin access is enforced with JWT and `RolesGuard`.
