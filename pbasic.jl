movementTranslation = Dict(
    "DRIVE" => "Forward",
    "BACK" => "Backward",
    "LEFT" => "TurnLeft",
    "RIGHT" => "TurnRight",
    "SPINL" => "SpinLeft",
    "SPINR" => "SpinRight"
)

subroutineTemplate = Dict(
    "Forward" => "Forward: HIGH 13 : LOW 12 : HIGH 15 : LOW 14 : RETURN",
    "Backward" => "Backward: HIGH 12 : LOW 13 : HIGH 14 : LOW 15 : RETURN",
    "TurnLeft" => "TurnLeft: HIGH 13 : LOW 12 : LOW 15 : LOW 14 : RETURN",
    "TurnRight" => "TurnRight: LOW 13 : LOW 12 : HIGH 15 : LOW 14 : RETURN",
    "SpinLeft" => "SpinLeft: HIGH 13 : LOW 12 : HIGH 14 : LOW 15 : RETURN",
    "SpinRight" => "SpinRight: HIGH 12 : LOW 13 : HIGH 15 : LOW 14 : RETURN"
)


function generatePBASIC(state::DerivationState)
    border = colorize("#", :magenta, :yellow)^150 # line specifications

    print(colorize("Press Enter to continue...", :blue, :green))
    readline()
    println(border) # border
    assignments = state.validKeys
    usedMovements = Set()
    pbasic_code = ""

    pbasic_code *= "\n'{\$STAMP BS2p}\n"
    pbasic_code *= "'{\$PBASIC 2.5}\n"
    pbasic_code *= "KEY\t\tVAR\t\tByte\n"
    pbasic_code *= "Main:\t\tDO\n"
    pbasic_code *= "\t\t   SERIN 3,2063,250,Timeout,[KEY]\n"

    for assignment in assignments
        tokens = split(assignment, r"\s+")
        key = tokens[2]
        movement = tokens[4]

        if haskey(movementTranslation, movement)
            push!(usedMovements, movementTranslation[movement])
            pbasic_code *= "\t\t   IF KEY = '$(uppercase(key))' OR KEY = '$(lowercase(key))' THEN GOSUB $(movementTranslation[movement])\n"
        else
            println("Invalid movement '$movement' found in assignment: '$assignment'. Skipping this assignment.")
        end
    end

    pbasic_code *= "\t\tLOOP\n"
    pbasic_code *= "Timeout:\tGOSUB Motor_OFF\n"
    pbasic_code *= "\t\tGOTO Main\n"
    pbasic_code *= "'+++++ Movement Procedures ++++++++++++++++++++++++++++++\n"

    for movement in usedMovements
        pbasic_code *= subroutineTemplate[movement] * "\n"
    end

    pbasic_code *= "Motor_OFF: LOW 13 : LOW 12 : LOW 15 : LOW 14 : RETURN\n"
    pbasic_code *= "'++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"

    println(colorize(pbasic_code, :black, :white))

    open("iZEBOT.BSP", "w") do file
        write(file, pbasic_code)
    end
    print(colorize("PBASIC code saved to iZEBOT.BSP | Press Enter to continue...", :blue, :green))
    readline()
end

