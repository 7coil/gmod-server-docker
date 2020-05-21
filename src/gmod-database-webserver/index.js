const express = require('express');
const bodyParser = require('body-parser');

const apiRouter = require('./routes/api/v1')

const app = express();

app.use(bodyParser.json())
  .use('/api/v1', apiRouter)

app.listen(8000)
