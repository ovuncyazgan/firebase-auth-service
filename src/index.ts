import express from "express"
import firAdmin from "firebase-admin"
import dotenv from "dotenv"

dotenv.config()

const api = express()
const app = firAdmin.initializeApp()
const auth = app.auth()

api.use("/", async (req, res) => {
    let authHeader = req.headers.authorization
    if (!authHeader) {
        res.status(401).end()
        return 
    }
    try {
        let decodedToken = await auth.verifyIdToken(authHeader)

        res.setHeader("X-User-UID", decodedToken.uid)
        res.setHeader("X-User-Data", JSON.stringify(decodedToken))
        res.status(200).end()
    } catch(e) {
        res.status(401).end()
    }
})

const port = process.env.PORT

api.listen(port, () => console.log("AuthService starts listening on", port))