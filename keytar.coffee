xml2object = require "xml2object"
request = require "request"
util = require "util"

METAR_API_URL = "http://aviationweather.gov/adds/dataserver_current/httpparam" +
  "?dataSource=metars&requestType=retrieve&format=xml&hoursBeforeNow=1" +
  "&stationString=%s"

keytar = require("zappajs").app ->
  @view index: ->
    doctype 5
    html ->
      body ->
        h1 -> "METAR"
        p -> "Visit /metar/:station_id to retrieve METAR as JSON"

  @get "/": ->
    @render "index"

  @get "/metar/:station": ->
    parser = new xml2object ["METAR"]
    parser.on "object", (name, obj) =>
      @send obj

    metarUrl = util.format METAR_URL, @params.station
    request.get(metarUrl).pipe(parser.saxStream)

keytar.app.listen Number(process.env.PORT || 3000)