const express = require('express');
const bodyParser = require('body-parser');

const apiRouter = require('./routes/api/v1')

const app = express();

app.use(bodyParser.json())
  .use(bodyParser.urlencoded({ extended: true }))
  .use((req, res, next) => {
    if (req.body && typeof req.body.payload === 'object') {
      req.payload = req.body.payload;
    } else if (req.body && typeof req.body.payload === 'string') {
      req.payload = JSON.parse(req.body.payload);
    } else {
      req.payload = {};
    }

    next();
  })
  .use('/api/v1', apiRouter)

const webServer = app.listen(80)

process.on('SIGTERM', () => {
  webServer.close();
})
