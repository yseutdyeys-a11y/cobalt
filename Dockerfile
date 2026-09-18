FROM node:20-alpine AS base
ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"

# Corepack ko base image par install aur enable karein
RUN corepack enable && corepack prepare pnpm@latest --activate

FROM base AS build
WORKDIR /app
COPY . /app

RUN apk add --no-cache python3 alpine-sdk

# Simple install command execute karein
RUN pnpm install --no-frozen-lockfile

# Build step run karein
RUN pnpm --filter=@imput/cobalt-api build

# Output folder mein app deploy karein
RUN pnpm deploy --filter=@imput/cobalt-api --prod /prod/api

FROM base AS api
WORKDIR /app

COPY --from=build --chown=node:node /prod/api /app

USER node

EXPOSE 9000
CMD [ "node", "src/index.js" ]
