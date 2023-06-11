# Menggunakan base image node:18-alpine dari Docker Hub
FROM node:18-alpine

# Membuat working directory /src
WORKDIR /src

# Memindahkan file package.json dan package-lock.json ke working directory
COPY package*.json ./

# Menjalankan perintah npm ci untuk menginstall dependency dengan clean install
RUN npm ci

# Memindahkan seluruh berkas dengan ekstensi .js ke working directory
COPY ./*.js ./

# Menjalankan perintah node index.js untuk menjalankan aplikasi
CMD ["node", "index.js"]