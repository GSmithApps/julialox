using Test

# Adjust paths as needed for your project layout
# include("../src/lexer.jl")
# include("../src/parser.jl")

# Define structural equality for AST nodes just for testing
import Base: ==
==(a::Num, b::Num) = a.value == b.value
==(a::Add, b::Add) = a.left == b.left && a.right == b.right

NumToken(v) = NumberToken(v)  # alias for readability

@testset "parser: basic structures" begin
    @test parse_tokens([NumToken(42)]) == Num(42)
    @test parse_tokens([NumToken(1), PlusSign(), NumToken(2)]) ==
          Add(Num(1), Num(2))
    @test parse_tokens([NumToken(12), PlusSign(), NumToken(3), PlusSign(), NumToken(4)]) ==
          Add(Add(Num(12), Num(3)), Num(4))
end

@testset "parser: parse_string integration" begin
    @test parse_string("12 + 3 + 4") == Add(Add(Num(12), Num(3)), Num(4))
    @test parse_string("  7   +   8  ") == Add(Num(7), Num(8))
end

@testset "parser: error cases" begin
    @test_throws ArgumentError parse_tokens(Token[])      # empty
    @test_throws ArgumentError parse_string("+ 1")        # starts with '+'
    @test_throws ArgumentError parse_string("1 +")        # ends with '+'
    @test_throws ArgumentError parse_string("1 ++ 2")     # double plus
    @test_throws ArgumentError parse_string("1 + + 2")    # plus where number expected
    @test_throws ArgumentError parse_string("1 2")        # missing '+'
end