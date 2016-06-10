--------------------------------------------------------------------------------
-- Acquire frames from camera/video/folder with images.
--
-- Needs the following values:
-- 1) opt.camID:  Camera device to be selected incase of multiple cameras
--                (in case of one camera by default set it to 0)
-- 2) opt.camRes: Resolution of the image to be captured by camera
-- 3) opt.input:  'cam' for camera or path to the video file
-- 4) opt.ratio:  Ratio by which input frame has to be rescaled
--
-- * Constructor initialization returns self and frame resolution
-- * Forward function return RGB frame
--
-- Written by: Abhishek Chaurasia
-- Dated: 26th March, 2016
--------------------------------------------------------------------------------

local Frames = {}

local cv = require 'cv'
require 'cv.highgui'
require 'cv.videoio'
require 'cv.imgproc'

function Frames:__init(o)
   opt = o[1]

   local cap               -- openCV videoCapture object
--------------------------------------------------------------------------------
   -- check if input is a camera device or a video file
   if opt.input:lower() == 'cam' then
      cap = cv.VideoCapture{device=opt.camID}
      if not cap:isOpened() then
         print("Failed to open the default camera")
         os.exit(-1)
      end
      local res = {HVGA  = {w= 320, h= 240},
                   QHD   = {w= 640, h= 360},
                   VGA   = {w= 640, h= 480},
                   FWVGA = {w= 854, h= 480},
                   HD    = {w=1280, h= 720},
                   FHD   = {w=1920, h=1080}}
      cap:set{cv.CAP_PROP_FRAME_WIDTH, res[opt.camRes].w}
      cap:set{cv.CAP_PROP_FRAME_HEIGHT, res[opt.camRes].h}
      -- cap:set{cv.CAP_PROP_FPS, opt.fps}
      print(opt.fps)
      print("Accessing camera (" .. opt.camID .. ")")
      print("Camera resolution set to: " .. res[opt.camRes].h .. " x " .. res[opt.camRes].w)
   else
--------------------------------------------------------------------------------
      cap = cv.VideoCapture{opt.input}
      -- cap:set{cv.CAP_PROP_FPS, opt.fps}
      if not cap:isOpened() then
         print("Failed to open the video file at:")
         print(opt.input)
         os.exit(-1)
      end
      print("Reading video file:")
      print(opt.input)
   end

   --cv.namedWindow{"edges", cv.WINDOW_AUTOSIZE}
--------------------------------------------------------------------------------
   -- capture the first frame
   local _, frameCV = cap:read{}

   -- get the resolution of the frame
   local height = frameCV:size(1) * opt.ratio
   local width = frameCV:size(2) * opt.ratio
   local frameRes = {height, width}

   -- print the resolution of the frame
   if not (opt.input:lower() == 'cam') then
      print("Frame resolution is: ".. height .. " x " .. width)
   end

--------------------------------------------------------------------------------
   -- Forward function to capture next frames
   if opt.ratio == 1 then
      self.forward = function()
         --cv.imshow{"edges", frameCV}

         -- read next frame
         cap:read{frameCV}

         -- Go from BGR=>RGB and then from hxwx3 => 3xhxw
         local frameTH = frameCV:clone()
         cv.cvtColor{frameCV, frameTH, cv.COLOR_BGR2RGB}
         frameTH = frameTH:transpose(1,3):transpose(2,3)
         return(frameTH)
      end
   else
--------------------------------------------------------------------------------
      self.forward = function()
         -- read next frame
         cap:read{frameCV}

         -- resize frame
         local frameTH = torch.ByteTensor(height, width, 3)
         local dim = cv.Size(width, height)
         cv.resize{src = frameCV, dst = frameTH, dsize = dim, fx = 0, fy = 0, interpolation = cv.INTER_AREA}

         -- Go from BGR=>RGB and then from hxwx3 => 3xhxw
         cv.cvtColor{frameTH, frameTH, cv.COLOR_BGR2RGB}
         frameTH = frameTH:transpose(1,3):transpose(2,3)
         return(frameTH)
      end
   end
   return self, frameRes
end

return Frames
