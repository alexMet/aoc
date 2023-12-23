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

    sum_of_predictions_start: int = 0
    sum_of_predictions_end: int = 0
    it := string(data)
	for line in strings.split_lines_iterator(&it) {
        history_strings := strings.split(line, " ")

        n := len(history_strings)
        history := make([][]int, n)
        for i in 0..<n {
            history[i] = make([]int, n)
            history[0][i] = strconv.atoi(history_strings[i])
        }
        defer delete(history)
        defer for i in 0..<n {
            delete(history[i])
        }

        for i in 1..<n {
            for j in i..<n {
                history[i][j] = history[i - 1][j] - history[i - 1][j - 1]
            }
        }

        prediction_start: int = 0
        prediction_end: int = 0
        for i in 0..<n {
            prediction_start = history[n - i - 1][n - i - 1] - prediction_start
            prediction_end += history[i][n - 1]
        }

        sum_of_predictions_start += prediction_start
        sum_of_predictions_end += prediction_end
	}

    return sum_of_predictions_end, sum_of_predictions_start
}

main :: proc() {
    x, y := solve("2023/day09/test.txt")
    assert(x == 114)
    assert(y == 2)
    x, y = solve("2023/day09/input.txt")
    assert(x == 1992273652)
    assert(y == 1012)
	fmt.println("1st part:", x)
    fmt.println("2nd part:", y)
}
