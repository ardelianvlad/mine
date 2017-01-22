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
	-- обрахуємо кількість мін
	mines_qty = math.floor(0.15*sizex*sizey)
	-- заповнюємо комірки
	init()
	-- завантажуємо шрифт
	font = love.graphics.newFont('fonts/ka1.ttf', 2/3*grid)
	love.graphics.setFont(font)
	-- завантажуємо текстури
	mineImg = love.graphics.newImage('img/mine-1.png')
	flagImg = love.graphics.newImage('img/flag-1.png')
	boomImg = {}
	for i=1,6 do
		boomImg[i] = love.graphics.newImage('img/boom/boom-'.. tostring(i) ..'.png')
	end
	scullImg = {}
	scullImg[1] = love.graphics.newImage('img/scull/scull-1.png')
	scullImg[2] = love.graphics.newImage('img/scull/scull-2.png')
	winImg = love.graphics.newImage('img/win.png')
	-- Завантажуємо звуки
	sonarSound = love.audio.newSource('sounds/sonar.wav')
	sonarOffSound = love.audio.newSource('sounds/sonar-off.wav')
	explosionSound = love.audio.newSource('sounds/explosion.wav')
	winSound = love.audio.newSource('sounds/win.wav')
	openSound = love.audio.newSource('sounds/open.wav')
end


-- Перевірка чи гра закінчена
-- в даному випадку "gameOver" означає що гравець відкрив усі комірки
function love.update(dt)
	if not win then
		win = true
		for i=1,sizex do
			for j=1,sizey do
				if _pic[i][j] == HIDDEN then 
					win = false
					break
				end
			end
		end
		win = win and not gameOver
		if win then
			love.audio.play(winSound)
		end
	end
	if win then
		for i=1,sizex do
			for j=1,sizey do
				_pic[i][j] = _table[i][j]
			end
		end
		winTime = winTime + dt
		if winTime > 0.2 then
			if winFrame == 1 then
				winFrame = 2
			else
				winFrame = 1
			end
			winTime = 0
		end
	end
	if gameOver then
		scullTime = scullTime + dt
		if scullTime > 0.3 then
			if scullFrame == 1 then
				scullFrame = 2
			else
				scullFrame = 1
			end
			scullTime = 0
		end
		boomTime = boomTime + dt
		if boomTime > 0.1 then
			if boomFrame < 6 then
				boomFrame = boomFrame + 1
				boomTime = 0
			end
		end
	end
end


-- Малюємо комірки
function love.draw()
	-- якщо "Кінець гри" - виводимо "Череп"
	if gameOver and boomFrame > 5 then
		if scullFrame == 1 then
			love.graphics.setColor(250,250,0)
		else
			love.graphics.setColor(250,0,0)
		end
		love.graphics.rectangle("fill", 0, 0, grid*sizex+2, grid*sizey+2)
		love.graphics.setColor(0,0,0)
		love.graphics.printf("GAME", 0, 0.05*grid*sizey, sizex*grid, 'center')
		love.graphics.printf("OVER", 0, 0.85*grid*sizey, sizex*grid, 'center')
		love.graphics.setColor(255,255,255)
		love.graphics.draw(scullImg[scullFrame], grid*sizex*(0.125), grid*sizey*(0.125), 0, grid*sizey/480)
	-- якщо гравець відкрив усі комірки правильно
	elseif win then
		if winFrame == 1 then
			love.graphics.setColor(0,180,180)
		else
			love.graphics.setColor(180,0,60)
		end
		love.graphics.rectangle("fill", 0, 0, grid*sizex+2, grid*sizey+2)
		love.graphics.setColor(0,0,0)
		love.graphics.printf("YOU", 0, 0.05*grid*sizey, sizex*grid, 'center')
		love.graphics.printf("WIN", 0, 0.85*grid*sizey, sizex*grid, 'center')
		love.graphics.setColor(255,255,255)
		love.graphics.draw(winImg, grid*sizex*(0.125), grid*sizey*(0.125), 0, grid*sizey/480)
	-- малюємо комірки
	else
		for i=1,sizex do
			for j=1,sizey do
				if _pic[i][j] == HIDDEN then
					love.graphics.setColor(80, 100, 255)
					love.graphics.rectangle("fill", (i-1)*grid+2, (j-1)*grid+2, grid-2, grid-2)
				elseif _pic[i][j] == BOMB then
					love.graphics.setColor(255, 255, 255)
					love.graphics.rectangle("fill", (i-1)*grid+2, (j-1)*grid+2, grid-2, grid-2)
					love.graphics.draw(boomImg[boomFrame], (i-1)*grid+2, (j-1)*grid+2, 0, grid/100)
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
	end
end


-- Оброблюємо натиснення кнопок миші
function love.mousepressed(x, y, button, istouch)
	-- ліва кнопка миші
	if button == 1 then
		-- якщо "Кінець гри" - будуємо поле заново
		if gameOver or win then
			init()
			gameOver = false
			win = false
		-- інакше перевіряємо натиснення на відповідну комірку
		else
			for i=1,sizex do
				for j=1,sizey do
					if x > (i-1)*grid and x < i*grid
						and y > (j-1)*grid and  y < j*grid then
						love.audio.stop(openSound)
						love.audio.play(openSound)
						_pic[i][j] = _table[i][j]
						-- якщо в комірці "міна" - то гра закінчилась 
						if _table[i][j] == BOMB or _table[i][j] == DEFUSED then
							_table[i][j] = BOMB
							for i=1,sizex do
								for j=1,sizey do
									_pic[i][j] = _table[i][j]
								end
							end
							gameOver = true
							love.audio.play(explosionSound)
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
					if _pic[i][j] == HIDDEN and flags_qty <= mines_qty then
						_pic[i][j] = FLAG
						flags_qty = flags_qty + 1
						if _table[i][j] == BOMB then _table[i][j] = DEFUSED end
						love.audio.stop(sonarSound)
						love.audio.play(sonarSound)
					elseif _pic[i][j] == FLAG then
						_pic[i][j] = HIDDEN
						flags_qty = flags_qty - 1
						if _table[i][j] == DEFUSED then _table[i][j] = BOMB end
						love.audio.stop(sonarOffSound)
						love.audio.play(sonarOffSound)
					end
				end
			end
		end
	end
end


-- Рекурсивне відкриття порожних та сусідних комірок
function fill(i,j)
	if _pic[i][j] == FLAG then
		flags_qty = flags_qty - 1
	end
	isHidden = _pic[i][j]
	_pic[i][j] = _table[i][j]
	if  _table[i][j] == EMPTY and (isHidden == HIDDEN or isHidden == FLAG) then
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
			_table[i][j] = EMPTY
			_pic[i][j] = HIDDEN
		end
	end
	count = 0
	while count < mines_qty do
		x = math.random(1, sizex)
		y = math.random(1, sizey)
		if _table[x][y] ~= BOMB then
			_table[x][y] = BOMB
			count = count + 1
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
	flags_qty = 1
	-- Ініціалізуємо змінні для анімації
	boomFrame = 1
	boomTime = 0
	scullFrame = 1
	scullTime = 0
	winFrame = 1
	winTime = 0
end
