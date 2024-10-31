include("definitions.jl")

function parseTree(state::DerivationState)
    border = colorize("#", :magenta, :yellow)^150 # line specifications

    print(colorize("Press Enter to continue...", :blue, :green))
    readline()
    println(border) # border
    assignments = state.validKeys
    program = colorize("[program]", :red, :none)
    assignment = colorize("[assignments-list]", :blue, :none)
    keyAssignment = colorize("[key-assignments]", :magenta, :none)
    keyCommand = colorize("key [key] = [command];", :green, :none)

    if length(assignments) == 1
        # tokens will be in key [key] = [drive]
        tokens1 = split(assignments[1], r"\s+")
        println("\t\t\t\t\t\t\t    $program")
        println("\t\t\t\t/\t\t\t\t|\t\t\t\t\\")
        println("\t\t\t    wake\t\t\t$assignment\t\t\tsleep")
        println("\t\t\t\t\t\t\t/")
        println("\t\t\t\t\t$keyAssignment")
        println("\t\t\t\t\t      /")
        println("\t\t\t\t$keyCommand")
        println("\t\t\t\t      |\t\t|")
        println("\t\t\t\t      $(tokens1[2])\t      $(tokens1[4])")

    elseif length(assignments) == 2
        tokens1 = split(assignments[1], r"\s+")
        tokens2 = split(assignments[2], r"\s+")
        println("\t\t\t\t\t\t\t    $program")
        println("\t\t\t\t/\t\t\t\t|\t\t\t\t\\")
        println("\t\t\t    wake\t\t\t$assignment\t\t\tsleep")
        println("\t\t\t\t\t\t\t/\t\t\\")
        println("\t\t\t\t\t$keyAssignment\t\t$assignment")
        println("\t\t\t\t\t      /\t\t\t\t/")
        println("\t\t\t\t$keyCommand\t\t$keyAssignment")
        println("\t\t\t\t      |\t\t|\t\t\t|")
        println("\t\t\t\t      $(tokens1[2])\t      $(tokens1[4])\t\t$keyCommand")
        println("\t\t\t\t\t\t\t\t      |\t\t|")
        println("\t\t\t\t\t\t\t\t      $(tokens2[2])\t      $(tokens2[4])")

    elseif length(assignments) == 3
        tokens1 = split(assignments[1], r"\s+")
        tokens2 = split(assignments[2], r"\s+")
        tokens3 = split(assignments[3], r"\s+")
        println("\t\t\t\t\t\t\t    $program")
        println("\t\t\t\t/\t\t\t\t|\t\t\t\t\\")
        println("\t\t\t    wake\t\t\t$assignment\t\t\tsleep")
        println("\t\t\t\t\t\t\t/\t\t\\")
        println("\t\t\t\t\t$keyAssignment\t\t$assignment")
        println("\t\t\t\t\t      /\t\t\t\t/\t\t\t\\")
        println("\t\t\t\t$keyCommand\t\t$keyAssignment\t\t$assignment")
        println("\t\t\t\t      |\t\t|\t\t\t|\t\t\t\t|")
        println("\t\t\t\t      $(tokens1[2])\t      $(tokens1[4])\t\t$keyCommand\t\t$keyAssignment")
        println("\t\t\t\t\t\t\t\t      |\t\t|\t\t\t|")
        println("\t\t\t\t\t\t\t\t      $(tokens2[2])\t      $(tokens2[4])\t\t$keyCommand")
        println("\t\t\t\t\t\t\t\t\t\t\t\t      |\t\t|")
        println("\t\t\t\t\t\t\t\t\t\t\t\t      $(tokens3[2])\t      $(tokens3[4])")

    elseif length(assignments) == 4
        tokens1 = split(assignments[1], r"\s+")
        tokens2 = split(assignments[2], r"\s+")
        tokens3 = split(assignments[3], r"\s+")
        tokens4 = split(assignments[4], r"\s+")

        # Print the modified structure
        println("\t\t\t\t\t\t\t    $program")
        println("\t\t\t\t/\t\t\t\t|\t\t\t\t\\")
        println("\t\t\t    wake\t\t\t$assignment\t\t\tsleep")
        println("\t\t\t\t\t\t\t/\t\t\\")
        println("\t\t\t\t\t$keyAssignment\t\t$assignment")
        println("\t\t\t\t\t      /\t\t\t\t/\t\t\t\\")
        println("\t\t\t\t$keyCommand\t\t$keyAssignment\t\t$assignment")
        println("\t\t\t\t      |\t\t|\t\t\t|\t\t\t\t|\t\t\\")
        println("\t\t\t\t      $(tokens1[2])\t      $(tokens1[4])\t\t$keyCommand\t\t$keyAssignment\t$assignment")
        println("\t\t\t\t\t\t\t\t      |\t\t|\t\t\t|\t\t\t\t\\")
        println("\t\t\t\t\t\t\t\t      $(tokens2[2])\t      $(tokens2[4])\t\t$keyCommand\t\t$keyAssignment")
        println("\t\t\t\t\t\t\t\t\t\t\t\t      |\t\t|\t\t\t\\")
        println("\t\t\t\t\t\t\t\t\t\t\t\t      $(tokens3[2])\t      $(tokens3[4])\t\t$keyCommand")
        println("\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t      |\t\t|")
        println("\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t      $(tokens4[2])\t      $(tokens4[4])")
    end
end