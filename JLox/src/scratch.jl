# Function to accurately count the number of trailing spaces.
# This mimics finding the 'numSpacesToRight' in your pseudocode.
function get_trailing_spaces_for_start(line::AbstractString)::Int
    # we pretend trailing '/' and "|" are spaces when calculating the
    # number of trailing spaces. We achieve this by replacing the first structural 
    # brace with a space character for the purpose of calculating the right-justification count.
    
    # Find the index of the first '/' (which is the one replaced in the main function).
    brace_index = findlast('/', line)
    pipe_index = findlast('|', line)
    
    if !isnothing(brace_index)
        # Create a temporary line where the structural brace is replaced by a single space.
        # This ensures the brace contributes to the "trailing space" count.
        temp_line = string(line[1:brace_index-1], " ", line[brace_index+1:end])
    elseif !isnothing(pipe_index)
        temp_line = string(line[1:pipe_index-1], " ", line[pipe_index+1:end])
    else
        # If no brace exists, use the line as is.
        temp_line = line
    end

    # The difference in length between the temporary line and the stripped line 
    # is the effective count of trailing spaces (including the brace's contribution).
    return length(temp_line) - length(rstrip(temp_line))
end

"""
Recursively processes lines of code from a stack based on trailing space difference.

The logic compares the trailing spaces of the current line to the previous line.
An increase in trailing spaces (assumed 2 spaces per level) is converted into
leading opening parentheses. The first '/' is replaced with a ')'.
"""
function process_lines_of_source_code(
    stack_of_remaining_lines::Vector{String}, 
    new_source_code::String, 
    previous_line_trailing_spaces::Int # Corresponds to previousLineEnd
)::String
    
    # Base Case
    if isempty(stack_of_remaining_lines)
        return new_source_code
    end
    
    # 1. Pop the current line and determine its trailing spaces.
    current_line = popfirst!(stack_of_remaining_lines)

    if strip(current_line) == "" || last(rstrip(current_line))  ∉ ['/', '|']
        return process_lines_of_source_code(stack_of_remaining_lines, new_source_code, previous_line_trailing_spaces)
    end
    
    # currentLineStart corresponds to the number of trailing spaces on the current line.
    # This now includes the contribution of the structural brace.
    current_line_trailing_spaces = get_trailing_spaces_for_start(current_line) 
    
    # 2. Calculate the number of new opening parentheses to add (numOpenParenthesis).
    # Note: We use max(0, ...) to ensure we only add parentheses when the trailing 
    # space count increases or stays the same (and never decreases the count).
    trailing_space_increase = current_line_trailing_spaces - previous_line_trailing_spaces
    
    # Calculate the number of structure-opening parentheses, assuming 2 spaces per step.
    num_open_parenthesis = max(0, floor(Int, trailing_space_increase / 2))

    # 3. Transform the line content.
    # Replace the first occurrence of "/" with ")" and "|"with " "
    if last(rstrip(current_line)) == '/'
        transformed_line = replace(current_line, "/" => ")", count=1)
    else
        transformed_line = replace(current_line, "|" => " ", count=1)
    end
    
    # 4. Accumulate the new source code (newSourceCode).
    open_parens_string = repeat("( ", num_open_parenthesis)
    
    # Append the new structure to the accumulator, adding a newline for clarity.
    new_source_code_accumulator = new_source_code * open_parens_string * transformed_line * (isempty(stack_of_remaining_lines) ? "" : "\n")
    
    # 5. Set the new 'previousLineEnd' (numSpacesToRight) for the next call.
    next_previous_line_trailing_spaces = length(current_line) - length(rstrip(transformed_line))

    println("")
    println(current_line)
    println("next line trailing spaces: " * string(next_previous_line_trailing_spaces))
    
    # 6. Recurse.
    return process_lines_of_source_code(
        stack_of_remaining_lines, 
        new_source_code_accumulator, 
        next_previous_line_trailing_spaces
    )
end

# Wrapper function for a clean initial call and demonstration.
function processLinesOfSourceCode(lines::Vector{String}, initial_source_code::String, initial_end::Int)
    # Create a mutable copy of the input lines since pop! modifies it in place (LIFO stack behavior).
    stack_copy = copy(lines)
    
    println("--- Transformation Output: ---\n")
    result = process_lines_of_source_code(stack_copy, initial_source_code, initial_end)
    print(result)
    # open("result.txt", "w") do io
    #     print(io, result) # Writes "First line.\n"
    # end
    return result
end

# Example 1: Original prompt example (with no trailing spaces, so no parens are added)
println("Example 1: Original Prompt")
processLinesOfSourceCode([
    "hello |",
    "world /"
], "", 0)

# Example 2: Illustrating Trailing Space Logic
# Note: The processing is LIFO, so "Level 3" is processed first, compared to 0 trailing spaces.
sample_code_right_justified = [
    "Line 1: Level 1 |",       # 1 physical space + 1 brace = 2 effective spaces
    "Line 2: Level 2 |",  # 3 physical spaces + 1 brace = 4 effective spaces
    "Line 3: Level 3 /",   # 6 physical spaces + 0 brace = 6 effective spaces
               "Hi |  ",
            "Grant |  ",
                "+ /  ",
              "print /",
        "Hey grant sup",
                     "",
                "     ",
                "2 |  ",
                "3 |  ",
                "+ /  ",
                "2 |  ",
                "3 |  ",
                "+ /  ",
                  "+ /",
]

println("\nExample 2: Right-Justified Structure (Updated with Brace-as-Space Logic)")
res = processLinesOfSourceCode(sample_code_right_justified, "", 0)

solution = join([
  "( Line 1: Level 1  ",
    "Line 2: Level 2  ",
    "Line 3: Level 3 )",
           "( ( Hi    ",
            "Grant    ",
                "+ )  ",
              "print )",
            "( ( 2    ",
                "3    ",
                "+ )  ",
              "( 2    ",
                "3    ",
                "+ )  ",
                  "+ )",
], "\n")

# open("solution.txt", "w") do io
#     print(io, solution) # Writes "First line.\n"
# end

println(res == solution)
