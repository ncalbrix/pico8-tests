pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
function _init()
	c=new_caster(64,64)
	r=new_rectangle(80,20,90,40)
	c:set_rec(r)
end

function _update()
	c:update()
end

function _draw()
	cls()
	rectfill(0,0,127,127,5)
	r:draw()
	c:draw()
end
-->8
function new_caster(_x,_y)
	return {
		x=_x,
		y=_y,
		rec=nil,
		rel_x=nil,
		rel_y=nil,
		circ_x=nil,
		circ_y=nil,
		
		--inner methods
		compute_rel_x=function(self,rec)
			local rel=nil
			if (self.x<rec.x0) then
				rel=-1
			elseif ((rec.x0<=self.x) and (self.x<=rec.x1)) then
				rel=0
			else
				rel=1
			end
			return rel
		end,
		
		compute_rel_y=function(self,rec)
			local rel=nil
			if (self.y<rec.y0) then
				rel=-1
			elseif ((rec.y0<=self.y) and (self.y<=rec.y1)) then
				rel=0
			else
				rel=1
			end
			return rel
		end,
		
		set_rec=function(self,_rec)
			self.rec=_rec
			self.rel_x=self:compute_rel_x(self.rec)
			self.rel_y=self:compute_rel_y(self.rec)
		end,
		
		move=function(self)
			if (btn(0)) then self.x-=1 end
			if (btn(1)) then self.x+=1 end
			if (btn(2)) then self.y-=1 end
			if (btn(3)) then self.y+=1 end
		end,
		
		update_rel=function(self)
			self.rel_x=self:compute_rel_x(self.rec)
			self.rel_y=self:compute_rel_y(self.rec)
		end,
		
		rel_circ_pos=function(self)
			local mid_x = self.rec.x0 + ((self.rec.x1-self.rec.x0)/2)
			local mid_y = self.rec.y0 + ((self.rec.y1-self.rec.y0)/2)
			local len_x = (self.rec.x1-self.rec.x0)+1
			local len_y = (self.rec.y1-self.rec.y0)+1
			local circ_x = mid_x + (self.rel_x * len_x)
			local circ_y = mid_y + (self.rel_y * len_y)
			
			return {
				x=circ_x,
				y=circ_y
			}
		end,
		
		update_circ=function(self)
			local pos=self:rel_circ_pos()
			self.circ_x=pos.x
			self.circ_y=pos.y
		end,
		
		lines2rec=function(self)
			line(self.x,self.y,self.rec.x0,self.rec.y0,10)
			line(self.x,self.y,self.rec.x0,self.rec.y1,10)
			line(self.x,self.y,self.rec.x1,self.rec.y0,10)
			line(self.x,self.y,self.rec.x1,self.rec.y1,10)
		end,
		
		--outer methods
		update=function(self)
			self:move()
			if (self.rec) then
				self:update_rel()
				self:update_circ()
			end
		end,
		
		draw=function(self)
			if (self.rec) then
				circfill(self.circ_x,self.circ_y,1,8)
				self:lines2rec()
			end
			pset(self.x,self.y,7)
		end
	}
end
-->8
function new_rectangle(_x0,_y0,_x1,_y1)
	return {
		x0=_x0,
		y0=_y0,
		x1=_x1,
		y1=_y1,
		
		--outer methods
		draw=function(self)
			rectfill(
				self.x0,
				self.y0,
				self.x1,
				self.y1,
				6
			)
		end
	}
end
-->8
function new_point(_x,_y)
	return {
		x=_x,
		y=_y
	}
end

function line_coeffs(p1,p2)
	local xa=a.x
	local ya=a.y
	local xb=b.x
	local yb=b.y
	--to do
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
