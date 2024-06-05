FROM --platform=arm64 node:22-bookworm-slim AS builder
WORKDIR /app
COPY package.json ./
COPY package-lock.json ./
RUN npm i --legacy-peer-deps
COPY . ./
RUN npm run build

FROM --platform=arm64 node:22-bookworm-slim AS runner
WORKDIR /app
COPY --from=builder /app/package.json ./
COPY --from=builder /app/serve.json ./
COPY --from=builder /app/.tmp/build/static ./.tmp/build/static
EXPOSE 3000
CMD node index.js