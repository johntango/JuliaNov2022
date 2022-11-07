### A Pluto.jl notebook ###
# v0.19.9

using Markdown
using InteractiveUtils

# ╔═╡ 3fa86f22-dfa1-4123-8dc0-662629b01651
begin
	# House Sales Data, ETL, Build Predictive Model(linear regression), 
	# Assess Model, Deploy Model. Training data  'house100Data.csv'
	# R^2 = 0.75  Price explained by the indep. variables
	import Pkg; Pkg.add("DataFrames")
	Pkg.add("Missings")
	Pkg.add("Plots")
	Pkg.add("CSV")
	Pkg.add("HTTP")
	using DataFrames
	using CSV
	using Missings
	using Plots
	using HTTP
	using Statistics
	using LinearAlgebra
end

# ╔═╡ 8bd96238-1583-4352-99bc-e999d269bb2e


# ╔═╡ d599692a-10c6-4ec0-a1d2-2162c5c070dc
md"""
### data_description.txt
SalePrice — the property’s sale price in dollars. This is the target variable that you’re trying to predict.  
MSSubClass — The building class  
MSZoning — The general zoning classification 
MasVnrArea - Masonary Veneer Area in sq ft
LotFrontage — Linear feet of street connected to property  
LotArea — Lot size in square feet  
Street — Type of road access  
Alley — Type of alley access  
LotShape — General shape of property  
LandContour — Flatness of the property  
Utilities — Type of utilities available  
LotConfig — Lot configuration  
"""

# ╔═╡ b5822d43-b3c8-479f-8cfe-67f45f878620
begin
	files = [ 
	"https://raw.githubusercontent.com/alicezehner/PS2HouseDataExercise/master/predictions.csv",
	"https://raw.githubusercontent.com/evaserman/PS2/main/predictions.csv"
	]
	# get length of files
	filesLen = length(files)
	
end

# ╔═╡ 389c45d0-368d-406a-a36e-4e14cb819474
begin
# "SalePrice", "SalePrice_1" are the column names
# get mean error for each file
# get R^2 value. Metric to measure accuracy of model
function getR2Accuracy(Y, Yp)
    # get number of rows
    m = size(Y)[1]
    # get mean of Y
    Ymean = mean(Y)
    # get sum of squared errors
    SSE = sum((Y - Yp).^2)
    # get sum of squared total
    SST = sum((Ymean .-Y).^2)  # note the dot operator and order of subtraction
    # get R^2
    R2 = 1 - SSE/SST
    return R2
end 
end


# ╔═╡ ec4d2d9d-280c-484f-9bcd-3ab00a0167a9
begin
	# Julia CSV read actual price data into DataFrame
	# compare predicted price to actual price using R2
	
	actual = CSV.read("alldata.csv",DataFrame)
	# pick out the Id and SalePrice columns from actual
	select!(actual, [:Id, :SalePrice])
	# print actual names
	print(names(actual))
	
	
	for i in 1:filesLen
	    
	    url = files[i]
	    print("url: ",url,"\n")
	    # Julia CSV read url into DataFrame 
	    res = HTTP.get(url)
	    data = CSV.read(res.body,DataFrame)
	   
	   
	    # Julia DataFrames join two dataframes data and actual on Id
	    df = innerjoin(data,actual, on=:Id, makeunique=true)
	    # Julia DataFrames drop rows with missing values
	    print("names : ",names(df),"\n")
	    print("size : ",size(df),"\n")
	    print("R2 accuracy: ",getR2Accuracy(df.SalePrice, df.SalePrice_1),"\n")
	end
	    
	    
	
	
end

# ╔═╡ Cell order:
# ╠═8bd96238-1583-4352-99bc-e999d269bb2e
# ╟─3fa86f22-dfa1-4123-8dc0-662629b01651
# ╟─d599692a-10c6-4ec0-a1d2-2162c5c070dc
# ╠═b5822d43-b3c8-479f-8cfe-67f45f878620
# ╠═389c45d0-368d-406a-a36e-4e14cb819474
# ╠═ec4d2d9d-280c-484f-9bcd-3ab00a0167a9
