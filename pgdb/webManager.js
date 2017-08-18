const {
    Client
} = require('pg')

module.exports = {
    getClient: function () {
        return new Client({
            user: "faers_web_manager",
            host: "35.195.8.82",
            database: "faersdb",
            password: "userManager888",
            port: 5432
        })
    }
}