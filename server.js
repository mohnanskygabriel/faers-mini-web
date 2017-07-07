var http = require('http'),
    fs = require('fs'),
    pgClient = require('./search/pgClient.js');

http.createServer(function (request, response) {
    if (request.method === "GET") {
        if (request.url === "/") {
            fs.readFile('./index.html', function (err, html) {
                if (err) throw err;
                response.writeHeader(200, {
                    "Content-Type": "text/html"
                });
                response.write(html);
                response.end();
            });
        }
        if (request.url === "/search") {
            fs.readFile('./search.html', function (err, html) {
                if (err) throw err;
                response.writeHeader(200, {
                    "Content-Type": "text/html"
                });
                response.write(html);
                response.end();
            });
        }
    } else if (request.method === "POST") {
        request.on("data", function (data) {
            data = data.toString();
            searchedBrand = data.split("=")[1]
            console.log("Searching...: " + searchedBrand)
            sql = "SELECT name FROM faers.active_substance WHERE name LIKE(\'%" + searchedBrand + "%\')"
            client = pgClient.getClient()
            client.connect()
            client.query(sql,
                (err, res) => {
                    jsonObject = []
                    if (err) {
                        console.log(err.stack)
                    } else {
                        for (row in res.rows) {
                            jsonObject.push({
                                brandName: res.rows[row].name
                            })
                        }
                        response.writeHeader(200, {
                            "Content-Type": "application/json"
                        });
                        // response.write(JSON.stringify(jsonObject))
                        response.end(JSON.stringify(jsonObject))
                    }
                })
        })

    }
}).listen(1337);
data = new Date();
console.log(data.getHours() + ":" + data.getMinutes() + ":" + data.getSeconds() + " Server running at http://127.0.0.1:1337/");