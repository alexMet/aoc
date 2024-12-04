package main

import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"
import "core:text/regex"

solve :: proc(filepath: string) -> (int, int) {
    data, ok := os.read_entire_file(filepath, context.allocator)
    if !ok {
        fmt.println("File doesn't exist!")
        return -1, -1
    }
    defer delete(data, context.allocator)

    it := string(data)
    haystack := &it
    r, _ := regex.create_by_user(`/mul\(([0-9]+),([0-9]+)\)|do\(\)|don't\(\)/gm`)
    defer regex.destroy(r)

    success: bool
    enabled: bool = true
    total: int = 0
    correct_total: int = 0
    capture: regex.Capture
    defer regex.destroy(capture)

    for {
        capture, success = regex.match(r, haystack^)
        if !success {
            break
        }

        if strings.compare(capture.groups[0], `don't()`) == 0 {
            enabled = false
        }
        else if strings.compare(capture.groups[0], `do()`) == 0 {
            enabled = true
        }
        else {
            m := strconv.atoi(capture.groups[1]) * strconv.atoi(capture.groups[2])
            total += m
            if enabled {
                correct_total += m
            }
        }

        haystack^ = haystack[capture.pos[0][1]:]
    }

    return total, correct_total
}

main :: proc() {
    x, y := solve("2024/day03/test.txt")
    assert(x == 161)
    assert(y == 161)
    x, y = solve("2024/day03/test2.txt")
    assert(x == 161)
    assert(y == 48)
    x, y = solve("2024/day03/input.txt")
    fmt.println("1st part:", x)
    assert(x == 184576302)
    fmt.println("2nd part:", y)
    assert(y == 118173507)
}
