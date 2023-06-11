require('dotenv').config()

const express = require("express");
const app = express();

const bp = require("body-parser");

// Import amqplib untuk berinteraksi dengan protokol AMQP
const amqp = require("amqplib");
const amqpServer = process.env.AMQP_URL;
var channel, connection;

connectToQueue();

async function connectToQueue() {
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
