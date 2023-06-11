require('dotenv').config()

const express = require("express");
const app = express();

const bp = require("body-parser");

// Modifikasi kode agar dapat menggunakan kredensial dari kubernetes secret
const amqp = require("amqplib");
const host = process.env.AMQP_HOST;
const port = process.env.AMQP_PORT;
const user = process.env.AMQP_USER;
const pass = process.env.AMQP_PASS;
const amqpServer = `amqp://${user}:${pass}@${host}:${port}`;

var channel, connection;

connectToQueue();

// Fungsi delay digunakan untuk menunda eksekusi kode selama beberapa detik
function delay(time) {
    return new Promise(resolve => setTimeout(resolve, time));
}

async function connectToQueue() {
    // Menunggu 5 detik agar sidecar proxy selesai di-deploy.
    // Ketika menggunakan istio, container tidak langsung dapat memanggil rabbitmq
    // sehingga perlu menunggu beberapa saat sampai sidecar selesai di-deploy.
    await delay(5000);
    try {
        // Membuat koneksi dengan AMQP server yaitu RabbitMQ
        connection = await amqp.connect(amqpServer);

        // Membuat channel untuk berkomunikasi
        channel = await connection.createChannel();

        // Membuat queue dengan nama "order"
        await channel.assertQueue("order");

        // Mengonsumsi queue "order"
        channel.consume("order", data => {

            // Setiap ada pesan masuk, maka akan di-print ke console
            console.log(`Order received: ${Buffer.from(data.content)}`);
            console.log("** Will be shipped soon! **\n")

            // Mengirimkan ACK ke RabbitMQ untuk memberitahu bahwa pesan sudah diterima
            channel.ack(data);
        });
    } catch (ex) {
        console.error(ex);
    }
}

app.listen(process.env.PORT, () => {
    console.log(`Server running at ${process.env.PORT}`);
});
