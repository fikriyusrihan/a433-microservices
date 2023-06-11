require('dotenv').config()

const express = require("express");
const app = express();

const bp = require("body-parser");
app.use(bp.json());

// Modifikasi kode agar dapat menggunakan kredensial dari kubernetes secret
const amqp = require("amqplib");
const host = process.env.AMQP_HOST;
const port = process.env.AMQP_PORT;
const user = process.env.AMQP_USER;
const pass = process.env.AMQP_PASS;
const amqpServer = `amqp://${user}:${pass}@${host}:${port}`;

var channel, connection;

connectToQueue();

async function connectToQueue() {
    // Membuat koneksi dengan AMQP server yaitu RabbitMQ
    connection = await amqp.connect(amqpServer);

    // Membuat channel untuk berkomunikasi dengan AMQP server
    channel = await connection.createChannel();
    try {
        // Membuat queue dengan nama "order"
        const queue = "order";
        await channel.assertQueue(queue);
        console.log("Connected to the queue!")
    } catch (ex) {
        console.error(ex);
    }
}

// Membuat endpoint untuk menerima order
app.post("/order", (req, res) => {
    // Mengambil data order dari request body
    const { order } = req.body;

    // Memanggil fungsi createOrder untuk mengirim pesan ke queue "order"
    createOrder(order);

    // Mengembalikan response dengan data order
    res.send(order);
});

const createOrder = async order => {
    // Mengirim pesan ke queue "order"
    const queue = "order";
    await channel.sendToQueue(queue, Buffer.from(JSON.stringify(order)));
    console.log("Order succesfully created!")

    // Ketika menerima sinyal SIGINT, maka tutup koneksi dengan AMQP server
    process.once('SIGINT', async () => { 
        console.log('got sigint, closing connection');
        await channel.close();
        await connection.close(); 
        process.exit(0);
    });
};

app.listen(process.env.PORT, () => {
    console.log(`Server running at ${process.env.PORT}`);
});

