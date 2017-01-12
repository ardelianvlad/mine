-- main --

require('globals')


-- Ініціалізація змінних при завантаженні
function love.load()
	-- таблиця зі значеннями комірок
	_table = {}
	-- таблиця з ігровим полем
	_pic = {}
	for i=1,sizex do
		_table[i] = {}
		_pic[i] = {}
	end
	-- заповнюємо комірки
	init()
	-- завантажуємо шрифт
	font = love.graphics.newFont('fonts/ka1.ttf', 20)
	love.graphics.setFont(font)
	-- завантажуємо текстури
	mineImg = love.graphics.newImage('img/mine-1.png')
	flagImg = love.graphics.newImage('img/flag-1.png')
	boomImg = love.graphics.newImage('img/boom.png')
end


-- Малюємо комірки
function love.draw()
	for i=1,sizex do
		for j=1,sizey do
			if _pic[i][j] == HIDDEN then
				love.graphics.setColor(80, 100, 255)
				love.graphics.rectangle("fill", (i-1)*grid+2, (j-1)*grid+2, grid-2, grid-2)
			elseif _pic[i][j] == BOMB then
				love.graphics.setColor(255, 255, 255)
				love.graphics.rectangle("fill", (i-1)*grid+2, (j-1)*grid+2, grid-2, grid-2)
				love.graphics.draw(boomImg, (i-1)*grid+2, (j-1)*grid+2, 0, grid/100)
			elseif _pic[i][j] == DEFUSED then
				love.graphics.setColor(255, 255, 255)
				love.graphics.rectangle("fill", (i-1)*grid+2, (j-1)*grid+2, grid-2, grid-2)
				love.graphics.draw(mineImg, (i-1)*grid+2, (j-1)*grid+2, 0, grid/100)
			elseif _pic[i][j] == EMPTY then
				love.graphics.setColor(255, 255, 255)
				love.graphics.rectangle("fill", (i-1)*grid+2, (j-1)*grid+2, grid-2, grid-2)
			elseif _pic[i][j] == FLAG then
				love.graphics.setColor(80, 100, 255)
				love.graphics.rectangle("fill", (i-1)*grid+2, (j-1)*grid+2, grid-2, grid-2)
				love.graphics.setColor(255,255,255)
				love.graphics.draw(flagImg, (i-1)*grid+2, (j-1)*grid+2, 0, grid/100)
			else 
				love.graphics.setColor(255, 255, 255)
				love.graphics.rectangle("fill", (i-1)*grid+2, (j-1)*grid+2, grid-2, grid-2)
				love.graphics.setColor(0,0,0)
				love.graphics.print(tostring(_pic[i][j]), (i-1)*grid+7, (j-1)*grid+2)
			end
		end
	end
	-- якщо "Кінець гри" - виводимо запрошення зіграти ще раз
	if gameOver then
		love.graphics.setColor(0,0,0,180)
		love.graphics.rectangle("fill", 0, (sizey-2.5)/2*grid, sizex*grid, 2.5*grid)
		love.graphics.setColor(255,255,255)
		love.graphics.printf("RETRY", 0, (sizey-1)/2*grid, sizex*grid, 'center')
	end
end


-- Оброблюємо натиснення кнопок миші
function love.mousepressed(x, y, button, istouch)
	-- ліва кнопка миші
	if button == 1 then
		-- якщо "Кінець гри" - будуємо поле заново
		if gameOver then
			init()
			gameOver = false
		-- інакше перевіряємо натиснення на відповідну комірку
		else
			for i=1,sizex do
				for j=1,sizey do
					if x > (i-1)*grid and x < i*grid
						and y > (j-1)*grid and  y < j*grid then
						_pic[i][j] = _table[i][j]
						-- якщо в комірці "міна" - то гра закінчилась 
						if _pic[i][j] == BOMB then
							for i=1,sizex do
								for j=1,sizey do
									_pic[i][j] = _table[i][j]
								end
							end
							gameOver = true
						end
						-- якщо в комірці пусто - відкриваємо сусідні комірки
						if _pic[i][j] == EMPTY then
							_pic[i][j] = HIDDEN
							fill(i,j)
						end
					end
				end
			end
		end
	end
	-- права копка миші
	if button == 2 then 
		for i=1,sizex do
			for j=1,sizey do
				if x > (i-1)*grid and x < i*grid
					and y > (j-1)*grid and  y < j*grid then
					-- ставимо/ знімаємо прапорець
					if _pic[i][j] == HIDDEN then
						_pic[i][j] = FLAG
						if _table[i][j] == BOMB then _table[i][j] = DEFUSED end
					elseif _pic[i][j] == FLAG then
						_pic[i][j] = HIDDEN
						if _table[i][j] == DEFUSED then _table[i][j] = BOMB end
					end
				end
			end
		end
	end
end


-- Рекурсивне відкриття порожних та сусідних комірок
function fill(i,j)
	isHidden = _pic[i][j]
	_pic[i][j] = _table[i][j]
	if  _table[i][j] == EMPTY and isHidden == HIDDEN then
		if i > 1 and j > 1 then fill(i-1,j-1) end
		if j > 1 then fill(i,j-1) end
		if i < sizex and j > 1 then fill(i+1,j-1) end
		if i < sizex then fill(i+1,j) end
		if i < sizex and j < sizey then fill(i+1,j+1) end
		if j < sizey then fill(i,j+1) end
		if i > 1 and j < sizey then fill(i-1,j+1) end
		if i > 1 then fill(i-1,j) end
	end
end


-- Рандомно заповнюємо комірки мінами
function init()
	-- заповнюємо мінами
	math.randomseed(love.timer.getTime())
	for i=1,sizex do
		for j=1,sizey do
			if math.random() > 0.8 then 
				_table[i][j] = BOMB
			else 
				_table[i][j] = EMPTY
			end
			_pic[i][j] = HIDDEN
		end
	end
	-- заповнюємо комірки числами
	for i=1,sizex do
		for j=1,sizey do
			if _table[i][j] ~= BOMB then
				local t = 0
				if i > 1 and j > 1 and _table[i-1][j-1] == BOMB then t = t + 1 end
				if j > 1 and _table[i][j-1] == BOMB then t = t + 1 end
				if i < sizex and j > 1 and _table[i+1][j-1] == BOMB then t = t + 1 end
				if i < sizex and _table[i+1][j] == BOMB then t = t + 1 end
				if i < sizex and j < sizey and _table[i+1][j+1] == BOMB then t = t + 1 end
				if j < sizey and _table[i][j+1] == BOMB then t = t + 1 end
				if i > 1 and j < sizey and _table[i-1][j+1] == BOMB then t = t + 1 end
				if i > 1 and _table[i-1][j] == BOMB then t = t + 1 end
				_table[i][j] = t
			end
		end
	end
end
