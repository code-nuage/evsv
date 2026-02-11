return function(file_name: string)
   local file = io.open(file_name, "r")
   print(file:read("*a"))
   file:close()
end