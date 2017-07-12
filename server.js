var http = require('http'),
    fs = require('fs'),
    pgGuestClient = require('./pgdb/pgGuest.js');

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
        //find = drug/reaction; brand= '%'; manufacturer = '%'
        //TODO: make a filter for filtering +, %26
        request.on("data", function (data) {
            data = data.toString()
            find = data.split("&")[0].split("=")[1]
            if (find === 'drug') {
                searchedBrand = data.split("&")[1].split("=")[1].replace(/\+/g, " ").replace(/\%26/g, "\&")
                searchedManufacturer = data.split("&")[2].split("=")[1].replace(/\+/g, " ").replace(/\%26/g, "\&")
                if (searchedBrand.length > 0 && searchedManufacturer.length > 0) {
                    sql = "SELECT drug_name, manufacturer_name, similarity(drug_name, " + "\'" + searchedBrand + "\'" + "), similarity(manufacturer_name, " + "\'" + searchedManufacturer + "\'" + ") FROM faers.drug_short WHERE drug_name LIKE(\'%" + searchedBrand + "%\') AND manufacturer_name LIKE(\'%" + searchedManufacturer + "%\') ORDER BY 3 DESC,4 DESC,1,2"
                } else if (searchedBrand.length > 0 && searchedManufacturer.length == 0) {
                    sql = "SELECT drug_name, manufacturer_name, similarity(drug_name, " + "\'" + searchedBrand + "\'" + ") FROM faers.drug_short WHERE drug_name LIKE(\'%" + searchedBrand + "%\') ORDER BY 3 DESC,1,2 "
                } else if (searchedBrand.length == 0 && searchedManufacturer.length > 0) {
                    sql = "SELECT drug_name, manufacturer_name, similarity(manufacturer_name, " + "\'" + searchedManufacturer + "\'" + ") FROM faers.drug_short WHERE manufacturer_name LIKE(\'%" + searchedManufacturer + "%\') ORDER BY 3 DESC,2,1"
                } else if (searchedBrand.length == 0 && searchedManufacturer.length == 0) {
                    sql = "SELECT drug_name, manufacturer_name FROM faers.drug_short ORDER BY 1,2"
                }
                client = pgGuestClient.getClient()
                client.connect()
                client.query(sql,
                    (err, res) => {
                        jsonObject = []
                        if (err) {
                            console.log(err.stack)
                        } else {
                            for (row in res.rows) {
                                jsonObject.push({
                                    drugName: res.rows[row].drug_name,
                                    manufacturerName: res.rows[row].manufacturer_name
                                })
                            }
                            response.writeHeader(200, {
                                "Content-Type": "application/json; charsert=UTF-8"
                            });
                            // response.write(JSON.stringify(jsonObject))
                            response.end(JSON.stringify(jsonObject))
                        }
                    })
            } else if (find === 'reaction') {
                brand = data.split("&")[1].split("=")[1].replace(/\+/g, " ")
                manufacturer = data.split("&")[2].split("=")[1].replace(/\+/g, " ").replace(/\%26/g, "\&")
                //console.log('Brand: ' + brand + ' Manufacturer: ' + manufacturer)
                sql = "SELECT * FROM faers.get_reactions(\'" + brand + "\', \'" + manufacturer + "\')"
                client = pgGuestClient.getClient()
                client.connect()
                client.query(sql,
                    (err, res) => {
                        jsonObject = []
                        if (err) {
                            console.log(err.stack)
                        } else {
                            for (row in res.rows) {
                                jsonObject.push({
                                    reaction: res.rows[row].drug_name,
                                    quantity: res.rows[row].quantity
                                })
                            }
                            response.writeHeader(200, {
                                "Content-Type": "application/json; charsert=UTF-8"
                            });
                            // response.write(JSON.stringify(jsonObject))
                            response.end(JSON.stringify(jsonObject))
                        }
                    })

            }
        })

    }
}).listen(1337);
data = new Date();
console.log(data.getHours() + ":" + data.getMinutes() + ":" + data.getSeconds() + " Server running at http://127.0.0.1:1337/");
