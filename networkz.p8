pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
-- networkz
-- a network/graph test

function _init()
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
	
	net=new_network(nodes,adj)
	agent=new_agent(net:get_node(1),1.5)
	agent2=new_agent(net:get_node(1),2,4)
	
	cls()
	net:draw()
--	agent:draw()
--	
--	node_1=net:get_node(1)
--	print(node_1)
--	dest_1=node_1:rnd_adj_node()
--	print(dest_1)
--	
--	pa(agent)
--	agent:update()
--	pa(agent)
--	agent:update()
--	pa(agent)
--	agent:update()
--	pa(agent)
--	agent:update()
--	pa(agent)
--	agent:update()
--	pa(agent)
--	agent:update()
--	pa(agent)
end

function _update()
	net:update()
end

function _draw()
	cls()
	net:draw()
end

function pa(agent)
	?agent.x..':'..agent.y..':'..agent.speed
	?agent.dx..':'..agent.dy
	if (agent.next_node) then
		?agent.next_node.x..':'..agent.next_node.y
	else
		?agent.next_node
	end
	?agent.dist_to_go
	?'-------'
end
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
		agents={},
		
		--inner methods
		get_node=function(self,n)
			return self.nodes[n]
		end,
		
		add_node=function(self,node)
			add(self.nodes,node)
			node:set_network(self)
		end,
		
		add_link=function(self,link)
			add(self.links,link)
			link:set_network(self)
		end,
		
		add_agent=function(self,agent)
			add(self.agents,agent)
		end,
		
		--outer methods
		update=function(self)
			for a in all(self.agents) do
				a:update()
			end
		end,
		
		draw=function(self)
			for n in all(self.nodes) do
				n:draw()
			end
			for l in all(self.links) do
				l:draw()
			end
			for a in all(self.agents) do
				a:draw()
			end
		end
	}
	
	--construction
	for n in all(_nodes) do
		network:add_node(n)
--		n:set_network(network)
	end
	
	for org,dests in pairs(adj) do
		for dst in all(dests) do
			l = new_link(
				network:get_node(org),
				network:get_node(dst)
			)
			
			network:add_link(l)
--			l.set_network(network)
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
		
		get_link=function(self,idx)
			return self.links[idx]
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
		
		rnd_adj_node=function(self)
			nb_nodes=#self.links
			dest_idx=flr(rnd(nb_nodes))+1
			return self:get_link(dest_idx):other_node(self)
		end,
		
		dist_to=function(self,node)
			return vect_norm(
				self.x,
				self.y,
				node.x,
				node.y
			)
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
				return self.node_2
			else
				return self.node_1
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


-- agent class

def_agent_col=9
def_agent_speed=1
def_agent_size=5

function new_agent(_node,_speed,_col)
	_speed = (_speed or def_agent_speed)
	_col = (_col or def_agent_col)
	
	agent = {
		--attrs
		current_node=_node,
		next_node=nil,
		network=_node.network,
		
		col=_col,
		size=def_agent_size,
		
		speed=_speed,
		dist_to_go=0,
		
		x=_node.x,
		y=_node.y,
		dx=0,
		dy=0,
		
		--inner methods
		rnd_dest=function(self)
			return self.current_node:rnd_adj_node()
		end,
		
		set_dest=function(self,dest)
			self.next_node=dest
			self.dist_to_go=self.current_node:dist_to(self.next_node)
		end,
		
		move=function(self)
			self.x+=self.dx
			self.y+=self.dy
		end,
		
		set_speed_comp=function(self)
			local norm=vect_norm(
				self.current_node.x,
				self.current_node.y,
				self.next_node.x,
				self.next_node.y
			)
			local coef=(self.speed/norm)
			local xab=self.next_node.x-self.current_node.x
			local yab=self.next_node.y-self.current_node.y
			
			self.dx=coef*xab
			self.dy=coef*yab
		end,
		
		--outer methods
		update=function(self)
			if (not self.next_node) then
				self:set_dest(self:rnd_dest())
				self:set_speed_comp()
			else
				if (self.dist_to_go>self.speed) then
					self:move()
					self.dist_to_go-=self.speed
				else
					self.x=self.next_node.x
					self.y=self.next_node.y
					self.current_node=self.next_node
					self.next_node=nil
				end
			end
		end,
		
		draw=function(self)
			circ(self.x,self.y,self.size,self.col)
		end
	}
	
	--construction
	agent.network:add_agent(agent)
	
	return agent
end

-->8
-- utility functions

function link_equality(link_1,link_2)
	return (
		((link_1.node_1 == link_2.node_1) and (link_1.node_2 == link_2.node_2))
		or
		((link_1.node_1 == link_2.node_2) and (link_1.node_2 == link_2.node_1))
	)
end

function vect_norm(xa,ya,xb,yb)
	local x=xb-xa
	x=x*x
	
	local y=yb-ya
	y=y*y
	
	return sqrt(x+y)
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
