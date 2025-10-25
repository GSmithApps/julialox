using Test

# bring the lexer into scope (adjust the include path as needed)
# include("../src/lexer.jl")

# helper to make tokens comparable in tests
as_tuple(t::Token) = t isa NumberToken ? (:num, t.value) :
                     t isa PlusSign   ? (:plus,) :
                     (:unknown,)

@testset "tokenize basics" begin
    @test map(as_tuple, tokenize("")) == Tuple[]

    @test map(as_tuple, tokenize("42")) == [(:num, 42)]
    @test map(as_tuple, tokenize("  42  ")) == [(:num, 42)]

    @test map(as_tuple, tokenize("12 + 3 + 456")) ==
          [(:num, 12), (:plus,), (:num, 3), (:plus,), (:num, 456)]

    @test map(as_tuple, tokenize("7   +   8")) ==
          [(:num, 7), (:plus,), (:num, 8)]

    # trailing whitespace after last token
    @test map(as_tuple, tokenize("9 + 10   ")) ==
          [(:num, 9), (:plus,), (:num, 10)]

    # leading whitespace before first token
    @test map(as_tuple, tokenize("   1 + 2")) ==
          [(:num, 1), (:plus,), (:num, 2)]
end

@testset "error cases" begin
    @test_throws ArgumentError tokenize("1+2")           # missing spaces around '+'
    @test_throws ArgumentError tokenize("a")             # unexpected char
    @test_throws ArgumentError tokenize("1 @ 2")         # unexpected char
    @test_throws ArgumentError tokenize("+")             # plus without surrounding numbers
    @test_throws ArgumentError tokenize("1 +")           # incomplete expression, ends after '+'
end

@testset "larger numbers & spacing" begin
    @test map(as_tuple, tokenize("1234567890 + 9876543210")) ==
          [(:num, 1234567890), (:plus,), (:num, 9876543210)]

    # tabs and newlines count as whitespace
    @test map(as_tuple, tokenize("3\t+\n4")) ==
          [(:num, 3), (:plus,), (:num, 4)]
end