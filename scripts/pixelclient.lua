BUTTON_PIN = 3       -- GPIO0
LED_PIN    = 4       -- GPIO2
BRIGHT     = 0.1
PIXELS     = 16
ON         = BRIGHT * 255
BLUE  = string.char( 0,  0, ON)
SERVER = "d8347528.ngrok.io"

ws = websocket.createClient()

startmonitoring = function(ipaddress, regcode)

    mytimer =  tmr.create()
    
    onetimer = tmr.create()
    onetimer:register(3000, tmr.ALARM_SINGLE, function()
      ws:send('5')
      print('onetimer')
--      mytimer =
      mytimer:register(3000, tmr.ALARM_AUTO, function()
        ws:send('2') 
        --ws:send('42["chat message", "are you there"]')
        print('in timer')
      end)
      mytimer:start()
    end)
    
    ws:on("connection", function(ws)
      print('begin connection')
      --ws:send('{"command":"subscribe","identifier":"{\\"channel\\":\\"AlertChannel\\"}"}')
      --ws:send('42["chat message", "are you there"]')
      ws:send('2probe')
      print('got ws connection')      
      onetimer:start()
    end)
    ws:on("receive", function(_, msg, opcode)  
      print('got message:', msg, opcode)
      if(msg == '3') then
        --ws:send('42["chat message", "are you there"]')-- opcode is 1 for text message, 2 for binary
      else
        endraw = string.len(msg)
        beginraw = string.find(msg, ',')   
        if(beginraw ~= nil) then
            rawjson = (string.sub(msg, beginraw + 1, endraw-1)) 
            decodemsg = cjson.decode(rawjson)
            buffer = ""
            for pixel = 0, 15 do
                --buffer = buffer .. colourWheel((index + pixel * rainbow_speed) % 256)
                print(pixel, decodemsg[tostring(pixel)])
                pixeltable = decodemsg[tostring(pixel)]
                buffer = buffer .. string.char(pixeltable['g'], pixeltable['r'], pixeltable['b'])
            end
            ws2812.write(buffer)
            --for k,v in pairs(decodemsg) do 
            --    print(k,v)
            --    print(tonumber(k))
            --    for kk, vv in pairs(v) do
            --        print(kk, vv)
            --    end 
            --end
            --print(rawjson)    
        end
      end
      --print('parsed ', msg['message'])
      --decodemsg = cjson.decode(msg)
      --for k,v in pairs(decodemsg) do print(k,v) end
      --print('decoded ', decodemsg['message'])
    end)
    ws:on("close", function(_, status)
      mytimer:stop()
      print('connection closed', status)
      ws = nil -- required to lua gc the websocket client
    end)

    ws:connect('ws://' .. ipaddress .. '/socket.io/?EIO=3&transport=websocket&sid=' .. regcode)    
    
end

--startmonitoring('192.168.0.40')
http.get("http://" .. SERVER .. "/socket.io/?EIO=3&transport=polling&t=LkejpYO", nil, function(code, data, headers)
    if (code < 0) then
      print("HTTP request failed")
    else
      print(code, data)
      for k, v in pairs(headers ) do
        print(k, v)
      end
      print(headers['set-cookie'])
      endcode = string.find(headers['set-cookie'],';')
      begincode = string.find(headers['set-cookie'], '=')
      regcode = (string.sub(headers['set-cookie'], begincode + 1, endcode-1))
      ws2812.init()
      ws2812.write(BLUE:rep(PIXELS))
      startmonitoring(SERVER, regcode)
      http.get("http://" .. SERVER .. "/socket.io/?EIO=3&transport=polling&t=LkejpYO&sid=" .. regcode, nil, function(code, data, headers)
        print('monitor success')
      end)
    end
  end)
 

--findIP(lastaddress)
