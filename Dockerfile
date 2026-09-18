FROM node:20-alpine AS base

ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"

RUN corepack enable

FROM base AS build

WORKDIR /app

# Native modules build karne ke liye tools
RUN apk add --no-cache python3 alpine-sdk

COPY pnpm-lock.yaml pnpm-workspace.yaml package.json ./
COPY api/package.json ./api/
COPY packages/ ./packages/

# Dependencies install karein
RUN --mount=type=cache,id=pnpm,target=/pnpm/store \
    pnpm install --frozen-lockfile

COPY . .

# API package deploy karein
RUN pnpm deploy --filter=api --prod /prod/api

FROM base AS api

WORKDIR /app

COPY --from=build /prod/api /app

EXPOSE 9000

ENV PORT=9000
ENV NODE_ENV=production

USER node

CMD [ "node", "src/index.js" ]
