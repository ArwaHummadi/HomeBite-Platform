# HomeBite-Platform

Web platform connecting home cooks with customers and drivers.

HomeBite lets home cooks (الأسر المنتجة) sell their meals online. Customers order meals from
cooks near them, drivers deliver the orders, and an administrator manages the platform.
The project is developed in steps; this repository grows as each part is completed.

## Technology

- Next.js 15 with React and TypeScript
- PostgreSQL 17 database, running in Docker
- Prisma to define the tables and read and write the data

## Run the project on your computer

1. Install Node.js 20 or newer from https://nodejs.org
2. Install Docker Desktop from https://www.docker.com/products/docker-desktop and open it.
3. Download the code and prepare it:

```bash
git clone https://github.com/ArwaHummadi/HomeBite-Platform.git
cd HomeBite-Platform
npm install
npm run setup
npm run dev
```

4. Open http://localhost:3000 in the browser. The home page lists the cities stored in the database.

`npm run setup` creates the `.env` file, starts the database, creates the tables and adds the
starting data. You only need it the first time (and again if you delete the database).
If you already have the project, run `git pull` and `npm install`, then `npm run setup`.

## The database

The 25 tables follow our ERD. They are written in `prisma/schema.prisma`, and the SQL that creates
them is in `prisma/migrations`. The starting data (20 cities and the platform settings) is added
by `prisma/seed.ts`.

| Command | What it does |
|---|---|
| `npm run db:up` | Start the database |
| `npm run db:down` | Stop the database (the data stays) |
| `npm run db:migrate` | Create any missing tables |
| `npm run db:seed` | Add the starting data again |
| `npm run db:reset` | Delete everything and start again with the starting data |
| `npm run db:studio` | Open Prisma Studio in the browser to see the tables and their rows |

## Project structure

```
prisma/
  schema.prisma        the tables
  migrations/          SQL that creates the tables
  seed.ts              adds the starting data
  seed/data.ts         the list of cities
scripts/setup.ts       the npm run setup command
src/
  app/                 the pages of the website
  domain/settings.ts   the platform settings and their first values
  server/db.ts         the database connection
docker-compose.yml     the database server (PostgreSQL in Docker)
.env.example           example settings; copied to .env on your computer
```
