FROM node:18.17.0 as builder

WORKDIR /app

COPY package.json yarn.lock ./
RUN corepack enable && yarn install

ENV REACT_APP_BACKEND_URL=/api

COPY . .
RUN yarn build

FROM nginx:alpine

COPY --from=builder /app/build /usr/share/nginx/html
COPY default.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
