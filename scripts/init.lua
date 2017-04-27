
BUTTON_PIN = 3       -- GPIO0
LED_PIN    = 4       -- GPIO2
BRIGHT     = 0.1
PIXELS     = 16
ON         = BRIGHT * 255
BLUE  = string.char( 0,  0, ON)
--SERVER = "d8347528.ngrok.io"
SERVER = "138.68.243.2"
TIME_ALARM = 50      -- 0.025 second, 40 Hz
TIME_SLOW  = 500000  -- 0.500 second,  2 Hz

ws = websocket.createClient()

function colourWheel(index)
  if index < 85 then
    return string.char(index * 3 * BRIGHT, (255 - index * 3) * BRIGHT, 0)
  elseif index < 170 then
    index = index - 85
    return string.char((255 - index * 3) * BRIGHT, 0, index * 3 * BRIGHT)
  else
    index = index - 170
    return string.char(0, index * 3 * BRIGHT, (255 - index * 3) * BRIGHT)
  end
end

rainbow_speed = 16

function rainbow(index)
  buffer = ""
  for pixel = 0, 15 do
    buffer = buffer .. colourWheel((index + pixel * rainbow_speed) % 256)
  end
  return buffer
end

rainbow_index = 0

function rainbowHandler()
  if gpio.read(BUTTON_PIN) == 1 then
    ws2812.write(rainbow(rainbow_index))
    rainbow_index = (rainbow_index + 1) % 256
  else
    tmr.stop(1)
    print("rainbowHandler: EXIT");
  end
end

print("setting timeer")

delayRainbowDone = function()
   tmr.alarm(1, TIME_ALARM, 1, rainbowHandler)  
end

delayRainbow = function()
    tmr.alarm(2, 2000, 0, delayRainbowDone)
end

startmonitoring = function(ipaddress, regcode, delayRain)


    function colourWheel(index)
        if index < 85 then
            return string.char(index * 3 * BRIGHT, (255 - index * 3) * BRIGHT, 0)
        elseif index < 170 then
            index = index - 85
            return string.char((255 - index * 3) * BRIGHT, 0, index * 3 * BRIGHT)
        else
            index = index - 170
            return string.char(0, index * 3 * BRIGHT, (255 - index * 3) * BRIGHT)
        end
    end

    rainbow_speed = 16

    rainbow1 = function(index)
        buffer = ""
        for pixel = 0, 15 do
            buffer = buffer .. colourWheel((index + pixel * rainbow_speed) % 256)
        end
        return buffer
    end

    rainbow_index = 0

    rainbowHand = function()
        if gpio.read(BUTTON_PIN) == 1 then
            ws2812.write(rainbow1(rainbow_index))
            rainbow_index = (rainbow_index + 1) % 256
        else
            tmr.stop(1)
            print("rainbowHandler: EXIT");
        end
    end

    print("setting timeer")

    delayRainbowDone1 = function()
        tmr.alarm(1, TIME_ALARM, 1, rainbowHand)  
    end

    delayRainbow1 = function()
        tmr.alarm(2, 2000, 0, delayRainbowDone1)
    end

    delayRainbow1()

    mytimer =  tmr.create()
    
    onetimer = tmr.create()
    onetimer:register(3000, tmr.ALARM_SINGLE, function()
      ws:send('5')
      print('onetimer')
      mytimer:register(3000, tmr.ALARM_AUTO, function()
        ws:send('2') 
        print('in timer')
      end)
      mytimer:start()
    end)
    
    ws:on("connection", function(ws)
      print('begin connection')
      ws:send('2probe')
      print('got ws connection')      
      onetimer:start()
    end)
    ws:on("receive", function(_, msg, opcode)  
      print('got message:', msg, opcode)
      if(msg == '3') then
        --ws:send('42["chat message", "are you there"]')-- opcode is 1 for text message, 2 for binary
      else
        tmr.stop(1)
        print(TIME_ALARM)
        delayRainbow1()
        endraw = string.len(msg)
        beginraw = string.find(msg, ',')   
        if(beginraw ~= nil) then
            rawjson = (string.sub(msg, beginraw + 1, endraw-1)) 
            decodemsg = cjson.decode(rawjson)
            buffer = ""
            for pixel = 0, 15 do
                print(pixel, decodemsg[tostring(pixel)])
                pixeltable = decodemsg[tostring(pixel)]
                buffer = buffer .. string.char(pixeltable['g'], pixeltable['r'], pixeltable['b'])
            end
            ws2812.write(buffer)
        end
      end

    end)
    ws:on("close", function(_, status)
      mytimer:stop()
      print('connection closed', status)
      --ws = nil -- required to lua gc the websocket client

      reconnect = function()
        print("reconnecting")
        startmonitoring(ipaddress, regcode, delayRain)
      end
      tmr.alarm(3, 10000, 0, connectit)      
    end)

    ws:connect('ws://' .. ipaddress .. '/socket.io/?EIO=3&transport=websocket&sid=' .. regcode)    
    
end

connectit = function()
http.get("http://" .. SERVER .. "/socket.io/?EIO=3&transport=polling&t=LkejpYO", nil, function(code, data, headers)
    if (code < 0) then
      print("HTTP request failed")
      tmr.alarm(3, 10000, 0, connectit)
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
      print("monitoring")
      delayRainbow()
      startmonitoring(SERVER, regcode, delayRainbow)
      http.get("http://" .. SERVER .. "/socket.io/?EIO=3&transport=polling&t=LkejpYO&sid=" .. regcode, nil, function(code, data, headers)
        print('monitor success')
      end)
    end
  end)
end

wifi.eventmon.register(wifi.eventmon.STA_GOT_IP, function(T)
 print("\n\tSTA - GOT IP".."\n\tStation IP: "..T.IP.."\n\tSubnet mask: "..
 T.netmask.."\n\tGateway IP: "..T.gateway)
 tmr.stop(3)
 connectit()
 end)

