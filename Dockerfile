# Étape 1 : installation et compilation
FROM node:22-alpine AS builder

WORKDIR /usr/src/app

RUN corepack enable \
    && corepack prepare pnpm@9.15.9 --activate

COPY package.json pnpm-lock.yaml ./

RUN pnpm install --frozen-lockfile

COPY . .

RUN pnpm run build

# Supprime les dépendances de développement
RUN pnpm prune --prod


# Étape 2 : image de production
FROM node:22-alpine AS production

WORKDIR /usr/src/app

ENV NODE_ENV=production
ENV PORT=8080

COPY --from=builder /usr/src/app/package.json ./package.json
COPY --from=builder /usr/src/app/node_modules ./node_modules
COPY --from=builder /usr/src/app/dist ./dist

EXPOSE 8080

CMD ["node", "dist/main.js"]
