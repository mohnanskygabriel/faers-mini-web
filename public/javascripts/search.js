function search() {
    $($("#adverseEventDiv")).hide();
    $("#drugTable tbody").empty();
    $("#adverseEventTable tbody").empty();
    $.post("", {
            find: "drug",
            brand: $("#brand").val(),
            manufacturer: $("#manufacturer").val()
        },
        function (data, status) {
            if (data.length > 0) {
                for (obj in data) {
                    var row = $("<tr></tr>").addClass("drugRow");
                    for (key in data[obj]) {
                        column = $("<td></td>").text(data[obj][key]);
                        row.append(column);
                    }
                    row.on("click", searchAdverseEvent);
                    row.on("click", testEvent);
                    $("#drugTable tbody").append(row);
                }
            } else {
                var row = $("<tr></tr>").addClass("drugRow");
                column = $("<td></td>").text("Drug not found");
                column.prop('colspan', 2);
                row.append(column);
                $("#drugTable tbody").append(row);
            }

        }
    );
};

function searchAdverseEvent() {
    $("#adverseEventTable tbody").empty();
    $.post("", {
            find: "reaction",
            brand: $($(this).children()[0]).text(),
            manufacturer: $($(this).children()[1]).text()
        },
        function (data, status) {
            if (data.length > 0) {
                for (obj in data) {
                    var row = $("<tr></tr>");
                    for (key in data[obj]) {
                        column = $("<td></td>").text(data[obj][key]);
                        row.append(column);
                    }
                    $("#adverseEventTable tbody").append(row);
                }
            } else {
                var row = $("<tr></tr>");
                column = $("<td></td>").text("No adverse event found");
                column.prop('colspan', 2);
                row.append(column);
                $("#adverseEventTable tbody").append(row);
            }
        }
    );
    $($("#adverseEventDiv")).show();
}

function testEvent() {
    var rowIdx = $(this).index("tr") - 1;
    $.post("", {
            find: "substance",
            brand: $($(this).children()[0]).text(),
            manufacturer: $($(this).children()[1]).text()
        },
        function (data, status) {
            if (data.length > 0) {
                for (obj in data) {
                    var row = $("<tr></tr>");
                    for (key in data[obj]) {
                        column = $("<td></td>").text(data[obj][key]);
                        row.append(column);
                    }
                    $("#drugTable > tbody tr:nth-child(" + rowIdx + ")").after(row);
                    rowIdx = rowIdx + 1;
                }
            } else {
                var row = $("<tr></tr>");
                column = $("<td></td>").text("Substances not found");
                row.append(column);
                $("#drugTable > tbody tr:nth-child(" + rowIdx + ")").after(row);
            }
        }
    );
};
