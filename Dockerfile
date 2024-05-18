# Stage 1: Build the application
FROM node:18 as builder

WORKDIR /build

# Copy package.json and package-lock.json (if available)
COPY package*.json ./

# Install dependencies including TypeScript
RUN npm install

# Install TypeScript globally
RUN npm install -g typescript

# Copy the rest of the application source code
COPY tsconfig.json ./
COPY src/ src/

# Build the TypeScript application
RUN npm run build

# Stage 2: Run the application
FROM node:18 as runner

WORKDIR /app

# Copy only the necessary files from the builder stage
COPY --from=builder /build/package*.json ./
COPY --from=builder /build/node_modules ./node_modules
COPY --from=builder /build/dist ./dist

# Expose the application port
EXPOSE 8000

# Start the application
CMD ["node", "dist/app.js"]
