const express = require("express")
const t = require("./sum.js")

const app = express()

const port = 3000

app.get("/",(req,res)=>{
    res.send("Running from docker image")
})

app.listen(port,()=>{
    console.log(`Runing on port `+port)
})