include("derivation.jl")
include("parsing_tree.jl")
function main()
    while true
        try
            displayGrammar()
            print(colorize("Enter Instructions: ", :blue, :white))
            aids = readline()
            if deriveProgram(aids)
                parseTree(aids)
            end
        catch e
            println(colorize("Error: $e", :white, :red))
        end
    end
end

main()