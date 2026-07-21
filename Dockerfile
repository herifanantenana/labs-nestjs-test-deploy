FROM node:22-alpine AS base

WORKDIR /usr/src/app

RUN corepack enable

FROM base AS deps

COPY package.json pnpm-lock.yaml ./

RUN corepack prepare pnpm@9 --activate && pnpm install --frozen-lockfile

FROM base AS build

COPY --from=deps /usr/src/app/node_modules ./node_modules
COPY . .

RUN corepack prepare pnpm@9 --activate && pnpm build

FROM node:22-alpine AS production

ENV NODE_ENV=production

WORKDIR /usr/src/app

COPY package.json pnpm-lock.yaml ./

RUN corepack enable && corepack prepare pnpm@9 --activate && pnpm install --frozen-lockfile --prod

COPY --from=build /usr/src/app/dist ./dist

EXPOSE 3000

CMD ["node", "dist/main.js"]
