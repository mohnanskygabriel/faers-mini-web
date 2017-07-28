const express = require("express"),
    livereload = require('livereload'),
    app = express(),
    fs = require("fs"),
    pgGuestClient = require("./pgdb/pgGuest.js");

app.use(express.static("public"));

var port = process.env.PORT || 8080;

app.get("/", function (req, res) {
    fs.readFile("./views/index.html", function (err, html) {
        if (err) throw err;
        res.writeHeader(200, {
            "Content-Type": "text/html"
        });
        res.write(html);
        res.end();
    });
});

app.get("/search", function (req, res) {
    fs.readFile("./views/search.html", function (err, html) {
        if (err) throw err;
        res.writeHeader(200, {
            "Content-Type": "text/html"
        });
        res.write(html);
        res.end();
    });
});

app.get("/contact", function (req, res) {
    fs.readFile("./views/contact.html", function (err, html) {
        if (err) throw err;
        res.writeHeader(200, {
            "Content-Type": "text/html"
        });
        res.write(html);
        res.end();
    });
});

app.post("/search", function (req, res) {
    //find = drug/reaction; brand= '%'; manufacturer = '%'
    //TODO: make a filter for filtering +, %26
    req.on("data", function (data) {
        data = data.toString();
        find = data.split("&")[0].split("=")[1];
        if (find === "drug") {
            searchedBrand = data.split("&")[1].split("=")[1].replace(/\+/g, " ").replace(/\%26/g, "\&");
            searchedManufacturer = data.split("&")[2].split("=")[1].replace(/\+/g, " ").replace(/\%26/g, "\&");
            if (searchedBrand.length > 0 && searchedManufacturer.length > 0) {
                sql = "SELECT drug_name, manufacturer_name, similarity(drug_name, " + "\'" + searchedBrand + "\'" + "), similarity(manufacturer_name, " + "\'" + searchedManufacturer + "\'" + ") FROM faers.drug_short WHERE drug_name LIKE(\'%" + searchedBrand + "%\') AND manufacturer_name LIKE(\'%" + searchedManufacturer + "%\') ORDER BY 3 DESC,4 DESC,1,2";
            } else if (searchedBrand.length > 0 && searchedManufacturer.length == 0) {
                sql = "SELECT drug_name, manufacturer_name, similarity(drug_name, " + "\'" + searchedBrand + "\'" + ") FROM faers.drug_short WHERE drug_name LIKE(\'%" + searchedBrand + "%\') ORDER BY 3 DESC,1,2 ";
            } else if (searchedBrand.length == 0 && searchedManufacturer.length > 0) {
                sql = "SELECT drug_name, manufacturer_name, similarity(manufacturer_name, " + "\'" + searchedManufacturer + "\'" + ") FROM faers.drug_short WHERE manufacturer_name LIKE(\'%" + searchedManufacturer + "%\') ORDER BY 3 DESC,2,1";
            } else if (searchedBrand.length == 0 && searchedManufacturer.length == 0) {
                sql = "SELECT drug_name, manufacturer_name FROM faers.drug_short ORDER BY 1,2";
            }
            client = pgGuestClient.getClient();
            client.connect();
            client.query(sql,
                (err, dbResponse) => {
                    jsonObject = [];
                    if (err) {
                        console.log(err.stack);
                    } else {
                        for (row in dbResponse.rows) {
                            jsonObject.push({
                                drugName: dbResponse.rows[row].drug_name,
                                manufacturerName: dbResponse.rows[row].manufacturer_name
                            });
                        }
                        res.writeHeader(200, {
                            "Content-Type": "application/json; charsert=UTF-8"
                        });
                        // res.write(JSON.stringify(jsonObject));
                        res.end(JSON.stringify(jsonObject));
                        client.end(function (error) {
                            if (error) throw err;
                        });
                    }
                });
        } else if (find === "reaction") {
            brand = data.split("&")[1].split("=")[1].replace(/\+/g, " ");
            manufacturer = data.split("&")[2].split("=")[1].replace(/\+/g, " ").replace(/\%26/g, "\&");
            //console.log('Brand: ' + brand + ' Manufacturer: ' + manufacturer);
            sql = "SELECT * FROM faers.get_reactions(\'" + brand + "\', \'" + manufacturer + "\')";
            client = pgGuestClient.getClient();
            client.connect();
            client.query(sql,
                (err, dbResponse) => {
                    jsonObject = [];
                    if (err) {
                        console.log(err.stack);
                    } else {
                        for (row in dbResponse.rows) {
                            jsonObject.push({
                                reaction: dbResponse.rows[row].drug_name,
                                quantity: dbResponse.rows[row].quantity
                            });
                        }
                        res.writeHeader(200, {
                            "Content-Type": "application/json; charsert=UTF-8"
                        });
                        // res.write(JSON.stringify(jsonObject));
                        res.end(JSON.stringify(jsonObject));
                        client.end(function (error) {
                            if (error) throw err;
                        });
                    }
                });
        };
    });
});

app.listen(port, function () {
    console.log("Server running at http://localhost:" + port);
});

var lrserver = livereload.createServer();
lrserver.watch(__dirname);
console.log('livereload listening...')
