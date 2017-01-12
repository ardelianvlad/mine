-- config --


require('globals')


function love.conf(t)
    t.identity = nil
    t.version = "0.10.1"
    t.console = false
    t.accelerometerjoystick = true
    t.externalstorage = false
    t.gammacorrect = false
 
    t.window.title = "Mine"
    t.window.icon = 'img/flag-2.png'
    t.window.width = sizex*grid+2
    t.window.height = sizey*grid+2
    t.window.borderless = false
    t.window.resizable = false
    t.window.minwidth = 1
    t.window.minheight = 1
    t.window.fullscreen = false
    t.window.fullscreentype = "desktop"
    t.window.vsync = true
    t.window.msaa = 0
    t.window.display = 1
    t.window.highdpi = false
    t.window.x = nil
    t.window.y = nil
 
    t.modules.audio = false
    t.modules.event = true
    t.modules.graphics = true
    t.modules.image = true
    t.modules.joystick = false
    t.modules.keyboard = true
    t.modules.math = true
    t.modules.mouse = true
    t.modules.physics = false
    t.modules.sound = false
    t.modules.system = true
    t.modules.timer = true
    t.modules.touch = false
    t.modules.video = true
    t.modules.window = true
    t.modules.thread = true
end