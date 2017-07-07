const {
    Client
} = require('pg')

module.exports = {
    getClient: function () {
        return new Client({
            user: "faers",
            host: "127.0.0.1",
            database: "faersdb",
            password: "nhb2017",
            port: 5432
        })
    }
}
