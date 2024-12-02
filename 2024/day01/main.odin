package main

import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"
import "core:slice"

solve :: proc(filepath: string) -> (int, int) {
    data, ok := os.read_entire_file(filepath, context.allocator)
    if !ok {
        fmt.println("File doesn't exist!")
        return -1, -1
    }
    defer delete(data, context.allocator)

    locations_left := make([dynamic]int)
    locations_right := make([dynamic]int)
    defer delete(locations_left)
    defer delete(locations_right)

    it := string(data)
    for line in strings.split_lines_iterator(&it) {
        locations := strings.split(line, "   ")
        append(&locations_left, strconv.atoi(locations[0]))
        append(&locations_right, strconv.atoi(locations[1]))
    }
    slice.sort(locations_left[:])
    slice.sort(locations_right[:])

    total_distance: int = 0
    similarity_score: int = 0
    for location, index in locations_left {
        total_distance += abs(location - locations_right[index])
        similarity_score += location * slice.count(locations_right[:], location)
    }

    return total_distance, similarity_score
}

main :: proc() {
    x, y := solve("2024/day01/test.txt")
    assert(x == 11)
    assert(y == 31)
    x, y = solve("2024/day01/input.txt")
    fmt.println("1st part:", x)
    fmt.println("2nd part:", y)
}
