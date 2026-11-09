import type { Metadata } from "next";
import "./globals.css";

// Shared frame for every page of the site: language, direction and the browser tab title.
export const metadata: Metadata = {
  title: "HomeBite",
  description: "Web platform connecting home cooks with customers and drivers",
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="ar" dir="rtl">
      <body>{children}</body>
    </html>
  );
}
