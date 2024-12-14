FROM node:lts-slim

ENV NODE_ENV=production
ENV PORT=${PORT:-3090}

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY ./dist ./dist

CMD ["node", "index.js"]