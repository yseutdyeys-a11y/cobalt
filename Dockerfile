FROM node:20-bookworm

WORKDIR /app

# Corepack aur pnpm setup
RUN corepack enable && corepack prepare pnpm@latest --activate

# Repository files copy karein
COPY . .

# Dependencies install karein
RUN pnpm install --no-frozen-lockfile

# Cobalt API build karein
RUN pnpm --filter=api build

EXPOSE 9000

ENV PORT=9000
ENV NODE_ENV=production

CMD ["pnpm", "--filter=api", "start"]
