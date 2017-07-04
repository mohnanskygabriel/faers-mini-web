//use modules: http, fs(File System)
var http = require('http'),
    fs = require('fs');
const {
    Client
} = require('pg')

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
        var POST = {};
        /*request.on('data', function(data){
              data = data.toString();
              data = data.split('&');
              for (var i = 0; i < data.length; i++) {
                   var _data = data[i].split("=");
                   POST[_data[0]] = _data[1];
               }
              console.log(data);
         });*/
        request.on('data', function (data) {
            data = data.toString();
            searchedBrand = data.split("=")[1]
            console.log('Searching...: ' + searchedBrand)
            sql = 'SELECT name FROM faers.active_substance WHERE name LIKE(\'%' + searchedBrand + '%\')'
            console.log(sql)
            const client = new Client({
                user: 'faers',
                host: '127.0.0.1',
                database: 'faersdb',
                password: 'nhb2017',
                port: 5432
            })
            client.connect()
            client.query(sql,
                (err, res) => {
                    if (err) {
                        console.log(err.stack)
                    } else {
                        for (row in res.rows) {
                            json = '{' + res.rows[row].id + ':' + res.rows[row].name + '}'
                            console.log(json)
                        }
                    }

                })
        })
        /**/
        response.writeHeader(200, {
            "Content-Type": "application/json"
        });
        response.write(JSON.stringify(
                [
                {
                    brandName: "Ibalgin",
                    manufactureName: "Pharma"
                    },
                {
                    brandName: "Paralen",
                    manufactureName: "Zentiva"
                    }
                ]
        ));
        response.end();
    }
}).listen(1337);


console.log('Server running at http://127.0.0.1:1337/');

//search do with GET
//PUT - insert
//DELETE - delte something form db
