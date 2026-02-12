local lfs <const> = require("lfs")

local record fs
   home:         string
   config_dir:   string

   -- OS utils
   is_windows:   function():                                   (boolean)

   -- Path
   join:         function(...: string):                        string
   normalize:    function(path: string):                       string

   -- Utils
   exists:       function(path: string):                       (boolean, string)
   mode:         function(path: string):                       (lfs.Attributes.mode | nil, string)
   is_file:      function(path: string):                       boolean
   is_directory: function(path: string):                       boolean

   -- File
   read_file:    function(path: string):                       (string, string)
   write_file:   function(path: string, content?: string):     (boolean, string)
   append_file:  function(path: string, content: string):      (boolean, string)
   touch:        function(path: string):                       (boolean, string)
   copy_file:    function(path_from: string, path_to: string): (boolean, string)
   move_file:    function(path_from: string, path_to: string): (boolean, string)
   remove_file:  function(path: string):                       (boolean, string)

   -- Directory
   mkdir:        function(path: string):                       (boolean, string)
   mkdir_recursive: function(path: string): (boolean, string)
   rmdir:        function(path: string):                       (boolean, string)
   -- rmdir_recursive: function(path: string): (boolean, string)
end

--+ OS utils +--
function fs.is_windows(): boolean
   return package.config:sub(1, 1) == "\\"
end

local function get_home(): string
   return os.getenv("HOME")
      or os.getenv("USERPROFILE")
      or (os.getenv("HOMEDRIVE") and os.getenv("HOMEPATH")
         and (os.getenv("HOMEDRIVE") .. os.getenv("HOMEPATH")))
end

local function get_config_dir(): string
   if fs.is_windows() then
      return os.getenv("APPDATA")
   end

   return os.getenv("XDG_CONFIG_HOME")
      or (fs.home and (fs.home .. "/.config"))
end

fs.home = get_home()
fs.config_dir = get_config_dir()

--+ Path +--
function fs.join(...: string): string
   local parts = {...}
   assert(#parts > 0,
      "Argument <...>: Must be strings.")
   return fs.normalize(table.concat(parts, "/"))
end

function fs.normalize(path: string): string
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

--+ Utils +--
function fs.mode(path: string): (lfs.Attributes.mode | nil, string)
   path = fs.normalize(path)
   local mode, err = lfs.attributes(path, "mode")
   return mode and mode or nil, err
end

function fs.exists(path: string): (boolean, string)
   path = fs.normalize(path)
   local mode, err = fs.mode(path)
   return mode and true or false, err
end

function fs.is_file(path: string): boolean
   path = fs.normalize(path)
   local mode, _ = fs.mode(path)
   return mode == "file"
end

function fs.is_directory(path: string): boolean
   path = fs.normalize(path)
   local mode, _ = fs.mode(path)
   return mode == "directory"
end

--+ Files +--
function fs.read_file(path: string): (string, string)
   local file, content, err: FILE, string, string
   path = fs.normalize(path)

   file, err = io.open(path, "r")
   if not file then
      return nil, err
   end

   content, err = file:read("*a")
   file:close()
   if not content then
      return nil, err
   end

   return content
end

function fs.write_file(path: string, content?: string): (boolean, string)
   local _: any
   path = fs.normalize(path)

   local file, err = io.open(path, "w")
   if not file then
      return false, err
   end

   if content then
      _, err = file:write(content)
      if err then
         file:close()
         return false, err
      end
   end

   file:close()
   return true
end

function fs.append_file(path: string, content: string): (boolean, string)
   local _: any                                                                -- Fix "unknown variable: _" compiler error
   path = fs.normalize(path)
   
   local file, err = io.open(path, "a")
   if not file then
      return false, err
   end

   _, err = file:write(content)
   if err then
      file:close()
      return false, err
   end

   file:close()
   return true
end

function fs.touch(path: string): (boolean, string)
   path = fs.normalize(path)
   
   local ok, err = lfs.touch(path)

   return ok and true or false, err
end

function fs.copy_file(path_from: string, path_to: string): (boolean, string)
   local ok: boolean
   path_from = fs.normalize(path_from)
   path_to = fs.normalize(path_to)

   local content, err = fs.read_file(path_from)
   if not content then return false, err end

   ok, err = fs.write_file(path_to, content)
   if not ok then
      return false, err
   end

   return true
end

function fs.move_file(path_from: string, path_to: string): (boolean, string)
   path_from = fs.normalize(path_from)
   path_to = fs.normalize(path_to)

   local ok, err = os.rename(path_from, path_to)
   if ok then return true end

   -- OS incompatibility fallback
   ok, err = fs.copy_file(path_from, path_to)

   if not ok then return false, err end

   ok, err = fs.remove_file(path_from)
   return ok and true or false, err
end

function fs.remove_file(path: string): (boolean, string)
   path = fs.normalize(path)

   local ok, err = os.remove(path)
   return ok and true or false, err
end

--+ Directory +--
function fs.mkdir(path: string): (boolean, string)
   path = fs.normalize(path)

   local ok, err = lfs.mkdir(path)
   return ok and true or false, err
end

function fs.mkdir_recursive(path: string): (boolean, string)
   path = fs.normalize(path)

   if fs.is_directory(path) then
      return true
   end

   if fs.is_file(path) then
      return false, "Path exists and is not a directory"
   end

   local current = ""
   local is_absolute = path:sub(1, 1) == "/"

   for part in path:gmatch("[^/]+") do
      if current == "" then
         current = part
      else
         current = current .. "/" .. part
      end

      local dir = is_absolute and ("/" .. current) or current

      if not fs.is_directory(dir) then
         local ok, err = fs.mkdir(dir)
         if not ok then
            return false, err
         end
      end
   end

   return true
end



function fs.rmdir(path: string): (boolean, string)
   path = fs.normalize(path)

   local ok, err = lfs.rmdir(path)
   return ok and true or false, err
end

return fs
