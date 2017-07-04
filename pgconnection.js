const {
    Client
} = require('pg')
const client = new Client({
    user: 'faers',
    host: '127.0.0.1',
    database: 'faersdb',
    password: 'nhb2017',
    port: 5432,
})
client.connect()
client.query('SELECT id, name FROM faers.active_substance',
    (err, res) => {
        for (row in res.rows) {
            json = '{' + res.rows[row].id + ':' + res.rows[row].name + '}'
            console.log(json)
        }
        client.end()
    })
