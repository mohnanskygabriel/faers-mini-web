const {
    Client
} = require('pg')

module.exports = {
    getClient: function () {
        return new Client({
            user: "faers_web_manager",
            host: "127.0.0.1",
            database: "faersdb",
            password: "userManager888",
            port: 5432
        })
    }
}