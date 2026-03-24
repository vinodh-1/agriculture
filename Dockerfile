# syntax=docker/dockerfile:1

# ---------- Stage 1 : Build Stage ----------
FROM node:12.18.1 AS builder

WORKDIR /app

# Copy dependency files
COPY package.json package-lock.json* ./

# Install dependencies
RUN npm install --production

# Copy application source
COPY . .


# ---------- Stage 2 : Production Stage ----------
FROM node:12.18.1-alpine

ENV NODE_ENV=production

WORKDIR /app

# Copy only required files from builder
COPY --from=builder /app /app

EXPOSE 8080

CMD ["node", "server.js"]
