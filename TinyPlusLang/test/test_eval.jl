using Test

# include("../src/lexer.jl")
# include("../src/parser.jl")
# include("../src/eval.jl")

@testset "evaluate: direct AST" begin
    @test evaluate(Num(0)) == 0
    @test evaluate(Add(Num(1), Num(2))) == 3
    @test evaluate(Add(Add(Num(12), Num(3)), Num(4))) == 19
end

@testset "evaluate: end-to-end from source" begin
    @test evaluate(parse_string("1 + 2 + 3 + 4 + 5")) == 15
    @test evaluate(parse_string("1234567890 + 9876543210")) == 11111111100
    @test evaluate(parse_string("  7   +   8  ")) == 15
end

@testset "evaluate: parser errors surface" begin
    @test_throws ArgumentError parse_string("+ 1")
    @test_throws ArgumentError parse_string("1 +")
    @test_throws ArgumentError parse_string("1 ++ 2")
end