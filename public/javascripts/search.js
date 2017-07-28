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
            for (obj in data) {
                var row = $("<tr></tr>").addClass("drugRow");
                for (key in data[obj]) {
                    column = $("<td></td>").text(data[obj][key]);
                    row.append(column);
                }
                row.on("click", searchAdverseEvent);
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
            for (obj in data) {
                var row = $("<tr></tr>");
                for (key in data[obj]) {
                    column = $("<td></td>").text(data[obj][key]);
                    row.append(column);
                }
                $("#adverseEventTable tbody").append(row);
            }
        }
    );
    $($("#adverseEventDiv")).show();
}


