# Stage 1: Build React app
FROM node:16.17.0-alpine AS build-one

WORKDIR /todoapp

# Copy package files and install dependencies first (better cache)
COPY package*.json ./
RUN npm install

# Copy rest of source code
COPY . .

# Build the React app
RUN npm run build

# Stage 2: Production with NGINX
FROM nginx:stable-alpine

# Remove default NGINX static files
RUN rm -rf /usr/share/nginx/html/*

# Copy build output from Stage 1
COPY --from=build-one /todoapp/build/ /usr/share/nginx/html/

# Copy custom entrypoint script and make it executable
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# Expose port 80
EXPOSE 80

# Use the custom entrypoint script as the container entrypoint
ENTRYPOINT ["/docker-entrypoint.sh"]

# Start NGINX in foreground
CMD ["nginx", "-g", "daemon off;"]
