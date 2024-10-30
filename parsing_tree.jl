# Function to print the top part of the parse tree
function topPart()
    top = ["[program]", "wake", "[assignments]", "sleep"]
    println("                             $(top[1])")
    println("                       /          |        \\     ")
    println("                    $(top[2])   $(top[3])  $(top[4])")
    println("                             /        \\")
end

# Function to print the parse tree based on verified input
function parseTree(input::AbstractString)
    # Splitting by semicolons to identify key assignments
    inputF = split(input, ";")
    inputF = strip.(inputF)  # Strip whitespace from each element

    # Identify the key assignments between 'wake' and 'sleep'
    numAssignments = length(inputF) - 2  # Exclude 'wake' and 'sleep'

    # Define top part structure
    top = ["[program]", "wake", "[assignments]", "sleep", "[key-assign]", "[x]", "[y]"]

    if numAssignments == 1
        # Tree for 1 key
        println("                    $(top[1])")
        println("             /           |        \\      ")
        println("           $(top[2])   $(top[3])  $(top[4])")
        println("                         |")
        println("                    $(top[5])")
        println("                        /    \\      ")
        println("                  key $(top[6]) = $(top[7])")

        # Extract key assignment details
        assignment = split(inputF[2])  # second element after 'wake'
        println("                       |     |")
        println("                       $(assignment[2])   $(chop(assignment[4]))")

    elseif numAssignments == 2
        # Tree for 2 keys
        topPart()
        println("                     $(top[5]) ; $(top[3])")
        println("                         /   \\           \\")
        println("                   key $(top[6]) = $(top[7])      $(top[5]) ")
        println("                        |     |          /   \\")

        # Extract first key assignment details
        assignment1 = split(inputF[2])
        println("                        $(assignment1[2])   $(chop(assignment1[4]))   key $(top[6]) = $(top[7])")

        # Extract second key assignment details
        assignment2 = split(inputF[3])
        println("                                        |     |")
        println("                                        $(assignment2[2])    $(chop(assignment2[4]))  ")

    elseif numAssignments == 3
        # Tree for 3 keys
        topPart()
        println("                     $(top[5]) ; $(top[3])")
        println("                        /   \\                /     \\")
        println("                  key $(top[6]) = $(top[7])      $(top[5]) ; $(top[3]) ")
        println("                       |     |           /   \\             \\")

        # Extract first key assignment details
        assignment1 = split(inputF[2])
        println("                       $(assignment1[2])   $(chop(assignment1[4]))   key $(top[6]) = $(top[7])      $(top[5])")

        # Extract second key assignment details
        assignment2 = split(inputF[3])
        println("                                        |    |            /   \\")
        println("                                        $(assignment2[2])   $(chop(assignment2[4]))    key $(top[6]) = $(top[7])")

        # Extract third key assignment details
        assignment3 = split(inputF[4])
        println("                                                         |     |")
        println("                                                         $(assignment3[2])    $(chop(assignment3[4])) ")

    elseif numAssignments == 4
        # Tree for 4 keys
        topPart()
        println("                    $(top[5])  ;  $(top[3])")
        println("                        /   \\               /     \\")
        println("                  key $(top[6]) = $(top[7])    $(top[5])  ;  $(top[3]) ")
        println("                       |     |           /   \\         /        \\")

        # Extract first key assignment details
        assignment1 = split(inputF[2])
        println("                       $(assignment1[2])   $(chop(assignment1[4]))   key $(top[6]) = $(top[7])  $(top[5]) ; $(top[3]) ")

        # Extract second key assignment details
        assignment2 = split(inputF[3])
        println("                                        |     |         /   \\           \\")
        println("                                        $(assignment2[2])   $(chop(assignment2[4]))  key $(top[6]) = $(top[7])      $(top[5])")

        # Extract third key assignment details
        assignment3 = split(inputF[4])
        println("                                                       |     |           /    \\")
        println("                                                       $(assignment3[2])    $(chop(assignment3[4]))   key $(top[6]) = $(top[7])")

        # Extract fourth key assignment details
        assignment4 = split(inputF[5])
        println("                                                                        |     |")
        println("                                                                        $(assignment4[2])    $(chop(assignment4[4]))")
    end
end
