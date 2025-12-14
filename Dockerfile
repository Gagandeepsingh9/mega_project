# Stage 1
FROM node:18-alpine AS stage1
WORKDIR /app
RUN apk add --no-cache python3 make g++
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build 

# Stage 2
FROM node:18-alpine AS stage2
WORKDIR /app
COPY --from=stage1 /app/.next/standalone ./
COPY --from=stage1 /app/.next/static ./.next/static
COPY --from=stage1 /app/public ./public

ENV NODE_ENV=production
ENV PORT=3000

EXPOSE 3000
CMD ["node", "server.js"]
