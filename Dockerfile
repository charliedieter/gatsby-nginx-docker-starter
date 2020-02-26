FROM node:alpine as gatsby-pages

COPY . .
# System dependencies for packages that use node-gyp
RUN apk add --update --no-cache \
  python \
  make \
  g++
# Install and build production gatsby pages
RUN npm install && npm run build

FROM nginx:stable

COPY --from=gatsby-pages public /var/www/
COPY ./nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]