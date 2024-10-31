function parseTree(state::DerivationState)
    assignments = state.validKeys
    if length(assignments) == 1
        # tokens will be in key [key] = [drive]
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
        println(tree)

    elseif length(assignments) == 2
        tokens1 = split(assignments[1], r"\s+")
        tokens2 = split(assignments[2], r"\s+")
        tree = """
                                         [program]
                                     /       |       \\
                               wake   [assignment-list]   sleep
                                 /                       |
                    [key-assignment]                   [assignment-list]
                 /                     \\                 |
              key [key] = [command]          [key-assignment]
                   /        \\                     |
               $(tokens1[2])      [command]       key [key] = [command]
                               \\                  /         \\
                              $(tokens1[4])   $(tokens2[2])     $(tokens2[4])
               """
        println(tree)

    elseif length(assignments) == 3
        tokens1 = split(assignments[1], r"\s+")
        tokens2 = split(assignments[2], r"\s+")
        tokens3 = split(assignments[3], r"\s+")
        tree = """
                                [program]
                           /         |         \\
                     wake    [assignment-list]    sleep
                                /                   |
                    [key-assignment]           [assignment-list]
                 /           |                  /           |
          key [key] = [command]        [key-assignment]     [key-assignment]
               /         \\              |                 |
          $(tokens1[2])   [command]   key [key] = [command]  key [key] = [command]
                        \\              /       \\           /         \\
                       $(tokens1[4]) $(tokens2[2]) $(tokens2[4]) $(tokens3[2]) $(tokens3[4])
               """
        println(tree)

    elseif length(assignments) == 4
        tokens1 = split(assignments[1], r"\s+")
        tokens2 = split(assignments[2], r"\s+")
        tokens3 = split(assignments[3], r"\s+")
        tokens4 = split(assignments[4], r"\s+")
        tree = """
                                [program]
                           /         |         \\
                     wake    [assignment-list]    sleep
                               /                        |
                    [key-assignment]             [assignment-list]
                 /           |                    /            |
          key [key] = [command]           [key-assignment]     [key-assignment]
               /         \\                   |                    |
          $(tokens1[2])   [command]     key [key] = [command]   key [key] = [command]
                        \\                  /       \\              |
                       $(tokens1[4]) $(tokens2[2]) $(tokens2[4])    [key-assignment]
                                                       /       \\      |
                                                $(tokens3[2]) $(tokens3[4]) key $(tokens4[2]) = $(tokens4[4])
                                                               /       \\
                                                     $(tokens4[2]) $(tokens4[4])
               """
        println(tree)
    end
end
