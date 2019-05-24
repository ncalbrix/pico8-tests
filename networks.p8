pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
-- networks
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
			for l in all(self.nodes) do
				l:draw()
			end
		end
	}
	
	print('starting const')
	--construction
	print('adding nodes')
	for n in all(_nodes) do
		network.add_node(n)
		n.set_network(network)
	end
	print('nodes added')
	
	print('adding links')
	for org,dests in pairs(adj) do
		for dst in all(dests) do
			print('constr link')
			l = new_link(
				network.nodes[org],
				network.nodes[dst]
			)
			print('link built')
			
			network.add_link(l)
			l.set_network(network)
			del(adj[dst],org)
		end
	end
	print('links added')
	
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
		network=nil,
		
		--inner methods
		set_network=function(self,net)
			self.network=net
		end,
		
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
		node_2=_node_2,
		col=_col,
		network=nil,

		--inner methods
		set_network=function(self,net)
			self.network=net
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
	new_node(107,107),
	new_node(107,20),
	new_node(20,107)
}

adj = {
	{2,4},
	{1,3,4},
	{2},
	{1,2}
}


net = new_network(nodes,adj)
function _draw()
	cls()
	net:draw()
	print(#net.nodes)
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
