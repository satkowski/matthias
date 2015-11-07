# Description:
#   FSR Krams
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot protokoll - Frag' hubot nach dem aktuellem protokoll
#   hubot protokoll <datum> - Frag' hubot nach dem Protokoll von <datum> (ISO-Format)
#   hubot ese - hubot sagt dir das Datum der ESE (falls das jemand updated)
#   hubot bürostatus - hubot sagt dir, ob aktuell wer im Büro ist.
#
# Author:
#   kiliankoe


module.exports = (robot) ->
  robot.respond /protokoll(.*)/i, (msg) ->
    date = msg.match[1]
    if date == ""
      msg.send "https://www.ifsr.de/protokolle/current.pdf"
    else
      year = date.split("-")[0]
      dateobj = new Date(date)
      if dateobj.getDay() != 1
        msg.send "Das war leider kein Sitzungsdatum."
      else
        msg.send "https://www.ifsr.de/protokolle/#{year.slice(1, year.length)}/#{date.slice(1, date.length)}.pdf"

  robot.respond /ese/i, (msg) ->
    currentdate = new Date()
    esedate = new Date("2015-10-05 9:00:00")
    datediff = esedate - currentdate

    days = Math.floor(datediff/1000/60/60/24)
    datediff -= days*24*3600*1000
    hours = Math.floor(datediff/1000/60/60)
    datediff -= hours*3600*1000
    minutes = Math.floor(datediff/1000/60)
    msg.send "Nur noch #{days} Tage, #{hours} Stunden und #{minutes} Minuten bis zur ESE 2015."

  robot.respond /buero|buerostatus|büro|bürostatus/i, (msg) ->
    robot.http('https://www.ifsr.de/buerostatus/output.php')
      .get() (err, res, body) ->
        if body.trim() == "1"
          msg.send "Jemand da."
        else if body.trim() == "0"
          msg.send "Keiner da."
        else
          msg.send "Keine Ahnung, Sebastian hat schon wieder unerwartet was geändert!"
