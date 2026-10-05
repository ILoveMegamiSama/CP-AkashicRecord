import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';
import remarkMath from 'remark-math';
import rehypeKatex from 'rehype-katex';

// https://astro.build/config
export default defineConfig({
  site: 'https://ilovemegamisama.github.io',
  base: process.env.GITHUB_ACTIONS ? '/CP-AkashicRecord' : '/',
  markdown: {
    remarkPlugins: [remarkMath],
    rehypePlugins: [rehypeKatex],
  },
  integrations: [
    starlight({
      title: 'Akashic Record - CP C++14',
      description: 'Cổng thông tin và thư viện tra cứu chuẩn mực cho Lập Trình Thi Đấu C++14',
      defaultLocale: 'root',
      locales: {
        root: {
          label: 'Tiếng Việt',
          lang: 'vi',
        },
      },
      customCss: [
        'katex/dist/katex.min.css',
        './src/styles/custom.css',
      ],
      sidebar: [
        {
          label: 'Tập 1: Nền Tảng C++14 & Tư Duy Bộ Nhớ',
          autogenerate: { directory: 'vol1' },
        },
        {
          label: 'Tập 2: Cấu Trúc Dữ Liệu STL & Kỹ Thuật Cốt Lõi',
          autogenerate: { directory: 'vol2' },
        },
        {
          label: 'Tập 3: Giải Thuật Đồ Thị & Quy Hoạch Động',
          autogenerate: { directory: 'vol3' },
        },
        {
          label: 'Tập 4: Cấu Trúc Dữ Liệu Nâng Cao & Hình Học',
          autogenerate: { directory: 'vol4' },
        },
      ],
      social: {
        github: 'https://github.com/ILoveMegamiSama/CP-AkashicRecord',
      },
    }),
  ],
});
