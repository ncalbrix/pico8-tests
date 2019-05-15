pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
-- main program

function _init()
end

function _draw()
	bckgrnd()
	player:draw()
	foregrnd()
end

function _update()
	player:update()
end
-->8
-- player class

player = {
	--attr
	x=64,
	y=64,
	s=1,
	ffs={},
	
	--inner methods
	move=function(self)
		if (btn(0)) then self.x-=1 end
		if (btn(1)) then self.x+=1 end
		if (btn(2)) then self.y-=1 end
		if (btn(3)) then self.y+=1 end
	end,
	
	gen_ff=function(self)
		if (btn(4)) then
		 add(self.ffs, new_ff(self.x+3,self.y+3,10))
		end
	end,
	
	
	update_ffs=function(self)
		for ff in all(self.ffs) do
			ff:update()
		end
	end,
	
	--outer methods
	draw=function(self)
		spr(self.s, self.x, self.y)
		for ff in all(self.ffs) do
			ff:draw()
		end
	end,
	
	update=function(self)
		self:move()
		self:gen_ff()
		self:update_ffs()
	end
}

-->8
-- background and foreground
-- drawing functions

function bckgrnd()
	rectfill(0,0,127,127,5)
	rectfill(2,2,125,125,0)
end

function foregrnd()
	rect(30,30,97,97,5)
end
-->8
-- force field class

ff_col = 9

function new_ff(_x,_y,_r)
	return {
		-- attr
		x=_x,
		y=_y,
		r=_r,
		life=150,
		
		-- outer methods
		draw=function(self)
			circ(self.x,self.y,self.r,ff_col)
			print(self.life,self.x-3,self.y-3)
		end,
		
		update=function(self)
			if (self.life > 0) then
				self.life -= 1
			end
		end
	}
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000010000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700011111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000018888100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000011111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700011111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000001001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
