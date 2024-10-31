# Definitions for variables used in this program


# Struct for ANSI Colors
mutable struct Colors
    black::String
    red::String
    green::String
    yellow::String
    blue::String
    magenta::String
    cyan::String
    white::String
    bBlack::String
    bRed::String
    bGreen::String
    bYellow::String
    bBlue::String
    bMagenta::String
    bCyan::String
    bWhite::String
    reset::String
    none::String
end

# Struct for grammar rules
mutable struct GrammarRule
    lhs::String        # Left-hand side
    arrow::String      # Arrow symbol (→)
    separator::String   # Separator (e.g., "")
    rhs::String        # Right-hand side
end

# Struct for constants
mutable struct Constants
    printBorderWidth::Int
    keys::Set{String}
    commands::Set{String}
    terminationCommand::String
    derivationPadding::Vector{Integer}
    grammarPadding::Vector{Integer}
    grammar_rules::Vector{GrammarRule}
    foreground::Colors
    background::Colors
end

# Struct for derivation State
mutable struct DerivationState
    validKeys::Vector{String}
    assignedButtons::Set{String}
    derivationStep::String
    derivationCounter::Int
    derivationGrammar::String
    derivationReplaceGrammar::String
    currentKeyAssignment::String
end


# Resets the derivation State every time a new derivation is called
function resetState()
    return DerivationState(
        [],             # validKeys  
        Set{String}(),  # assignedKeys       
        "",             # derivationStep
        1,              # derivationCounter
        "",             # derivationGrammar
        "",             # derivationReplaceGrammar
        ""              # currentKeyAssignment
    )
end

# Constants that are used throughout the program
systemConstants = Constants(
    150,  # printBorderWidth
    Set(["a", "b", "c", "d"]),                                                      # keys
    Set(["DRIVE", "BACK", "LEFT", "RIGHT", "SPINL", "SPINR"]),                      # commands
    "ABORT",                                                                        # terminationCommand
    [20, 5, 100],                                                                   # DerivationPadding
    [20, 5, 2, 100],                                                                # GrammarPadding
    [
        GrammarRule("[program]", "→", "", "wake [assignment-list] sleep"),
        GrammarRule("[assignment-list]", "→", "", "[key-assignment];"),
        GrammarRule("", "→", "|", "[key-assignment]; [assignment-list]"),
        GrammarRule("[key-assignment]", "→", "", "key [key] = [command]"),
        GrammarRule("[key]", "→", "", "a | b | c | d"),
        GrammarRule("[command]", "→", "", "DRIVE | BACK | LEFT | RIGHT | SPINL | SPINR")
    ],                                                                              #grammarRule
    Colors(
        "\u001b[30m", "\u001b[31m", "\u001b[32m", "\u001b[33m", "\u001b[34m",
        "\u001b[35m", "\u001b[36m", "\u001b[37m", "\u001b[90m", "\u001b[91m",
        "\u001b[92m", "\u001b[93m", "\u001b[94m", "\u001b[95m", "\u001b[96m",
        "\u001b[97m", "\u001b[0m", ""
    ),                                                                              # foreground colors
    Colors(
        "\u001b[40m", "\u001b[41m", "\u001b[42m", "\u001b[43m", "\u001b[44m",
        "\u001b[45m", "\u001b[46m", "\u001b[47m", "\u001b[100m", "\u001b[101m",
        "\u001b[102m", "\u001b[103m", "\u001b[104m", "\u001b[105m", "\u001b[106m",
        "\u001b[107m", "\u001b[0m", ""
    )                                                                               # background colors
)