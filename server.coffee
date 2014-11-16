express = require 'express'
app = express()

setInterval2 = (t,f)-> setInterval f, t

app.use '/', express.static(__dirname + '/public')

app.get '/update-stream', (req, res) ->
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

server = app.listen 3000, ()->
  console.log 'listening at http://%s:%s', server.address().address, server.address().port