### A Pluto.jl notebook ###
# v0.19.16

using Markdown
using InteractiveUtils

# ╔═╡ facd39d0-7497-11ed-198e-37bc7791a4eb
## Prompt

# Install Julia, then install Pluto (similar to jupyter notebooks for python or R-Studio for R).

# Create a notebook where you create a bioinformatics tool set including an infix operator-type function that takes strings representing DNA and a function name and runs the function with the string as the parameter.

# Infix operators work like the plus symbol in the statement 1 + 1 => +(1,1) => 2
# Another example is the times symbol in 3 * 2 => *(3,2) => 6.

# Yours should have a call signature like “string ▷ function”

# Please note the |> is a pipe command in Julia (not a ▷ unicode symbol). Tough they are serving the same purp

# You can go as far as you care with that notebook. We are interested in how clear and concise your code is, how easily you adapt to new tools. Submit the saved notebook file to a public github account and submit the url for review.

# ╔═╡ 02563e16-20cf-4333-aa76-d88898dc397c
"""
    string ▷ function  

Use the unicode character, ▷, as a pipe operator

### Examples
```julia-repl
julia> "bioinformatics" ▷ uppercase
"BIOINFORMATICS"

julia> "apple" ▷ length
5
```
See also [`complement`](@ref) [`reverse`](@ref) [`transcribe`](@ref) [`dsDNA`](@ref) [`uppercase`](@ref) [`length`](@ref)
"""
▷ = |>

# ╔═╡ bf9289df-d57e-47d6-9b86-a7230a487def
"""
    complement(sequence)
	sequence ▷ complement

Return the complement of a DNA sequence.

### Arguments
- `sequence`: string representing DNA.

### Notes
- Assuming the input sequence is conventional, i.e., 5'->3', the returned output will be 3'->5' from left to right.
- If non-DNA nucleotide characters are present, no results are returned and a warning is printed.
- Can be used with `reverse` to generate the reverse-complement of a sequence, if it contains an ORF on the reverse strand.
- Preserves letter case

### Examples
```julia-repl
julia> complement("gattaca")
"ctaatgt"

julia> "gattaca" ▷ complement
"ctaatgt"

julia> "gattaca" ▷ reverse ▷ complement
"tgtaatc"
```
See also [`▷`](@ref) [`reverse`](@ref) [`transcribe`](@ref) [`dsDNA`](@ref) 
"""
function complement(sequence)
	if !contains(sequence, r"[^atgcATGC]")
		sequence = replace(sequence, "a"=>"t", "t"=>"a", "g"=>"c", "c"=>"g", "A"=>"T", "T"=>"A", "G"=>"C", "C"=>"G")
		return sequence
	else
		print("Warning: Input contains unknown DNA nucleotides.")
	end
end

# ╔═╡ 19302051-e4e1-4f59-8c91-df6923f81c89
"""
    transcribe(sequence)
	sequence ▷ transcribe

Return the RNA transcript of a coding strand DNA sequence.

### Arguments
- `sequence`: string representing DNA.

### Notes
- Assuming the input sequence is conventional, i.e., 5'->3' coding strand, the resulting RNA sequence will be 5'->3' from left to right.
- If non-DNA nucleotide characters are present, no results are returned and a warning is printed.
- Preserves letter case

### Examples
```julia-repl
julia> transcribe("gattaca")
"gauuaca"

julia> "gattaca" ▷ transcribe
"gauuaca"
```
See also [`▷`](@ref) [`complement`](@ref) [`reverse`](@ref) [`dsDNA`](@ref)
"""
function transcribe(sequence)
	if !contains(sequence, r"[^atgcATGC]")
		sequence = replace(sequence, "t"=>"u", "T"=>"U")
		return sequence
	else
		print("Warning: Input contains unknown DNA nucleotides.")
	end
end

# ╔═╡ 26905b39-29f0-4f2f-aa7a-6e16ddd87640
"""
    dsDNA(sequence)
	sequence ▷ dsDNA

Returns plain text of a double stranded DNA sequence from a single strand input.

### Arguments
- `sequence`: string representing DNA.

### Notes
- Assuming the input sequence is conventional, i.e., 5'->3' coding strand, the resulting complementary sequence will be on the lower line, 3'->5' from left to right.
- If non-DNA nucleotide characters are present, no results are returned and a warning is printed.
- Preserves letter case

### Examples
```julia-repl
julia> dsDNA("gattaca")
gattaca
ctaatgt

julia> "gattaca" ▷ dsDNA
gattaca
ctaatgt
```
See also [`▷`](@ref) [`complement`](@ref) [`reverse`](@ref) [`transcribe`](@ref) [`Text`](@ref)
"""
function dsDNA(sequence)
	if !contains(sequence, r"[^atgcATGC]")
		upper = sequence 
		lower = sequence ▷ complement
		return (upper * "\n" * lower) ▷ Text
	else
		print("Warning: Input contains unknown DNA nucleotides.")
	end
end

# ╔═╡ b88f9a87-373b-4e2f-b0dc-7817d19d4550
# Demonstrations

# ╔═╡ 5cf61dde-41f1-4360-9634-cc54554c74cb
"atcgatGGGatctgac" ▷ complement

# ╔═╡ 9bd72c33-8917-4400-b123-cf18852b52e3
"atcgatGGGatctgac" ▷ reverse

# ╔═╡ 0868e215-4cde-4585-a197-15ce32f3675f
"atcgatGGGatctgac" ▷ reverse ▷ complement

# ╔═╡ 73da8ab5-cffd-4737-a0ab-aa43da066614
"atcgatGGGatctgac" ▷ transcribe

# ╔═╡ 2fd56d7b-8d11-421d-b371-9c3fcb9b9ce4
"atcgatGGGatctgac" ▷ dsDNA

# ╔═╡ 8612acd0-5cd6-4001-a0c0-124ff2d6e74e
 # Final notes

# I didn't have time to get into how to specify the input and return data types for the functions. The "sequence" variable could have be written as e.g. "sequence::AbstractString" to further specify the functions use.

# I didn't have time to build a translate function

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.3"
manifest_format = "2.0"
project_hash = "da39a3ee5e6b4b0d3255bfef95601890afd80709"

[deps]
"""

# ╔═╡ Cell order:
# ╠═facd39d0-7497-11ed-198e-37bc7791a4eb
# ╠═02563e16-20cf-4333-aa76-d88898dc397c
# ╠═bf9289df-d57e-47d6-9b86-a7230a487def
# ╠═19302051-e4e1-4f59-8c91-df6923f81c89
# ╠═26905b39-29f0-4f2f-aa7a-6e16ddd87640
# ╠═b88f9a87-373b-4e2f-b0dc-7817d19d4550
# ╠═5cf61dde-41f1-4360-9634-cc54554c74cb
# ╠═9bd72c33-8917-4400-b123-cf18852b52e3
# ╠═0868e215-4cde-4585-a197-15ce32f3675f
# ╠═73da8ab5-cffd-4737-a0ab-aa43da066614
# ╠═2fd56d7b-8d11-421d-b371-9c3fcb9b9ce4
# ╠═8612acd0-5cd6-4001-a0c0-124ff2d6e74e
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
