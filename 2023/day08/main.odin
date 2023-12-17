package main

import "core:fmt"
import "core:os"
import "core:strings"

calculate_human_steps :: proc(network: ^map[string][]string, directions: ^string) -> int {
    steps: int = 0
    current_moves := network["AAA"]

    for {
        for direction in directions {
            next_move := current_moves[0 if rune(direction) == 'L' else 1]
            current_moves = network[next_move]
            steps += 1

            if next_move == "ZZZ" {
                return steps
            }
        }
    }
}

calculate_ghost_steps :: proc(network: ^map[string][]string) -> int {
    all_moves: [dynamic]string
    defer delete(all_moves)

    for key in network {
        if key[2] == 'A' {
            append(&all_moves, key)
        }
    }

    fmt.println(all_moves, len(all_moves))
    steps, direction: int = 0, 1
    for {
        total_z_moves: int = 0

        for current_move, i in all_moves {
            next_move := network[current_move][direction]
            all_moves[i] = next_move

            if next_move[2] == 'Z' {
                total_z_moves += 1
            }
        }

        // fmt.println(all_moves, direction, total_z_moves)
        if total_z_moves == len(all_moves) {
            return steps
        }

        direction = (direction + 1) % 2
        steps += 1
    }
}

solve :: proc(filepath: string) -> int {
	data, ok := os.read_entire_file(filepath, context.allocator)
	if !ok {
        fmt.println("File doesn't exist!")
		return -1
	}
	defer delete(data, context.allocator)

    network := make(map[string][]string)
    defer delete(network)

    it := string(data)
    directions, _ := strings.split_lines_iterator(&it)
    strings.split_lines_iterator(&it)
	for line in strings.split_lines_iterator(&it) {
        s := strings.split(line, " = ")
        s[1], _ = strings.remove(s[1], "(", 1)
        s[1], _ = strings.remove(s[1], ")", 1)
        network[s[0]] = strings.split(s[1], ", ")
	}

    human_steps := calculate_human_steps(&network, &directions)
    // ghost_steps := calculate_ghost_steps(&network)
    return human_steps
}

main :: proc() {
    x := solve("2023/day08/test.txt")
    assert(x == 2)
    x = solve("2023/day08/test2.txt")
    assert(x == 6)
    // x := solve("2023/day08/test3.txt")
    x = solve("2023/day08/input.txt")
    assert(x == 16343)
	fmt.println("1st part:", x)
    // fmt.println("2nd part:", x)
}
