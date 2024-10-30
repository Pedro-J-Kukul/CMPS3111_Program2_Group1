include("definitions.jl")


function colorize(char::String, fgColor::Symbol, bgColor::Symbol)
    fgColorValue = getfield(systemConstants.foreground, Symbol(fgColor))
    bgColorValue = getfield(systemConstants.background, Symbol(bgColor))
    return string(bgColorValue, fgColorValue, char, systemConstants.foreground.reset, systemConstants.background.reset)
end

function format_rule(rule::Vector{String}, paddingLengths::Vector{Integer})
    return join([rpad(item, paddingLengths[i]) for (i, item) in enumerate(rule)], "")
end

function updateDerivationSteps(state::DerivationState)
    if isempty(state.derivationStep)
        state.derivationStep = state.derivationGrammar
        formattedRule = format_rule(["[program]", "➝", state.derivationStep], systemConstants.derivationPadding)
    else
        lastStep = split(state.derivationStep, '\n') |> last

        if occursin(state.derivationReplaceGrammar, lastStep)
            state.derivationCounter += 1
            state.derivationStep = replace(lastStep, state.derivationReplaceGrammar => state.derivationGrammar)

            formattedRule = format_rule([string(state.derivationCounter), "➝", state.derivationStep], systemConstants.derivationPadding)
        else
            throw("Derivation error: target not found")
        end
    end

    println(colorize(formattedRule, :blue, :white))
end

function displayGrammar()
    border = colorize("#", :magenta, :yellow)^150

    println(border)
    println(colorize("Grammar Rules:", :blue, :green))
    println(border)

    for rule in systemConstants.grammar_rules
        println(colorize(format_rule([rule.lhs, rule.arrow, rule.separator, rule.rhs], systemConstants.grammarPadding), :blue, :green))
    end
    println(border)
end
