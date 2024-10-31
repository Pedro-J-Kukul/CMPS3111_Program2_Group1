include("definitions.jl")

# Colors a string
function colorize(text::String, fgColor::Symbol, bgColor::Symbol)
    fgColorValue = getfield(systemConstants.foreground, Symbol(fgColor)) # gets the foreground colors that matches the symbol
    bgColorValue = getfield(systemConstants.background, Symbol(bgColor)) # gets the background colors that matches the symbol
    return string(bgColorValue, fgColorValue, text, systemConstants.foreground.reset, systemConstants.background.reset)
end

# Adds padding to an Set
function format_rule(rule::Vector{String}, paddingLengths::Vector{Integer})
    return join([rpad(item, paddingLengths[i]) for (i, item) in enumerate(rule)], "")
end

# Used to display the current derivation state
function updateDerivationSteps(state::DerivationState)
    if isempty(state.derivationStep) # check if its a new derivation
        state.derivationStep = "wake [assignment-list] sleep" # if a new derivation, start from the highest level
        formattedRule = format_rule(["[program]", "➝", state.derivationStep], systemConstants.derivationPadding) # formmated line
    elseif occursin(state.derivationReplaceGrammar, state.derivationStep) #checks if the correct text was added correctly
        state.derivationCounter += 1 # updates the counter 
        state.derivationStep = replace(state.derivationStep, state.derivationReplaceGrammar => state.derivationGrammar) # replaces the grammar to replace with the new target that was declared in each function

        formattedRule = format_rule([string(state.derivationCounter), "➝", state.derivationStep], systemConstants.derivationPadding) # formats this new line for printing
    else
        throw("Derivation error: target not found") #safety measures
    end
    println(colorize(formattedRule, :blue, :white)) # prints it with colors
end

# Displays BNF Grammar
function displayGrammar()
    border = colorize("#", :magenta, :yellow)^150 # line specifications

    println(border) # border
    println(colorize("Grammar Rules:", :blue, :green)) # Header
    println(border) # border

    for rule in systemConstants.grammar_rules# Prints each grammar rule with padding and colors
        println(colorize(format_rule([rule.lhs, rule.arrow, rule.separator, rule.rhs], systemConstants.grammarPadding), :blue, :green))
    end
    println(border) # border
end
