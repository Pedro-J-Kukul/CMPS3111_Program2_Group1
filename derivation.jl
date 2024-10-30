include("helpers.jl")
function deriveProgram(input::String, state::DerivationState)
    input = strip(input)
    wakeCount = count("wake", input)
    sleepCount = count("sleep", input)
    state.derivationGrammar = "wake [assignments] sleep"
    state.derivationReplaceGrammar = ""

    if isempty(input)
        throw("Received no Instructions")
    elseif input == systemConstants.terminationCommand
        println(colorize("Terminating Program...:", :white, :red))
        exit()
    elseif uppercase(input) == systemConstants.terminationCommand
        throw("Did you mean $(systemConstants.terminationCommand)?")
    elseif wakeCount != 1 || sleepCount != 1
        throw("The instructions should have exactly one 'wake' and one 'sleep'.")
    elseif !startswith(input, "wake") || !endswith(input, "sleep")
        throw("The instructions should start with 'wake' and end with 'sleep'.")
    end

    input = replace(replace(input, "wake" => ""), "sleep" => "")
    if isempty(input)
        throw("Enter instructions between wake and sleep")
    end

    updateDerivationSteps(state)
    return deriveAssignmentList(input, state)
end


function deriveAssignmentList(input::AbstractString, state::DerivationState)
    input = strip(input)
    semicolonCount = count(isequal(';'), input)

    if isempty(input) && state.assignmentsCount > 1
        return true
    elseif semicolonCount < 1
        throw("No valid instructions found. Instructions must end with a ';'.")
    elseif semicolonCount == 1 && input == ";"
        throw("Instructions cannot be only ';'")
    elseif state.assignmentsCount > 4
        throw("Maximum amount of buttons assigned. Cannot derive further.")
    end

    firstSemicolonIndex = findfirst(isequal(';'), input)
    currentAssignment = strip(input[1:firstSemicolonIndex-1])
    remainingAssignments = strip(input[firstSemicolonIndex+1:end])

    if semicolonCount == 1
        state.derivationGrammar = "[key-assign]"
    else
        state.derivationGrammar = "[key-assign]; [assignments]"
    end
    state.derivationReplaceGrammar = "[assignments]"
    updateDerivationSteps(state)
    state.assignmentsCount += 1
    deriveKeyAssignments(currentAssignment, state)
    return deriveAssignmentList(remainingAssignments, state)
end

function deriveKeyAssignments(input::AbstractString, state::DerivationState)
    input = strip(input)
    keyTokens = split(input, r"\s+")
    state.derivationGrammar = "key [key] = [command]"
    state.derivationReplaceGrammar = "[key-assign]"
    state.currentKeyAssignment = ""

    if isempty(input)
        throw("Expected a key assignment, received nothing")
    elseif keyTokens[1] != "key" || length(keyTokens) != 4 || keyTokens[3] != "="
        throw("Invalid assignment format in: $input. Expected 'key [key] = [command]'")
    end

    popat!(keyTokens, 3)
    popat!(keyTokens, 1)

    updateDerivationSteps(state)
    return deriveKey(keyTokens, state)
end


function deriveKey(input, state::DerivationState)
    button = strip(popfirst!(input))
    if !in(button, systemConstants.keys)
        throw("Invalid value for [key]: $button. Expected one of: $(join(systemConstants.keys, ", "))")
    elseif in(button, state.assignedButtons)
        throw("The key '$button' has already been assigned.")
    end
    push!(state.assignedButtons, button)
    state.currentKeyAssignment *= "key $button "
    state.derivationGrammar = "$button"
    state.derivationReplaceGrammar = "[key]"
    updateDerivationSteps(state)
    deriveCommand(input, state)
end


function deriveCommand(input, state::DerivationState)
    command = strip(popfirst!(input))
    if !in(command, systemConstants.commands)
        throw("Invalid value for [command]: $command. Expected one of: $(join(systemConstants.commands, ", "))")
    end

    state.currentKeyAssignment *= "= $command"
    push!(state.validKeys, state.currentKeyAssignment)
    state.derivationGrammar = "$command"
    state.derivationReplaceGrammar = "[command]"
    updateDerivationSteps(state)
    return true
end
