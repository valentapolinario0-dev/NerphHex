const express = require("express");
const path = require("path");

const app = express();

app.use(express.static("public"));

function generateCode(length = 8) {
    const chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    let code = "";
    for (let i = 0; i < length; i++) {
        code += chars[Math.floor(Math.random() * chars.length)];
    }
    return code;
}

app.get("/new", (req, res) => {
    const code = generateCode();
    res.redirect("/" + code);
});

app.get("/:code", (req, res) => {
    const code = req.params.code;

    res.send(`
    <html>
    <head>
    <title>RAW PAGE ${code}</title>
    <style>
    body{
        background:#0a0a0a;
        color:#00ff9d;
        font-family:monospace;
        text-align:center;
        padding-top:100px;
    }
    </style>
    </head>

    <body>

    <h1>RAW PAGE</h1>
    <h2>${code}</h2>

    <p>Página gerada dinamicamente</p>

    <a href="/new">Gerar nova página</a>

    </body>
    </html>
    `);
});

app.listen(3000, () => {
    console.log("Servidor rodando em http://localhost:3000");
});
