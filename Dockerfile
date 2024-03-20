# Step 1: Build the React app
# Specify the Node.js version, making sure it's the LTS version 16
FROM node:16-alpine as builder

RUN apk add --no-cache git

# rpc url
ENV REACT_APP_NETWORK_URL=https://crossfi.rpc.dex.guru/archive/4157

# chain id
ENV REACT_APP_CHAIN_ID=4157

ENV REACT_APP_WALLETCONNECT_BRIDGE_URL="https://uniswap.bridge.walletconnect.org"

# Set the working directory in the container
WORKDIR /app

# Yarn is included with official Node images, but if you need a specific version, you can install it like this:
# RUN npm install -g yarn

# Copy package.json and yarn.lock
COPY package.json yarn.lock ./

# Copy the rest of your app's source code from your host to your image filesystem.
COPY . .

# Install dependencies
RUN yarn preinstall 
RUN yarn install

# Build your application
RUN yarn build

# Step 2: Serve the application

# Use an Nginx image to serve the application
FROM nginx:alpine

# Copy the build output to replace the default nginx contents.
COPY --from=builder /app/build /usr/share/nginx/html

# Expose port 80 to the outside once the container has launched
EXPOSE 80

# Tell the image what to do when it starts as a container
CMD ["nginx", "-g", "daemon off;"]
