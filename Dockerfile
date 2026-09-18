FROM node:18-bookworm

WORKDIR /app

# Build tools install karein C++ modules (isolated-vm) ke liye
RUN apt-get update && apt-get install -y python3 build-essential && rm -rf /var/lib/apt/lists/*

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
