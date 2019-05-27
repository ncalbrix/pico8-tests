pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
-- networkz
-- a network/graph test

-->8
-- base classes

-- network class

function new_network(_nodes,adj)
	_nodes = (_nodes or {})
	adj = (adj or {})
	
	network = {
		--attrs
		nodes={},
		links={},
		
		--inner methods
		get_node=function(self,n)
			return self.nodes[n]
		end,
		
		add_node=function(self,node)
			add(self.nodes,node)
		end,
		
		add_link=function(self,link)
			add(self.links,link)
		end,
		
		--outer methods
		draw=function(self)
			for n in all(self.nodes) do
				n:draw()
			end
			for l in all(self.links) do
				l:draw()
			end
		end
	}
	
	--construction
	for n in all(_nodes) do
		network:add_node(n)
		n:set_network(network)
	end
	
	for org,dests in pairs(adj) do
		for dst in all(dests) do
			l = new_link(
				network:get_node(org),
				network:get_node(dst)
			)
			
			network:add_link(l)
			l.set_network(network)
			del(adj[dst],org)
		end
	end
	
	return network
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
		links={},
		network=nil,
		
		--inner methods
		set_network=function(self,net)
			self.network=net
		end,
		
		add_link=function(self,link)
			add(self.links,link)
		end,

		adjacent_nodes=function(self)
			nodes={}
			
			for l in all (self.links) do
				n = l.other_node(self)
				add(nodes,n)
			end
			
			return nodes
		end,
		
		--outer methods
		draw=function(self)
			rect(
				self.x-2,
				self.y-2,
				self.x+2,
				self.y+2,
				self.col
			)
		end
	}
end


-- link class

def_link_col=7

function new_link(_node_1,_node_2,_col)
	_col = (_col or def_link_col)
	
	link = {
		--attrs
		node_1=_node_1,
		node_2=_node_2,
		col=_col,
		network=nil,

		--inner methods
		set_network=function(self,net)
			self.network=net
		end,

		other_node=function(self,node)
			if (self.node_1 == node) then
				return node_2
			else
				return node_1
			end
		end,
		
		--outer methods
		draw=function(self)
			line(
				self.node_1.x,
				self.node_1.y,
				self.node_2.x,
				self.node_2.y,
				self.col
			)
		end
	}
	
	link.node_1:add_link(link)
	link.node_2:add_link(link)
	
	return link
end

function link_equality(link_1,link_2)
	return (
		((link_1.node_1 == link_2.node_1) and (link_1.node_2 == link_2.node_2))
		or
		((link_1.node_1 == link_2.node_2) and (link_1.node_2 == link_2.node_1))
	)
end
-->8
nodes = {
	new_node(20,20),
	new_node(10,60),
	new_node(107,20),
	new_node(54,107)
}

adj = {
	{2,4},
	{1,3,4},
	{2},
	{1,2}
}


cls()
net = new_network(nodes,adj)
net:draw()
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
