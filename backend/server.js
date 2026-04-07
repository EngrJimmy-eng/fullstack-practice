const express = require('express');
const mysql = require('mysql');
const cors = require('cors');

const app = express();
app.use(cors());

const db = mysql.createConnection({
  host: 'localhost',
  user: 'appuser',
  password: 'password',
  database: 'myapp'
});

db.connect(err => {
  if (err) console.log(err);
  else console.log("MySQL Connected");
});

app.get('/api', (req, res) => {
  db.query('SELECT NOW() AS time', (err, result) => {
    if (err) return res.send(err);
    res.json(result);
  });
});

app.listen(3001, () => console.log("Server running on 3001"));
