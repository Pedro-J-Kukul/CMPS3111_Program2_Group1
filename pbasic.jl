function generatePBASIC(state::DerivationState)
    # Extract assignments from the state
    assignments = state.validKeys

    # Define a header block
    header = """
             '{\$STAMP BS2p}
             '{\$PBASIC 2.5}
             KEY         VAR         Byte
             Main:       DO
                         SERIN 3,2063,250,Timeout,[KEY]
             """

    # Define a dictionary for movement translations to PBASIC subroutine names
    movement_translation = Dict(
        "DRIVE" => "Forward",
        "BACK" => "Backward",
        "LEFT" => "TurnLeft",
        "RIGHT" => "TurnRight",
        "SPINL" => "SpinLeft",
        "SPINR" => "SpinRight"
    )

    # Arrays to track used movements
    used_movements = Set()

    # Initialize the body block for button assignments
    body_block = ""

    # Loop through each key assignment in the assignments array
    for assignment in assignments
        # Split the assignment by whitespace to get the key and movement
        tokens = split(assignment, r"\s+")
        key = tokens[2]
        movement = tokens[4]

        # Validate and store the used movement
        if haskey(movement_translation, movement)
            push!(used_movements, movement_translation[movement])

            # Map movement to PBASIC subroutine and format the conditional statement
            body_block *= "    IF KEY = '$(uppercase(key))' OR KEY = '$(lowercase(key))' THEN GOSUB $(movement_translation[movement])\n"
        else
            println("Invalid movement '$movement' found in assignment: '$assignment'. Skipping this assignment.")
        end
    end

    # Define footer and subroutine blocks
    footer1 = """
                          LOOP
              Timeout:    GOSUB Motor_OFF
                          GOTO Main
              """

    # Define subroutine code template
    subroutine_template = Dict(
        "Forward" => "Forward: HIGH 13 : LOW 12 : HIGH 15 : LOW 14 : RETURN",
        "Backward" => "Backward: HIGH 12 : LOW 13 : HIGH 14 : LOW 15 : RETURN",
        "TurnLeft" => "TurnLeft: HIGH 13 : LOW 12 : LOW 15 : LOW 14 : RETURN",
        "TurnRight" => "TurnRight: LOW 13 : LOW 12 : HIGH 15 : LOW 14 : RETURN",
        "SpinLeft" => "SpinLeft: HIGH 13 : LOW 12 : HIGH 14 : LOW 15 : RETURN",
        "SpinRight" => "SpinRight: HIGH 12 : LOW 13 : HIGH 15 : LOW 14 : RETURN"
    )

    # Generate subroutine block code based on used movements
    subroutine_block = "\n'+++++ Movement Procedures ++++++++++++++++++++++++++++++\n"
    for movement in used_movements
        subroutine_block *= subroutine_template[movement] * "\n"
    end

    footer2 = """
          Motor_OFF: LOW 13 : LOW 12 : LOW 15 : LOW 14 : RETURN
          '+++++++++++++++++++++++++++++++++++++++++++++++++++++++
          """

    # Combine all parts to form the complete PBASIC code
    pbasic_code = header * body_block * footer1 * subroutine_block * footer2

    # Display and save the generated PBASIC code
    println("\nGenerated PBASIC Code:\n")
    println(pbasic_code)

    open("iZEBOT.BSP", "w") do file
        write(file, pbasic_code)
    end

    println("\nPBASIC code saved to iZEBOT.BSP")
end
