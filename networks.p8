pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
-- networks
-- a network/graph test


t=0

function _init()
	cls()
	n = new_network(
		{
			new_node(20,78),
			new_node(96,45),
			new_node(50,75),
			new_node(30,110,7)
		}
	)
	n:draw()
end

function _update()
	if (btn(5)) then
		for i=1,3 do
			n:add_node(
				new_node(
					128*rnd(),
					128*rnd(),
					15*rnd()+1
				)
			)
		end
	end
end

function _draw()
	cls()
	n:draw()
end
-->8
-- base classes

-- network class

function new_network(_nodes,_links)
	_nodes = (_nodes or {})
	_links = (_links or {})
	
	return {
		--attrs
		nodes=_nodes,
		links=_links,
		
		--inner methods
		get_node=function(self,n)
			return self.nodes[n]
		end,
		
		add_node=function(self,node)
			add(self.nodes,node)
		end,
		
		--outer methods
		draw=function(self)
			for n in all(self.nodes) do
				n:draw()
			end
		end
	}
end


-- node class

def_node_col=2

function new_node(_x,_y,_col)
	_col = (_col or def_node_col)
	
	return {
	 --attrs
		x=_x,
		y=_y,
		col=_col,
		
		--outer methods
		draw=function(self)
			rect(
				self.x-1,
				self.y-1,
				self.x+1,
				self.y+1,
				self.col
			)
		end
	}
end


-- link class

def_link_col=7

function new_link(_node_1,_node_2,_col)
	_col = (_col or def_link_col)
	
	return {
		--attrs
		node_1=_node_1,
		node_2=_node_2
		
		--outer methods
	}	
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
