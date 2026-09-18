FROM node:20-alpine AS base
ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"

FROM base AS build
WORKDIR /app
COPY . /app

# Corepack aur required build tools enable karein
RUN corepack enable
RUN apk add --no-cache python3 alpine-sdk

# Without --frozen-lockfile ke dependencies install karein
RUN --mount=type=cache,id=pnpm,target=/pnpm/store \
    pnpm install

# Build process run karein
RUN pnpm --filter=@imput/cobalt-api build

# Output folder mein app deploy karein
RUN pnpm deploy --filter=@imput/cobalt-api --prod /prod/api

FROM base AS api
WORKDIR /app

COPY --from=build --chown=node:node /prod/api /app

USER node

EXPOSE 9000
CMD [ "node", "src/index.js" ]
