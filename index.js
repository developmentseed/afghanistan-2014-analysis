var map = L.mapbox.map('map','ndi.map-hio7h1na,drewbo19.al4pwrk9');
var map2 = L.mapbox.map('dots','ndi.map-hio7h1na,drewbo19.42oz85mi');

var margin = {top: 20, right: 30, bottom: 50, left: 40},
    width = 760 - margin.left - margin.right,
    height = 500 - margin.top - margin.bottom;

var x = d3.scale.linear()
    .domain([0, 600])
    .range([0, width]);

var y = d3.scale.linear()
    .domain([0, .007])
    .range([height, 0]);

var xAxis = d3.svg.axis()
    .scale(x)
    .orient("bottom");

var yAxis = d3.svg.axis()
    .scale(y)
    .orient("left")
    .tickFormat(d3.format(".1%"));

var line = d3.svg.line()
    .x(function(d) { return x(d[0]); })
    .y(function(d) { return y(d[1]); });

var prov = $("#province")

var aavotes = $("#abdullah-votes")

var agvotes = $("#ghani-votes")

var svg = d3.select("#viz").append("svg")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
    .attr("id","chart")
    .attr("viewBox","0 0 760 500")
    .attr("perserveAspectRatio","xMinYMid")
  .append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

svg.append("g")
    .attr("class", "x axis")
    .attr("transform", "translate(0," + height + ")")
    .call(xAxis)
  .append("text")
    .attr("class", "label")
    .attr("x", width)
    .attr("y", 30)
    .style("text-anchor", "end")
    .text("Vote Count per Polling Station");

svg.append("g")
    .attr("class", "y axis")
    .call(yAxis);


function kernelDensityEstimator(kernel, x) {
  return function(sample) {
    return x.map(function(x) {
      return [x, d3.mean(sample, function(v) { return kernel(x - v); })];
    });
  };
}

function epanechnikovKernel(scale) {
  return function(u) {
    return Math.abs(u /= scale) <= 1 ? .75 * (1 - u * u) / scale : 0;
  };
}

var kde = kernelDensityEstimator(epanechnikovKernel(20), x.ticks(600));

d3.csv("results_ps_freq.csv", function(data) {
  d3.csv("province_results.csv", function(pdata){

  var series = d3.keys(data[0]).slice(0);
  var votes = series.map(function(name) {
    return {
      name: name,
      info: pdata.filter(function(d){ return +d["prov"] == +name;})[0],
      values: data.map(function(d) { return +d[name];})
    };
  });

  svg.selectAll("path")
      .data(votes, function(d){ return d.name;})
    .enter().append("path")
      .attr("class", function(d){
        return "line prov-" + d.info["prov"];
      })
      .attr("d", function(d) {
        return line(kde(d["values"]));
      })
      .on("mouseover",function(d) {
          prov.text(d.info["iec_prov"]);
          aavotes.text(d.info["Abdullah"]);
          agvotes.text(d.info["Ghani"]);
      })
      .on("mouseout",function() {
          prov.text("");
          aavotes.text("");
          agvotes.text("");
      });

});
});

var chart = $("#chart"),
    aspect = chart.width() / chart.height(),
    container = chart.parent();
$(window).on("resize", function() {
    var targetWidth = container.width();
    chart.attr("width", targetWidth);
    chart.attr("height", Math.round(targetWidth / aspect));
}).trigger("resize");

// draw three little distogram/density plots for examples

var margin2 = {top: 20, right: 10, bottom: 40, left: 40},
    width2 = 250 - margin2.left - margin2.right,
    height2 = 200 - margin2.top - margin2.bottom;

var x2 = d3.scale.linear()
    .domain([0, 600])
    .range([0, width2]);

var y2 = d3.scale.linear()
    .domain([0, .007])
    .range([height2, 0]);

var yalt = d3.scale.linear()
    .domain([0,.07])
    .range([height2,0])

var xAxis2 = d3.svg.axis()
    .scale(x2)
    .orient("bottom")
    .ticks(6);

var yAxis2 = d3.svg.axis()
    .scale(y2)
    .orient("left")
    .tickFormat(d3.format(".1%"));

var line2 = d3.svg.line()
    .x(function(d) { return x2(d[0]); })
    .y(function(d) { return y2(d[1]); });

var histogram = d3.layout.histogram()
    .frequency(false)
    .bins(x2.ticks(60));

var svg2 = d3.select("#viz2").append("svg")
    .attr("width", width2 + margin2.left + margin2.right)
    .attr("height", height2 + margin2.top + margin2.bottom)
  .append("g")
    .attr("transform", "translate(" + margin2.left + "," + margin2.top + ")");

svg2.append("g")
    .attr("class", "x axis")
    .attr("transform", "translate(0," + height2 + ")")
    .call(xAxis2)
  .append("text")
    .attr("class", "label")
    .attr("x", width2)
    .attr("y", 30)
    .style("text-anchor", "end")
    .text("Votes per polling station");

svg2.append("g")
    .attr("class", "y axis")
    .call(yAxis2);

d3.csv("results_ps_freq.csv", function(data) {
  dataset01 = data.map(function(d) { return +d["1"]; });
  var data = histogram(dataset01),
      kde = kernelDensityEstimator(epanechnikovKernel(20), x2.ticks(60));

  svg2.selectAll(".bar")
      .data(data)
    .enter().insert("rect", ".axis")
      .attr("class", "bar")
      .attr("x", function(d) { return x2(d.x) + 1; })
      .attr("y", function(d) { return yalt(d.y); })
      .attr("width", x2(data[0].dx + data[0].x) - x2(data[0].x) - 1)
      .attr("height", function(d) { return height2 - yalt(d.y); });

  svg2.append("path")
      .datum(kde(dataset01))
      .attr("class", "line small")
      .attr("d", line2);
});

var svg3 = d3.select("#viz3").append("svg")
    .attr("width", width2 + margin2.left + margin2.right)
    .attr("height", height2 + margin2.top + margin2.bottom)
  .append("g")
    .attr("transform", "translate(" + margin2.left + "," + margin2.top + ")");

svg3.append("g")
    .attr("class", "x axis")
    .attr("transform", "translate(0," + height2 + ")")
    .call(xAxis2)
  .append("text")
    .attr("class", "label")
    .attr("x", width2)
    .attr("y", 30)
    .style("text-anchor", "end")
    .text("Votes per polling station");

svg3.append("g")
    .attr("class", "y axis")
    .call(yAxis2);

d3.csv("results_ps_freq.csv", function(data) {
  dataset06 = data.map(function(d) { return +d["6"]; });
  var data = histogram(dataset06),
      kde = kernelDensityEstimator(epanechnikovKernel(20), x2.ticks(60));

  svg3.selectAll(".bar")
      .data(data)
    .enter().insert("rect", ".axis")
      .attr("class", "bar")
      .attr("x", function(d) { return x2(d.x) + 1; })
      .attr("y", function(d) { return yalt(d.y); })
      .attr("width", x2(data[0].dx + data[0].x) - x2(data[0].x) - 1)
      .attr("height", function(d) { return height2 - yalt(d.y); });

  svg3.append("path")
      .datum(kde(dataset06))
      .attr("class", "line small")
      .attr("d", line2);
});

var svg4 = d3.select("#viz4").append("svg")
    .attr("width", width2 + margin2.left + margin2.right)
    .attr("height", height2 + margin2.top + margin2.bottom)
  .append("g")
    .attr("transform", "translate(" + margin2.left + "," + margin2.top + ")");

svg4.append("g")
    .attr("class", "x axis")
    .attr("transform", "translate(0," + height2 + ")")
    .call(xAxis2)
  .append("text")
    .attr("class", "label")
    .attr("x", width2)
    .attr("y", 30)
    .style("text-anchor", "end")
    .text("Votes per polling station");

svg4.append("g")
    .attr("class", "y axis")
    .call(yAxis2);

d3.csv("results_ps_freq.csv", function(data) {
  dataset32 = data.map(function(d) { return +d["32"]; });
  var data = histogram(dataset32),
      kde = kernelDensityEstimator(epanechnikovKernel(20), x2.ticks(60));

  svg4.selectAll(".bar")
      .data(data)
    .enter().insert("rect", ".axis")
      .attr("class", "bar")
      .attr("x", function(d) { return x2(d.x) + 1; })
      .attr("y", function(d) { return yalt(d.y); })
      .attr("width", x2(data[0].dx + data[0].x) - x2(data[0].x) - 1)
      .attr("height", function(d) { return height2 - yalt(d.y); });

  svg4.append("path")
      .datum(kde(dataset32))
      .attr("class", "line small")
      .attr("d", line2);
});


// digit analysis

var x3 = d3.scale.linear()
    .domain([0, 100])
    .range([0, width]);

var y3 = d3.scale.linear()
    .domain([0, 850])
    .range([height, 0]);

var xAxis3 = d3.svg.axis()
    .scale(x3)
    .orient("bottom")
    .tickValues(["00", "10", "20", "30", "40", "50", "60", "70", "80", "90", ""])
    .tickFormat(d3.format("0"))
    //.ticks(10);

var yAxis3 = d3.svg.axis()
    .scale(y3)
    .orient("left")
//    .tickFormat(d3.format(".1%"));

var histogram2 = d3.layout.histogram()
//    .frequency(false)
    .bins(x3.ticks(100));

var svg5 = d3.select("#viz5").append("svg")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
    .attr("id","chart5")
    .attr("viewBox","0 0 760 500")
    .attr("perserveAspectRatio","xMinYMid")
  .append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

svg5.append("g")
    .attr("class", "x axis")
    .attr("transform", "translate(0," + height + ")")
    .call(xAxis3)
  .append("text")
    .attr("class", "label")
    .attr("x", width)
    .attr("y", 30)
    .style("text-anchor", "end")
    .text("Last two digits of polling station vote count");

svg5.append("g")
    .attr("class", "y axis")
    .call(yAxis3);

d3.csv("countsoverhundred.csv", function(data) {
  dataset01 = data.map(function(d) { return d["x"]; });
  var data = histogram2(dataset01);

  svg5.selectAll(".bar")
      .data(data)
    .enter().insert("rect", ".axis")
      .attr("class", "bar")
      .attr("x", function(d) { return x3(d.x) + 1; })
      .attr("y", function(d) { return y3(d.y); })
      .attr("width", x3(data[0].dx + data[0].x) - x3(data[0].x) - 1)
      .attr("height", function(d) { return height - y3(d.y); });

});

var chart5 = $("#chart5"),
    aspect5 = chart5.width() / chart5.height(),
    container5 = chart5.parent();
$(window).on("resize", function() {
    var targetWidth5 = container5.width();
    chart5.attr("width", targetWidth5);
    chart5.attr("height", Math.round(targetWidth5 / aspect5));
}).trigger("resize");
