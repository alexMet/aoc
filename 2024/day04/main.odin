package main

import "core:fmt"
import "core:os"
import "core:strings"
import "core:slice"
import "core:unicode/utf8"

solve :: proc(filepath: string) -> (int, int) {
    data, ok := os.read_entire_file(filepath, context.allocator)
    if !ok {
        fmt.println("File doesn't exist!")
        return -1, -1
    }
    defer delete(data, context.allocator)

    line: int = 0
    xmas_cnt: int = 0
    x_mas_cnt: int = 0
    n, _ := slice.linear_search(data, '\n')
    words := make([][]rune, n)
    it := string(data)
    for i in 0..<n {
        line, _ := strings.split_lines_iterator(&it)
        words[i] = make([]rune, n)
        for c, j in line {
            words[i][j] = c
        }
    }
    defer delete(words)
    defer for i in 0..<n {
        delete(words[i])
    }

    // I'm pretty sure there's a better way
    for i in 0..<n {
        for j in 0..<n {
            if words[i][j] == 'X' {
                // LEFT
                if j - 3 >= 0 {
                    if words[i][j - 1] == 'M' && words[i][j - 2] == 'A' && words[i][j - 3] == 'S' {
                        xmas_cnt += 1
                    }
                    if i - 3 >= 0 && words[i - 1][j - 1] == 'M' && words[i - 2][j - 2] == 'A' && words[i - 3][j - 3] == 'S' {
                        xmas_cnt += 1
                    }
                    if i + 3 < n && words[i + 1][j - 1] == 'M' && words[i + 2][j - 2] == 'A' && words[i + 3][j - 3] == 'S' {
                        xmas_cnt += 1
                    }
                }
                // RIGHT
                if j + 3 < n {
                    if words[i][j + 1] == 'M' && words[i][j + 2] == 'A' && words[i][j + 3] == 'S' {
                        xmas_cnt += 1
                    }
                    if i - 3 >= 0 && words[i - 1][j + 1] == 'M' && words[i - 2][j + 2] == 'A' && words[i - 3][j + 3] == 'S' {
                        xmas_cnt += 1
                    }
                    if i + 3 < n && words[i + 1][j + 1] == 'M' && words[i + 2][j + 2] == 'A' && words[i + 3][j + 3] == 'S' {
                        xmas_cnt += 1
                    }
                }
                // TOP
                if i - 3 >= 0 && words[i - 1][j] == 'M' && words[i - 2][j] == 'A' && words[i - 3][j] == 'S' {
                    xmas_cnt += 1
                }
                // BOTTOM
                if i + 3 < n && words[i + 1][j] == 'M' && words[i + 2][j] == 'A' && words[i + 3][j] == 'S' {
                    xmas_cnt += 1
                }
            }
            else if words[i][j] == 'A' {
                if j - 1 >= 0 && j + 1 < n && i - 1 >= 0 && i + 1 < n {
                    mas := utf8.runes_to_string([]rune{words[i - 1][j - 1], 'A', words[i + 1][j + 1]})
                    sam := utf8.runes_to_string([]rune{words[i - 1][j + 1], 'A', words[i + 1][j - 1]})
                    if (mas == "MAS" || mas == "SAM") && (sam == "MAS" || sam == "SAM") {
                        x_mas_cnt += 1
                    }
                }
            }
        }
    }

    return xmas_cnt, x_mas_cnt
}

main :: proc() {
    x, y := solve("2024/day04/test.txt")
    assert(x == 18)
    assert(y == 9)
    x, y = solve("2024/day04/input.txt")
    fmt.println("1st part:", x)
    assert(x == 2336)
    fmt.println("2nd part:", y)
    assert(y == 1831)
}
