local lfs <const> = require("lfs")

local record fs
   exists: function(path: string): (boolean, string)
   mode: function(path: string): (lfs.Attributes.mode | nil, string)
   is_file: function(path: string): boolean
   is_directory: function(path: string): boolean

   join: function(...: string): string
   normalize: function(path: string): string

   read_file: function(path: string): (string | boolean, string)
   write_file: function(path: string, content?: string): (boolean, string)
   append_file: function(path: string, content: string): (boolean, string)
   touch: function(path: string): (boolean, string)
   copy_file: function(path_from: string, path_to: string): (boolean, string)
   move_file: function(path_from: string, path_to: string): (boolean, string)
   remove_file: function(path: string): (boolean, string)

   mkdir: function(path: string): (boolean, string)
   -- mkdir_recursive: function(path: string): (boolean, string)
   rmdir: function(path: string): (boolean, string)
   -- rmdir_recursive: function(path: string): (boolean, string)
end

function fs.mode(path: string): (lfs.Attributes.mode | nil, string)
   local mode, err = lfs.attributes(path, "mode")
   return mode and mode or nil, err
end

function fs.exists(path: string): (boolean, string)
   local mode, err = fs.mode(path)
   return mode and true or false, err
end

function fs.is_file(path: string): boolean
   local mode, _ = fs.mode(path)
   return mode == "file"
end

function fs.is_directory(path: string): boolean
   local mode, _ = fs.mode(path)
   return mode == "directory"
end


function fs.join(...: string): string
   local parts = {...}
   assert(#parts > 0,
      "Argument <...>: Must be strings.")
   return fs.normalize(table.concat(parts, "/"))
end

function fs.normalize(path: string): string
   assert(type(path) == "string", "path must be a string")

   local is_absolute = path:sub(1, 1) == "/"
   local parts = {}
   
   for part in path:gmatch("[^/]+") do
      if part == ".." then
         if #parts > 0 and parts[#parts] ~= ".." then
            table.remove(parts)
         elseif not is_absolute then
            table.insert(parts, "..")
         end
      elseif part ~= "." and part ~= "" then
         table.insert(parts, part)
      end
   end

   local normalized = table.concat(parts, "/")
   if is_absolute then
      normalized = "/" .. normalized
   end

   if normalized == "" then
      return is_absolute and "/" or "."
   end

   return normalized
end


function fs.read_file(path: string): (string | boolean, string)
   path = fs.normalize(path)
   local file, err: FILE, string
   file, err = io.open(path, "r")
   if not file then
      return false, err
   end
end

function fs.write_file(path: string, content?: string): (boolean, string)
   path = fs.normalize(path)
   local file, ok, err: FILE, boolean, string
   file, err = io.open(path, "w+")
   if not file then
      return false, err
   end
   if content then
      file, err = file:write(content)
      if not ok then
         return false, err
      end
   end
   return true
end

return fs
