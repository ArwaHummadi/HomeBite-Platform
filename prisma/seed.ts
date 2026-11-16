// Puts the starting data in the database: the cities and the platform settings.
// You can run it more than once; it empties the two tables first, so nothing is added twice.
// Run with: npm run db:seed
import "dotenv/config";
import { PrismaClient } from "@prisma/client";
import { SETTING_DEFS } from "@/domain/settings";
import { CITIES } from "./seed/data";

const prisma = new PrismaClient();

async function main() {
  // Empty the tables and start the id numbers from 1 again.
  await prisma.$executeRawUnsafe("TRUNCATE TABLE platform_setting, city RESTART IDENTITY CASCADE");

  // Cities
  await prisma.city.createMany({
    data: CITIES.map(([nameAr, nameEn]) => ({ nameAr, nameEn })),
  });

  // Platform settings with their first values (the administrator can change them later)
  await prisma.platformSetting.createMany({
    data: SETTING_DEFS.map((s) => ({ key: s.key, value: s.default, description: s.description.en })),
  });

  console.log(`Cities added: ${await prisma.city.count()}`);
  console.log(`Settings added: ${await prisma.platformSetting.count()}`);
}

main()
  .catch((error) => {
    console.error(error);
    process.exit(1);
  })
  .finally(() => prisma.$disconnect());
