--------------------------------------------------------------------------------
-- View frames grabbed from video or camera
--
-- Written by: Abhishek Chaurasia
-- Dated     : 10th June, 2016
--------------------------------------------------------------------------------

-- Torch packages
require 'image'
require 'qtwidget'

-- Local repo files
local opts = require 'opts'
local Frames = require 'frame'

-- Get the input arguments parsed and stored in opt
local opt = opts.parse(arg)

torch.setdefaulttensortype('torch.FloatTensor')

--------------------------------------------------------------------------------
-- Initialize class Frame which can be used to read videos/camera
local frame, frameRes = Frames:__init{opt}
local winHeight = frameRes[1]*opt.zoom
local winWidth = frameRes[2]*opt.zoom

-- Create a window for displaying the output
local win = qtwidget.newwindow(winWidth, winHeight, 'Video/Camera Frame')

-- profiling timers
local timer = torch.Timer()      -- whole loop
local totalTime
local tg = torch.Timer()         -- grabbing a frame
local grabTime
local tp = torch.Timer()         -- processing
local processTime
local td = torch.Timer()         -- displaying
local displayTime

while win:valid() do
   -- Reset timer to mark starting point to calculate fps
   timer:reset()

   tg:reset()
   local img = frame:forward()
   grabTime = tg:time().real

   td:reset()
   image.display{image = img, win=win, zoom=opt.zoom}
   displayTime = td:time().real

   -- Get the timer values
   totalTime = timer:time().real
   if opt.verbose then
      print("Reading:    " .. string.format('%.1f', (1000*grabTime)) .. ' ms')
      print("Displaying: " .. string.format('%.1f', (1000*displayTime)) .. ' ms')
      print("fps:        " .. string.format('%.2f', (1/totalTime)))
   end
   collectgarbage()
end
