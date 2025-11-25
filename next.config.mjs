/** @type {import('next').NextConfig} */
const nextConfig = {
  eslint: {
    // Esto hace que los errores de ESLint NO tumben el build en Vercel
    ignoreDuringBuilds: true,
  },
};

export default nextConfig;
