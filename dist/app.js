import express from "express";
const app = express();
const port = process.env.PORT || 8000;
app.get("/", (req, res) => {
    res.send("Hello World");
});
if (process.env.NODE_ENV !== "test") {
    app.listen(port, () => {
        console.log(`App running at port ${port}`);
    });
}
export default app;
