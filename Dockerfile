FROM node:20-alpine

WORKDIR /app

COPY package*.json .

RUN npm install

COPY . .

EXPOSE 3000

# Install wget for healthcheck (Alpine image)
RUN apk add --no-cache wget

# Healthcheck to verify the app is responding on port 3000
HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
  CMD wget -qO- http://localhost:3000/ >/dev/null 2>&1 || exit 1


CMD [ "npm", "start"]