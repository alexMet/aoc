package main

import "core:fmt"
import "core:math"
import "core:math/big"
import "core:os"
import "core:strings"

solve :: proc(filepath: string, n: int) -> (int, int) {
    data, ok := os.read_entire_file(filepath, context.allocator)
    if !ok {
        fmt.println("File doesn't exist!")
        return -1, -1
    }
    defer delete(data, context.allocator)

    points, card_index: int = 0, 0
    cards := make([]int, n)
    it := string(data)
    for line in strings.split_lines_iterator(&it) {
        win_cnt: int = 0
        card := strings.split(line, ": ")[1]
        c := strings.split(card, " | ")
        my_numbers := strings.split(c[0], " ")
        winning_numbers := strings.split(c[1], " ")

        winning_numbers_map := make(map[string]bool)
        for number in winning_numbers {
            winning_numbers_map[number] = true
        }
        defer delete(winning_numbers_map)

        for number in my_numbers {
            if number != "" && number in winning_numbers_map {
                win_cnt += 1
            }
        }

        points += int(big.pow(2, big._WORD(win_cnt - 1)))
        for i in 0..<min(win_cnt, n) {
            cards[card_index + i + 1] += cards[card_index] + 1
        }
        card_index += 1
    }

    card_cnt := math.sum(cards) + n
    return points, card_cnt
}

main :: proc() {
    x, y := solve("2023/day04/test.txt", 6)
    assert(x == 13)
    assert(y == 30)
    x, y = solve("2023/day04/input.txt", 219)
    assert(x == 26426)
    assert(y == 6227972)
    fmt.println("1st part:", x)
    fmt.println("2nd part:", y)
}
