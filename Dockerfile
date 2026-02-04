# Build stage for the Next.js frontend
FROM node:20-alpine AS base

# Install dependencies only when needed
FROM base AS deps
RUN apk add --no-cache libc6-compat git
WORKDIR /app

# Enable Corepack for Yarn 3
RUN corepack enable

# Copy root package files
COPY package.json yarn.lock .yarnrc.yml ./
COPY .yarn ./.yarn
COPY packages/nextjs/package.json ./packages/nextjs/
COPY packages/hardhat/package.json ./packages/hardhat/

# Install dependencies
RUN yarn install --immutable

# Development stage - runs all services
FROM base AS development
WORKDIR /app

RUN apk add --no-cache git
RUN corepack enable

COPY --from=deps /app/node_modules ./node_modules
COPY --from=deps /app/.yarn ./.yarn
COPY --from=deps /app/packages/nextjs/node_modules ./packages/nextjs/node_modules
COPY --from=deps /app/packages/hardhat/node_modules ./packages/hardhat/node_modules
COPY . .

EXPOSE 3000 8545

# Production build stage
FROM base AS builder
WORKDIR /app

RUN corepack enable

COPY --from=deps /app/node_modules ./node_modules
COPY --from=deps /app/.yarn ./.yarn
COPY --from=deps /app/packages/nextjs/node_modules ./packages/nextjs/node_modules
COPY --from=deps /app/packages/hardhat/node_modules ./packages/hardhat/node_modules
COPY . .

# Build the Next.js application
WORKDIR /app/packages/nextjs
RUN yarn build

# Production stage
FROM base AS production
WORKDIR /app

ENV NODE_ENV=production

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

COPY --from=builder /app/packages/nextjs/public ./public
COPY --from=builder --chown=nextjs:nodejs /app/packages/nextjs/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/packages/nextjs/.next/static ./.next/static

USER nextjs

EXPOSE 3000

ENV PORT=3000
ENV HOSTNAME="0.0.0.0"

CMD ["node", "server.js"]
