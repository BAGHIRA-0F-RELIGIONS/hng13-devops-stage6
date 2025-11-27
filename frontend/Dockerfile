# frontend/Dockerfile (multi-stage build)
FROM node:18-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

FROM nginx:stable-alpine
COPY --from=build /app/dist /usr/share/nginx/html
# optional: copy custom nginx config if you need /api proxy (traefik will route)
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
