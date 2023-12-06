package main

import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"

solve :: proc(filepath: string) -> (int, int) {
	data, ok := os.read_entire_file(filepath, context.allocator)
	if !ok {
        fmt.println("File doesn't exist!")
		return -1, -1
	}
	defer delete(data, context.allocator)

    sum_of_game_ids, sum_of_powers: int = 0, 0
    it := string(data)
	for line in strings.split_lines_iterator(&it) {
        r, g, b: int = 0, 0, 0
        s := strings.split(line, ":")
        game_id, _ := strconv.parse_int(strings.split(s[0], " ")[1])

        for shown_set in strings.split(s[1], ";") {
            for cubes in strings.split(shown_set, ",") {
                c := strings.split(cubes, " ")
                count, _ := strconv.parse_int(c[1])

                switch c[2] {
                case "red": r = max(count, r)
                case "green": g = max(count, g)
                case "blue": b = max(count, b)
                }
            }
        }
        
        if r <= 12 && g <= 13 && b <= 14 {
            sum_of_game_ids += game_id
        }
        sum_of_powers += r * g * b
	}

    return sum_of_game_ids, sum_of_powers
}

main :: proc() {
    x, y := solve("2023/day02/test.txt")
    assert(x == 8)
    assert(y == 2286)
    x, y = solve("2023/day02/input.txt")
    assert(x == 2149)
    assert(y == 71274)
	fmt.println("1st part:", x)
    fmt.println("2nd part:", y)
}
