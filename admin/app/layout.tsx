import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "MartoraX Admin",
  description: "Control panel for the MartoraX marketplace",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}
