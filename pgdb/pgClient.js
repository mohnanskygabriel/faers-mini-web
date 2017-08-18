const {
    Client
} = require('pg')

module.exports = {
    getClient: function () {
        return new Client({
            user: "faers_wwweb_client",
            host: "35.195.8.82",
            database: "faersdb",
            password: "faersRegisteredclientPass153",
            port: 5432
        })
    }
}