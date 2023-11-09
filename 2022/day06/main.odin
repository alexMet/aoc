package main

import "core:fmt"
import "core:os"
import "core:strings"

solve :: proc(filepath: string, target: int) {
	data, ok := os.read_entire_file(filepath, context.allocator)
	if !ok {
        fmt.println("File doesn't exist!")
		return
	}
	defer delete(data, context.allocator)

    it := string(data)
	for line in strings.split_lines_iterator(&it) {
        first: int = 0
        m := make(map[rune]int, 24)
        defer delete(m)

        for letter, i in line {
            if i - first == target {
                fmt.println(i)
                break
            }

            position, is_letter_found := m[letter]
            if is_letter_found && position >= first {
                first = position + 1
            }
            m[letter] = i
        }
	}
}

main :: proc() {
    fmt.println("--- Part 1 ---")
    solve("2022/day06/test.txt", 4)
    solve("2022/day06/input.txt", 4)
    fmt.println("--- Part 2 ---")
    solve("2022/day06/test.txt", 14)
    solve("2022/day06/input.txt", 14)
}
