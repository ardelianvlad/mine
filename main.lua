grid = 25
offset = 0
sizex = 15
sizey = 15

function init()
	math.randomseed(love.timer.getTime())
	for i=1,sizex do
		for j=1,sizey do
			if math.random() > 0.8 then 
				_table[i][j] = -1
			else 
				_table[i][j] = 0
			end
			_pic[i][j] = -2
		end
	end
	for i=1,sizex do
		for j=1,sizey do
			if _table[i][j] ~= -1 then
				local t = 0
				if i > 1 and j > 1 and _table[i-1][j-1] == -1 then t = t + 1 end
				if j > 1 and _table[i][j-1] == -1 then t = t + 1 end
				if i < sizex and j > 1 and _table[i+1][j-1] == -1 then t = t + 1 end
				if i < sizex and _table[i+1][j] == -1 then t = t + 1 end
				if i < sizex and j < sizey and _table[i+1][j+1] == -1 then t = t + 1 end
				if j < sizey and _table[i][j+1] == -1 then t = t + 1 end
				if i > 1 and j < sizey and _table[i-1][j+1] == -1 then t = t + 1 
				end
				if i > 1 and _table[i-1][j] == -1 then t = t + 1 end
				_table[i][j] = t
			end
		end
	end
end

function love.load()
	_table = {}
	_pic = {}
	for i=1,sizex do
		_table[i] = {}
		_pic[i] = {}
	end
	init()
	font = love.graphics.newFont(20)
	love.graphics.setFont(font)
end

function love.update()
	gameOver = true
	for i=1,sizex do
		for j=1,sizey do
			if _pic[i][j] == -2 then 
				gameOver = false
				break
			end
		end
	end
end

function love.draw()
	for i=1,sizex do
		for j=1,sizey do
			if _pic[i][j] == -2 then
				love.graphics.setColor(0, 255, 0)
				love.graphics.rectangle("fill", offset+(i-1)*grid+2, offset+(j-1)*grid+2, grid-2, grid-2)
			elseif _pic[i][j] == -1 then
				love.graphics.setColor(255, 0, 0)
				love.graphics.rectangle("fill", offset+(i-1)*grid+2, offset+(j-1)*grid+2, grid-2, grid-2)
			elseif _pic[i][j] == 0 then
				love.graphics.setColor(255, 255, 255)
				love.graphics.rectangle("fill", offset+(i-1)*grid+2, offset+(j-1)*grid+2, grid-2, grid-2)
			elseif _pic[i][j] == -3 then
				love.graphics.setColor(0, 255, 0)
				love.graphics.rectangle("fill", offset+(i-1)*grid+2, offset+(j-1)*grid+2, grid-2, grid-2)
				love.graphics.setColor(0,0,0)
				love.graphics.print("X", offset+(i-1)*grid+7, offset+(j-1)*grid+2)
			else 
				love.graphics.setColor(255, 255, 255)
				love.graphics.rectangle("fill", offset+(i-1)*grid+2, offset+(j-1)*grid+2, grid-2, grid-2)
				love.graphics.setColor(0,0,0)
				love.graphics.print(tostring(_pic[i][j]), offset+(i-1)*grid+7, offset+(j-1)*grid+2)
			end
		end
	end
	if gameOver then
		love.graphics.setColor(0,0,0)
    	love.graphics.ellipse("fill", sizex/2*grid, sizey/2*grid, 50, 50, 100)
    	love.graphics.setColor(255,255,255)
    	love.graphics.print("Retry",(sizex-2)/2*grid, (sizey-1)/2*grid)
	end
end

function love.mousepressed(x, y, button, istouch)
    if button == 1 then 
    	if gameOver then
	    	init()
	    	gameOver = false
	    else
	        for i=1,sizex do
				for j=1,sizey do
					if x > offset+(i-1)*grid and x < offset+i*grid
						and y > offset+(j-1)*grid and  y < offset+j*grid then
						_pic[i][j] = _table[i][j]
						if _pic[i][j] == -1 then
							for i=1,sizex do
								for j=1,sizey do
									_pic[i][j] = _table[i][j]
								end
						    end
						    gameOver = true
						end
						if _pic[i][j] == 0 then
							_pic[i][j] = -2
							fill(i,j)
						end
					end
				end
		    end
		end
    end
    if button == 2 then 
        for i=1,sizex do
			for j=1,sizey do
				if x > offset+(i-1)*grid and x < offset+i*grid
					and y > offset+(j-1)*grid and  y < offset+j*grid then
					if _pic[i][j] == -2 then
						_pic[i][j] = -3
					elseif _pic[i][j] == -3 then
						_pic[i][j] = -2
					end
				end
			end
	    end
    end
end

function fill(i,j)
	isHidden = _pic[i][j]
	_pic[i][j] = _table[i][j]
	if  _table[i][j] == 0 and isHidden == -2 then
		if i > 1 and j > 1 then fill(i-1,j-1) end
		if j > 1 then fill(i,j-1) end
		if i < sizex and j > 1 then fill(i+1,j-1) end
		if i < sizex then fill(i+1,j) end
		if i < sizex and j < sizey then fill(i+1,j+1) end
		if j < sizey then fill(i,j+1) end
		if i > 1 and j < sizey then fill(i-1,j+1)	 end
		if i > 1 then fill(i-1,j) end
	end
end
	
--  0 - empty
-- -1 - bomb
-- -2 - hidden
-- -3 - flag