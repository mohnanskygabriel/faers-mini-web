const {
    Client
} = require('pg')

module.exports = {
    getClient: function () {
        return new Client({
            user: "faers_wwweb_guest",
            host: "35.195.8.82",
            //host: "127.0.0.1",
            database: "faersdb",
            password: "faersHostpass351",
            port: 5432
        })
    }
}