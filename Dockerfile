# Menggunakan base image node versi 18-alpine
FROM node:18-alpine

# Membuat sebuah working directory di /src
WORKDIR /src

# Menyalin package.json dan package-lock.json ke dalam working directory
COPY package*.json ./

# Menjalankan perintah npm ci untuk menginstall dependency dengan clean install
RUN npm ci

# Menyalin semua file dengan ekstensi .js ke dalam working directory
COPY ./*.js ./

# Menjalankan perintah node index.js untuk menjalankan aplikasi
CMD ["node", "index.js"]