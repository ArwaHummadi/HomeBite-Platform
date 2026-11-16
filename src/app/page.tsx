import { prisma } from "@/server/db";

// Read the database on every visit (not only once when the site is built).
export const dynamic = "force-dynamic";

// Home page. For now it only shows what is in the database,
// to check that the website and the database work together.
export default async function HomePage() {
  let cities: { id: number; nameAr: string; nameEn: string }[] = [];
  let settingsCount = 0;
  let connected = true;

  try {
    cities = await prisma.city.findMany({ orderBy: { id: "asc" } });
    settingsCount = await prisma.platformSetting.count();
  } catch (error) {
    // Visitors only see a short message on the page. The details are for us, in the terminal.
    console.error("Could not read the database. Is it running? Try: npm run setup", error);
    connected = false;
  }

  return (
    <main>
      <h1>HomeBite</h1>

      {connected ? (
        <>
          <h2>المدن ({cities.length})</h2>
          <ul>
            {cities.map((city) => (
              <li key={city.id}>
                {city.nameAr} - {city.nameEn}
              </li>
            ))}
          </ul>
          <p>عدد إعدادات المنصة: {settingsCount}</p>
        </>
      ) : (
        <p>الموقع غير متاح حالياً. حاول مرة أخرى بعد قليل.</p>
      )}
    </main>
  );
}
