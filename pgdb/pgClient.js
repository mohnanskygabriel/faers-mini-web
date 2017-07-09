const {
    Client
} = require('pg')

module.exports = {
    getClient: function () {
        return new Client({
            user: "faers_wwweb_client",
            host: "127.0.0.1",
            database: "faersdb",
            password: "faersRegisteredclientPass153",
            port: 5432
        })
    }
}