# Stage 1: Build stage for the Node.js app
FROM node:16.17.0-alpine AS build-one
# Set the working directory
WORKDIR /todoapp
# Copy the application code
COPY . . 
# Install dependencies and build the application
RUN npm install
RUN npm run build
# Stage 2: Production stage with NGINX
FROM nginx:stable-alpine
# Remove the default NGINX static files
RUN rm -rf /usr/share/nginx/html/*
# Copy the build output from the first stage to NGINX's static filedirectory
COPY --from=build-one /todoapp/build/ /usr/share/nginx/html/
# Expose the default NGINX port
EXPOSE 80
# Start NGINX in the foreground
CMD ["nginx", "-g", "daemon off;"]