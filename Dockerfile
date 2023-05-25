# Using node:14-alpine as base image
# URL: https://hub.docker.com/_/node
FROM node:14-alpine

# Create /app directory and set it as working directory
WORKDIR /app

# Copy all files from current directory of host machine
# to current working directory (/app) of container
COPY . .

# Setting up environment variables
# NODE_ENV=production means that the app will run in production mode
# DB_HOST=item-db means that the app will connect to item-db container as database
ENV NODE_ENV=production DB_HOST=item-db

# Install all dependencies and build the app
RUN npm install --production --unsafe-perm && npm run build

# Expose port 8080
# Application will be accessible at port 8080
EXPOSE 8080

# After container is created,
# run the app with `npm start` command
CMD ["npm", "start"]

