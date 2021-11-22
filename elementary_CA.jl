### A Pluto.jl notebook ###
# v0.17.1

using Markdown
using InteractiveUtils

# ╔═╡ 8de7c73a-95c5-4a77-9137-359f27b70686
begin
	using Pkg
	Pkg.activate(mktempdir())
end

# ╔═╡ 73d15379-b3b2-4697-8f53-598bd55703a0
begin	
	Pkg.add(["Statistics", "PlutoUI", "LinearAlgebra", "Plots"])
	using Statistics, PlutoUI, LinearAlgebra
	using Plots
end

# ╔═╡ 9449a8ec-47dc-11ec-17a7-b3c560ad0de5
md"""
# Elementary cellular automata (CA) in Julia

In this notebook we want to construct functionalities to compute the trajectories for any of the 256 elementary CAs. 

There is a very nice explanation of how this can be done in the [cellular automata in the browser](https://www.javascript.christmas/2019/22) by Kjetil Golid. 

You can base your implementation on his explanantion or use your own way of constructing these CAs.
"""

# ╔═╡ 92207233-6b94-44b9-8b38-2a097c88b899
md"""
### A solution to the elementary CA chalenge
I am going to follow the description in the Java Christmas blog!

First, define an abstract type for the one dimensional cellullar automatas
"""

# ╔═╡ 85c5d33a-30ae-4ae4-a41e-2ac0e5c97c38
abstract type one_dimensional_CA end

# ╔═╡ 1bdc2d8d-bd56-4b7d-aa96-ffc167cbff20
md"""
second, define a subtype for the elementary CA. The only field is going ot be the rule!
"""

# ╔═╡ 7d7b36a4-8ef8-429b-b63c-20b3544f5a19
struct elmt_CA_PBC <: one_dimensional_CA
	rule::Int64
end

# ╔═╡ 713deb78-5767-4864-bd97-f1583054f93f
struct elmt_CA_OBC <: one_dimensional_CA
	rule::Int64
end

# ╔═╡ 5e63c67f-f029-40d0-bae2-8d33d369e16b
md"""
Now we need a function updating the state of a single cell based on the value of the cell and its two neighbors at the previous time
"""

# ╔═╡ d3141164-1a6a-4963-9b52-05796f66407a
##-- updating the state of a cell
"""
	update_cell(past_cells::String, rule::Int64)
computes the value of a cell in the next time step based on the
values of the cell and its two neighbors in the previous step.
"""
function update_cell(past_cells::String, rule::Int64)
    b_rule = digits(rule, base = 2, pad = 8)
    num = parse(Int, past_cells, base = 2) + 1
    new_val = b_rule[num]
    return new_val
end

# ╔═╡ bbd852f9-6cad-481f-8d12-4490c2a0c7b5
md"""
Now we create function to fill the trajectory of the cellullar automata!
"""

# ╔═╡ 2eadc93b-2c8d-4038-a035-9ab157b263d2
#--> evolving the automata with periodic boundary conditions
function fill_automata(eCA::elmt_CA_PBC, size::Int, tsteps::Int, 
	icond::Vector)
	##-- Array to store the automata trajectory
	CA = zeros(Int, tsteps, size)
	CA[1,:] = icond
		
	rule = eCA.rule
	##-- Time evolving the automata
	for ii = 2:tsteps	
	    for jj = 1:size
	        #global old_val
	        if jj == 1
	            old_val = string(CA[ii-1, end])*string(CA[ii-1, jj])*
				string(CA[ii-1, jj+1])
	        elseif jj == size
	            old_val = string(CA[ii-1, jj-1])*string(CA[ii-1, jj])*
				string(CA[ii-1, 1])
	        else
	            old_val = string(CA[ii-1, jj-1])*string(CA[ii-1, jj])*
				string(CA[ii-1, jj+1])
	        end
	        CA[ii,jj] = update_cell(old_val, rule)
	    end
	end
	return CA
end

# ╔═╡ 897ad564-c175-4f2e-816d-c2f3f05c4948
md"""
### Let us now make some elementary CA trajectories ! 
"""

# ╔═╡ becc2faf-6725-4f93-9438-6894750457df


# ╔═╡ a172eb57-b738-40e7-92f4-7a3aa1b4858b
md"""
## Helper functions
"""

# ╔═╡ 1ca90790-e908-460a-ad68-f1f3ee38bd30
##-- build the initial state for the 1D automata 
function get_1D_CA_initial_state(init::String, size::Int)
	if init == "random"
		return rand((0,1), size)
	elseif init == "middle one" 
		vec = ones(Int, size)
        vec[Int(size/2)] = 0
		return vec
	elseif init == "middle zero"
		vec = zeros(Int, size)
        vec[Int(size/2)] = 1
		return vec
	elseif init == "two rand zeros"
		vec = ones(Int, size)
        vec[rand(1:1:size)] = 0
		vec[rand(1:1:size)] = 0
		return vec
	end
end 

# ╔═╡ 4b5301bf-c0e5-4a3b-98d0-c7eaf6b01334
##-- parameters for the cellullar automata and the 
begin
	size = 100
	steps = 100
	icond = get_1D_CA_initial_state("two rand zeros", size)  
	
	#rule = rand(0:1:255)
	rule = 195
	"Rule is " * string(rule) 
end;

# ╔═╡ 288c2ae7-b71d-4d95-a462-9b6c42d7bdc8
#--> evolving the automata with hard wall boundary conditions
function fill_automata(eCA::elmt_CA_OBC, size::Int, tsteps::Int,
	icond::Vector)
	##-- Array to store the automata trajectory
	CA = zeros(Int, tsteps, size)
	CA[1,:] = icond
		
	rule = eCA.rule
	for ii = 2:steps
	    for jj = 1:size
	        #global old_val
	        if jj == 1
	            old_val = "0"*string(CA[ii-1, jj])*string(CA[ii-1, jj+1])
	        elseif jj == size
	            old_val = string(CA[ii-1, jj-1])*
				string(CA[ii-1, jj])*string(CA[ii-1, 1])
	        else
	            old_val = string(CA[ii-1, jj-1])*string(CA[ii-1, jj])*"0"
	        end
	        CA[ii,jj] = update_cell(old_val, rule)
	    end
	end
	return CA
end

# ╔═╡ 6f725ba9-71b0-4a5e-a5a1-8e9bfbd98c9f
let
	##-- delcaring the automata and evolving it!
	my_eCA = elmt_CA_PBC(rule)
	CA_trajetory = fill_automata(my_eCA, size, steps, icond)

	##-- plotting the trajectorie!
	plo = plot(xlabel = "cell number", ylabel = "step", tickfontsize = 12, 
	title = "Rule " * string(my_eCA.rule))

	heatmap!(1:1:size, 1:1:steps, CA_trajetory, c = [:black, :white], 
		colorbar = false)
	
	plo
end

# ╔═╡ a30efe3f-a8b7-42e4-9ad5-267563ebc877


# ╔═╡ 7ee6a7ce-f524-470c-a70e-0eb3e79cf38b
mediumbreak = html"<br><br>"

# ╔═╡ ef1d6def-ba3a-4025-95f7-14e16b79df81
mediumbreak

# ╔═╡ bd8b198e-7829-4513-984c-b12a69d0e4e0
mediumbreak

# ╔═╡ Cell order:
# ╠═8de7c73a-95c5-4a77-9137-359f27b70686
# ╠═73d15379-b3b2-4697-8f53-598bd55703a0
# ╟─9449a8ec-47dc-11ec-17a7-b3c560ad0de5
# ╟─92207233-6b94-44b9-8b38-2a097c88b899
# ╠═85c5d33a-30ae-4ae4-a41e-2ac0e5c97c38
# ╟─1bdc2d8d-bd56-4b7d-aa96-ffc167cbff20
# ╠═7d7b36a4-8ef8-429b-b63c-20b3544f5a19
# ╠═713deb78-5767-4864-bd97-f1583054f93f
# ╟─5e63c67f-f029-40d0-bae2-8d33d369e16b
# ╠═d3141164-1a6a-4963-9b52-05796f66407a
# ╟─bbd852f9-6cad-481f-8d12-4490c2a0c7b5
# ╠═2eadc93b-2c8d-4038-a035-9ab157b263d2
# ╠═288c2ae7-b71d-4d95-a462-9b6c42d7bdc8
# ╟─ef1d6def-ba3a-4025-95f7-14e16b79df81
# ╟─897ad564-c175-4f2e-816d-c2f3f05c4948
# ╠═4b5301bf-c0e5-4a3b-98d0-c7eaf6b01334
# ╠═6f725ba9-71b0-4a5e-a5a1-8e9bfbd98c9f
# ╠═becc2faf-6725-4f93-9438-6894750457df
# ╠═bd8b198e-7829-4513-984c-b12a69d0e4e0
# ╟─a172eb57-b738-40e7-92f4-7a3aa1b4858b
# ╠═1ca90790-e908-460a-ad68-f1f3ee38bd30
# ╠═a30efe3f-a8b7-42e4-9ad5-267563ebc877
# ╟─7ee6a7ce-f524-470c-a70e-0eb3e79cf38b
