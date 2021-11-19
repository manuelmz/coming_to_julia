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
struct elementary_CA <: one_dimensional_CA
	rule::Int64
end

# ╔═╡ 5e63c67f-f029-40d0-bae2-8d33d369e16b
md"""
Now we need a function updating the state of a single cell based on the value of the cell and its two neighbors at the previous time
"""

# ╔═╡ d3141164-1a6a-4963-9b52-05796f66407a
##-- updating the state of a cell
function update_cell(past_cells::String, rule::Int64)
    """
    Updating the value of a given cell at the next time
    using the values of the three adjacent cells in the previous time.
    The updating procedure is based on the extremely nice tutorial by
    which can be found at
    """
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
##-- creating and evolving the automata
function fill_automata(eCA::elementary_CA, size::Int, tsteps::Int, periodic::Bool,
	icond::Int)
    """
    This function returns the trajectory of the automata given some parameters.
    The parameters are:
    size: the number of cells of the automata. Expecting an integer
    tsteps: the number of time evoluton steps. Expecting an integer
    rule: the rule defining the automata to be evolved. Expecting an integer
    between 0 and 255
    periodic: a bolean specifying whether to use periodic boundary conditions
    or not
    icond: an integer between 0 and 2, for the specification of the intiial
    condition. A value of 0 indicates an intial condition given by a string of
    ones with a cero in the middle. A value of 1 indicates an initial condition
    given by a string of ceros with a one in the middle. A value of 2 indicates
    a random intial condition.

    returns an array of integers with dimensions tsteps x size, with the
    trajectory of the automata.
    """
    ##-- Array to store the automata trajectory
    CA = zeros(Int, tsteps, size)
	rule = eCA.rule
    ##-- Time evolving the automata
    for ii = 1:tsteps
        ##-- initializing the automata
        if ii == 1
            if icond == 0
                #--> Initial condition is a cero at the middle surrounded by ones
                CA[1,:] = ones(Int, size)
                CA[1, Int(size/2)] = 0
            elseif icond == 1
                #--> initial condition is a one in the middle surrounded by ceros
                CA[1, Int(size/2)] = 1
            elseif icond == 2
                #--> initial condition is a random string of zeros and ones
                ##--> sampled uniformly
                CA[ii,:] = rand((0,1), size)
            end
			
        ##-- Time evolving based on the given initial condition
        else
            if periodic
                #--> evolving the automata with periodic boundary conditions
                for jj = 1:size
                    #global old_val
                    if jj == 1
                        old_val = string(CA[ii-1, end])*
						string(CA[ii-1, jj])*string(CA[ii-1, jj+1])
                    elseif jj == size
                        old_val = string(CA[ii-1, jj-1])*
						string(CA[ii-1, jj])*string(CA[ii-1, 1])
                    else
                        old_val = string(CA[ii-1, jj-1])*
						string(CA[ii-1, jj])*string(CA[ii-1, jj+1])
                    end
                    CA[ii,jj] = update_cell(old_val, rule)
                end
            else
                #--> evolving the automata with hard wall boundary conditions
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
        #- end of boundary condition conditional
        end
    #-- end of time volution
    end
    return CA
#-- end of function
end

# ╔═╡ 897ad564-c175-4f2e-816d-c2f3f05c4948
md"""
### Let us now make some elementary cA trajectories ! 
"""

# ╔═╡ 4b5301bf-c0e5-4a3b-98d0-c7eaf6b01334
##-- parameters for the cellullar automata and the 
begin
	size = 100
	steps = 100
	periodic = true
	icond = 2  
	
	#rule = rand(0:1:255)
	rule = 106
	"Rule is " * string(rule) 
end;

# ╔═╡ 6f725ba9-71b0-4a5e-a5a1-8e9bfbd98c9f
let
	##-- delcaring the automata and evolving it!
	my_eCA = elementary_CA(rule)
	CA_trajetory = fill_automata(my_eCA, size, steps, periodic, icond)

	##-- plotting the trajectorie!
	plo = plot(xlabel = "cell number", ylabel = "step", tickfontsize = 12, 
	title = "Rule " * string(my_eCA.rule))

	heatmap!(1:1:size, 1:1:steps, CA_trajetory, c = [:black, :white], 
		colorbar = false)
	
	plo
end

# ╔═╡ becc2faf-6725-4f93-9438-6894750457df


# ╔═╡ 7ee6a7ce-f524-470c-a70e-0eb3e79cf38b
mediumbreak = html"<br><br>"

# ╔═╡ ef1d6def-ba3a-4025-95f7-14e16b79df81
mediumbreak

# ╔═╡ Cell order:
# ╠═8de7c73a-95c5-4a77-9137-359f27b70686
# ╠═73d15379-b3b2-4697-8f53-598bd55703a0
# ╟─9449a8ec-47dc-11ec-17a7-b3c560ad0de5
# ╟─92207233-6b94-44b9-8b38-2a097c88b899
# ╠═85c5d33a-30ae-4ae4-a41e-2ac0e5c97c38
# ╟─1bdc2d8d-bd56-4b7d-aa96-ffc167cbff20
# ╠═7d7b36a4-8ef8-429b-b63c-20b3544f5a19
# ╟─5e63c67f-f029-40d0-bae2-8d33d369e16b
# ╠═d3141164-1a6a-4963-9b52-05796f66407a
# ╟─bbd852f9-6cad-481f-8d12-4490c2a0c7b5
# ╟─2eadc93b-2c8d-4038-a035-9ab157b263d2
# ╟─ef1d6def-ba3a-4025-95f7-14e16b79df81
# ╟─897ad564-c175-4f2e-816d-c2f3f05c4948
# ╠═4b5301bf-c0e5-4a3b-98d0-c7eaf6b01334
# ╟─6f725ba9-71b0-4a5e-a5a1-8e9bfbd98c9f
# ╠═becc2faf-6725-4f93-9438-6894750457df
# ╟─7ee6a7ce-f524-470c-a70e-0eb3e79cf38b
