const express = require('express');
const r = require('rethinkdb');

const router = express.Router();
let databaseHost = process.env.DATABASE_HOST || '127.0.0.1'
let dbCon = null;

const onConnect = (error, connection) => {
  if (error) {
    console.log(error);
    setTimeout(() => {
      r.connect({
        host: databaseHost,
        db: 'list'
      }, onConnect)
    }, 100)
  } else {
    dbCon = connection;
  }
}

r.connect({
  host: databaseHost,
  db: 'list'
}, onConnect)

router
  .post('/ulib/ban', (req, res) => {
    r.table('bans')
      .insert(req.payload, {
        conflict: (id, oldban, newban) =>
          oldban
            .merge(newban.without('admin'))
            .merge({
              modified: newban('admin')
            })
      })
      .run(dbCon)
      .then(data => res.json(data));
  })
  .post('/ulib/unban', (req, res) => {
    r.table('bans')
      .get(req.payload.id)
      .delete()
      .run(dbCon)
      .then(data => res.json(data));
  })
  .post('/ulib/bans', (req, res) => {
    r.table('bans')
      .run(dbCon)
      .then(data => res.json(data));
  })
  .post('/ulib/ucl-save-groups', (req, res) => {
    const data = Object.entries(req.payload.groups)
      .map(([key, value]) => Object.assign(value, { id: key }))

    r.table('ulib_groups')
      .delete()
      .run(dbCon)
      .then(() => {
        r.table('ulib_groups')
          .insert(data)
          .run(dbCon)
          .then(result => res.json(result));
      });
  })
  .post('/ulib/ucl-reload-groups', (req, res) => {
    r.table('ulib_groups')
      .run(dbCon)
      .then(cursor => cursor.toArray())
      .then((groups) => {
        const data = {};

        // Turn array into key-value
        groups.forEach((group) => {
          data[group.id] = group;
        });

        res.json(data);
      });
  })
  .post('/ulib/ucl-save-users', (req, res) => {
    const data = Object.entries(req.payload.users)
      .map(([key, value]) => Object.assign(value, { id: key }))

    r.table('ulib_users')
      .delete()
      .run(dbCon)
      .then(() => {
        r.table('ulib_users')
          .insert(data)
          .run(dbCon)
          .then(result => res.json(result));
      });
  })
  .post('/ulib/ucl-reload-users', (req, res) => {
    r.table('ulib_users')
      .run(dbCon)
      .then(cursor => cursor.toArray())
      .then((users) => {
        const data = {};

        // Turn array into key-value
        users.forEach((user) => {
          data[user.id] = user;
        });

        res.json(data);
      });
  })
  .post('/ps/create-user', (req, res) => {
    r.table('points')
      .insert({
        id: req.payload.id,
        items: {}
      }, {
        conflict: 'update'
      })
      .run(dbCon)
      .then(data => res.json(data));
  })
  .post('/ps/get-data', (req, res) => {
    r.table('points')
      .get(req.payload.id)
      .default({})
      .run(dbCon)
      .then(data => res.json(data));
  })
  .post('/ps/set-points', (req, res) => {
    r.table('points')
      .get(req.payload.id)
      .update({ points: req.payload.points })
      .run(dbCon)
      .then(data => res.json(data));
  })
  .post('/ps/give-points', (req, res) => {
    r.table('points')
      .get(req.payload.id)
      .update({ points: r.row('points').default(0).add(req.payload.points) })
      .run(dbCon)
      .then(data => res.json(data));
  })
  .post('/ps/take-points', (req, res) => {
    r.table('points')
      .get(req.payload.id)
      .update({ points: r.row('points').default(0).sub(req.payload.points) })
      .run(dbCon)
      .then(data => res.json(data));
  })
  .post('/ps/give-item', (req, res) => {
    r.table('points')
      .get(req.payload.id)
      .update({
        items: {
          [req.payload.item]: req.payload.data
        }
      })
      .run(dbCon)
      .then(data => res.json(data));
  })
  .post('/ps/take-item', (req, res) => {
    r.table('points')
      .get(req.payload.id)
      .replace(r.row.without({
        items: {
          [req.payload.item]: true
        }
      }))
      .run(dbCon)
      .then(data => res.json(data));
  })
  .post('/ps/set-data', (req, res) => {
    r.table('points')
      .insert({
        id: req.payload.id,
        items: req.payload.items
      }, {
        conflict: 'update'
      })
      .run(dbCon)
      .then(data => res.json(data));
  });

module.exports = router;

process.on('SIGTERM', () => {
  dbCon.close();
})
