enum FieldState {
    case playerCircle
    case playerCross
    case playerNone
    case error
}

struct FieldStates {
    static var stateArray: [FieldState] = initStateArray()

    static func initStateArray() -> [FieldState]{
        var array: [FieldState] = []
        for _ in 0..<9 {
            array.append(.playerNone)
        }
        return array
    }
    
    static func initComputerIsCircle() -> Bool {
        let randomNum = Int.random(in: 0...1)
        if randomNum == 0 {
            return true
        } else {
            return false
        }
    }
    
    static func setState(index: Int, state: FieldState) {
        guard index >= 0 || index < 9  else {
            print("Error: Wrong index")
            return
        }
        guard stateArray[index] == FieldState.playerNone else {
            print("Eroor: Field state is played")
            return
        }
        stateArray[index] = state
    }
    
    static func getState(_ index: Int) -> FieldState{
        guard index >= 0 || index < 9  else {
            print("Error: Wrong index")
            return .error
        }
        return stateArray[index]
    }
    
    static func resetFields() {
        for index in 0..<9 {
            stateArray[index] = .playerNone
        }
    }
    
    static func reAvailableFields() -> [Int] {
        var availabeFilelds: [Int] = []
        for (index, field) in stateArray.enumerated() {
            if field == FieldState.playerNone {
                availabeFilelds.append(index)
            }
        }
        return availabeFilelds
    }
}
