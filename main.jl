include("derivation.jl")
include("helpers.jl")
function main()
    while true
        try
            state = resetState()
            displayGrammar()
            print(colorize("Enter Instructions: ", :blue, :white))
            aids = readline()
            deriveProgram(aids, state)

        catch e
            println(colorize("Error: $e", :white, :red))
        end
    end
end

main()