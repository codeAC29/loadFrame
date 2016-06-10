--------------------------------------------------------------------------------
-- Contains options required by main.lua
--
-- Written by: Abhishek Chaurasia
-- Dated     : 10th June, 2016
--------------------------------------------------------------------------------

local opts = {}

lapp = require 'pl.lapp'
function opts.parse(arg)
   local opt = lapp [[
   Command line options:
   ## I/O
   -i, --input    (default cam)
                  Input cam/folder/file location for camera/image/video respectively
   -r, --ratio    (default 1)
                  Rescale image size for faster processing
   -v, --verbose  Verbose mode
   -z, --zoom     (default 1)
                  Zoom for display
   --camID        (default 0)
                  Select the camera number
   --camRes       (default VGA)
                  Resolution of the camera: QHD/VGA/FWVGA/HD/FHD
   --fps          (default 30)
                  fps for input
   ]]
   return opt
end

return opts
