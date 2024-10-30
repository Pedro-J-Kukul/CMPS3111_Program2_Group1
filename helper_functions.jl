#globals
global assignmentsCount::Number
global assignedKeys = Set{String}()
global derivationStep::String
global derivationCounter::Number


const global keys = Set(["a", "b", "c", "d"])
const global commands = Set(["DRIVE", "BACK", "LEFT", "RIGHT", "SPINL", "SPINR"])
const global terminationCommand = "ABORT"


# Colorizes a String using ansi codes
function colorize(char::String, fgColor::Symbol, bgColor::Symbol) # string, text color, background color
    foregroundColors = (
        black="\u001b[30m", red="\u001b[31m", green="\u001b[32m", yellow="\u001b[33m", blue="\u001b[34m",
        magenta="\u001b[35m", cyan="\u001b[36m", white="\u001b[37m", bBlack="\u001b[90m", bRed="\u001b[91m",
        bGreen="\u001b[92m", bYellow="\u001b[93m", bBlue="\u001b[94m", bMagenta="\u001b[95m", bCyan="\u001b[96m",
        bWhite="\u001b[97m", reset="\u001b[0m", none=""
    )

    backgroundColors = (
        black="\u001b[40m", red="\u001b[41m", green="\u001b[42m", yellow="\u001b[43m", blue="\u001b[44m",
        magenta="\u001b[45m", cyan="\u001b[46m", white="\u001b[47m", bBlack="\u001b[100m", bRed="\u001b[101m",
        bGreen="\u001b[102m", bYellow="\u001b[103m", bBlue="\u001b[104m", bMagenta="\u001b[105m", bCyan="\u001b[106m",
        bWhite="\u001b[107m", reset="\u001b[0m", none=""
    )
    return string(backgroundColors[bgColor], foregroundColors[fgColor], char, foregroundColors[:reset], backgroundColors[:reset]) # return string with color
end

function printBorder()
    println(colorize("#", :magenta, :yellow)^150)
end

function format_rule(rule, paddingLengths)
    return join([rpad(item, paddingLengths[i]) for (i, item) in enumerate(rule)], "")
end

function displayGrammar()
    grammar_rules = [
        ["[program]", "→", "", "wake [assignment-list] sleep"],
        ["[assignment-list]", "→", "", "[key-assignment];"],
        ["", "→", "|", "[key-assignment]; [assignment-list]"],
        ["[key-assignment]", "→", "", "key [key] = [command]"],
        ["[key]", "→", "", "a | b | c | d"],
        ["[command]", "→", "", "DRIVE | BACK | LEFT | RIGHT | SPINL | SPINR"]
    ]
    paddingLengths = [20, 5, 2, 30]  # Adjusted padding for better alignment


    printBorder()
    println(colorize("Grammar Rules:", :blue, :green))
    printBorder()

    for rule in grammar_rules
        println(colorize(format_rule(rule, paddingLengths), :blue, :green))
    end
    printBorder()
end

function resetGlobals()
    global assignmentsCount = 0
    global assignedkeys = String[]
    global derivationStep = ""
    global derivationCounter = 1
end


function updateDerivationSteps!(target::String, replacement::String)
    global derivationStep, derivationCounter
    paddingLengths = [20, 5, length(target)]

    if isempty(derivationStep)
        derivationStep = target
        formattedRule = format_rule(["[program]", "➝", derivationStep], paddingLengths)
    else

        lastStep = split(derivationStep, '\n') |> last

        if occursin(target, lastStep)
            derivationCounter += 1
            derivationStep = replace(lastStep, target => replacement)

            formattedRule = format_rule([string(derivationCounter), "➝", derivationStep], paddingLengths)
        else
            throw("Derivation error: target not found")
        end
    end

    println(colorize(formattedRule, :blue, :white))
end


function generatePBASIC()
    global assignedKeys

    # Define a dictionary for movement translations
    movement_translation = Dict(
        "FORWARD" => "Forward",
        "REVERSE" => "Backward",
        "TURN_LEFT" => "TurnLeft",
        "TURN_RIGHT" => "TurnRight",
        "SPIN_LEFT" => "SpinLeft",
        "SPIN_RIGHT" => "SpinRight"
    )

    # Create the HEADER BLOCK
    pbasic_code = """
    '{STAMP BS2p}'
    '{PBASIC 2.5}'
    KEY VAR Byte
    Main: DO
    SERIN 3,2063,250,Timeout,[KEY]
    """

    # Create the BODY BLOCK with button assignments
    body_block = ""
    for assignment in assignedKeys
        # Ensure format "key [x] = [y]"
        parts = split(assignment, " ")
        if length(parts) < 4 || parts[3] != "="
            println("Error in assignment format: '$assignment'. Skipping this assignment.")
            continue
        end

        key = strip(parts[2])
        movement = strip(parts[4])

        # Translate movement to PBASIC subroutine, handling missing movements
        pbasic_movement = get(movement_translation, movement, "UNKNOWN")
        if pbasic_movement == "UNKNOWN"
            println("Error: Invalid movement '$movement' in assignment: '$assignedKeys'. Skipping this assignment.")
            continue
        end

        body_block *= "IF KEY = \"$key\" THEN GOSUB $pbasic_movement\n"
    end

    if isempty(body_block)
        println("No valid key assignments found.")
        return
    end

    # Add FOOTER 1 Code
    footer1 = """
    LOOP
    Timeout: GOSUB Motor_OFF
    GOTO Main
    '+++++ Movement Procedure ++++++++++++++++++++++++++++++
    """

    # Create the SUBROUTINE BLOCK
    subroutine_block = """
    Forward: HIGH 13 : LOW 12 : HIGH 15 : LOW 14 : RETURN
    Backward: HIGH 12 : LOW 13 : HIGH 14 : LOW 15 : RETURN
    TurnLeft: HIGH 13 : LOW 12 : LOW 15 : LOW 14 : RETURN
    TurnRight: LOW 13 : LOW 12 : HIGH 15 : LOW 14 : RETURN
    SpinLeft: HIGH 13 : LOW 12 : HIGH 14 : LOW 15 : RETURN
    SpinRight: HIGH 12 : LOW 13 : HIGH 15 : LOW 14 : RETURN
    """

    # Add FOOTER 2 Code
    footer2 = """
    Motor_OFF: LOW 13 : LOW 12 : LOW 15 : LOW 14 : RETURN
    '+++++++++++++++++++++++++++++++++++++++++++++++++++++++
    """

    # Combine all blocks
    pbasic_code *= body_block * footer1 * subroutine_block * footer2

    # Display generated code onscreen
    println("\nGenerated PBASIC Code:\n")
    println(pbasic_code)

    # Save generated code to a file
    file = "IZEBOT.BSP"
    open(file, "w") do foo
        write(foo, pbasic_code)
    end
    println("\nPBASIC code saved to $file")

    # Prompt user to continue
    println("Press Enter to continue...")
    readline()
end
