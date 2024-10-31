include("derivation.jl")
include("helpers.jl")
include("pbasic.jl")
include("parsing_tree.jl")

function main()
    while true
        try
            state = resetState()
            displayGrammar()
            print(colorize("Enter Instructions: ", :blue, :green))
            aids = readline()
            if deriveProgram(aids, state)
                parseTree(state)
                generatePBASIC(state)
            end
        catch e
            println(colorize("Error: $e", :white, :red))
        end
    end
end

main()