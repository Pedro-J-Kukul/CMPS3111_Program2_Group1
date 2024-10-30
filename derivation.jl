include("helper_functions.jl")

# Rename to something better
function deriveProgram(input::String)
    global terminationCommand
    resetGlobals()

    input = strip(input)
    wakeCount = count("wake", input)
    sleepCount = count("sleep", input)

    if isempty(input) # if empty
        throw("Expected Instructions; Received null")
    elseif uppercase(input) == terminationCommand && userInput != terminationCommand # if almost 'ABORT'
        throw("Did you mean $terminationCommand?")
    elseif input == terminationCommand # if 'ABORT'
        println(colorize("Terminating Program...:", :white, :red))
        exit()
    elseif wakeCount < 1 # if no 'wake' 
        throw("'wake' must be included.")
    elseif sleepCount < 1 # if no 'sleep'
        throw("'sleep' must be included.")
    elseif wakeCount > 1 || sleepCount > 1 # if too many 'wake' or sleep'
        throw("The input should have exactly one 'wake' and one 'sleep'.")
    elseif !startswith(input, "wake") # if not start with 'wake'
        throw("The input string should start with 'wake'.")
    elseif !endswith(input, "sleep") # if not end with 'sleep'
        throw("The input string should end with 'sleep'.")
    end

    input = replace(input, "wake" => "")
    input = replace(input, "sleep" => "")



    if isempty(input)
        throw("Enter instructions")
    end
    updateDerivationSteps!("wake [assignments] sleep", "")

    return deriveAssignmentList(input)
end



function deriveAssignmentList(input::AbstractString)
    global assignmentsCount

    input = strip(input)
    semicolonCount = count(isequal(';'), input)

    if semicolonCount < 1
        throw("No valid instructions found. Instructions must end with a ';'.")
    end

    firstSemicolonIndex = findfirst(isequal(';'), input)
    currentAssignment = strip(input[1:firstSemicolonIndex-1])
    remainingAssignments = strip(input[firstSemicolonIndex+1:end])

    if assignmentsCount > 4
        throw("Maximum amount of buttons assigned. Cannot derive further: $remainingAssignments")
    end

    if semicolonCount == 1
        updateDerivationSteps!("[assignments]", "[key-assign];")
    else
        updateDerivationSteps!("[assignments]", "[key-assign]; [assignments]")
    end

    assignmentsCount += 1
    deriveKeyAssignments(currentAssignment)

    if semicolonCount > 1
        return deriveAssignmentList(remainingAssignments)
    elseif !isempty(remainingAssignments)
        throw("Invalid Instructions: Extra content after final ';':  $remainingAssignments''.")
    end

    return true
end

function deriveKeyAssignments(input::AbstractString)
    global assignedKeys

    input = strip(input)
    keyTokens = split(input, " ")

    if isempty(input)
        throw("Expected assignment, received nothing")
    elseif keyTokens[1] != "key"
        throw("Expected 'key', received $(keyTokens[1]) at $input")
    elseif keyTokens[3] != "="
        throw("Expected '=', received $(keyTokens[3]) at $input")
    elseif length(keyTokens) != 4
        throw("Expected exactly four words, received $(length(keyTokens)), $input")
    end

    push!(assignedKeys, input)
    updateDerivationSteps!("[key-assign]", "key [key] = [command]")
    deriveKey(keyTokens[2])
    deriveCommand(keyTokens[4])
    return true
end

function deriveKey(input::AbstractString)
    global keys, assignedKeys
    input = strip(input)
    if !in(input, keys)
        throw("Invalid value for [key] $input. Expected one of: $(join(keys, ", "))")
    end

    for key in assignedKeys
        if occursin(input, key) > 1
            throw("The key '$input' has already been assigned.")
        end
    end


    updateDerivationSteps!("[key]", "$input")
    return true
end

function deriveCommand(input::AbstractString)
    global commands
    input = strip(input)
    if !in(input, commands)
        throw("Invalid value for [command]: $input. Expected one of: $(join(commands, ", "))")
    end
    updateDerivationSteps!("[command]", "$input")
    return true
end

# chain command later it works ``

