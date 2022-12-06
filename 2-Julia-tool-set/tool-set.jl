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
See also [`complement`](@ref) [`reverse`](@ref) [`transcribe`](@ref) [`dsDNA`](@ref) [`uppercase`](@ref) [`length`](@ref) [`translate`](@ref)
"""
▷ = |>

# ╔═╡ ff5a022b-363e-46ae-bd5d-1c50676acaf5
"""
    isDNA(sequence)
	sequence ▷ isDNA

Tests if a string contains *only* DNA characters, i.e., a, t, c, g, A, T, C, G, returns a boolean value.

### Arguments
- `sequence`: a string representing DNA.

### Notes
- Takes upper case and lower case characters.
- Does not handle unidentified nucleotides (Ns)

### Examples
```julia-repl
julia> isDNA("gattaca")
true

julia> "gattaca" ▷ isDNA
true

julia> "cgaauuaca" ▷ isDNA
false
```
See also [`▷`](@ref) [`complement`](@ref) [`reverse`](@ref) [`transcribe`](@ref) [`dsDNA`](@ref) [`translate`](@ref)
"""
function isDNA(sequence)
	if contains(sequence, r"[^atgcATGC]")
		return false
	else 
		return true
	end
end

# ╔═╡ bf9289df-d57e-47d6-9b86-a7230a487def
"""
    complement(sequence)
	sequence ▷ complement

Return the complement of a DNA sequence.

### Arguments
- `sequence`: a string representing DNA.

### Notes
- Assuming the input sequence is conventional, i.e., 5'->3', the returned output will be 3'->5' from left to right.
- If non-DNA nucleotide characters are present, no results are returned, and a warning is printed.
- Can be used with `reverse` to generate the reverse complement of a sequence if it contains an ORF on the reverse strand.
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
See also [`▷`](@ref) [`isDNA`](@ref) [`reverse`](@ref) [`transcribe`](@ref) [`dsDNA`](@ref) [`translate`](@ref)
"""
function complement(sequence)
	if isDNA(sequence)
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
- `sequence`: a string representing DNA.

### Notes
- Assuming the input sequence is conventional, i.e., 5'->3' coding strand, the resulting RNA sequence will be 5'->3' from left to right.
- If non-DNA nucleotide characters are present, no results are returned, and a warning is printed.
- Preserves letter case

### Examples
```julia-repl
julia> transcribe("gattaca")
"gauuaca"

julia> "gattaca" ▷ transcribe
"gauuaca"
```
See also [`▷`](@ref) [`isDNA`](@ref) [`complement`](@ref) [`reverse`](@ref) [`dsDNA`](@ref) [`translate`](@ref)
"""
function transcribe(sequence)
	if isDNA(sequence)
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

Returns the double-stranded DNA sequence as plain text from a single-strand input.

### Arguments
- `sequence`: a string representing DNA.

### Notes
- Assuming the input sequence is conventional, i.e., 5'->3' coding strand, the resulting complementary sequence will be on the lower line, 3'->5' from left to right.
- If non-DNA nucleotide characters are present, no results are returned, and a warning is printed.
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
See also [`▷`](@ref) [`Text`](@ref) [`isDNA`](@ref) [`complement`](@ref) [`reverse`](@ref) [`transcribe`](@ref) [`translate`](@ref)
"""
function dsDNA(sequence)
	if isDNA(sequence)
		upper = sequence 
		lower = complement(sequence)
		return Text((upper * "\n" * lower))
	else
		print("Warning: Input contains unknown DNA nucleotides.")
	end
end

# ╔═╡ d4116a0b-1875-432b-a031-e924393b0224
"""
    sgc (standard genetic code)

Dictionary of RNA codons and their matching single letter amino acid counterparts.

Adapted from [wikipedia](https://en.wikipedia.org/wiki/DNA_and_RNA_codon_tables#cite_note-12).
### Usage
To be used in conjunction with [`translate`](@ref).
"""
sgc = Dict(
	"UUU"=>"F",
	"UUC"=>"F",
	"UUA"=>"L",
	"UUG"=>"L",
	"CUU"=>"L",
	"CUC"=>"L",
	"CUA"=>"L",
	"CUG"=>"L",
	"AUU"=>"I",
	"AUC"=>"I",
	"AUA"=>"I",
	"AUG"=>"M", # start codon
	"GUU"=>"V",
	"GUC"=>"V",
	"GUA"=>"V",
	"GUG"=>"V",
	"UCU"=>"S",
	"UCC"=>"S",
	"UCA"=>"S",
	"UCG"=>"S",
	"CCU"=>"P",
	"CCC"=>"P",
	"CCA"=>"P",
	"CCG"=>"P",
	"ACU"=>"T",
	"ACC"=>"T",
	"ACA"=>"T",
	"ACG"=>"T",
	"GCU"=>"A",
	"GCC"=>"A",
	"GCA"=>"A",
	"GCG"=>"A",
	"UAU"=>"Y",
	"UAC"=>"Y",
	"UAA"=>"_", # stop codon
	"UAG"=>"_", # stop codon
	"CAU"=>"H",
	"CAC"=>"H",
	"CAA"=>"Q",
	"CAG"=>"Q",
	"AAU"=>"N",
	"AAC"=>"N",
	"AAA"=>"K",
	"AAG"=>"K",
	"GAU"=>"D",
	"GAC"=>"D",
	"GAA"=>"E",
	"GAG"=>"E",
	"UGU"=>"C",
	"UGC"=>"C",
	"UGA"=>"_", # stop codon
	"UGG"=>"W",
	"CGU"=>"R",
	"CGC"=>"R",
	"CGA"=>"R",
	"CGG"=>"R",
	"AGU"=>"S",
	"AGC"=>"S",
	"AGA"=>"R",
	"AGG"=>"R",
	"GCU"=>"G",
	"GGC"=>"G",
	"GGA"=>"G",
	"GGG"=>"G")

# ╔═╡ 5b655dc1-c79d-40b7-b103-21f199edbdeb
"""
    translate(sequence)
	sequence ▷ translate

Returns the single-letter amino acid translation of a DNA sequence.

### Arguments
- `sequence`: a string representing DNA.

### Notes
- Assumes the input is a 5'->3' coding strand DNA. 
- Removes new line characters for simple FASTA copy and paste.
- Searches for the first occurring standard start codon (ATG), then begins translation.
- If no start codons are present, no results are returned, and a warning is printed.
- Stops translation at stop codons.
- If non-DNA nucleotide characters are present, no results are returned, and a warning is printed.

### Examples
```julia-repl
julia> translate("atggattacaggtga")
"MDYR"

julia> "atggattacaggtga" ▷ translate
"MDYR"
```
See also [`▷`](@ref) [`sgc`](@ref) [`isDNA`](@ref) [`complement`](@ref) [`reverse`](@ref) [`transcribe`](@ref) 
"""
function translate(sequence)
	sequence = replace(sequence, "\n" => "")
	if isDNA(sequence)
		sequence = uppercase(sequence)
		sequence = transcribe(sequence)
		if match(r"AUG.*", sequence) == nothing
			print("Standard start codon not found.")
		else
			protein = []
			orf = match(r"AUG.*", sequence)
			codons = collect(eachmatch(r"(.{3})", orf.match, overlap = false))
			for i in range(1, length((codons)))
				codon = codons[i]
				amino_acid = replace(codon.match, sgc...)
				push!(protein, amino_acid)
			end
			protein = join(protein)
			protein = replace(protein, r"_.*" => "") # remove AAs after stop codons
			return protein
		end
	else
		print("Warning: Input contains unknown DNA nucleotides.")
	end
end

# ╔═╡ b88f9a87-373b-4e2f-b0dc-7817d19d4550
# Demo
sequence = "atcgatGGGatctgac"

# ╔═╡ ab4f87c6-a679-45a5-9f09-f58dbc14bcd9
sequence ▷ isDNA

# ╔═╡ 5cf61dde-41f1-4360-9634-cc54554c74cb
sequence ▷ complement

# ╔═╡ 9bd72c33-8917-4400-b123-cf18852b52e3
sequence ▷ reverse

# ╔═╡ 0868e215-4cde-4585-a197-15ce32f3675f
sequence ▷ reverse ▷ complement

# ╔═╡ 73da8ab5-cffd-4737-a0ab-aa43da066614
sequence ▷ transcribe

# ╔═╡ 2fd56d7b-8d11-421d-b371-9c3fcb9b9ce4
sequence ▷ dsDNA

# ╔═╡ 1be59bdf-82ac-48c5-999a-fb614ad9fccf
sequence ▷ translate

# ╔═╡ e955f658-dd39-4c79-8e4b-47d85b2eab2c
# Real-world demo

# Sequence of human insulin from https://www.ncbi.nlm.nih.gov/nuccore/NC_000011.10?report=fasta&from=2159779&to=2161209&strand=true

begin
	insulin =
	"""
	AGCCCTCCAGGACAGGCTGCATCAGAAGAGGCCATCAAGCAGGTCTGTTCCAAGGGCCTTTGCGTCAGGT
	GGGCTCAGGATTCCAGGGTGGCTGGACCCCAGGCCCCAGCTCTGCAGCAGGGAGGACGTGGCTGGGCTCG
	TGAAGCATGTGGGGGTGAGCCCAGGGGCCCCAAGGCAGGGCACCTGGCCTTCAGCCTGCCTCAGCCCTGC
	CTGTCTCCCAGATCACTGTCCTTCTGCCATGGCCCTGTGGATGCGCCTCCTGCCCCTGCTGGCGCTGCTG
	GCCCTCTGGGGACCTGACCCAGCCGCAGCCTTTGTGAACCAACACCTGTGCGGCTCACACCTGGTGGAAG
	CTCTCTACCTAGTGTGCGGGGAACGAGGCTTCTTCTACACACCCAAGACCCGCCGGGAGGCAGAGGACCT
	GCAGGGTGAGCCAACTGCCCATTGCTGCCCCTGGCCGCCCCCAGCCACCCCCTGCTCCTGGCGCTCCCAC
	CCAGCATGGGCAGAAGGGGGCAGGAGGCTGCCACCCAGCAGGGGGTCAGGTGCACTTTTTTAAAAAGAAG
	TTCTCTTGGTCACGTCCTAAAAGTGACCAGCTCCCTGTGGCCCAGTCAGAATCTCAGCCTGAGGACGGTG
	TTGGCTTCGGCAGCCCCGAGATACATCAGAGGGTGGGCACGCTCCTCCCTCCACTCGCCCCTCAAACAAA
	TGCCCCGCAGCCCATTTCTCCACCCTCATTTGATGACCGCAGATTCAAGTGTTTTGTTAAGTAAAGTCCT
	GGGTGACCTGGGGTCACAGGGTGCCCCACGCTGCCTGCCTCTGGGCGAACACCCCATCACGCCCGGAGGA
	GGGCGTGGCTGCCTGCCTGAGTGGGCCAGACCCCTGTCGCCAGGCCTCACGGCAGCTCCATAGTCAGGAG
	ATGGGGAAGATGCTGGGGACAGGCCCTGGGGAGAAGTACTGGGATCACCTGTTCAGGCTCCCACTGTGAC
	GCTGCCCCGGGGCGGGGGAAGGAGGTGGGACATGTGGGCGTTGGGGCCTGTAGGTCCACACCCAGTGTGG
	GTGACCCTCCCTCTAACCTGGGTCCAGCCCGGCTGGAGATGGGTGGGAGTGCGACCTAGGGCTGGCGGGC
	AGGCGGGCACTGTGTCTCCCTGACTGTGTCCTCCTGTGTCCCTCTGCCTCGCCGCTGTTCCGGAACCTGC
	TCTGCGCGGCACGTCCTGGCAGTGGGGCAGGTGGAGCTGGGCGGGGGCCCTGGTGCAGGCAGCCTGCAGC
	CCTTGGCCCTGGAGGGGTCCCTGCAGAAGCGTGGCATTGTGGAACAATGCTGTACCAGCATCTGCTCCCT
	CTACCAGCTGGAGAACTACTGCAACTAGACGCAGCCCGCAGGCAGCCCCACACCCGCCGCCTCCTGCACC
	GAGAGAGATGGAATAAAGCCCTTGAACCAGC
	""" 
	insulin ▷ translate
end

# Returns a surprisingly short output. But this translate function is designed to find the first standard start codon and the first stop codon after that. It will not be able to find the open reading frame that generates the longest or most accurate translation. So this function isn't very biologically relevant and would need further optimization for actual use.

# If you plug this insulin sequence into https://web.expasy.org/translate/, the "Frame 3" result that is returned is the same result as this.

# ╔═╡ 8612acd0-5cd6-4001-a0c0-124ff2d6e74e
# Final thoughts

# I chose not to use the reassigned pipe character "▷" within functions for consistency with the formatting of most Base functions. But I believe most of the function steps here could also use ▷ pipes for easier readability.

# I could imagine a direct translate function, without searching for a start codon, would also have utility. This would just require some simple editing of the function above.

# I didn't have time to get into how to specify the input and return data types for the functions. The "sequence" variable could have been written as, e.g., "sequence::AbstractString" to further specify the function's use case.

# For sure, there is a better way to store  access the dictionary of codon-amino acid pairs, but I also thought that is outside the scope of the prompt.

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
# ╠═ff5a022b-363e-46ae-bd5d-1c50676acaf5
# ╠═bf9289df-d57e-47d6-9b86-a7230a487def
# ╠═19302051-e4e1-4f59-8c91-df6923f81c89
# ╠═26905b39-29f0-4f2f-aa7a-6e16ddd87640
# ╠═d4116a0b-1875-432b-a031-e924393b0224
# ╠═5b655dc1-c79d-40b7-b103-21f199edbdeb
# ╠═b88f9a87-373b-4e2f-b0dc-7817d19d4550
# ╠═ab4f87c6-a679-45a5-9f09-f58dbc14bcd9
# ╠═5cf61dde-41f1-4360-9634-cc54554c74cb
# ╠═9bd72c33-8917-4400-b123-cf18852b52e3
# ╠═0868e215-4cde-4585-a197-15ce32f3675f
# ╠═73da8ab5-cffd-4737-a0ab-aa43da066614
# ╠═2fd56d7b-8d11-421d-b371-9c3fcb9b9ce4
# ╠═1be59bdf-82ac-48c5-999a-fb614ad9fccf
# ╠═e955f658-dd39-4c79-8e4b-47d85b2eab2c
# ╠═8612acd0-5cd6-4001-a0c0-124ff2d6e74e
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
