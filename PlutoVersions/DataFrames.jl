### A Pluto.jl notebook ###
# v0.19.9

using Markdown
using InteractiveUtils

# ╔═╡ 0ea5a8bc-673d-434b-8b08-d039c9f151f3
begin
    import Pkg
    Pkg.add("DataFrames")
    Pkg.add("Missings")
    Pkg.add("CSV")
    using DataFrames
    using Missings
    using CSV
end

# ╔═╡ 895befb1-87e9-4613-9dc3-defc7d6b7fb2
begin
	df0 = DataFrame(
	colour = ["green","blue","white","green","green"],
	shape  = ["circle", "triangle", "square","square","circle"],
	border = ["dotted", "line", "line", "line", "dotted"],
 	area   = [1.1, 2.3, 3.1, missing, 5.2])
end 

# ╔═╡ aa5039a1-0ed5-47ae-b767-01d62bb21863
# explore the dataframe
begin
	for c in eachrow(df0)    # eachcol(df) for columns
	    print(c)
	end
end


# ╔═╡ da0500b7-2787-4be7-b0ca-86afb8cccd8b
begin
	#Referencing is obtained using the exclamation mark ! for the row position 
	#(to emphasize that referenced data could be changed in the new object) 
	myRef1 = df0[!, :colour]
	#myRef1[1] = "pink"   # changes the original dataframe as well
	#myRef1
end

# ╔═╡ 35172a0b-aa40-458c-9c12-21b038f2be02
# we can also reference a column by name
myRef2 = df0.colour

# ╔═╡ a7953530-07ec-470f-b885-ba6192500c2d
begin
	dict0 = Dict(:Color=>["green","blue","white","green","green"],:Shape=>["circle", "triangle", "square","square","circle"],:Border=>["dotted", "line", "line", "line", "dotted"],:Area=>[1.1, 2.3, 3.1, missing, 5.2])
	df01 = DataFrame(dict0)
	#select(df, Not(:Area))   # drop column :Area
end

# ╔═╡ 12a7b0dc-c29c-42f5-bec9-7ba05732baf0
"""we have a list of 3 books and their authors. 
 Some of the books have more than one author
 list of books "The Hobbit", "The Lord of the Rings", "The Silmarillion"
 list of authors "J.R.R. Tolkien", "J.R.R. Tolkien",     "J.R.R. Tolkien" and "Christopher Tolkien"
 construct a dataframe with two columns: Book and Author
"""

# ╔═╡ a45f6e31-23e1-4567-8d1e-b3908e8537d5
tuples = (:H => [5, 10], :J => [10, 15])

# ╔═╡ e5fb9d0a-508c-44b2-9cea-12f199b98148
typeof(tuples)

# ╔═╡ 3e8e796e-3b70-435f-8001-ed0589406ffe
begin
    df = DataFrame(tuples)
end


# ╔═╡ c6f8379c-37c7-4102-804c-f5da5e86206c
dict = Dict(:H => [5, 10, 15, 20], :J => [1, 2, 3, 4])

# ╔═╡ 5ca0c1ae-0eb1-44d2-a8ea-0ed49b3bbdd2
typeof(dict)

# ╔═╡ 6fe93942-ae92-40f8-a605-1a8f233d3a6f
df2 = DataFrame(dict)



# ╔═╡ d120a06b-a0a7-40b4-a60a-7b578f0be6c4
df4 = DataFrame(:X => [5, 10, 15, 20], :Y => [5, 10, 15, 20])

# ╔═╡ a7344750-577e-4324-a73e-fe093c8c4214
push!(df4, [10, 15])

# ╔═╡ b775d780-3ce5-4ee5-bf35-607f10e4bdbd
# Child of struct:
df4.X

# ╔═╡ e88dec37-a505-4350-8af4-62b3cadc550f
# Key:
df4[!, :X]

# ╔═╡ ed7662d5-ecd8-4097-aac2-3acf2b9cac5c
names(df4)

# ╔═╡ b80af2ff-5b0f-4f35-95c4-2207dab4822d
df4[!, :Z] = [1, 2, 3, 4, 5]

# ╔═╡ 84684b87-a2a3-4022-ab47-89ccee0f685d
show(df4)

# ╔═╡ c7bb7f3c-ae0a-4123-b0b9-947e61077bfe
show(df4, allcols=true)

# ╔═╡ 6467c29e-69fe-47a1-9b1e-97367f64d604
first(df4, 2)

# ╔═╡ b1df5b7e-3efe-4f50-a36d-2ce9ec0fc373
last(df4, 3)

# ╔═╡ 7b583bc3-b719-4111-b8be-fd31afafb0a7
df4[2:4, :]

# ╔═╡ 0db42ee4-9874-47f8-a680-5d259255cbab
df4[Not(2:4), :]

# ╔═╡ 5a13f9bd-c876-46b5-8f1c-1622d0fe6cc7
show(df4)

# ╔═╡ d4faf5dc-2dcc-4fd4-9e62-772421bc3afa
df4[2, 2]

# ╔═╡ 0b97ac76-7c22-43fb-9879-e19ba668e924
df5 = DataFrame(:A => [5, 10, 15, 20, 25], :Y => [5, 10, 15, 20, 15])

# ╔═╡ 6df13a2e-b1f6-44ff-b28a-7fc498403cd5
innerjoin(df4, df5, on=:Y)

# ╔═╡ cd349c13-665d-4065-838a-639a31a5a146
sort!(df5)

# ╔═╡ 28cce68d-1307-45ac-a22b-89fb6d1e8159
df6 = DataFrame(:A => [5, missing, 6], :B => [5, 10, 2])

# ╔═╡ e8876d1f-deba-4a49-b382-a3652be68be6
dropmissing(df6)

# ╔═╡ b4025fff-4add-4f8e-86bf-20c92b2f48bc
df6

# ╔═╡ 09612415-8574-4134-b449-0adb46c719c7
dropmissing(df6, :A)

# ╔═╡ 57e42951-4a20-46fa-92f9-ef2522b0c1e2
md"""

"""

# ╔═╡ 548ff73f-e0cc-48cd-83d4-7028812f458a
df7 = DataFrame(x=[1, missing, 3, nothing, 5, NaN], y='a':'f')


# ╔═╡ 3d353fea-c034-4548-83b9-2ca935f7e5df
filter([1] => x -> !any(f -> f(x), (ismissing, isnothing, isnan)), df7)

# ╔═╡ 65e6ed93-fc1c-4223-bd34-85afd38a37cd
filter(:x => x -> !any(f -> f(x), (ismissing, isnothing, isnan)), df7)

# ╔═╡ dcd0f805-79ee-4b06-a40f-b2d0525e6099
begin
    df8 = DataFrame(x=[missing, NaN, 3432.34, 432.2, NaN, 43.0])
    # select numerical type columns from a DataFrame df3
    filter(:x => x -> !any(f -> f(x), (ismissing, isnothing, isnan)), df8)
end

# ╔═╡ 934cbf7f-acfa-4413-af3f-5fa37134b853
df9 = DataFrame(A=[1, 3, 4, 5, 6, 432], B=[1, 3, 4, 5, 6, 3], C=["a", "b", "c", "d", "e", "f"])

# ╔═╡ cdb7f749-4276-4d5a-b314-ae7488fa6051
begin
    #using Missings
    # drop columns with not number values
    dfa = df9[:, map(col -> eltype(col) <: Number, eachcol(df9))]
    # note use of subtype operator <:
end




# ╔═╡ Cell order:
# ╠═0ea5a8bc-673d-434b-8b08-d039c9f151f3
# ╠═895befb1-87e9-4613-9dc3-defc7d6b7fb2
# ╠═aa5039a1-0ed5-47ae-b767-01d62bb21863
# ╠═da0500b7-2787-4be7-b0ca-86afb8cccd8b
# ╠═35172a0b-aa40-458c-9c12-21b038f2be02
# ╠═a7953530-07ec-470f-b885-ba6192500c2d
# ╠═12a7b0dc-c29c-42f5-bec9-7ba05732baf0
# ╠═a45f6e31-23e1-4567-8d1e-b3908e8537d5
# ╠═e5fb9d0a-508c-44b2-9cea-12f199b98148
# ╠═3e8e796e-3b70-435f-8001-ed0589406ffe
# ╠═c6f8379c-37c7-4102-804c-f5da5e86206c
# ╠═5ca0c1ae-0eb1-44d2-a8ea-0ed49b3bbdd2
# ╠═6fe93942-ae92-40f8-a605-1a8f233d3a6f
# ╠═d120a06b-a0a7-40b4-a60a-7b578f0be6c4
# ╠═a7344750-577e-4324-a73e-fe093c8c4214
# ╠═b775d780-3ce5-4ee5-bf35-607f10e4bdbd
# ╠═e88dec37-a505-4350-8af4-62b3cadc550f
# ╠═ed7662d5-ecd8-4097-aac2-3acf2b9cac5c
# ╠═b80af2ff-5b0f-4f35-95c4-2207dab4822d
# ╠═84684b87-a2a3-4022-ab47-89ccee0f685d
# ╠═c7bb7f3c-ae0a-4123-b0b9-947e61077bfe
# ╠═6467c29e-69fe-47a1-9b1e-97367f64d604
# ╠═b1df5b7e-3efe-4f50-a36d-2ce9ec0fc373
# ╠═7b583bc3-b719-4111-b8be-fd31afafb0a7
# ╠═0db42ee4-9874-47f8-a680-5d259255cbab
# ╠═5a13f9bd-c876-46b5-8f1c-1622d0fe6cc7
# ╠═d4faf5dc-2dcc-4fd4-9e62-772421bc3afa
# ╠═0b97ac76-7c22-43fb-9879-e19ba668e924
# ╠═6df13a2e-b1f6-44ff-b28a-7fc498403cd5
# ╠═cd349c13-665d-4065-838a-639a31a5a146
# ╠═28cce68d-1307-45ac-a22b-89fb6d1e8159
# ╠═e8876d1f-deba-4a49-b382-a3652be68be6
# ╠═b4025fff-4add-4f8e-86bf-20c92b2f48bc
# ╠═09612415-8574-4134-b449-0adb46c719c7
# ╟─57e42951-4a20-46fa-92f9-ef2522b0c1e2
# ╠═548ff73f-e0cc-48cd-83d4-7028812f458a
# ╠═3d353fea-c034-4548-83b9-2ca935f7e5df
# ╠═65e6ed93-fc1c-4223-bd34-85afd38a37cd
# ╠═dcd0f805-79ee-4b06-a40f-b2d0525e6099
# ╠═934cbf7f-acfa-4413-af3f-5fa37134b853
# ╠═cdb7f749-4276-4d5a-b314-ae7488fa6051
