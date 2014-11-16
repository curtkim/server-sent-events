express = require 'express'
Tail = require('tail').Tail
app = express()

setInterval2 = (t,f)-> setInterval f, t

app.use '/', express.static(__dirname + '/public')

app.get '/interval', (req, res) ->
  req.socket.setTimeout(Infinity);

  messageCount = 0;

  intervalId = setInterval2 1000, ()->
    messageCount++
    #res.write('id: ' + messageCount + '\n')
    res.write("data: " + messageCount + '\n\n') # Note the extra newline

  res.writeHead 200, {
    'Content-Type': 'text/event-stream',
    'Cache-Control': 'no-cache',
    'Connection': 'keep-alive'
  }
  res.write('\n')

  req.on "close", ()->
    console.log 'closed'
    clearInterval intervalId


app.get '/tail', (req, res) ->

  tail = new Tail("temp.txt")

  req.socket.setTimeout(Infinity);

  messageCount = 0;

  res.writeHead 200, {
    'Content-Type': 'text/event-stream',
    'Cache-Control': 'no-cache',
    'Connection': 'keep-alive'
  }
  res.write('\n')

  tail.on "line", (data)->
    messageCount++
    res.write('id: ' + messageCount + '\n')
    res.write("data: " + data + '\n\n') # Note the extra newline

  req.on "close", ()->
    console.log 'closed'
    tail.unwatch()


server = app.listen 3000, ()->
  console.log 'listening at http://%s:%s', server.address().address, server.address().port