http.get("http://news.ycombinator.com", 
    nil, function(code, data, headers)
    print(code, data, headers)
end)