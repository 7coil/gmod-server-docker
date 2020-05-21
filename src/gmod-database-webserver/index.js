const express = require('express');
const bodyParser = require('body-parser');

const apiRouter = require('./routes/api/v1')

const app = express();

app.use(bodyParser.json())
  .use('/api/v1', apiRouter)

const webServer = app.listen(80)

process.on('SIGTERM', () => {
  webServer.close();
})
