include("helpers.jl")

# Main Derivation
function deriveProgram(input::String, state::DerivationState) # accepts a string and a struct
    input = strip(input) # removes whitespace
    wakeCount = count("wake", input) # counts the number of 'wake'
    sleepCount = count("sleep", input) # counts the number of 'sleep'

    if isempty(input) # Empty String
        throw("Received no Instructions")
    elseif input == systemConstants.terminationCommand # terminates if system is the 'ABORT'
        println(colorize("Terminating Program...:", :white, :red))
        exit()
    elseif uppercase(input) == systemConstants.terminationCommand  # if user didn't capitalize 'ABORT'
        throw("Did you mean $(systemConstants.terminationCommand)?")
    elseif wakeCount != 1 || sleepCount != 1 # if user didn't include 'wake' or 'sleep' or if they included too many
        throw("The instructions should have exactly one 'wake' and one 'sleep'.")
    elseif !startswith(input, "wake") || !endswith(input, "sleep") # if it didn't start with 'wake' or end with 'sleep'
        throw("The instructions should start with 'wake' and end with 'sleep'.")
    end

    input = replace(replace(input, "wake" => ""), "sleep" => "") # replace 'wake' and 'sleep' with whitespace
    updateDerivationSteps(state) # updates Derivation Step
    return deriveAssignmentList(input, state) # furthers derivation
end


function deriveAssignmentList(input::AbstractString, state::DerivationState) # accepts an abstract string since Julia is picky when TypeChecking is involved, and the global struct Derivation State
    input = strip(input) # Strips input for safety
    semicolonCount = count(isequal(';'), input) # counts the delimeters
    assignmentsCount = length(state.validKeys) # count of valid assignments since it is an array, it counts the number of indexes of the array

    if isempty(input) && assignmentsCount > 0 # if there are no more valid assignments to derive
        return true
    elseif isempty(input) # if no assignments were entered
        throw("Enter instructions between wake and sleep")
    elseif semicolonCount < 1 && !isempty(input) # if assignments were not ended with a delimeter
        throw("No valid instructions found. Instructions must end with a ';'. Received: '$input'")
    elseif semicolonCount < 1 # if no assignments were made
        throw("No valid instructions found. Instructions must end with a ';'.")
    elseif semicolonCount == 1 && input == ";" #if the user only entered a delimeter
        throw("Instructions cannot be only ';'")
    elseif assignmentsCount > 3 # if user exceeded assignments
        throw("Maximum amount of buttons assigned. Cannot derive further.")
    end

    firstSemicolonIndex = findfirst(isequal(';'), input) # first semi-colon index to be used for splitting
    currentAssignment = strip(input[1:firstSemicolonIndex-1]) # extracts the beginning string until the delimter, and doesn't include delimeter
    remainingAssignments = strip(input[firstSemicolonIndex+1:end]) # extracts the remaining text without the first part

    # text to replace in the derivation
    if semicolonCount == 1 # if only one assignment,
        state.derivationGrammar = "[key-assignment]"
    else # if there are many assignments
        state.derivationGrammar = "[key-assignment]; [assignment-list]"
    end
    state.derivationReplaceGrammar = "[assignment-list]" # what to replace
    updateDerivationSteps(state) # updates the derivation output
    deriveKeyAssignments(currentAssignment, state) # derives this assignment further
    return deriveAssignmentList(remainingAssignments, state) # recursively loops through the remaining string
end

function deriveKeyAssignments(input::AbstractString, state::DerivationState)
    input = strip(input) # strips input for safety
    keyTokens = split(input, r"\s+") #splits the assignment by whitespace
    state.derivationGrammar = "key [key] = [command]" # correct grammar
    state.derivationReplaceGrammar = "[key-assignment]" # what to replace
    state.currentKeyAssignment = "" # initializes a new string for validation of this current key assignment

    if isempty(input) #if nothign was entered in betweem delimiter for safety
        throw("Expected a key assignment, received nothing")
    elseif keyTokens[1] != "key" || length(keyTokens) != 4 || keyTokens[3] != "=" # if it is not in the correct grammar format
        throw("Invalid assignment format in: $input. Expected 'key [key] = [command]'")
    end

    popat!(keyTokens, 3) # remove the '='
    popat!(keyTokens, 1) # remove the 'key'

    updateDerivationSteps(state) # updates derivation steps
    return deriveKey(keyTokens, state) # chains into deriving the key
end


function deriveKey(input, state::DerivationState)
    button = strip(popfirst!(input))
    if !in(button, systemConstants.keys) # if the key was not one of the expected results
        throw("Invalid value for [key]: $button. Expected one of: $(join(systemConstants.keys, ", "))")
    elseif in(button, state.assignedButtons) # if the botton has already been assigned
        throw("The key '$button' has already been assigned.")
    end
    push!(state.assignedButtons, button) # for simplification purposes, adds the assigned buttons to a separate array
    state.currentKeyAssignment *= "key $button " # for adding to the valid key assignment
    state.derivationGrammar = "$button" # derives the grammar
    state.derivationReplaceGrammar = "[key]" # will replace [key]
    updateDerivationSteps(state) # updates derivaiton Steps
    deriveCommand(input, state) #now goes onto processing the other half of the key assignment
end


function deriveCommand(input, state::DerivationState)
    command = strip(popfirst!(input)) # removes the command and empties the array
    if !in(command, systemConstants.commands) # if the command wasd not found
        throw("Invalid value for [command]: $command. Expected one of: $(join(systemConstants.commands, ", "))")
    end

    state.currentKeyAssignment *= "= $command" # completes the valid string
    push!(state.validKeys, state.currentKeyAssignment) # pushes this completed string into an array for use with other functions
    state.derivationGrammar = "$command" #updates the derivation
    state.derivationReplaceGrammar = "[command]" # to replace
    updateDerivationSteps(state) #updates steps
    return true # returns a true upon success
end
