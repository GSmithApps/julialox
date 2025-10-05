"""
Recursively processes lines of code from a vector based on trailing space difference.

The logic compares the trailing spaces of the current line to the previous line.
An increase in trailing spaces (assumed 2 spaces per level) is converted into
leading opening parentheses. The first '/' is replaced with a ')'.
"""
function process_lines_of_source_code(
    vector_of_remaining_lines::Vector{String},
    new_source_code::String,
    previous_line_leading_spaces::Int
)::String

    # Base Case
    if isempty(vector_of_remaining_lines)
        return new_source_code
    end

    current_line = popfirst!(vector_of_remaining_lines)

    if strip(current_line) == "" || last(lstrip(current_line))  ∉ ['|']
        return process_lines_of_source_code(vector_of_remaining_lines, new_source_code, previous_line_leading_spaces)
    end

    current_line_leading_spaces = length(current_line) - length(lstrip(current_line))
    
    # good til here

    leading_space_decrease = previous_line_leading_spaces - current_line_leading_spaces

    # Calculate the number of structure-opening parentheses, assuming 2 spaces per step.
    num_close_parenthesis = max(0, floor(Int, leading_space_decrease / 2))

    # 3. Transform the line content.
    # Replace the first occurrence of "/" with ")" and "|"with " "
    if last(rstrip(current_line)) == '/'
        transformed_line = replace(current_line, "/" => ")", count=1)
    else
        transformed_line = replace(current_line, "|" => " ", count=1)
    end

    # 4. Accumulate the new source code (newSourceCode).
    open_parens_string = repeat("( ", num_close_parenthesis)

    # Append the new structure to the accumulator, adding a newline for clarity.
    new_source_code_accumulator = new_source_code * open_parens_string * transformed_line * (isempty(vector_of_remaining_lines) ? "" : "\n")

    # previous line leading spaces needs to be calculated based on the "/"

    # 6. Recurse.
    return process_lines_of_source_code(
        vector_of_remaining_lines,
        new_source_code_accumulator,
        current_line_leading_spaces
    )
end

# Wrapper function for a clean initial call and demonstration.
function processLinesOfSourceCode(lines::Vector{String})
    stack_copy = copy(lines)

    println("--- Transformation Output: ---\n")
    result = process_lines_of_source_code(stack_copy, "", -2)
    println(result)
    return result
end

function processSourceCode(sourceCode::String)
    sourceCodeLines = split(sourceCode, "\n")

    return processLinesOfSourceCode(map(String, sourceCodeLines))

end


"""
| / defun
  | / factorial n
  | / if
    | / <= n 1
    | 1
    | / *
      | n
      | / factorial
        | / - n 1

| / print
  | "hi"

| / print
  | / + "hi" "grant"

"""


