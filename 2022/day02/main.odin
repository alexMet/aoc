package main

import "core:fmt"
import "core:os"
import "core:strings"

Move :: enum int {Rock = 1, Paper = 2, Scissors = 3, Invalid = -1}
Round :: enum int {Loose = 0, Draw = 3, Win = 6, Invalid = -1}

wrong_decrypt :: proc(move: u8) -> Move {
    switch rune(move) {
    case 'A', 'X': return .Rock
    case 'B', 'Y': return .Paper
    case 'C', 'Z': return .Scissors
    case:          return .Invalid
    }
}

decrypt :: proc(move: u8) -> Round {
    switch rune(move) {
    case 'X': return .Loose
    case 'Y': return .Draw
    case 'Z': return .Win
    case:     return .Invalid
    }
}

solve :: proc(filepath: string) -> (int, int) {
	data, ok := os.read_entire_file(filepath, context.allocator)
	if !ok {
        fmt.println("File doesn't exist!")
		return 0, 0
	}
	defer delete(data, context.allocator)

	it := string(data)
    wrong_score: int = 0
    score: int = 0
	for line in strings.split_lines_iterator(&it) {
        elf_move := line[0]
        my_move := line[2]
        wrong_score += int(wrong_decrypt(my_move)) + int((my_move - elf_move - 1)) % 3 * 3
        score += int(my_move + elf_move - 1) % 3 + int(decrypt(my_move)) + 1
    }
    return wrong_score, score
}

main :: proc() {
    x, y := solve("day02/test.txt")
    assert(x == 15)
    assert(y == 12)
    x, y = solve("day02/input.txt")
	fmt.println("Part 1:", x)
	fmt.println("Part 2:", y)
}
