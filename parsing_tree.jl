function parseTree(state::DerivationState)
    assignments = state.validKeys
    if length(assignments) == 1

        # tokens will be in key [key] = [drive]
        # use a dummy array for testi
        tokens = split(assignments[1], r"\s+")
        tree = """
                                          [program]
                                      /       |       \\
                                 wake   [assignment-list]   sleep
                                              |
                                       [key-assignment]
                                              |
                                     key [key] = [command]
                                            /        \\
                                           $(tokens[2])      [command]
                                                       \\
                                                        $(tokens[4])
               """
    elseif length(assignments) == 2
        tokens1 = split(assignments[1], r"\s+")
        tree = """
                                          [program]
                                      /       |       \\
                                 wake   [assignment-list]   sleep
                                    /                       |
                       [key-assignment]                   [assignment-list]
                    /                     \\
                     key [key] = [command]
                            /        \\
                           $(tokens[2])      [command]
                                       \\
                                        $(tokens[4])
               """

    elseif length(assignments) == 3
        # Parse tree for 3 assignments
        tokens1 = split(assignments[1], r"\s+")
        tokens2 = split(assignments[2], r"\s+")
        tokens3 = split(assignments[3], r"\s+")
        println("                     [key-assign] ; [assignments]")
        println("                         /    \\               /    \\")
        println("                    key $(tokens1[2]) = $(tokens1[4])   [key-assign] ; [assignments]")
        println("                       /    \\               /    \\          |")
        println("                    $(tokens1[2]) $(tokens1[4])    key $(tokens2[2]) = $(tokens2[4])   [key-assign]")
        println("                                             /    \\           /     \\")
        println("                                        $(tokens2[2]) $(tokens2[4])    key $(tokens3[2]) = $(tokens3[4])")
        println("                                                              /     \\")
        println("                                                         $(tokens3[2]) $(tokens3[4])")

    elseif length(assignments) == 4
        # Parse tree for 4 assignments
        tokens1 = split(assignments[1], r"\s+")
        tokens2 = split(assignments[2], r"\s+")
        tokens3 = split(assignments[3], r"\s+")
        tokens4 = split(assignments[4], r"\s+")
        println("                     [key-assign] ; [assignments]")
        println("                         /    \\               /    \\")
        println("                    key $(tokens1[2]) = $(tokens1[4])   [key-assign] ; [assignments]")
        println("                       /    \\               /    \\          /     \\")
        println("                    $(tokens1[2]) $(tokens1[4])    key $(tokens2[2]) = $(tokens2[4])   [key-assign] ; [assignments]")
        println("                                             /    \\          /    \\            |")
        println("                                        $(tokens2[2]) $(tokens2[4])   key $(tokens3[2]) = $(tokens3[4])   [key-assign]")
        println("                                                              /    \\           /     \\")
        println("                                                         $(tokens3[2]) $(tokens3[4])   key $(tokens4[2]) = $(tokens4[4])")
        println("                                                                            /     \\")
        println("                                                                       $(tokens4[2]) $(tokens4[4])")
    end
end
