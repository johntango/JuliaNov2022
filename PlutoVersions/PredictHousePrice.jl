### A Pluto.jl notebook ###
# v0.19.9

using Markdown
using InteractiveUtils

# ╔═╡ 94802ec1-6e6b-4608-bc1e-cb959868baf5
begin
    import Pkg
    Pkg.add("Plots")
    using Plots
end

# ╔═╡ 177fe39a-0a5e-4863-9a98-97253dae4dad
begin
    # House Sales Data, ETL, Build Predictive Model(linear regression), 
    # Assess Model, Deploy Model. Training data  'house100Data.csv'
    # R^2 = 0.75  Price explained by the indep. variables
    Pkg.add("DataFrames")
    Pkg.add("Missings")
    Pkg.add("CSV")
    Pkg.add("Statistics")
    Pkg.add("LinearAlgebra")
    using DataFrames
    using CSV
    using Missings
    using Statistics
    using LinearAlgebra
end

# ╔═╡ ccd33cef-a4f3-43c3-aacc-f0326d07be00
md"""
### House Price Prediction Exercise - data_description.txt
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

# ╔═╡ 1df4c152-9827-4511-a778-12b16d24f1cb


# ╔═╡ ed8f6d88-2dc7-483e-ace6-321b37ce661d
begin
    xx = range(1, 100)
    yy = xx .^ 2
    scatter(xx, yy)
end


# ╔═╡ d57a171a-839c-4a7d-85aa-0ccfa12ff4ec
begin
    train = CSV.read("house100Data.csv", DataFrame)
    size(train)
end

# ╔═╡ 66013ac0-97ff-45d5-a704-5467853749b5
# extract SalePrice column
price = train[:, :SalePrice]




# ╔═╡ 671944c8-09b7-4a44-a1eb-988d4b23afbd
begin
    #plot([1:100], price)
    # scatter plot
    #scatter(train[:,:LotArea], price)
    # bar plot
    bar([1:100], price)

end

# ╔═╡ 306aad6b-1706-4c7a-8774-104853a9b79f
# drop columns with missing values
# drop columns with missing values
#select!(train, Not(:Alley))   # this drops the Alley column
#shape of train
size(train)

# ╔═╡ 4f32bf65-12f8-4496-a99e-6e2bb3c0d130
df2 = DataFrame(:A => [5, 10, 15, 20, 25], :Y => [5, 10, missing, 20, 15])

# ╔═╡ e1dd2eaa-58bb-40dc-84dc-b3f7ad5b769d
begin
    # count missing values in column 
    function getListOfMissingColumns(df)
        missingColumns = []
        for i in 1:size(df)[2]
            num = count(ismissing, df[:, i])
            if num > 0
                # print column name and number of missing values
                println(names(df)[i], " ", num)
                push!(missingColumns, names(df)[i])
            end
        end
        return missingColumns
    end
    getListOfMissingColumns(train)
    # drop columns with missing values



end

# ╔═╡ 52ed110a-f713-4304-8396-956feb699a4e
begin
    function dropColumnsWithMissingValues(df)
        missingColumns = getListOfMissingColumns(df)
        for i in 1:length(missingColumns)
            select!(df, Not(Symbol(missingColumns[i])))
        end
        return df
    end
    #train = dropColumnsWithMissingValues(train)
    dropColumnsWithMissingValues(train)
    size(train)
end

# ╔═╡ 2e748081-0b02-43df-b6a0-bc369c95f51c
begin
    # get names of non numeric columns float and int

    function getNonNumericColumns(df)
        nonNumericColumns = []
        for i in 1:size(df)[2]
            if !(eltype(df[:, i]) <: Number)
                push!(nonNumericColumns, names(df)[i])
            end
        end
        return nonNumericColumns
    end
    nonNumericCols = getNonNumericColumns(train)

end

# ╔═╡ 72d6fb52-abfa-40cc-9610-95343d3231bd
begin
    # drop non numeric columns
    function dropNonNumericColumns(df)
        nonNumericColumns = getNonNumericColumns(df)
        for i in 1:length(nonNumericColumns)
            select!(df, Not(Symbol(nonNumericColumns[i])))
        end
        return df
    end
    # train = 
    dropNonNumericColumns(train)
    size(train)

end

# ╔═╡ f16533f2-30fb-43fc-8ee7-cccc64ce6bbb
begin
    # get name of problem column
    names(train)[33]
    select!(train, Not(Symbol("PoolArea")))
    size(train)
end

# ╔═╡ c02fd9e8-98e5-4f0e-9d49-d6bb216dcf55
begin
    # Build correlation matrix
    #using Statistics
    cor(Matrix(train))
    # Plot heatmap of correlation matrix
    heatmap(cor(Matrix(train)))
end

# ╔═╡ dd826df7-6a8a-4ae2-9b6a-4a2b2eebff3a
begin
    # select top 5 columns with highest correlation with SalePrice

    # select highest correlation with column 36
    priceCor = corMatrix[:, 36]
    # get index of the top 5 correlations
    top5 = sortperm(priceCor, rev=true)[1:5]
    # get column names of top 5 correlations
    top5Names = names(train)[top5]

end

# ╔═╡ 713b4fe2-7acc-4e44-b10f-79aa4f70f408
size(train)

# ╔═╡ 18ee727d-edef-4776-94d2-69c457dc199b
begin
    # select columns from list of column names
    function selectColumns(df, colNames)
        X = []
        for i in eachindex(colNames)
            if i == 1
                X = df[:, Symbol(colNames[eachindex])]
            else
                X = hcat(X, df[:, Symbol(colNames[eachindex])])
            end
        end
        return X
    end

    Y = selectColumns(train, top5Names[1:1])
    X = selectColumns(train, top5Names[2:4])
end

# ╔═╡ 27c9cac8-0f2e-466c-b97f-baa1cc7df5a1
begin
    # build linear regression model

    function buildLinearRegressionModel(X, Y)
        # get number of rows
        m = size(X)[1]
        # add column of ones to X
        X = hcat(ones(m, 1), X)
        # get theta
        theta = inv(X' * X) * X' * Y
        return theta
    end
    model = buildLinearRegressionModel(X, Y)
end

# ╔═╡ 4d3671a2-d86d-4879-a019-6647d838b2ce
begin
    # predict price
    function predictPrice(model, X)
        # get number of rows
        m = size(X)[1]
        # add column of ones to X
        X = hcat(ones(m, 1), X)
        # get theta
        Y = X * model
        return Y
    end
    Yp = predictPrice(model, X)
    # model accuracy R^2


end

# ╔═╡ 01343bf2-7600-4538-9bc7-62876c09aeb5
# plot predicted price vs actual price
scatter(Y, Yp, label="Predicted vs Actual Price")

# ╔═╡ c915d747-9209-4256-bc69-c6202933dc70
begin
    # RMS difference between predicted and actual price
    function getRMS(Y, Yp)
        # get number of rows
        m = size(Y)[1]
        # get difference
        diff = Y - Yp
        # get square of difference
        diffSq = diff .^ 2
        # get sum of square of difference
        sumDiffSq = sum(diffSq)
        # get mean of square of difference
        meanDiffSq = sumDiffSq / m
        # get root of mean of square of difference
        rms = sqrt(meanDiffSq)
        return rms
    end
    rms = getRMS(Y, Yp)



end

# ╔═╡ 9f29b357-5cb1-4020-b3c2-9b543e001303
begin
    # get R^2 value. Metric to measure accuracy of model
    function getR2Accuracy(Y, Yp)
        # get number of rows
        m = size(Y)[1]
        # get mean of Y
        Ymean = mean(Y)
        # get sum of squared errors
        SSE = sum((Y - Yp) .^ 2)
        # get sum of squared total
        SST = sum((Ymean .- Y) .^ 2)  # note the dot operator and order of subtraction
        # get R^2
        R2 = 1 - SSE / SST
        return R2
    end
    getR2Accuracy(Y, Yp)
end

# ╔═╡ 564d98c8-04bf-4f5e-90a7-68e1db06c3ab
# select numeric columns only
#numericCols = [:LotArea, :OverallQual, :OverallCond, :YearBuilt, :YearRemodAdd, #:MasVnrArea, :BsmtFinSF1, :BsmtFinSF2, :BsmtUnfSF, :TotalBsmtSF, :1stFlrSF, #:2ndFlrSF, :LowQualFinSF, :GrLivArea, :BsmtFullBath, :BsmtHalfBath, :FullBath, #:HalfBath, :BedroomAbvGr, :KitchenAbvGr, :TotRmsAbvGrd, :Fireplaces, :GarageYrBlt, #:GarageCars, :GarageArea, :WoodDeckSF, :OpenPorchSF, :EnclosedPorch, :3SsnPorch, #:ScreenPorch, :PoolArea, :MiscVal, :MoSold, :YrSold]


# ╔═╡ 3d04dc09-ab77-4d11-8c16-9b04742b54d0
begin
    # plot histogram of predicted price
    histogram(Yp, label="Predicted Price")

end

# ╔═╡ bfa74588-02a5-4157-b1c5-9fb46044a3d9
# Problem Set
# 1. Build a linear regression model to predict the price of houses in the test.csv file
# 2. Submit your predictions 


#test = CSV.read("test.csv", DataFrame)


# ╔═╡ Cell order:
# ╟─ccd33cef-a4f3-43c3-aacc-f0326d07be00
# ╠═94802ec1-6e6b-4608-bc1e-cb959868baf5
# ╠═1df4c152-9827-4511-a778-12b16d24f1cb
# ╠═177fe39a-0a5e-4863-9a98-97253dae4dad
# ╠═ed8f6d88-2dc7-483e-ace6-321b37ce661d
# ╠═d57a171a-839c-4a7d-85aa-0ccfa12ff4ec
# ╠═66013ac0-97ff-45d5-a704-5467853749b5
# ╠═671944c8-09b7-4a44-a1eb-988d4b23afbd
# ╠═306aad6b-1706-4c7a-8774-104853a9b79f
# ╠═4f32bf65-12f8-4496-a99e-6e2bb3c0d130
# ╠═e1dd2eaa-58bb-40dc-84dc-b3f7ad5b769d
# ╠═52ed110a-f713-4304-8396-956feb699a4e
# ╠═2e748081-0b02-43df-b6a0-bc369c95f51c
# ╠═72d6fb52-abfa-40cc-9610-95343d3231bd
# ╠═f16533f2-30fb-43fc-8ee7-cccc64ce6bbb
# ╠═c02fd9e8-98e5-4f0e-9d49-d6bb216dcf55
# ╟─dd826df7-6a8a-4ae2-9b6a-4a2b2eebff3a
# ╠═713b4fe2-7acc-4e44-b10f-79aa4f70f408
# ╠═18ee727d-edef-4776-94d2-69c457dc199b
# ╠═27c9cac8-0f2e-466c-b97f-baa1cc7df5a1
# ╠═4d3671a2-d86d-4879-a019-6647d838b2ce
# ╠═01343bf2-7600-4538-9bc7-62876c09aeb5
# ╠═c915d747-9209-4256-bc69-c6202933dc70
# ╠═9f29b357-5cb1-4020-b3c2-9b543e001303
# ╠═564d98c8-04bf-4f5e-90a7-68e1db06c3ab
# ╠═3d04dc09-ab77-4d11-8c16-9b04742b54d0
# ╠═bfa74588-02a5-4157-b1c5-9fb46044a3d9
