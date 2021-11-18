### A Pluto.jl notebook ###
# v0.17.1

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 131b4e08-1057-4567-80eb-8046f89bf7b8
begin
	using Pkg
	Pkg.activate(mktempdir())
end

# ╔═╡ 883fcff8-e9ef-4de6-95b1-d63127337f80
begin	
	Pkg.add(["Images", "ImageMagick", "Compose", "ImageFiltering",
			"TestImages", "Statistics", "PlutoUI", "LinearAlgebra", "Plots"])
	
	using Images
	using TestImages
	using ImageFiltering
	using Statistics
	using PlutoUI
	using LinearAlgebra
	using Plots
end

# ╔═╡ 871ddca4-4321-11ec-1e0d-bd2d5f2ec717
md"""
# Arrays in Julia! 
"""

# ╔═╡ 0e95b57a-95a8-48a5-8dd4-09bb77597e08
md"""
Since we are working inside a Pluto notebook the very first thing we need to do is to setup a temporary package environment. We do this below:
"""

# ╔═╡ e55e2dbb-3d6a-4e48-87ac-315cc7dbae8c
PlutoUI.TableOfContents(title = "Julia Arrays", indent = true)

# ╔═╡ 3e288973-2e57-4e7d-9233-d8a3f45487b8
md"""
## What are Juylia arrays? 
In Julia an array is a container. A containir which is indexed. You can either index an array with a cartesian index, for instance (i,j) for a two dimensional array, or a linear index (i).  

This means that whatever type you're working with can be used to define the entries of an array, in other words, you can store essentially any Julia type inside an array. 

Julia allow you to work with multidimensional arrays. It also provides a special type for one dimensional arrays, the Vector type. Let us look at some examples!
"""

# ╔═╡ f5caf46c-ebba-44ad-b657-ea2007cb3363
md"""
**this is an empty array**
"""

# ╔═╡ 8defc9e1-931b-4355-ae26-240ce7325c89
empty_arr = []

# ╔═╡ 751664cd-7e22-4d54-8ced-9cc588ded9f1
typeof(empty_arr)

# ╔═╡ 9d43f743-e32f-4ac2-b1f4-299c28f510e4
md"""
**We can fill the array by pushing elements into it**
"""

# ╔═╡ e1755f66-b3c3-4cb4-bdb0-e43fcd99d106
begin
	for jj = 1:10
		push!(empty_arr, jj)
	end
	empty_arr
end

# ╔═╡ ffb793c6-e787-4c8e-b412-185f7b4bba3d
md"""
Here the bang (!) implies the push function will return a modyfied version of the original array, that is, it points to the same object in memory. Withouth the bang, it will return a new array.
"""

# ╔═╡ 3236c95b-9252-4526-b646-b0adb1c475a3
md"""
**We can also create arrays by using "list comprehension", as in python**
This is a vector of random numbers sampled uniformly between zero and one
"""

# ╔═╡ 62b30478-41d9-4d8a-a8e1-2f036b040eb6
some_arr = [rand() for jj = 1:10]

# ╔═╡ 32a0dfda-df19-411d-89d6-9bfc31d2470f
typeof(some_arr)

# ╔═╡ de198831-331d-4294-9e73-26a221a407db
md"""
one can also obtain the same vector of random numbers using the build in function rand()
"""

# ╔═╡ 579e6fa3-0495-486a-ae41-0ec973a1d24a
some_other_arr = rand(10)

# ╔═╡ 5586ae70-e305-4e29-ac3a-76ab6f8a2ad7
typeof(some_other_arr)

# ╔═╡ d723c653-1548-4a58-b162-76749c2bf634
md"""
**The Linear Algebra pakcgae also provide buildier functions for simple arrays. For instance an array of zeros or an array of ones, or even a diagonal matrix where you can specify which diagonal is nonzero**
"""

# ╔═╡ 9df7f969-a826-433d-9c8c-b12ce6d2ecd8
zeros_arr = zeros(10)

# ╔═╡ 31ab1a19-e241-445d-b7b3-925f0b0828f6
ones_arr = ones(10)

# ╔═╡ 93f8f142-fdec-4072-97df-95797632923a
dmat = diagm(0=>ones_arr)

# ╔═╡ 73c98a12-7cd0-47c4-bea2-1e4305ccc171
md"""
There are also special types for matrices with structure. Banded, diagonal, Tridiagonal, Symmetric tridiagonal, sparce, .....

This is very convinient as some, or almost all, the decompositions or Matrix operations have an efficient method implemented for these special types.
"""

# ╔═╡ 633b3a8e-0c7f-4ed4-8087-d7f0e4613551
md"""
## Manipulating arrays

An interesting way of seeing how array manipulation works in Julia is by dealing with Images! 

An image is nothing but a two dimensional array whose entries are of RGB types!
"""

# ╔═╡ 631f0508-d8a8-4c02-bd3c-ea22c984b81e
md"""
#### Let us load the Harv
"""

# ╔═╡ c10dd482-d8ef-4d7d-be7e-3652f6df9856
flat_harv = load("figures/flat_harv.jpg")

# ╔═╡ 288850e7-a5dd-48a8-9a10-d1cb587a599f
size(flat_harv)

# ╔═╡ 7bad24af-e3d5-43ad-8955-cdaad9b51d7e
typeof(flat_harv)

# ╔═╡ 54180542-59b9-46ed-a954-7cd67773de98
typeof(flat_harv[1,3])

# ╔═╡ 8debde9a-b6a4-49dc-b955-3e28603476f4
typeof(flat_harv[4])

# ╔═╡ 7c075a44-5fba-4023-b4f2-1b85c395ecc9
flat_harv[4]

# ╔═╡ c092b543-9be0-4ca9-a002-b4fbbf95381b
md"""
**Let me now giveyou an example of the ineractivity which is possible in Pluto**
"""

# ╔═╡ 0e316451-035e-4a0c-a241-65d6c36726fe
@bind ll Slider(10:11:150, show_value = true)

# ╔═╡ afd6a0c3-2b56-42ef-894d-f956778ecd7c


# ╔═╡ 85e60b86-9bbb-4754-8bd7-b7290f403034
md"""
Array concatenation
"""

# ╔═╡ 8310a8d9-e1f8-44b8-867f-e813f1965075
md"""
**This is array concatennation along the row dimension (dimension 2)**
"""

# ╔═╡ 2a78f234-fc62-4174-a936-d98ec735b3f4
md"""
**This is array concatennation along the column dimension (dimension 1)**
"""

# ╔═╡ cac076f3-07d6-47b6-ac55-7a66e488635c
md"""
**Broadcasting (free elementwise functions)**
Something very nice about Julia is the easiness to promote functions define on types, which are by construction non arrays, to the case of element-wise operations on arrays. 

As an example, lets make a gray scale version of the flat_harv
"""

# ╔═╡ 8b98e8e3-00aa-46c2-a0f5-95e1ff81361c
md"""
### Is the flat Harv reddish, greenish or blueish ???
To answer this question we can calculate the mean value of red, green and blue of the flat Harv.
"""

# ╔═╡ b9e8cc47-457a-48e0-8ca4-73e5221b77e0
begin
	mean_red = mean(red.(flat_harv))
	mean_green = mean(green.(flat_harv))
	mean_blue = mean(blue.(flat_harv))

	#mean_harv_vals = mean.([red.(flat_harv), green.(flat_harv), blue.(flat_harv)])
	mean_harv_vals = [mean_red, mean_green, mean_blue]
	colors = ["red", "green", "blue"]
	
	max = findmax(mean_harv_vals)

	"The harv is more " * colors[max[2]]
end

# ╔═╡ dfd8af3d-4635-424a-adcc-b494bcf0c88a
md"""
## Views and data allocation
One of the issues that sometimes makes Julia code slow is allocating data. 

For instance, if you're are running a loop where in each iteration of the loop you make some computation for one of the columns of a two dimensional array MyArray, then the call 

~~~Julia
for ii = 1:length(MyArray)
	temp_col = MyArray[:, ii]
	desired_value = sum(abs.(temp_col).^2)
end
~~~

So, you want to compute the sum of all the norm square of the entries of each column. In the above code snipped the calling to temp_col creates a vector which is a copy of the column, one can avoid this by creating a view!

A view is just a window into an array, and thus we are not allocating a copy of the vector into memory, our code snipped will look like 

~~~Julia
for ii = 1:length(MyArray)
	temp_col = view(MyArray[:, ii])
	desired_value = sum(abs.(temp_col).^2)
end
~~~

Very nicely, Julia give us the posibility of defining macros, for instance, the line 

~~~Julia
temp_col = view(MyArray[:, ii])
~~~

can be rewritten using the macro @view 

~~~Julia
temp_col = @view MyArray[:, ii]
~~~

:D
"""

# ╔═╡ b539ffde-79fb-4276-9602-cbce6600281a


# ╔═╡ 37e69e60-3801-4737-942c-6e18f2da5b13


# ╔═╡ 0421fae6-6c57-430e-a370-93a04939c01d
md"""
## LinearAlgebra example: Wigner semicircle law

As an example of the different things the LinearAlgebra module allows us to do, let us try to construct the Wigner semicircle law for the eigenvalues of unitary random matrices.
"""

# ╔═╡ af4b97bf-6870-43fa-a66a-bf42756ca0af


# ╔═╡ 615a17af-c0e7-4995-a65d-9b0f356dc5ab
md"""
## Tiny homework
Following the example of the Wigner semicircle law, write a code to compute the distribution of level spacings for random unitary matrices, and compare your histogram with the expected Wigner-Dyson distribution.
"""

# ╔═╡ 59803f58-09ae-44f0-a55e-b3cc698d950e
md"""
# helper functions 
"""

# ╔═╡ 2864d588-51f6-4736-a9a4-1f84a0f0c86b
##-- decimating an image
function decimate(img::Array, spacing::Int64)
	"""
	This function decimates an image by returning a copy of it skiping a number of 
	pixes equal to spacing, both in the column and row indices
	"""
	return img[1:spacing:end, 1:spacing:end]
end 

# ╔═╡ 289b9969-40b7-4869-afd9-1e815af2a0e2
small_flat_harv = decimate(flat_harv, 27)

# ╔═╡ 4b7cfadb-154d-4961-8e85-24bcf667832d
two_harvs_row = [small_flat_harv small_flat_harv]

# ╔═╡ 02c9ed79-e649-4596-98b5-ee388600b59c
two_harvs_col = [small_flat_harv; small_flat_harv]

# ╔═╡ d61e931e-4985-45d4-bec7-6b77eae4c632
four_harvs = [small_flat_harv small_flat_harv; small_flat_harv small_flat_harv]

# ╔═╡ 8756c529-2fa9-45f3-b29d-675bd937d46d
shrinked_harv = decimate(flat_harv, ll)

# ╔═╡ dc08b675-7ca5-4e03-9c43-1fd613a582cb
small_harvs = [decimate(flat_harv, jj) for jj in 10:45:150]

# ╔═╡ 8d09ed12-097f-4db6-8921-048bd0d05323
GS_harv = Gray.(decimate(flat_harv, 11))

# ╔═╡ 1b3e296d-cb7c-4470-870d-aec701048dc1
##-- construct a symmetric random matrix 
function sym_rand_mat(size::Int64)
	"""
	This function construct a symmetric random matrix whose entries are sampled from
	a normal distribution with zero mean and unit variance
	"""
	mat = randn(size, size)

	return 0.5*(mat .+ transpose(mat))
end

# ╔═╡ 89552ffb-ed12-454b-ae92-da6b9a9e9de7
let 
	## constructing the symmetric random matrix and finding its eigenvalues
	mat_size = 2000
	smat = sym_rand_mat(mat_size)
	

	evals = eigvals(smat)
	R = maximum(evals)

	circle_vals(x) = (2/(pi*R))*sqrt(R^2 - x^2)
	xvals = -R:0.1:R
	cvals = circle_vals.(xvals)

	##-- building the figure
	plo = plot(xlabel = "eigenvalue value", tickfontsize = 10)

	histogram!(evals, bins = range(minimum(evals), maximum(evals), length = 35),
		normalize = true)
	plot!(xvals, 0.01*(cvals/maximum(cvals)), lw = 2.0, c = :red)

	plo
end 

# ╔═╡ 93f468c7-1ba7-4b28-9e6f-37edc96b3591
mediumbreak = html"<br><br>"

# ╔═╡ abece604-24ef-4e54-a406-238f37b51347
mediumbreak

# ╔═╡ baeb49b9-65a0-4d64-b468-c44db760fab2
mediumbreak

# ╔═╡ 2246b7c1-8278-4b99-a833-a6b120e59663
mediumbreak

# ╔═╡ 6c30871e-49be-4afc-940c-a93928f3c829
mediumbreak

# ╔═╡ 46af962e-372c-45dc-b4dc-5cd55d311d06
mediumbreak

# ╔═╡ Cell order:
# ╟─871ddca4-4321-11ec-1e0d-bd2d5f2ec717
# ╟─0e95b57a-95a8-48a5-8dd4-09bb77597e08
# ╠═131b4e08-1057-4567-80eb-8046f89bf7b8
# ╠═883fcff8-e9ef-4de6-95b1-d63127337f80
# ╠═e55e2dbb-3d6a-4e48-87ac-315cc7dbae8c
# ╟─abece604-24ef-4e54-a406-238f37b51347
# ╟─3e288973-2e57-4e7d-9233-d8a3f45487b8
# ╟─f5caf46c-ebba-44ad-b657-ea2007cb3363
# ╠═8defc9e1-931b-4355-ae26-240ce7325c89
# ╠═751664cd-7e22-4d54-8ced-9cc588ded9f1
# ╟─9d43f743-e32f-4ac2-b1f4-299c28f510e4
# ╠═e1755f66-b3c3-4cb4-bdb0-e43fcd99d106
# ╟─ffb793c6-e787-4c8e-b412-185f7b4bba3d
# ╟─3236c95b-9252-4526-b646-b0adb1c475a3
# ╠═62b30478-41d9-4d8a-a8e1-2f036b040eb6
# ╠═32a0dfda-df19-411d-89d6-9bfc31d2470f
# ╟─de198831-331d-4294-9e73-26a221a407db
# ╠═579e6fa3-0495-486a-ae41-0ec973a1d24a
# ╠═5586ae70-e305-4e29-ac3a-76ab6f8a2ad7
# ╟─d723c653-1548-4a58-b162-76749c2bf634
# ╠═9df7f969-a826-433d-9c8c-b12ce6d2ecd8
# ╠═31ab1a19-e241-445d-b7b3-925f0b0828f6
# ╠═93f8f142-fdec-4072-97df-95797632923a
# ╟─73c98a12-7cd0-47c4-bea2-1e4305ccc171
# ╟─baeb49b9-65a0-4d64-b468-c44db760fab2
# ╟─633b3a8e-0c7f-4ed4-8087-d7f0e4613551
# ╟─631f0508-d8a8-4c02-bd3c-ea22c984b81e
# ╠═c10dd482-d8ef-4d7d-be7e-3652f6df9856
# ╠═288850e7-a5dd-48a8-9a10-d1cb587a599f
# ╠═7bad24af-e3d5-43ad-8955-cdaad9b51d7e
# ╠═54180542-59b9-46ed-a954-7cd67773de98
# ╠═8debde9a-b6a4-49dc-b955-3e28603476f4
# ╠═7c075a44-5fba-4023-b4f2-1b85c395ecc9
# ╠═289b9969-40b7-4869-afd9-1e815af2a0e2
# ╟─c092b543-9be0-4ca9-a002-b4fbbf95381b
# ╠═0e316451-035e-4a0c-a241-65d6c36726fe
# ╠═8756c529-2fa9-45f3-b29d-675bd937d46d
# ╠═dc08b675-7ca5-4e03-9c43-1fd613a582cb
# ╠═afd6a0c3-2b56-42ef-894d-f956778ecd7c
# ╟─85e60b86-9bbb-4754-8bd7-b7290f403034
# ╟─8310a8d9-e1f8-44b8-867f-e813f1965075
# ╟─4b7cfadb-154d-4961-8e85-24bcf667832d
# ╟─2a78f234-fc62-4174-a936-d98ec735b3f4
# ╠═02c9ed79-e649-4596-98b5-ee388600b59c
# ╠═d61e931e-4985-45d4-bec7-6b77eae4c632
# ╟─cac076f3-07d6-47b6-ac55-7a66e488635c
# ╠═8d09ed12-097f-4db6-8921-048bd0d05323
# ╟─8b98e8e3-00aa-46c2-a0f5-95e1ff81361c
# ╠═b9e8cc47-457a-48e0-8ca4-73e5221b77e0
# ╟─2246b7c1-8278-4b99-a833-a6b120e59663
# ╟─dfd8af3d-4635-424a-adcc-b494bcf0c88a
# ╠═b539ffde-79fb-4276-9602-cbce6600281a
# ╠═37e69e60-3801-4737-942c-6e18f2da5b13
# ╟─6c30871e-49be-4afc-940c-a93928f3c829
# ╟─0421fae6-6c57-430e-a370-93a04939c01d
# ╠═89552ffb-ed12-454b-ae92-da6b9a9e9de7
# ╠═af4b97bf-6870-43fa-a66a-bf42756ca0af
# ╟─615a17af-c0e7-4995-a65d-9b0f356dc5ab
# ╟─46af962e-372c-45dc-b4dc-5cd55d311d06
# ╟─59803f58-09ae-44f0-a55e-b3cc698d950e
# ╠═2864d588-51f6-4736-a9a4-1f84a0f0c86b
# ╠═1b3e296d-cb7c-4470-870d-aec701048dc1
# ╠═93f468c7-1ba7-4b28-9e6f-37edc96b3591
