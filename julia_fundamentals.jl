### A Pluto.jl notebook ###
# v0.17.1

using Markdown
using InteractiveUtils

# ╔═╡ 622c9112-90f7-4e08-9ec4-17236a8d75b5
begin
	using Pkg
	Pkg.activate(mktempdir())
end

# ╔═╡ daf17aa2-beff-4875-8e7c-ee224fd32033
begin	
	Pkg.add(["Images", "Statistics", "PlutoUI", "LinearAlgebra", "Plots"])
	
	using Images, Statistics, PlutoUI, LinearAlgebra
	using Plots
end

# ╔═╡ 2687779e-4644-11ec-25d9-01c9824b4ab3
md"""
# Julia fundamentals
In this notebook we will talk about the fundamentals of the Julia programing language
"""

# ╔═╡ b79d8ab3-8ddb-49ed-8296-795e8dfdecb1
md"""
The first thing we need to do is to create a virtual package environment and load some modules
"""

# ╔═╡ d0ec700b-6501-49ca-ae50-3c2c8bd5c9ad
PlutoUI.TableOfContents(title = "Julia fundamentals", indent = true, depth = 4)

# ╔═╡ 53937214-77ec-4699-8ce7-c93ff7ebb586
md"""
## The Julia programing language
Julia was first introduced in [A fresh approach to numerical computing](https://doi.org/10.1137/141000671), with the aim of becoming the standar programing language for scientific computing.

Julia is a **high-level**, **high performance**, **dynamic programing** language. What does this mean?

- First, it is high level in the sense that the syntaxis is closer to human natural language than to machine instructions, and the compiler takes care of translating and optimizing your highlevel instructions into machine instrunctions, this is in the spirit of languages such as Python and Matlab.

- It is high perfornace in the sense that, even a plain translation of a Python code, say for matrix diagonalization, already provides good speed ups. Furthermore, when written *optimally* Julia can compete with C/C++/Fortran code. In fact, Julia is the only "interpreted" language which is part of the peta flop club, see [Julia joins the peta flop club](https://www.hpcwire.com/off-the-wire/julia-joins-petaflop-club/) 

- It is dynamic in the sense that the compiler can work with function arguments -or variables- whose type is unespecified, similar to how Pyhotn does it, and infered the type *on the go* from whatever arguments are passed to the function when the code is executed. Actually, Julia does something even more cool, **more on this later**

For a nice short intro check out the book [Julia Data Science](https://juliadatascience.io/), which is available in its entirety online!

The recent paper [Julia for Biologists](https://arxiv.org/abs/2109.09973) also offers a nice quick intro. Their, no exhaustive, set of reazons to use Julia is nicely summarized in Table 1 on their paper, which I am displaying below for your enjoyment :-)
"""

# ╔═╡ 041a8b6f-178f-408a-8cc0-cd5fcb778cc4
table_1 = load("figures/julia_for_biologists_table_1.png")

# ╔═╡ 508085c5-25d5-4d54-ab69-553a23263bfe
md"""
## Julia syntaxis
One can say that the syntaxis of Julia is a mix of Python, Matlab, and C syntaxis, with some original things. 

For example, this is a for loop
"""

# ╔═╡ 090d82ba-d11f-4242-b4ee-1c7fd5515470
begin
	sum_to_five = 0
	for ss = 1:5
		sum_to_five += ss
	end
	sum_to_five
end

# ╔═╡ 24327b75-0942-4ba1-946c-53b243a9ebf9
md"""
In the above code block, the begin - end are a particularity of Pluto notebooks. any time you want to execute instructions with more than a single line, they need to be inside such a code block.

The object "1:5" is a range, counting from one to five in steps of 1, and the declaration "+=" updates the value of "sum_to_five" by adding the current value of the oteration variable ss

Notice that Julia works with base 1 indexing! (If you are not a fan of this, there is a way in which you can redefined to be base zero, see [this link]())
"""

# ╔═╡ 948011df-a496-48e7-8e8d-0745fddfc60e
md"""
This is a conditional 
"""

# ╔═╡ 88bb8d3f-1afe-4a7c-9885-7c0baf3554b5
day = "sunday"

# ╔═╡ c886195c-2f3e-4481-a338-a76f22409fdf
if day in ["saturday", "sunday"]
	"It's the weekend! B)"
else 
	"It's a weekday, go back to work!"
end

# ╔═╡ 5aa6a480-a990-49a1-9698-62e3c7386ba6
md"""
In Julia string concatenation is represented with the symbol * 

For example
"""

# ╔═╡ 965f1fc5-5488-4b37-9144-32ca5008262a
"harv"*" the larv"

# ╔═╡ 6334ec08-681d-4a5c-a83b-fd4982845d1c


# ╔═╡ 2c12d501-51e4-48d7-a875-774424ef4506
md"""
**Any questions so far?**
"""

# ╔═╡ bed3b97a-c45e-40f5-8eb7-80394708f313
md"""
### tiny exercise #1
Test the Collatz conjecture up to n = 100.

The Collatz conjecture says that, for any positive integer $q$, the sequence

$$f(q) = q/2 \enspace \text{if}\enspace q \enspace\text{is even}$$
$$f(q) = 3q + 1 \enspace \text{if}\enspace q \enspace\text{is odd}$$

eventually reaches one.

Make a single plot with two panels.

- On one panel plot the first 100 positive integers with their stopping times, that is how long do they take to reach $1$.

- On the other panel plot the first 100 positive integers with the largest value reached during their Collatz sequence.
"""

# ╔═╡ 5119c9a5-7ad3-407b-85bd-df10021f8a50
md"""
### A solution to tiny exercise #1
"""

# ╔═╡ b36594e5-9cbe-4d8a-9724-05e9277afd62
function collatz_path(q::Int64)
	steps = 0
	max_val = q
	while q != 1
		##-- applying a single step of the Collatz sequence
		if q % 2 == 0
			q = q/2
		else
			q = 3*q + 1
		end
		##-- updating the largest value seen so far
		max_val = max(max_val, q)
		steps += 1
	end
	return (steps, max_val)
end

# ╔═╡ 9317131b-a30b-4ef0-93c8-fcdd7cc2c85b
let 
	##-- number of integers to be testd
	n_max = 10000
	##-- two vectora to store the data 
	stop_times = zeros(Int64, n_max)
	max_vals = zeros(Int64, n_max)

	## constructing the collatz path for each of the n_max integers
	for qq = 1:n_max
		stop_times[qq], max_vals[qq] = collatz_path(qq)
	end

	##-- making the plot

	#-- panel with the stoping times
	plot_times = plot(xlabel = "n", ylabel = "stoping time", legend = nothing, 
		tickfontsize = 10)
	scatter!(1:n_max, stop_times, marker = :d, ms = 2.5, c = :red)

	#-- panel with the largest value visited
	plot_max = plot(xlabel = "n", ylabel = "maximum value visited", legend = nothing)
	scatter!(1:n_max, max_vals, ylim = (0, 10^5), marker = :^, c = :green, ms = 1.0)
	
	plot(plot_times, plot_max)
end

# ╔═╡ 72fd050d-f8da-45f7-a998-c04eae98cebc
md"""
## The heart of the Julia language 
In short, the Julia language is all about types and functions!

What this means is that, different from Python and Matlab, Julia *is not* an object oriented language. There are no classes or objects. 

In this sense, Julia is closer to C/C++, as the way of creating or defining variables is by declaring a type.
"""

# ╔═╡ d0ef136e-3000-4549-bc5d-0703a5b2a555
md"""
### Types
A type is an abstract representation of a "thing". 

In Julia there are two different type of types, or ways of representing "things". On one hand, there are **abstract types** which are, as the name suggest, the abstract representation, and *cannot* be instantiated, by that I mean, you cannot define a variable to be of the type defined by the **abstract type**. 

In a sense, an **abstract type** is the umbrella label you create to put together a set of "things". 

On the other hand, there are **concrete types**, these are the ones that can be instantiated, by this I mean, these are the ones that have "properties" (fields) and are used to represent variables. Often they are subtypes of a given **abstract type**.

Anythhing in Julia that can be manipulated has a corresponding **concrete type**, and it is a subtype of some **abstract type**.
"""

# ╔═╡ 6adfee4a-c5b1-4ad7-abed-536596d63fdd
md"""
A good example of this is given by the numerical variables. For instance:
"""

# ╔═╡ 4884d196-066f-4081-b209-a31d43e38552
an_integer = 4

# ╔═╡ 10f7e8aa-ac87-4050-a3be-76da0b4b38ac
typeof(an_integer)

# ╔═╡ 1598d185-9501-4284-a8dd-b011831c7640
a_float = 3.2

# ╔═╡ 5796c7bb-71ed-45e1-b924-ee62ff46f0b8
typeof(a_float)

# ╔═╡ 70b02c44-fecc-4702-822a-64ce95bbf70a
a_complex = 1.0 + 1.0im

# ╔═╡ 1a520607-d5d2-4840-92a0-5a7d2cb48664
typeof(a_complex)

# ╔═╡ 6fdebd3e-a6cd-427c-971d-b4d9317f780d
a_rational = 1//2

# ╔═╡ 9a0b917e-0e5b-4c94-9ad4-5f94e27d2f2d
typeof(a_rational)

# ╔═╡ e1e05edc-d4aa-482e-baea-e671d28d6205
md"""
A nice example of how the type system looks, in the form of a hierarchical tree, can be seen here [Number hierarchy Julia](https://en.wikibooks.org/wiki/Introducing_Julia/Types#/media/File:Julia-number-type-hierarchy.svg).

Can you tell me which of these are **abstract type** which of these are **concrete type**?
"""

# ╔═╡ f3cd4fc4-6e25-4af5-b2e6-6c8deb163fc0
md"""
#### Inheritance of types 
There are then two different rules regarding inheritance for the two type of types. 

In the case of **abstract types** you can go as deep with the inheritance as you would like. For instance, we can define an asbtract type Book, then an abstract type Journal which is a subtype of Book, then an asbtract type Flyer which is a subtype of Journal, and we could, in principle keep going with this....

There is no limit in the depth because you're simple declaring a set of names for abstract categories which have a given parent and, can, have a child(s).

The above example will look smething like this
"""

# ╔═╡ 3be94537-046e-40c1-bd81-57a15313c6be
abstract type Book end 

# ╔═╡ 011400f0-f6e0-4faf-a8eb-79807d1f0858
abstract type Journal <: Book end

# ╔═╡ af943e6d-1a4b-425c-b8fa-d19b051a6c51
abstract type Flyer <: Journal end

# ╔═╡ 7e51f9fa-ecf0-42d2-b60b-d7cc4e946eaa
supertype(Book)

# ╔═╡ ff759daa-a505-4e2d-9a2f-98a84e467a3a
supertype(Journal)

# ╔═╡ ec56af6e-d71c-44eb-9efc-84c75bb28ab2
supertype(Flyer)

# ╔═╡ 81c09b4c-40b1-4184-91a7-736f9e54ca7b
md"""
In the case of **concrete types** we cannot define any subtypes. For instance, we can define a **concrete type** lab_journal which is a subtype of the **abstract type** Journal. 

However, lab_journal cannot have any childs. The above example looks like this:
"""

# ╔═╡ 6b08ffae-37b7-4513-bb14-c74e44b77c0c
struct lab_journal <: Journal 
	npages::Int64
end

# ╔═╡ a41cf443-d19d-42b1-9ca0-c8e974bb6ea2
supertype(lab_journal)

# ╔═╡ 8c305207-ab9a-4f4b-99be-43c8e95c0207
my_journal = lab_journal(20)

# ╔═╡ 091ea677-a40f-43bd-8c50-47400675effb
typeof(my_journal)

# ╔═╡ 52c44af0-8829-42b9-9a2b-4ab355227e21
my_journal.npages

# ╔═╡ 91d3a6ad-052b-4a50-bd76-0bf38a4f7261
md"""
### Functions
On the other hand, in Julia a function is the abstract idea of a code block which takes a set of arguments (imput variables) and returns a different (possibly the same, but altered) set of variables.

Functions can have methods. A method is a explicit implementation of a function which works only when each of the input variables have a determined type. 

If you do not specified the types of the input variables, the compiler creates a method which is expecting arguments of type Any (this is how Julia stores variables with unespeficied types), after you run your code once, calling the function with 
"""

# ╔═╡ 443c655b-ad54-4c6b-929a-214837e2ee96


# ╔═╡ 35c31230-f241-4fdf-9ff6-5ba65e50ad4f


# ╔═╡ c6887b20-a8c3-4c39-b3b4-e8d7ad39363a


# ╔═╡ 4408a2ab-af69-4253-bb37-7e040ed2bebb
md"""
#### abstract types and the idea of general programing
Before when we talked about **abstract types**, it could have been the case that you thought of them as being a nice thing to have for book keeping and organizational purposes, but useless otherwise.

To some extent, they do give this impresion, like you introduced an additional layer of abstractionw which might not be very useful. However, the beauty of **abstract types** lies in their abstraction. We can define functions which have methods expecting a variable of **abstract type**, this constraint the range o applicability of the function, helps the compiler, and allows for some level of generic programing. 

For example, the function
"""

# ╔═╡ 091e3369-2900-4b1b-94f6-9ca65bb91352
function add_seven(n::Number)
	return n + 7
end

# ╔═╡ 33a3a96e-843c-4c5b-ad4b-bd8e11cc8c2b
md"""
Will work on any numerical variable
"""

# ╔═╡ adfed59c-31d7-46e9-bb9c-4cde56982720
add_seven(2)

# ╔═╡ 03d6f7e5-ac2d-4210-ba51-2d65b01ae601
add_seven(2.1)

# ╔═╡ 7c923fce-6d55-44b6-8498-593710f0177a
add_seven(2//5)

# ╔═╡ 36e446b2-f1e2-4460-a704-298f53238300
md"""
But it will not work on any other type of variable
"""

# ╔═╡ 385ded73-68e6-44e5-bc66-f5deaaa0be63
add_seven("1")

# ╔═╡ aafd7c94-3466-4ae8-8572-58d8d1a8761a
md"""
> Furthermore functions have their respective type, as such one can create functions whose arguments are variables of type Function, which return variables of type Function!
"""

# ╔═╡ ae29e8b2-5393-493b-b097-32988b7572aa


# ╔═╡ fdd3d3f1-0a47-455a-9d69-324e3989e140


# ╔═╡ 47967a1f-c3d0-4ad4-a0f0-17eb832fe1b5
md"""
### tiny exercise #2
Simulate walkers on a discrete one dimensional chain.

The rules are simple:
- take a chain of $L$ cells

- thee are $N$ walkers on the chain, with $N \ll L$, with randomly assigned initial poistions

- walkers are solid, they interaction i sgiven by arigid collision, with walkers bouncing off of each other

- each walker moves one cell to the left or right with a 50/50 probability

- The chain has elastic edges, a walker reaching the edge bounces off os it

"""

# ╔═╡ 29608a51-4161-4d7f-98bb-21616af4605b
md"""
### A solution to tiny exercise #2
"""

# ╔═╡ eb123de0-3855-42a1-8b49-f69d3a4f59cf
md"""
First, we define a type to rpresent our walker!
"""

# ╔═╡ b1954585-153b-46bf-bd99-b2b0e81e2036
abstract type abstract_walker end 

# ╔═╡ 6abbd5d3-1414-470d-8a50-1d1b52df9e18
mutable struct Walker <: abstract_walker 
	pos::Int64 
end 

# ╔═╡ c974c3f7-ab40-48c4-9233-ccd98e9f63a9
md"""
Now we define the parameters of the chain 
"""

# ╔═╡ 53812282-ecbd-4fb5-abb4-d1cf039c7973
half_chain_length = 120

# ╔═╡ 2cd8f887-737f-46db-97f0-166f3d2d0175
chain_sites = -half_chain_length:1:half_chain_length

# ╔═╡ 072795aa-58ae-4116-a6ac-266d7ceaefbc
md"""
now we construct the functions to move walkers, make them interact, and make them bounce back off of the walls
"""

# ╔═╡ a1a81ce3-facd-4112-bf53-391c704864e1
function move_walker!(walker::Walker)
	"""
	Moves a walker one step to the left or right with a 50/50 chance
	"""
	walker.pos += rand([-1,1])
end

# ╔═╡ e6eb8845-4ba9-4eb7-9288-c27caa970f1d
function walker_action!(walker::Walker, walkers::Vector, half_chain_length::Int64)
	"""
	Interaction between two walkers. They bounce off of each other. 
	Walker on the left moves one cell to the left and walker on the right moves
	one cell to the right.
	"""

	## first check if a pair of walkers should interact
	distances = walker.pos .- [walkers[aa].pos for aa = 1:length(walkers)]
	walkers_to_interact = findall(x -> abs(x) == 1, distances)

	if length(walkers_to_interact) == 0
		if abs(walker.pos) >= half_chain_length
			if walker.pos > 0 
				walker.pos -= 2
			elseif walker.pos < 0 
				walker.pos += 2
			end
		else
			move_walker!(walker)
		end
	elseif length(walkers_to_interact) == 1
		posi = walkers_to_interact[1]
		if distances[posi] > 0 
			walker.pos += 2
			walkers[posi].pos -= 2
		elseif distances[posi] < 0
			walker.pos -= 2
			walkers[posi].pos += 2
		else
			for pp = 1:2
				if distances[walkers_to_interact[pp]] > 0 
					walkers[walkers_to_interact[pp]].pos -= 2
				elseif distances[walkers_to_interact[pp]] < 0 
					walkers[walkers_to_interact[pp]].pos += 2
				end
			end
		end
		
	end 
end

# ╔═╡ f42fe364-7ea1-4af8-8fbc-cc38a222dfc7
md"""
Now we construct the functions to compute one time step 
"""

# ╔═╡ 07008185-25e5-4f00-b593-4d87e9a9a391
function step!(walkers::Vector, half_chain_length::Int64, nwalkers::Int64)
	##-- checking if a walker has reached the walls, and moving it
	for ss = 1:nwalkers
		walker_action!(walkers[ss], walkers, half_chain_length)
	end 
end 

# ╔═╡ 55bed73c-d9c1-433c-a881-d680e78c8355
md"""
Initializing some walkers 
"""

# ╔═╡ 9537badf-0d34-4351-a13d-3e459996576d
##-- number of walkers
nwalkers = 4

# ╔═╡ 75485cc5-38c0-4420-bd77-d12b1dce3aba
md"""
Running a simulation
"""

# ╔═╡ 2e9f9ab5-56e1-4194-b5d9-64a210615674
md"""
## Tiny homework
In order to build a little argument in favor of our end goal, many-body simulations with tensor networks, I want you to watch Katharine Hyatt's talk [Why I use Julia for quantum physics](https://www.youtube.com/watch?v=4giNd6HLUQg) delivered at PyData 2018!
"""

# ╔═╡ 7e8d3daf-0617-40e0-969b-3be707cd2164


# ╔═╡ cdcf0765-9eb8-4ec5-a92b-a0a38739d949


# ╔═╡ 1ae6196c-478c-47e7-9a4d-cd7d946034aa


# ╔═╡ 1f6cf151-4880-4325-ba60-26623300d550
md"""
## Some helper functions
"""

# ╔═╡ c13e582d-c575-4fbc-b540-b859266468ba
##-- sampling initial positions randomly, withouth repetition 
function sample_init_posis(num_walkers::Int64, half_sites::Int64)
	chain = Array(-half_sites:1:half_sites)
	chain_length = length(chain)
	posis = []
	
	for ii = 1:num_walkers
		pos = rand(chain)
		push!(posis, pos)
		
		deleteat!(chain, pos .== chain)
	end 
	return posis
end

# ╔═╡ fe9ecf82-fffc-4462-810f-9af08a227059
walker_init_posis = sample_init_posis(nwalkers, half_chain_length)

# ╔═╡ ca8083b0-dd31-4293-9c96-d076c52b742e
walkers = [Walker(wposi) for wposi in walker_init_posis]

# ╔═╡ a78098d2-4b87-46c5-8650-794555f36043
begin
	steps = 3000
	positions = zeros(Int64, steps, nwalkers)
	
	for s = 1:steps
		step!(walkers, half_chain_length, nwalkers)

		positions[s,:] .= [walkers[kk].pos for kk = 1:nwalkers]
	end
end;

# ╔═╡ 47d0112c-8acf-471f-998b-fad542372fed
let

	##-- making the figure

	#- panel showing the trajectories
	plo = plot(xlabel = "position", ylabel = "time steps", legend = nothing,
		tickfontsize = 9)

	plot!(1:steps, positions)
	plot!([half_chain_length], linetype = :hline, c = :black, lw = 2.0)
	plot!([-half_chain_length], linetype = :hline, c = :black, lw = 2.0)
	
	#- panel showing the histograms
	his = plot(xlabel = "position", tickfontsize = 9, legend = nothing)
	histogram!(positions, bins = range(-half_chain_length, half_chain_length, 
		length = 60), normalize = true, alpha = 0.75)

	plot(plo, his)
end

# ╔═╡ 8e543167-d872-4a97-a4a5-93bbd0eafbb8
mediumbreak = html"<br><br>"

# ╔═╡ 31a9ad8b-766f-4fd1-87f1-9e9b9d2f82f9
mediumbreak

# ╔═╡ 9d3eedc8-decc-4d23-8117-3089957a449e
mediumbreak

# ╔═╡ d6dbd02d-e1ac-43ef-8daa-b242fe0113bc
mediumbreak

# ╔═╡ c6f58cef-3c0d-4ad5-a414-2fba48677cff
mediumbreak

# ╔═╡ ebc1bae6-439b-43af-8f23-48636ab987a4
mediumbreak

# ╔═╡ bfe0922d-1c8f-436e-b12f-d3ae6f11de65
mediumbreak

# ╔═╡ 6b104f30-46ee-44ee-8385-0af4ad106043
mediumbreak

# ╔═╡ 54c7af50-7a38-4d94-8975-015fbee8a1a6
mediumbreak

# ╔═╡ 381cb596-eb2f-47db-a71f-c62726572c67
mediumbreak

# ╔═╡ Cell order:
# ╟─2687779e-4644-11ec-25d9-01c9824b4ab3
# ╟─b79d8ab3-8ddb-49ed-8296-795e8dfdecb1
# ╠═622c9112-90f7-4e08-9ec4-17236a8d75b5
# ╠═daf17aa2-beff-4875-8e7c-ee224fd32033
# ╠═d0ec700b-6501-49ca-ae50-3c2c8bd5c9ad
# ╟─31a9ad8b-766f-4fd1-87f1-9e9b9d2f82f9
# ╟─53937214-77ec-4699-8ce7-c93ff7ebb586
# ╟─041a8b6f-178f-408a-8cc0-cd5fcb778cc4
# ╟─9d3eedc8-decc-4d23-8117-3089957a449e
# ╟─508085c5-25d5-4d54-ab69-553a23263bfe
# ╠═090d82ba-d11f-4242-b4ee-1c7fd5515470
# ╟─24327b75-0942-4ba1-946c-53b243a9ebf9
# ╟─d6dbd02d-e1ac-43ef-8daa-b242fe0113bc
# ╟─948011df-a496-48e7-8e8d-0745fddfc60e
# ╠═88bb8d3f-1afe-4a7c-9885-7c0baf3554b5
# ╠═c886195c-2f3e-4481-a338-a76f22409fdf
# ╟─5aa6a480-a990-49a1-9698-62e3c7386ba6
# ╠═965f1fc5-5488-4b37-9144-32ca5008262a
# ╠═6334ec08-681d-4a5c-a83b-fd4982845d1c
# ╟─2c12d501-51e4-48d7-a875-774424ef4506
# ╟─c6f58cef-3c0d-4ad5-a414-2fba48677cff
# ╟─bed3b97a-c45e-40f5-8eb7-80394708f313
# ╟─5119c9a5-7ad3-407b-85bd-df10021f8a50
# ╟─b36594e5-9cbe-4d8a-9724-05e9277afd62
# ╟─9317131b-a30b-4ef0-93c8-fcdd7cc2c85b
# ╟─ebc1bae6-439b-43af-8f23-48636ab987a4
# ╟─72fd050d-f8da-45f7-a998-c04eae98cebc
# ╟─d0ef136e-3000-4549-bc5d-0703a5b2a555
# ╟─6adfee4a-c5b1-4ad7-abed-536596d63fdd
# ╠═4884d196-066f-4081-b209-a31d43e38552
# ╠═10f7e8aa-ac87-4050-a3be-76da0b4b38ac
# ╠═1598d185-9501-4284-a8dd-b011831c7640
# ╠═5796c7bb-71ed-45e1-b924-ee62ff46f0b8
# ╠═70b02c44-fecc-4702-822a-64ce95bbf70a
# ╠═1a520607-d5d2-4840-92a0-5a7d2cb48664
# ╠═6fdebd3e-a6cd-427c-971d-b4d9317f780d
# ╠═9a0b917e-0e5b-4c94-9ad4-5f94e27d2f2d
# ╟─e1e05edc-d4aa-482e-baea-e671d28d6205
# ╟─bfe0922d-1c8f-436e-b12f-d3ae6f11de65
# ╟─f3cd4fc4-6e25-4af5-b2e6-6c8deb163fc0
# ╠═3be94537-046e-40c1-bd81-57a15313c6be
# ╠═011400f0-f6e0-4faf-a8eb-79807d1f0858
# ╠═af943e6d-1a4b-425c-b8fa-d19b051a6c51
# ╠═7e51f9fa-ecf0-42d2-b60b-d7cc4e946eaa
# ╠═ff759daa-a505-4e2d-9a2f-98a84e467a3a
# ╠═ec56af6e-d71c-44eb-9efc-84c75bb28ab2
# ╟─81c09b4c-40b1-4184-91a7-736f9e54ca7b
# ╠═6b08ffae-37b7-4513-bb14-c74e44b77c0c
# ╠═a41cf443-d19d-42b1-9ca0-c8e974bb6ea2
# ╠═8c305207-ab9a-4f4b-99be-43c8e95c0207
# ╠═091ea677-a40f-43bd-8c50-47400675effb
# ╠═52c44af0-8829-42b9-9a2b-4ab355227e21
# ╟─6b104f30-46ee-44ee-8385-0af4ad106043
# ╟─91d3a6ad-052b-4a50-bd76-0bf38a4f7261
# ╠═443c655b-ad54-4c6b-929a-214837e2ee96
# ╠═35c31230-f241-4fdf-9ff6-5ba65e50ad4f
# ╠═c6887b20-a8c3-4c39-b3b4-e8d7ad39363a
# ╟─4408a2ab-af69-4253-bb37-7e040ed2bebb
# ╠═091e3369-2900-4b1b-94f6-9ca65bb91352
# ╟─33a3a96e-843c-4c5b-ad4b-bd8e11cc8c2b
# ╠═adfed59c-31d7-46e9-bb9c-4cde56982720
# ╠═03d6f7e5-ac2d-4210-ba51-2d65b01ae601
# ╠═7c923fce-6d55-44b6-8498-593710f0177a
# ╟─36e446b2-f1e2-4460-a704-298f53238300
# ╠═385ded73-68e6-44e5-bc66-f5deaaa0be63
# ╟─54c7af50-7a38-4d94-8975-015fbee8a1a6
# ╟─aafd7c94-3466-4ae8-8572-58d8d1a8761a
# ╠═ae29e8b2-5393-493b-b097-32988b7572aa
# ╠═fdd3d3f1-0a47-455a-9d69-324e3989e140
# ╠═47967a1f-c3d0-4ad4-a0f0-17eb832fe1b5
# ╟─29608a51-4161-4d7f-98bb-21616af4605b
# ╟─eb123de0-3855-42a1-8b49-f69d3a4f59cf
# ╠═b1954585-153b-46bf-bd99-b2b0e81e2036
# ╠═6abbd5d3-1414-470d-8a50-1d1b52df9e18
# ╟─c974c3f7-ab40-48c4-9233-ccd98e9f63a9
# ╠═53812282-ecbd-4fb5-abb4-d1cf039c7973
# ╠═2cd8f887-737f-46db-97f0-166f3d2d0175
# ╟─072795aa-58ae-4116-a6ac-266d7ceaefbc
# ╠═a1a81ce3-facd-4112-bf53-391c704864e1
# ╠═e6eb8845-4ba9-4eb7-9288-c27caa970f1d
# ╟─f42fe364-7ea1-4af8-8fbc-cc38a222dfc7
# ╠═07008185-25e5-4f00-b593-4d87e9a9a391
# ╟─55bed73c-d9c1-433c-a881-d680e78c8355
# ╠═9537badf-0d34-4351-a13d-3e459996576d
# ╠═fe9ecf82-fffc-4462-810f-9af08a227059
# ╠═ca8083b0-dd31-4293-9c96-d076c52b742e
# ╟─75485cc5-38c0-4420-bd77-d12b1dce3aba
# ╠═a78098d2-4b87-46c5-8650-794555f36043
# ╟─47d0112c-8acf-471f-998b-fad542372fed
# ╟─381cb596-eb2f-47db-a71f-c62726572c67
# ╟─2e9f9ab5-56e1-4194-b5d9-64a210615674
# ╠═7e8d3daf-0617-40e0-969b-3be707cd2164
# ╠═cdcf0765-9eb8-4ec5-a92b-a0a38739d949
# ╠═1ae6196c-478c-47e7-9a4d-cd7d946034aa
# ╟─1f6cf151-4880-4325-ba60-26623300d550
# ╠═c13e582d-c575-4fbc-b540-b859266468ba
# ╠═8e543167-d872-4a97-a4a5-93bbd0eafbb8
